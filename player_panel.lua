-- CTtTranslate - Player Panel (sin opción de guardar permanente)
CTtTranslate = CTtTranslate or {}

-- Mostrar panel al jugador
function CTtTranslate.show_player_panel(player)
    local pname = player:get_player_name()
    local pdata = CTtTranslate.players[pname] or {}

    -- Idioma actual o por defecto español
    local current_lang = pdata.language or "es"
    local active = pdata.active or false

    -- Construir dropdown con idiomas
    local langs = {"es","en","pt","ru"}
    local lang_names = {"Español","English","Português","Русский"}
    local dropdown_index = 1
    for i, l in ipairs(langs) do
        if l == current_lang then
            dropdown_index = i
            break
        end
    end

    -- Formspect del panel
    local form = "formspec_version[4]" ..
                 "size[8,9]" ..
                 "label[0,0;CTtTranslate - Panel de Traducción]" ..

                 "dropdown[0.5,1;6;player_lang;" ..
                 table.concat(lang_names,",") .. ";" .. dropdown_index .. "]" ..

                 "checkbox[0.5,2.5;active;Activar traductor;" .. (active and "true" or "false") .. "]" ..

                 "button_exit[2,8;2,1;save;Guardar]"

    minetest.show_formspec(pname, "ctttranslate:player_panel", form)
end

-- Manejar respuesta del formulario
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "ctttranslate:player_panel" then return end

    local pname = player:get_player_name()
    CTtTranslate.players[pname] = CTtTranslate.players[pname] or {}

    -- Idioma
    if fields.player_lang then
        local lang_map = {["Español"]="es", ["English"]="en", ["Português"]="pt", ["Русский"]="ru"}
        CTtTranslate.players[pname].language = lang_map[fields.player_lang] or "es"
    end

    -- Activar/desactivar traductor
    CTtTranslate.players[pname].active = fields.active == "true"

    -- Mensaje al jugador
    local status = CTtTranslate.players[pname].active and "Activado" or "Desactivado"
    minetest.chat_send_player(pname, "[CTtTranslate] Traductor: " .. status .. " ✅ Idioma: " .. fields.player_lang)
end)