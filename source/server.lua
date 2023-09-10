NDCore = exports["ND_Core"]:GetCoreObject()
-- Function to check player permissions based on the chosen method
local function IsPlayerAllowed(player)
    if Config.aceperms then
        -- Use FiveM natives for permission check
        return IsPlayerAceAllowed(player, "codex:admin")
    else
        -- Use NDCore method for permission check
        return NDCore.Functions.IsPlayerAdmin(player)
    end
end

-- Admin kick command
RegisterCommand("kick", function(source, args, rawCommand)
    local player = tonumber(args[1]) -- Get the player ID to kick
    local reason = table.concat(args, " ", 2) -- Concatenate the rest of the args as the kick reason

    if not player then
        print("Usage: /kick [id] [reason]")
        return
    end

    if not IsPlayerAllowed(source) then
        print("You are not authorized to use this command.")
        return
    end

    DropPlayer(player, reason)
end, true) -- The `true` parameter makes the command restricted to admins

-- Admin teleport command
RegisterCommand("tp", function(source, args, rawCommand)
    local player = tonumber(args[1]) -- Get the player ID to teleport
    local targetPlayer = tonumber(args[2]) -- Get the target player ID to teleport to

    if not player or not targetPlayer then
        print("Usage: /tp [id] [target_id]")
        return
    end

    if not IsPlayerAllowed(source) then
        print("You are not authorized to use this command.")
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(player))
    local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayer))

    SetEntityCoords(GetPlayerPed(player), targetCoords)
end, true)

-- Admin vehicle command
RegisterCommand('car', function(source, args, rawCommand)
    local player = source
    local vehicleModel = args[1] or "adder"

    if not IsPlayerAllowed(player) then
        print("You are not authorized to use this command.")
        return
    end

    TriggerClientEvent('spawnVehicle', player, vehicleModel)
end)

RegisterNetEvent("giveVehicleAccessKeysAndOwnership")
AddEventHandler("giveVehicleAccessKeysAndOwnership", function(netId, vehicleModel)
    local player = source

    -- Make sure to replace this with your actual ND_VehicleSystem logic
    local vehicleEntity = NetworkGetEntityFromNetworkId(netId)
    local targetPlayer = player -- replace this with the target player's source

    exports["ND_VehicleSystem"]:giveAccess(player, vehicleModel, netId)
	exports["ND_VehicleSystem"]:setVehicleOwned(player, {model = vehicleModel}, false) -- adjust the third parameter as needed
    exports["ND_VehicleSystem"]:giveKeys(vehicleEntity, player, targetPlayer)
end)
