-- Shows a notification on the player's screen 
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterNetEvent('spawnVehicle')
AddEventHandler('spawnVehicle', function(vehicleModel)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local vehicleHash = GetHashKey(vehicleModel)

    RequestModel(vehicleHash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehicleHash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        local vehicle = CreateVehicle(vehicleHash, x, y, z, GetEntityHeading(PlayerPedId()) + 90, 1, 0)
        
        SetVehicleEngineOn(vehicle, true, true, false) -- Start the vehicle's engine instantly

        -- Give the player access, keys, and set the vehicle as owned using ND_VehicleSystem
        TriggerServerEvent("giveVehicleAccessKeysAndOwnership", NetworkGetNetworkIdFromEntity(vehicle), vehicleModel)
    end)
end)




