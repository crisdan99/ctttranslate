-- CTtTranslate - commands.lua
-- Registra los comandos del mod y la ayuda

CTtTranslate = CTtTranslate or {}

-- ===============================
-- Player command: /ctttranslate
-- Abre el panel de configuración del jugador
-- ===============================
minetest.register_chatcommand("ctttranslate", {
    params = "",
    description = "Open your translation panel",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            CTtTranslate.show_player_panel(player)
        end
    end
})

-- Alias corto
minetest.register_chatcommand("ctt", {
    params = "",
    description = "Open your translation panel (short command)",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            CTtTranslate.show_player_panel(player)
        end
    end
})

-- ===============================
-- Owner command: /ctranslate
-- Panel global (solo owner / server)
-- ===============================
minetest.register_chatcommand("ctranslate", {
    params = "",
    description = "Open the global translation panel (owner only)",
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            CTtTranslate.show_owner_panel(player)
        end
    end
})

-- ===============================
-- Help command: /help ctttranslate
-- ===============================
minetest.register_chatcommand("ctttranslate_help", {
    params = "",
    description = "Show help for CTtTranslate mod",
    func = function(name)
        minetest.chat_send_player(name, "===== CTtTranslate Help =====")
        minetest.chat_send_player(name, "/ctttranslate  - Open your translation panel")
        minetest.chat_send_player(name, "/ctt           - Short command for player panel")
        minetest.chat_send_player(name, "/ctranslate    - Open global panel (server only)")
        minetest.chat_send_player(name, "")
        minetest.chat_send_player(name, "Features:")
        minetest.chat_send_player(name, "- Automatic chat translation")
        minetest.chat_send_player(name, "- Supported languages: ES, EN, PT, RU")
        minetest.chat_send_player(name, "- Colored messages with language tag")
        minetest.chat_send_player(name, "- Per-player activation")
        minetest.chat_send_player(name, "")
        minetest.chat_send_player(name, "Project status: Work in progress")
        minetest.chat_send_player(name, "==============================")
    end
})

-- ===============================
-- Integración con /help ctttranslate
-- ===============================
minetest.register_on_chat_message(function(name, message)
    if message == "/help ctttranslate" or message == "/help CTttranslate" then
        minetest.run_server_chatcommand("ctttranslate_help", name)
        return true
    end
end)