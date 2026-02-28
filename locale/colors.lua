-- CTtTranslate
-- Colores por defecto de idiomas (MEJORADO)

CTtTranslate = CTtTranslate or {}

-- Colores por código de idioma
CTtTranslate.default_colors = {
    es = "#FFFF00",  -- Español (Amarillo)
    en = "#00AAFF",  -- Inglés (Azul)
    pt = "#00FF00",  -- Portugués (Verde)
    ru = "#AA00FF"   -- Ruso (Violeta)
}

-- Color por defecto si algo falla
CTtTranslate.fallback_color = "#FFFFFF"

-- Obtener color seguro
function CTtTranslate.get_language_color(lang)
    local color =
        CTtTranslate.default_colors
        and CTtTranslate.default_colors[lang]

    if type(color) == "string" and
       color:match("^#%x%x%x%x%x%x$") then
        return color
    end

    return CTtTranslate.fallback_color
end