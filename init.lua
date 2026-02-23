-- CTtTranslate
-- Archivo principal (loader)

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

CTtTranslate = CTtTranslate or {}

-- =========================
-- TRADUCCIÓN (I18n)
-- =========================
-- Traductor global del mod
CTtTranslate.S = minetest.get_translator(modname)

-- =========================
-- CARGA DE ARCHIVOS
-- =========================

-- Core
dofile(modpath .. "/core/config.lua")
dofile(modpath .. "/core/storage.lua")
dofile(modpath .. "/core/utils.lua")
dofile(modpath .. "/core/chat.lua")

-- Forms
dofile(modpath .. "/forms/owner_panel.lua")
dofile(modpath .. "/forms/player_panel.lua")

-- Locale (datos internos, no traducciones)
dofile(modpath .. "/locale/languages.lua")
dofile(modpath .. "/locale/colors.lua")

-- Comandos
dofile(modpath .. "/core/commands.lua")

minetest.log("action", "[CTtTranslate] Mod cargado (estructura base)")