-- CTtTranslate - chat.lua
-- Versión segura + DEBUG OWNER (traduce de verdad)

CTtTranslate = CTtTranslate or {}
CTtTranslate.config = CTtTranslate.config or {}

-- === DEBUG ===
-- Permite que el owner vea su propia traducción
CTtTranslate.config.debug_owner = true

-- HTTP
local http = minetest.request_http_api()
if not http then
    minetest.log("warning", "[CTtTranslate] HTTP API not available")
end

-- ===============================
-- Traducción real (LibreTranslate)
-- ===============================
local function translate_message(text, from_lang, to_lang, callback)
    if not http then
        callback(text)
        return
    end

    local url = "https://libretranslate.com/translate"
    local data = minetest.write_json({
        q = text,
        source = from_lang,
        target = to_lang,
        format = "text"
    })

    http.fetch({
        url = url,
        post_data = data,
        extra_headers = { "Content-Type: application/json" },
        timeout = 5,
        method = "POST"
    }, function(res)
        if res and res.succeeded and res.data then
            local ok, json = pcall(minetest.parse_json, res.data)
            if ok and json and json.translatedText then
                callback(json.translatedText)
                return
            end
        end
        callback(text)
    end)
end

-- ===============================
-- CHAT HANDLER
-- ===============================
minetest.register_on_chat_message(function(name, message)

    if message == "" or message:sub(1, 1) == "/" then
        return false
    end

    if not CTtTranslate.config.active then
        return false
    end

    local sender = CTtTranslate.players[name]
    if not sender or not sender.active or not sender.language then
        return false
    end

    local sender_lang = sender.language
    local is_owner = minetest.check_player_privs(name, {server=true})

    for _, player in ipairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local pdata = CTtTranslate.players[pname]

        -- ❌ Saltear owner solo si debug está apagado
        if pname == name and is_owner and not CTtTranslate.config.debug_owner then
            minetest.chat_send_player(pname, "<"..name.."> "..message)
            goto continue
        end

        if not pdata or not pdata.active or not pdata.language then
            minetest.chat_send_player(pname, "<"..name.."> "..message)
        else
            if pdata.language == sender_lang then
                minetest.chat_send_player(pname, "<"..name.."> "..message)
            else
                translate_message(message, sender_lang, pdata.language, function(translated)
                    minetest.chat_send_player(
                        pname,
                        "<"..name.."> "..translated
                    )
                end)
            end
        end

        ::continue::
    end

    return true
end)