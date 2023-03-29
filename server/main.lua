ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("close", function(source, args, raw)
    TriggerClientEvent("Mockos:Jobs:Close", source)
end)