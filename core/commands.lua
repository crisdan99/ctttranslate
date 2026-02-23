-- CTtTranslate - commands.lua
-- Registra los comandos del mod y la ayuda

CTtTranslate = CTtTranslate or {}

-- Traductor
local S = CTtTranslate.S

-- ===============================
-- Player command: /ctttranslate
-- Abre el panel de configuración del jugador
-- ===============================
minetest.register_chatcommand("ctttranslate", {
    params = "",
    description = S("Open your translation panel"),
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
    description = S("Open your translation panel (short command)"),
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
    description = S("Open the global translation panel (owner only)"),
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            CTtTranslate.show_owner_panel(player)
        end
    end
})

-- ===============================
-- Help command: /ctttranslate_help
-- ===============================
minetest.register_chatcommand("ctttranslate_help", {
    params = "",
    description = S("Show help for CTtTranslate mod"),
    func = function(name)
        minetest.chat_send_player(name, S("===== CTtTranslate Help ====="))
        minetest.chat_send_player(name, S("/ctttranslate  - Open your translation panel"))
        minetest.chat_send_player(name, S("/ctt           - Short command for player panel"))
        minetest.chat_send_player(name, S("/ctranslate    - Open global panel (server only)"))
        minetest.chat_send_player(name, "")
        minetest.chat_send_player(name, S("Features:"))
        minetest.chat_send_player(name, S("- Automatic chat translation"))
        minetest.chat_send_player(name, S("- Supported languages: ES, EN, PT, RU"))
        minetest.chat_send_player(name, S("- Colored messages with language tag"))
        minetest.chat_send_player(name, S("- Per-player activation"))
        minetest.chat_send_player(name, "")
        minetest.chat_send_player(name, S("Project status: Work in progress"))
        minetest.chat_send_player(name, S("=============================="))
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