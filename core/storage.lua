-- CTtTranslate - storage.lua
-- Compatible Android / PC / ContentDB
-- Solo el owner controla save_permanent

CTtTranslate = CTtTranslate or {}

-- Ruta correcta para guardar datos (NO usar modpath)
local data_path = minetest.get_mod_data_path()

-- Crear carpeta si no existe
if minetest.mkdir then
    minetest.mkdir(data_path)
end

-- ===============================
-- Guardar configuración de un jugador
-- ===============================
function CTtTranslate.save_player(player_name)
    local pdata = CTtTranslate.players[player_name]
    if not pdata then return end

    local file_path = data_path .. "/" .. player_name .. ".json"

    local ok, err = pcall(function()
        local file = io.open(file_path, "w")
        if file then
            file:write(minetest.write_json(pdata))
            file:close()
        end
    end)

    if not ok then
        minetest.log("error", "[CTtTranslate] Error saving player " ..
            player_name .. ": " .. tostring(err))
    end
end

-- ===============================
-- Cargar configuración de un jugador
-- ===============================
function CTtTranslate.load_player(player_name)
    local file_path = data_path .. "/" .. player_name .. ".json"

    local ok, pdata = pcall(function()
        local file = io.open(file_path, "r")
        if not file then return nil end
        local content = file:read("*all")
        file:close()
        return minetest.parse_json(content)
    end)

    if ok and pdata then
        CTtTranslate.players[player_name] = pdata
    else
        CTtTranslate.players[player_name] = CTtTranslate.players[player_name] or {}
    end
end

-- ===============================
-- Borrar configuración de un jugador
-- ===============================
function CTtTranslate.delete_player(player_name)
    os.remove(data_path .. "/" .. player_name .. ".json")
    CTtTranslate.players[player_name] = nil
end

-- ===============================
-- Al entrar un jugador
-- ===============================
minetest.register_on_joinplayer(function(player)
    CTtTranslate.load_player(player:get_player_name())
end)

-- ===============================
-- Al salir un jugador
-- ===============================
minetest.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    local pdata = CTtTranslate.players[pname]

    -- SOLO si el owner activó save_permanent
    if pdata and pdata.save_permanent then
        CTtTranslate.save_player(pname)
    end
end)