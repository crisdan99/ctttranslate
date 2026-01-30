-- CTtTranslate - storage.lua (versión solo owner controla save_permanent)
CTtTranslate = CTtTranslate or {}

local path = minetest.get_modpath("ctttranslate") .. "/Playersct/"

-- Crear carpeta Playersct si no existe
if not minetest.mkdir then
    minetest.log("warning", "[CTtTranslate] Tu versión de Minetest no soporta mkdir")
else
    minetest.mkdir(path)
end

-- ===============================
-- Guardar configuración de un jugador
-- ===============================
function CTtTranslate.save_player(player_name)
    local pdata = CTtTranslate.players[player_name]
    if not pdata then return end

    local file_path = path .. player_name .. ".json"
    local ok, err = pcall(function()
        local file = io.open(file_path, "w")
        if file then
            file:write(minetest.write_json(pdata))
            file:close()
        end
    end)

    if not ok then
        minetest.log("error", "[CTtTranslate] Error guardando jugador " .. player_name .. ": " .. tostring(err))
    end
end

-- ===============================
-- Cargar configuración de un jugador
-- ===============================
function CTtTranslate.load_player(player_name)
    local file_path = path .. player_name .. ".json"
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
        -- Nota: No asignamos save_permanent aquí; solo el owner puede hacerlo
    end
end

-- ===============================
-- Borrar configuración de un jugador
-- ===============================
function CTtTranslate.delete_player(player_name)
    local file_path = path .. player_name .. ".json"
    os.remove(file_path)
    CTtTranslate.players[player_name] = nil
end

-- ===============================
-- Cargar todos los jugadores al entrar
-- ===============================
minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name()
    CTtTranslate.load_player(pname)
    -- No se modifica save_permanent; jugador no puede elegirlo
end)

-- ===============================
-- Guardar todos los jugadores al salir
-- ===============================
minetest.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    local pdata = CTtTranslate.players[pname]
    -- Solo guardar si el owner activó save_permanent para este jugador
    if pdata and pdata.save_permanent then
        CTtTranslate.save_player(pname)
    end
end)