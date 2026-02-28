-- CTtTranslate - utils.lua (mejorado)

CTtTranslate = CTtTranslate or {}
CTtTranslate.utils = CTtTranslate.utils or {}

local utils = CTtTranslate.utils

-- =========================
-- Obtener datos del jugador
-- =========================

function utils.get_player(name)
    if type(name) ~= "string" then return nil end
    return CTtTranslate.players and CTtTranslate.players[name]
end

function utils.is_active(name)
    local p = utils.get_player(name)
    return p and p.active == true
end

function utils.get_language(name)
    local p = utils.get_player(name)
    return p and p.language
end

-- =========================
-- Idiomas habilitados
-- =========================

function utils.is_language_enabled(lang)
    return CTtTranslate.config.languages
       and CTtTranslate.config.languages[lang] == true
end

function utils.get_language_display(lang)
    if CTtTranslate.languages
       and CTtTranslate.languages[lang]
    then
        return CTtTranslate.languages[lang].display
    end
    return lang
end

-- =========================
-- Etiqueta de idioma
-- =========================

function utils.build_tag(original_lang)
    if not CTtTranslate.config.show_tag then return "" end

    local tag_type = CTtTranslate.config.tag_type

    if tag_type == "original" then
        return "[" .. utils.get_language_display(original_lang) .. "]"
    end

    if tag_type == "code" then
        local l = CTtTranslate.languages and CTtTranslate.languages[original_lang]
        return l and "[" .. (l.code or ""):upper() .. "]" or ""
    end

    if tag_type == "custom" then
        return "[" .. (CTtTranslate.config.custom_tag or "") .. "]"
    end

    return ""
end

-- =========================
-- Color por idioma
-- =========================

function utils.get_color(original_lang)
    if CTtTranslate.config.color_mode == "single" then
        return CTtTranslate.config.single_color or "#FFFFFF"
    end

    local colors = CTtTranslate.config.language_colors
    return (colors and colors[original_lang]) or "#FFFFFF"
end