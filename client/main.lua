ESX = nil

CreateThread(function() 
    while ESX == nil do  
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end 
end)

RegisterNetEvent("Mockos:Jobs:Notify")
AddEventHandler("Mockos:Jobs:Notify", function(type, header, msg, time)
    if type == "info" then
        TriggerEvent('b_notify', "info", header, msg, time)
    elseif type == "error" then
        TriggerEvent('b_notify', "error", header, msg, time)
    elseif type == "success" then
        TriggerEvent('b_notify', "success", header, msg, time)
    end
end)

function SetDisplay(bool, p1)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        job = p1,
        status = bool,
    })
end

RegisterNUICallback("exit", function(data)
    SetDisplay(false, ".Busfahrer")
    SetDisplay(false, ".Elektriker")
    SetDisplay(false, ".Cargo")
end)


RegisterNetEvent("Mockos:Jobs:Close")
AddEventHandler("Mockos:Jobs:Close", function()
    SetDisplay(false, ".Busfahrer")
    SetDisplay(false, ".Elektriker")
    SetDisplay(false, ".Cargo")
end)
