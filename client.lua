local lastVolume = 0.5
local currentVehicle = nil
local soundId = nil

-- G gomb
CreateThread(function()
    while true do
        Wait(0)

        if IsControlJustPressed(0, 47) then -- G
            local ped = PlayerPedId()

            if not IsPedInAnyVehicle(ped, false) then
                lib.notify({
                    title = 'CarPlay',
                    description = 'Nem vagy járműben!',
                    type = 'error'
                })
                return
            end

            openCarplay()
        end
    end
end)

-- Menü
function openCarplay()
    local input = lib.inputDialog('CarPlay', {
        {type = 'input', label = 'Zene link '},
        {type = 'slider', label = 'Hangerő', min = 0, max = 100, default = lastVolume * 100},
        {type = 'checkbox', label = 'Leállítás'}
    })

    if not input then return end

    local url = input[1]
    local volume = input[2] / 100
    local stop = input[3]

    lastVolume = volume

    if stop then
        TriggerServerEvent('carplay:stop')
        return
    end

    if url ~= nil and url ~= '' then
        TriggerServerEvent('carplay:play', url, volume)
    else
        TriggerServerEvent('carplay:setVolume', volume)
    end
end

-- 🔥 SZINKRON (RÁDIÓ MÓD)
RegisterNetEvent('carplay:sync', function(player, url, volume)
    local myPed = PlayerPedId()
    local myVeh = GetVehiclePedIsIn(myPed, false)

    local target = GetPlayerFromServerId(player)
    if target == -1 then return end

    local targetPed = GetPlayerPed(target)
    local targetVeh = GetVehiclePedIsIn(targetPed, false)

    if myVeh ~= 0 and myVeh == targetVeh then
        soundId = 'carplay_radio_' .. player

        exports.xsound:PlayUrl(soundId, url, volume)
        currentVehicle = myVeh
    end
end)

-- STOP
RegisterNetEvent('carplay:stop', function(player)
    local id = 'carplay_radio_' .. player

    if exports.xsound:soundExists(id) then
        exports.xsound:Destroy(id)
    end
end)

-- HANGERŐ
RegisterNetEvent('carplay:volume', function(player, volume)
    local id = 'carplay_radio_' .. player

    if exports.xsound:soundExists(id) then
        exports.xsound:setVolume(id, volume)
    end
end)

-- 🔁 JÁRMŰ CHECK (beszállás/kiszállás)
CreateThread(function()
    while true do
        Wait(1000)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= currentVehicle then
            -- kiszálltál → stop
            if soundId and exports.xsound:soundExists(soundId) then
                exports.xsound:Destroy(soundId)
            end
        end
    end
end)