-- CTtTranslate - chat.lua (versión completa)
-- Maneja chat con traducción automática, colores y etiquetas

CTtTranslate = CTtTranslate or {}

local http = minetest.request_http_api()
if not http then
    minetest.log("error", "[CTtTranslate] HTTP API required for translation")
end

-- ===============================
-- Construir etiqueta [IDIOMA]
-- ===============================
function CTtTranslate.build_tag(lang)
    if not CTtTranslate.config.show_original then return "" end
    local code = lang:upper()
    return "[" .. code .. "]"
end

-- ===============================
-- Obtener color de idioma
-- ===============================
function CTtTranslate.get_color(lang)
    local color = CTtTranslate.colors[lang]
    if not color then
        color = CTtTranslate.config.default_color or "#FF0000"
    end
    return color
end

-- ===============================
-- Traducir mensaje usando API
-- ===============================
local function translate_message(text, from_lang, to_lang, callback)
    local api_choice = CTtTranslate.config.api or "libre"
    local url = ""
    local data = {}

    if api_choice == "libre" then
        url = "https://libretranslate.com/translate"
        data = minetest.write_json({
            q = text,
            source = from_lang,
            target = to_lang,
            format = "text"
        })
    elseif api_choice == "google" then
        url = "https://translation.googleapis.com/language/translate/v2"
        data = minetest.write_json({
            q = text,
            source = from_lang,
            target = to_lang,
            key = CTtTranslate.config.google_key
        })
    else
        callback(text)
        return
    end

    http.fetch({
        url = url,
        post_data = data,
        extra_headers = {"Content-Type: application/json"},
        timeout = 5,
        method = "POST"
    }, function(result)
        if result.succeeded and result.data then
            local ok, res = pcall(minetest.parse_json, result.data)
            if ok and res then
                if api_choice == "libre" and res.translatedText then
                    callback(res.translatedText)
                    return
                elseif api_choice == "google" and res.data and res.data.translations then
                    callback(res.data.translations[1].translatedText)
                    return
                end
            end
        end
        -- fallback: texto original si falla
        callback(text)
    end)
end

-- ===============================
-- Interceptar mensajes de chat
-- ===============================
minetest.register_on_chat_message(function(name, message)
    if not CTtTranslate.config.active then return false end

    local sender_data = CTtTranslate.players[name]
    if not sender_data or not sender_data.language then
        return false
    end

    local sender_lang = sender_data.language

    for _, player in ipairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local pdata = CTtTranslate.players[pname]

        if not pdata or not pdata.active or not pdata.language then
            -- jugador sin traductor activo → chat normal
            minetest.chat_send_player(pname, "<" .. name .. "> " .. message)
        else
            local target_lang = pdata.language
            local is_sender = pname == name

            if target_lang == sender_lang and is_sender then
                -- El mismo jugador ve su mensaje en su idioma
                local color = "#FF0000" -- rojo fijo para el que escribe
                local tag = CTtTranslate.build_tag(sender_lang)
                local final_msg = minetest.colorize(color, message) .. " " .. tag
                minetest.chat_send_player(pname, "<" .. name .. "> " .. final_msg)
            elseif target_lang == sender_lang then
                -- Otros ven el mensaje original en su color
                local color = CTtTranslate.get_color(sender_lang)
                local tag = CTtTranslate.build_tag(sender_lang)
                local final_msg = minetest.colorize(color, message) .. " " .. tag
                minetest.chat_send_player(pname, "<" .. name .. "> " .. final_msg)
            else
                -- Traducir
                translate_message(message, sender_lang, target_lang, function(translated)
                    local color = CTtTranslate.get_color(target_lang)
                    local tag = CTtTranslate.build_tag(sender_lang)
                    local final_msg = minetest.colorize(color, translated) .. " " .. tag
                    minetest.chat_send_player(pname, "<" .. name .. "> " .. final_msg)
                end)
            end
        end
    end

    return true
end)