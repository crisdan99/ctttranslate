-- CTtTranslate - commands.lua
-- Comandos del mod

CTtTranslate = CTtTranslate or {}
local S = CTtTranslate.S

-- Función interna para abrir panel jugador
local function open_player_panel(name)
    local player = minetest.get_player_by_name(name)
    if player then
        CTtTranslate.show_player_panel(player)
    end
end

-- ===============================
-- Comando principal del jugador
-- ===============================

minetest.register_chatcommand("ctttranslate", {
    params = "",
    description = S("Open your translation panel"),
    func = function(name)
        open_player_panel(name)
    end
})

-- Alias corto
minetest.register_chatcommand("ctt", {
    params = "",
    description = S("Open your translation panel (short command)"),
    func = function(name)
        open_player_panel(name)
    end
})

-- ===============================
-- Activar / Desactivar mod
-- ===============================

minetest.register_chatcommand("ctt_toggle", {
    params = "",
    description = S("Enable or disable CTtTranslate"),
    privs = {server = true},
    func = function(name)
        CTtTranslate.config.active = not CTtTranslate.config.active
        minetest.chat_send_player(name,
            S("CTtTranslate active: ") ..
            tostring(CTtTranslate.config.active)
        )
    end
})

-- ===============================
-- Cambiar idioma rápido
-- Uso: /ctt_lang es
-- ===============================

minetest.register_chatcommand("ctt_lang", {
    params = "<language>",
    description = S("Change your translation language"),
    func = function(name, param)
        if not param or param == "" then
            minetest.chat_send_player(name,
                S("Usage: /ctt_lang <language>")
            )
            return
        end

        CTtTranslate.players[name] =
            CTtTranslate.players[name] or {}

        CTtTranslate.players[name].language =
            param:lower()

        CTtTranslate.save_player(name)

        minetest.chat_send_player(name,
            S("Language changed to: ") .. param:upper()
        )
    end
})

-- ===============================
-- Borrar datos del jugador
-- ===============================

minetest.register_chatcommand("ctt_reset", {
    params = "",
    description = S("Reset your translation settings"),
    func = function(name)
        CTtTranslate.delete_player(name)
        minetest.chat_send_player(name,
            S("Your CTtTranslate data has been reset.")
        )
    end
})

-- ===============================
-- Panel global (owner)
-- ===============================

minetest.register_chatcommand("ctranslate", {
    params = "",
    description = S("Open global translation panel (owner only)"),
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            CTtTranslate.show_owner_panel(player)
        end
    end
})

-- ===============================
-- Ayuda
-- ===============================

minetest.register_chatcommand("ctt_help", {
    description = S("Show CTtTranslate help"),
    func = function(name)
        local messages = {
            "===== CTtTranslate Help =====",
            "/ctt - Open panel",
            "/ctt_lang <lang> - Change language",
            "/ctt_reset - Reset your data",
            "/ctt_toggle - Enable/Disable mod (owner)",
            "/ctranslate - Owner panel",
            "=============================="
        }

        for _, msg in ipairs(messages) do
            minetest.chat_send_player(name, S(msg))
        end
    end
})