-- CTtTranslate
-- Definición de idiomas disponibles (MEJORADO)

CTtTranslate = CTtTranslate or {}

-- Idiomas definidos por código (estructura limpia)
CTtTranslate.languages = {

    es = {
        display = "Spanish"
    },

    en = {
        display = "English"
    },

    pt = {
        display = "Portuguese"
    },

    ru = {
        display = "Russian"
    }

}

-- Obtener nombre visible del idioma
function CTtTranslate.get_language_display(code)
    local lang =
        CTtTranslate.languages
        and CTtTranslate.languages[code]

    if lang and lang.display then
        return lang.display
    end

    return code or "unknown"
end

-- Obtener lista de códigos
function CTtTranslate.get_language_codes()
    local list = {}
    for code, _ in pairs(CTtTranslate.languages or {}) do
        table.insert(list, code)
    end
    table.sort(list)
    return list
end