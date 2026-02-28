-- CTtTranslate - config.lua
-- Configuración predeterminada del mod

CTtTranslate.config = CTtTranslate.config or {}

-- Activa o desactiva la funcionalidad principal
CTtTranslate.config.active = false

-- Si true, traduce automáticamente cuando sea necesario
CTtTranslate.config.auto_translate = true

-- Idioma por defecto (2 letras)
CTtTranslate.config.default_language =
    type(CTtTranslate.config.default_language) == "string"
    and CTtTranslate.config.default_language:lower()
    or "es"

-- Modo debug para owner
CTtTranslate.config.debug_owner =
    CTtTranslate.config.debug_owner == true

-- URL base del servicio de traducción
CTtTranslate.config.translation_api_url =
    CTtTranslate.config.translation_api_url
    or "https://libretranslate.com/translate"

-- Validación simple: debe ser una cadena con http
if type(CTtTranslate.config.translation_api_url) ~= "string"
or not CTtTranslate.config.translation_api_url:match("^https?://") then

    minetest.log(
        "warning",
        "[CTtTranslate] La URL de traducción es inválida! " ..
        tostring(CTtTranslate.config.translation_api_url)
    )

    -- Reestablecer al valor seguro por defecto
    CTtTranslate.config.translation_api_url = "https://libretranslate.com/translate"
end