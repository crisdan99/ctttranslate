-- CTtTranslate - chat.lua (mejorado)

CTtTranslate = CTtTranslate or {}
CTtTranslate.cache = CTtTranslate.cache or {}

local S = CTtTranslate.S

-- HTTP API
local http = minetest.request_http_api()
if not http then
    minetest.log("warning", S("[CTtTranslate] HTTP API no disponible"))
end

-- Translate with cache
local function translate_message(text, from_lang, to_lang, callback)
    if not http then
        callback(text)
        return
    end

    local key = text.."|"..from_lang.."|"..to_lang
    if CTtTranslate.cache[key] then
        callback(CTtTranslate.cache[key])
        return
    end

    local url = CTtTranslate.config.translation_api_url
    local body = minetest.write_json({
        q = text,
        source = from_lang,
        target = to_lang,
        format = "text"
    })

    http.fetch({
        url = url,
        post_data = body,
        extra_headers = { "Content-Type: application/json" },
        timeout = 5,
        method = "POST"
    }, function(res)
        if res and res.succeeded and res.data then
            local ok, json = pcall(minetest.parse_json, res.data)
            if ok and json and json.translatedText then
                CTtTranslate.cache[key] = json.translatedText
                callback(json.translatedText)
                return
            end
        end
        callback(text)
    end)
end

-- Chat handler
minetest.register_on_chat_message(function(name, message)
    if message == "" or message:sub(1,1) == "/" then
        return false
    end

    if not CTtTranslate.config.active then
        return false
    end

    local sender_lang = CTtTranslate.utils.get_language(name)
    if not sender_lang then
        return false
    end

    local is_owner = minetest.check_player_privs(name, {server=true})

    for _, player in ipairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local pdata = CTtTranslate.players[pname]
        local text_to_send

        -- Skip translation for owner if debug off
        if pname == name and is_owner
            and not CTtTranslate.config.debug_owner
        then
            text_to_send = message
        else
            if not pdata or not pdata.active
                or not pdata.language
                or pdata.language == sender_lang
            then
                text_to_send = message
            else
                translate_message(
                    message,
                    sender_lang,
                    pdata.language,
                    function(translated)
                        local tag = CTtTranslate.utils.build_tag(sender_lang)
                        local color = CTtTranslate.utils.get_color(sender_lang)
                        local formatted = tag.." "..translated
                        minetest.chat_send_player(
                            pname,
                            minetest.colorize(color, formatted)
                        )
                    end
                )
                goto continue
            end
        end

        local tag = CTtTranslate.utils.build_tag(sender_lang)
        local color = CTtTranslate.utils.get_color(sender_lang)
        minetest.chat_send_player(
            pname,
            minetest.colorize(color, tag.." "..text_to_send)
        )
        ::continue::
    end

    return true
end)