-- CTtTranslate - Owner Panel (MEJORADO)

CTtTranslate = CTtTranslate or {}

local S = CTtTranslate.S

function CTtTranslate.show_owner_panel(player)
    local pname = player:get_player_name()

    -- Solo owner (seguridad extra)
    if not minetest.check_player_privs(pname, {server=true}) then
        return
    end

    -- Lista de jugadores conectados
    local player_list = {}
    local save_status = {}

    for _, p in ipairs(minetest.get_connected_players()) do
        local n = p:get_player_name()
        table.insert(player_list, n)

        save_status[n] =
            CTtTranslate.players
            and CTtTranslate.players[n]
            and CTtTranslate.players[n].save_permanent
            or false
    end

    -- Generar checkboxes dinámicos
    local checkboxes = ""
    local y = 11.0

    for _, n in ipairs(player_list) do
        checkboxes = checkboxes ..
            "checkbox[1.2,"..y..";save_"..n.."; "..n..";" ..
            (save_status[n] and "true" or "false") .. "]"
        y = y + 0.9
    end

    local form =
        "formspec_version[4]" ..
        "size[24," .. (y + 3.8) .. "]" ..

        "label[0.6,0.4;" .. S("CTtTranslate - Owner Control Panel") .. "]" ..

        -- ===== GLOBAL =====
        "box[0.3,1.1;23.4,3.0;#222222]" ..
        "label[0.6,1.2;" .. S("Global Settings") .. "]" ..

        "checkbox[1.2,2.1;active;" ..
        S("Enable global translator") .. ";" ..
        (CTtTranslate.config.active and "true" or "false") .. "]" ..

        "checkbox[1.2,3.0;show_original;" ..
        S("Show original language tag") .. ";" ..
        (CTtTranslate.config.show_original and "true" or "false") .. "]" ..

        -- ===== API =====
        "box[0.3,4.4;23.4,3.4;#222222]" ..
        "label[0.6,4.5;" .. S("Translation API") .. "]" ..

       "dropdown[1.2,5.4;21.8;api_choice;" ..
        S("LibreTranslate") .. "," ..
        S("Google Translate") .. ";" ..
        (CTtTranslate.config.api == "google" and "2" or "1") .. "]" ..

        "field[1.2,6.6;21.8,1;google_key;" ..
        S("Google API Key") .. ":;" ..
        (CTtTranslate.config.google_key or "") .. "]" ..

        -- ===== VISUAL =====
        "box[0.3,8.2;23.4,2.2;#222222]" ..
        "label[0.6,8.3;" .. S("Visual") .. "]" ..

        "field[1.2,9.0;10,1;default_color;" ..
        S("Default color (HEX)") .. ":;" ..
        (CTtTranslate.config.default_color or "#FF0000") .. "]" ..

        -- ===== TEST =====
        "button[13.5,9.0;9,1;test_translation;" ..
        S("Test translation (owner)") .. "]" ..

        -- ===== PLAYERS =====
        "label[0.6,10.4;" ..
        S("Players (Save permanently)") .. "]" ..

        checkboxes ..

        "button_exit[10.5," .. (y + 1.6) .. ";3.5,1;save;" ..
        S("Save") .. "]"

    minetest.show_formspec(pname, "ctttranslate:owner_panel", form)
end

-- ===============================
-- HANDLE FORM
-- ===============================

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "ctttranslate:owner_panel" then
        return
    end

    local pname = player:get_player_name()

    -- Seguridad adicional
    if not minetest.check_player_privs(pname, {server=true}) then
        return
    end

    -- ===== TEST BUTTON =====
    if fields.test_translation then
        local color = CTtTranslate.config.default_color or "#00FF00"

        -- Validar color
        if not color:match("^#%x%x%x%x%x%x$") then
            color = "#00FF00"
        end

        local preview =
            minetest.colorize(color,
                S("Hello world (preview)")
            )

        minetest.chat_send_player(
            pname,
            S("[CTtTranslate TEST] ") .. preview
        )

        return
    end

    -- ===== ACTUALIZAR CONFIG =====
    if fields.api_choice then
        CTtTranslate.config.api =
            fields.api_choice == "Google Translate"
            and "google"
            or "libre"
    end

    if fields.google_key then
        CTtTranslate.config.google_key =
            fields.google_key
    end

    CTtTranslate.config.active =
        fields.active == "true"

    CTtTranslate.config.show_original =
        fields.show_original == "true"

    if fields.default_color and
       fields.default_color:match("^#%x%x%x%x%x%x$") then
        CTtTranslate.config.default_color =
            fields.default_color
    end

    -- Guardar configuración por jugador
    for key, value in pairs(fields) do
        if key:sub(1,5) == "save_" then
            local pn = key:sub(6)

            CTtTranslate.players[pn] =
                CTtTranslate.players[pn] or {}

            CTtTranslate.players[pn].save_permanent =
                value == "true"

            if value == "true" then
                CTtTranslate.save_player(pn)
            end
        end
    end

    minetest.chat_send_player(
        pname,
        S("[CTtTranslate] Owner settings saved")
    )
end)