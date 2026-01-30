-- CTtTranslate - Owner Panel mejorado con control de save_permanent
CTtTranslate = CTtTranslate or {}

-- Mostrar el panel al owner
function CTtTranslate.show_owner_panel(player)
    local pname = player:get_player_name()

    -- Construir lista de jugadores conectados
    local player_list = {}
    local save_status = {}
    for _, p in ipairs(minetest.get_connected_players()) do
        local n = p:get_player_name()
        table.insert(player_list, n)
        save_status[n] = CTtTranslate.players[n] and CTtTranslate.players[n].save_permanent or false
    end

    -- Crear checkboxes para cada jugador
    local checkboxes = ""
    local y = 6
    for _, n in ipairs(player_list) do
        checkboxes = checkboxes ..
            "checkbox[0.5,"..y..";save_"..n..";"..n..";"..(save_status[n] and "true" or "false").."]"
        y = y + 0.5
    end

    -- Crear el formulario
    local form = "formspec_version[4]" ..
                 "size[8,"..(y+2).."]" ..
                 "label[0,0;CTtTranslate - Owner Panel]" ..

                 "dropdown[0.5,1;6;api_choice;LibreTranslate,Google Translate;" ..
                 (CTtTranslate.config.api == "google" and "2" or "1") .. "]" ..

                 "field[0.5,2.5;6,1;google_key;Google API Key:;" ..
                 (CTtTranslate.config.google_key or "") .. "]" ..

                 "checkbox[0.5,4;active;Activar traductor global;" ..
                 (CTtTranslate.config.active and "true" or "false") .. "]" ..

                 "checkbox[0.5,5;show_original;Mostrar idioma original;" ..
                 (CTtTranslate.config.show_original and "true" or "false") .. "]" ..

                 "field[0.5,5.5;6,1;default_color;Color predeterminado (hex);" ..
                 (CTtTranslate.config.default_color or "#FF0000") .. "]" ..

                 checkboxes ..

                 "button_exit[2,"..(y+1)..";2,1;save;Guardar]"

    minetest.show_formspec(pname, "ctttranslate:owner_panel", form)
end

-- Manejar la respuesta del formulario
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "ctttranslate:owner_panel" then return end

    -- API
    if fields.api_choice then
        if fields.api_choice == "LibreTranslate" then
            CTtTranslate.config.api = "libre"
        elseif fields.api_choice == "Google Translate" then
            CTtTranslate.config.api = "google"
        end
    end

    -- Google Key
    if fields.google_key then
        CTtTranslate.config.google_key = fields.google_key
    end

    -- Activar traductor global
    CTtTranslate.config.active = fields.active == "true"

    -- Mostrar idioma original
    CTtTranslate.config.show_original = fields.show_original == "true"

    -- Color predeterminado
    if fields.default_color and fields.default_color ~= "" then
        CTtTranslate.config.default_color = fields.default_color
    end

    -- Guardar save_permanent de cada jugador
    for key, value in pairs(fields) do
        if key:sub(1,5) == "save_" then
            local player_name = key:sub(6)
            CTtTranslate.players[player_name] = CTtTranslate.players[player_name] or {}
            CTtTranslate.players[player_name].save_permanent = value == "true"
            if value == "true" then
                CTtTranslate.save_player(player_name)
            end
        end
    end

    minetest.chat_send_player(player:get_player_name(), "[CTtTranslate] Configuración guardada ✅")
end)