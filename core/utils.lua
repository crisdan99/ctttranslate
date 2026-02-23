-- CTtTranslate
-- Funciones auxiliares

CTtTranslate = CTtTranslate or {}

-- =========================
-- OBTENER DATOS DEL JUGADOR
-- =========================

function CTtTranslate.get_player(name)
	return CTtTranslate.players[name]
end

function CTtTranslate.is_active(name)
	local player = CTtTranslate.players[name]
	return player and player.active == true
end

function CTtTranslate.get_language(name)
	local player = CTtTranslate.players[name]
	return player and player.language
end

-- =========================
-- IDIOMAS
-- =========================

function CTtTranslate.is_language_enabled(lang)
	return CTtTranslate.config.languages[lang] == true
end

function CTtTranslate.get_language_display(lang)
	if CTtTranslate.languages[lang] then
		return CTtTranslate.languages[lang].display
	end
	return lang
end

-- =========================
-- ETIQUETA [IDIOMA]
-- =========================

function CTtTranslate.build_tag(original_lang)
	if not CTtTranslate.config.show_tag then return "" end

	if CTtTranslate.config.tag_type == "original" then
		return "[" .. CTtTranslate.get_language_display(original_lang) .. "]"
	end

	if CTtTranslate.config.tag_type == "code" then
		local l = CTtTranslate.languages[original_lang]
		return l and "[" .. l.code:upper() .. "]" or ""
	end

	if CTtTranslate.config.tag_type == "custom" then
		return "[" .. CTtTranslate.config.custom_tag .. "]"
	end

	return ""
end

-- =========================
-- COLORES
-- =========================

function CTtTranslate.get_color(original_lang)
	if CTtTranslate.config.color_mode == "single" then
		return CTtTranslate.config.single_color
	end

	local colors = CTtTranslate.config.language_colors
	return colors[original_lang] or "#FFFFFF"
end