-- CTtTranslate - Player Panel (MEJORADO)

CTtTranslate = CTtTranslate or {}
CTtTranslate.players = CTtTranslate.players or {}

local S = CTtTranslate.S

function CTtTranslate.show_player_panel(player)
    local pname = player:get_player_name()
    local pdata = CTtTranslate.players[pname] or {}

    local current_lang = pdata.language or "es"
    local active = pdata.active == true

    -- Idiomas soportados
    local langs = {"es","en","pt","ru"}
    local lang_names = {
      S("Spanish"),
      S("English"),
      S("Portuguese"),
      S("Russian")
}

    local dropdown_index = 1
    for i, l in ipairs(langs) do
        if l == current_lang then
            dropdown_index = i
            break
        end
    end

    local form =
        "formspec_version[4]" ..
        "size[8,6]" ..
        "label[0.3,0.3;" ..
        S("CTtTranslate - Translation Panel") .. "]" ..

        "dropdown[0.5,1.3;6;player_lang;" ..
        table.concat(lang_names, ",") .. ";" ..
        dropdown_index .. "]" ..

        "checkbox[0.5,2.6;active;" ..
        S("Enable translator") .. ";" ..
        (active and "true" or "false") .. "]" ..

        "button_exit[3,4.5;2,1;save;" ..
        S("Save") .. "]"

    minetest.show_formspec(pname,
        "ctttranslate:player_panel",
        form)
end

-- ===============================
-- Handle form
-- ===============================

minetest.register_on_player_receive_fields(function(player, formname, fields)

    if formname ~= "ctttranslate:player_panel" then
        return
    end

    local pname = player:get_player_name()

    CTtTranslate.players[pname] =
        CTtTranslate.players[pname] or {}

    local pdata = CTtTranslate.players[pname]

    -- Idioma
    if fields.player_lang then
    local index = tonumber(fields.player_lang)
    local langs = {"es","en","pt","ru"}
    if index and langs[index] then
        pdata.language = langs[index]
    end
end
    -- Activar / Desactivar
    if fields.active ~= nil then
        pdata.active = (fields.active == "true")
    end

    -- 🔥 Guardar automáticamente
    CTtTranslate.save_player(pname)

    local status =
        pdata.active and
        S("Enabled") or
        S("Disabled")

    minetest.chat_send_player(
        pname,
        S("[CTtTranslate] Translator: @1", status)
    )
end)