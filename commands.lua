-- CTtTranslate - commands.lua
-- Registra los comandos del mod y la ayuda en inglés

CTtTranslate = CTtTranslate or {}

-- ===============================
-- Player command: /CTttranslate
-- Abre el panel de configuración del jugador
-- ===============================
minetest.register_chatcommand("CTttranslate", {
    params = "",
    description = "Open your translation panel",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            CTtTranslate.show_player_panel(player)
        end
    end
})

-- ===============================
-- Owner command: /ctranslate
-- Abre el panel de configuración global del owner
-- ===============================
minetest.register_chatcommand("ctranslate", {
    params = "",
    description = "Open the global translation panel (owner only)",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player and minetest.check_player_privs(player, {server=true}) then
            CTtTranslate.show_owner_panel(player)
        else
            minetest.chat_send_player(name, "[CTtTranslate] You need server privileges to access this panel.")
        end
    end
})

-- ===============================
-- Help command: /help_ctttranslate
-- Muestra ayuda sobre el mod
-- ===============================
minetest.register_chatcommand("help_ctttranslate", {
    params = "",
    description = "Show help for CTtTranslate mod",
    func = function(name, param)
        minetest.chat_send_player(name, "===== CTtTranslate Help =====")
        minetest.chat_send_player(name, "/CTttranslate - Open your translation panel (choose language, activate/deactivate translator, save settings)")
        minetest.chat_send_player(name, "/ctranslate - Open owner/global translation panel (choose API, colors, global activation)")
        minetest.chat_send_player(name, "Features: Automatic chat translation between Spanish, English, Portuguese, and Russian")
        minetest.chat_send_player(name, "Translated messages appear in color with original language label [ES/EN/PT/RU]")
        minetest.chat_send_player(name, "Players can choose to save their settings permanently or per session")
        minetest.chat_send_player(name, "Owner can switch between LibreTranslate (free) or Google Translate API (paid)")
        minetest.chat_send_player(name, "==============================")
    end
})