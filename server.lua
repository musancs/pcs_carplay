RegisterNetEvent('carplay:play', function(url, volume)
    local src = source
    TriggerClientEvent('carplay:sync', -1, src, url, volume)
end)

RegisterNetEvent('carplay:stop', function()
    local src = source
    TriggerClientEvent('carplay:stop', -1, src)
end)

RegisterNetEvent('carplay:setVolume', function(volume)
    local src = source
    TriggerClientEvent('carplay:volume', -1, src, volume)
end)