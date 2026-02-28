-- CTtTranslate -- Archivo principal (loader)

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- Namespace principal
CTtTranslate = CTtTranslate or {}

-- Versión del mod
CTtTranslate.version = "1.0.10"

-- Sistema de traducción interno (I18n)
CTtTranslate.S = minetest.get_translator(modname)

-- Función segura para cargar archivos
local function safe_dofile(path)
    local ok, err = pcall(dofile, path)
    if not ok then
        minetest.log("error",
            "[CTtTranslate] Error cargando: " .. path .. " -> " .. tostring(err))
    end
end

-- =========================
-- CARGA DE MÓDULOS
-- =========================

-- Core
safe_dofile(modpath .. "/core/config.lua")
safe_dofile(modpath .. "/core/storage.lua")
safe_dofile(modpath .. "/core/utils.lua")
safe_dofile(modpath .. "/core/chat.lua")

-- Forms
safe_dofile(modpath .. "/forms/owner_panel.lua")
safe_dofile(modpath .. "/forms/player_panel.lua")

-- Locale
safe_dofile(modpath .. "/locale/languages.lua")
safe_dofile(modpath .. "/locale/colors.lua")

-- Commands
safe_dofile(modpath .. "/core/commands.lua")

-- Log final
minetest.log("action",
    "[CTtTranslate v" .. CTtTranslate.version .. "] Mod cargado correctamente")