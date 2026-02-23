-- CTtTranslate - config.lua

CTtTranslate = CTtTranslate or {}

-- Configuración global del mod
CTtTranslate.config = {
    -- ===============================
    -- Traductor global activo
    -- ===============================
    active = true,               -- true = habilitado, false = deshabilitado

    -- ===============================
    -- API de traducción
    -- ===============================
    api = "libre",               -- "libre" o "google"
    google_key = "",             -- Si se usa Google API, poner la clave

    -- ===============================
    -- Mostrar idioma original
    -- ===============================
    show_original = true,        -- true = mostrar [ES], false = ocultar

    -- ===============================
    -- Color de los mensajes traducidos
    -- ===============================
    default_color = "#FF0000",   -- Color predeterminado en hex
}

-- ===============================
-- Colores por idioma (puede modificarse en owner_panel)
-- ===============================
CTtTranslate.colors = {
    es = "#FF0000", -- rojo
    en = "#00FF00", -- verde
    pt = "#0000FF", -- azul
    ru = "#FFA500", -- naranja
}

-- ===============================
-- Lista de jugadores conectados y sus configuraciones
-- ===============================
CTtTranslate.players = {}