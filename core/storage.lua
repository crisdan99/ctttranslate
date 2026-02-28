-- CTtTranslate - storage.lua

CTtTranslate = CTtTranslate or {}
CTtTranslate.players = CTtTranslate.players or {}

-- Ruta de almacenamiento
local data_path = minetest.get_mod_data_path()
if minetest.mkdir then minetest.mkdir(data_path) end

-- Guardar configuración
function CTtTranslate.save_player(player_name)
    CTtTranslate.players = CTtTranslate.players or {}

    local pdata = CTtTranslate.players[player_name]
    if not pdata then return end

    local file_path = data_path .. "/" .. player_name .. ".json"

    local ok, err = pcall(function()
        local file = io.open(file_path, "w")
        if not file then
            minetest.log("error", "[CTtTranslate] No se pudo abrir archivo para guardar: " .. file_path)
            return
        end
        file:write(minetest.write_json(pdata))
        file:close()
    end)

    if not ok then
        minetest.log("error", "[CTtTranslate] Error saving player " .. player_name .. ": " .. tostring(err))
    end
end

-- Cargar configuración
function CTtTranslate.load_player(player_name)
    CTtTranslate.players = CTtTranslate.players or {}

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

-- Borrar configuración
function CTtTranslate.delete_player(player_name)
    local file_path = data_path .. "/" .. player_name .. ".json"
    os.remove(file_path)
    CTtTranslate.players[player_name] = nil
end

-- Al entrar un jugador
minetest.register_on_joinplayer(function(player)
    CTtTranslate.load_player(player:get_player_name())
end)

-- Al salir un jugador
minetest.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    local pdata = CTtTranslate.players[pname]

    if pdata and pdata.save_permanent then
        CTtTranslate.save_player(pname)
    end
end)