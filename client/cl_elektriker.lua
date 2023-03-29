ESX = nil

CreateThread(function() 
    while ESX == nil do  
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end 
end)

local Markerload = false
local inJob = false
local JobBlip = 0
local inRepair = false
local Repariert = 0

--Elektriker Marker--
Citizen.CreateThread(function()
    local Blip = AddBlipForCoord(Config.Elektriker.Coords.Blip)

    SetBlipSprite(Blip, Config.Elektriker.Blip.Type)
    SetBlipColour(Blip, Config.Elektriker.Blip.Color)
    SetBlipScale(Blip, Config.Elektriker.Blip.Size)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Elektriker")
    EndTextCommandSetBlipName(Blip)
end)

Citizen.CreateThread(function()
    while true do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Config.Elektriker.Coords.Marker, true)
        if distance < 25 then
            if Markerload ~= true then
                Markerload = true
                TriggerEvent("Mocko:Job:Elektriker:DrawMarker")
                TriggerEvent("Mocko:Job:Elektriker:MarkerCheckDist")
            end
            Citizen.Wait(10000)
        else
            Markerload = false
        end
        Citizen.Wait(5000)
    end
end)

AddEventHandler("Mocko:Job:Elektriker:MarkerCheckDist", function()
    while Markerload do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Config.Elektriker.Coords.Marker, true)
        if distance < 2 then
            ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um denn Elektriker zu öffnen", true, true, 1000)
            if IsControlJustPressed(0, 38) then
                SetDisplay(true, ".Elektriker")
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler("Mocko:Job:Elektriker:DrawMarker", function()
    while Markerload == true do
        DrawMarker(Config.Elektriker.Marker.Type, Config.Elektriker.Coords.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, Config.Elektriker.Marker.Scale, Config.Elektriker.Marker.Color, Config.Elektriker.Marker.Alpha, false, false, 2, true, nil, nil, false)
        Citizen.Wait(0)
    end
end)

AddEventHandler("Mocko:Job:Elektriker:Start", function()
    local i = 0
    while Config.Elektriker.Locations[i+1] do
        i = i+1
        Wait(0)
    end
    local p1 = math.random(1, i)
    TriggerEvent("Mocko:Job:Elektriker:LoadRepairBlip", p1)
    TriggerEvent("Mocko:Job:Elektriker:RepairMarkerCheckDist", p1)
    TriggerEvent("Mocko:Job:Elektriker:DrawRepairMarker", p1)
    TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Electricity", "Laufe zum Stromkasten und Reparier ihn!", 5000)
end)

AddEventHandler("Mocko:Job:Elektriker:Stop", function()
    local Player = PlayerPedId()
    inJob = false
    inRepair = false
    FreezeEntityPosition(Player, false)
    TriggerServerEvent("Mocko:Job:Elektriker:InsertDatabaseData", Repariert)
    TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Electricity", "Danke für deine Hilfe du hast "..Repariert.." Stromkästen Repariert!", 5000)
    Repariert = 0
    RemoveBlip(JobBlip)
    JobBlip = 0
end)

AddEventHandler("Mocko:Job:Elektriker:Repair", function()
    local Player = PlayerPedId()
    inRepair = true
    FreezeEntityPosition(Player, true)
    TriggerEvent("Mx::StartMinigameElectricCircuit", '50%', '50%', '2.0', '30vmin', '1.ogg', function()
        FreezeEntityPosition(Player, false)
        TriggerServerEvent("Mocko:Job:Elektriker:Pay")
        TriggerEvent("Mocko:Job:Elektriker:Start")
        Repariert = Repariert+1
        TriggerEvent("Mockos:Jobs:Notify", "success", "LS-Electricity", "Reparatur Erfolgreich abgeschlossen!", 5000)
        inRepair = false
    end)
end)

AddEventHandler("Mocko:Job:Elektriker:LoadRepairBlip", function(p1)
    if JobBlip then
        RemoveBlip(JobBlip)
        JobBlip = 0
    end

    JobBlip = AddBlipForCoord(Config.Elektriker.Locations[p1])

    SetBlipSprite(JobBlip, Config.Elektriker.RepairBlip.Type)
    SetBlipColour(JobBlip, Config.Elektriker.RepairBlip.Color)
    SetBlipScale(JobBlip, Config.Elektriker.RepairBlip.Size)
    SetBlipAsShortRange(JobBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Kapputer Stromkasten")
    EndTextCommandSetBlipName(JobBlip)
end)

AddEventHandler("Mocko:Job:Elektriker:RepairMarkerCheckDist", function(p1)
    while not inRepair and inJob do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Config.Elektriker.Locations[p1], true)
        if distance < 1 then
            ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um denn Stromkasten zu Reparieren", true, true, 1000)
            if IsControlJustPressed(0, 38) then
                TriggerEvent("Mocko:Job:Elektriker:Repair")
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler("Mocko:Job:Elektriker:DrawRepairMarker", function(p1)
    while not inRepair and inJob do
        DrawMarker(Config.Elektriker.Marker.Type, Config.Elektriker.Locations[p1], 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, Config.Elektriker.Marker.Scale, Config.Elektriker.Marker.Color, Config.Elektriker.Marker.Alpha, false, false, 2, true, nil, nil, false)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("Mocko:Job:Elektriker:LoadRankList")
end)

RegisterNetEvent("Mocko:Job:Elektriker:Close")
AddEventHandler("Mocko:Job:Elektriker:Close", function()
    SetDisplay(false, ".Elektriker")
end)

RegisterNetEvent("Mocko:Job:Busfahrer:LoadRepariertRanklist")
AddEventHandler("Mocko:Job:Busfahrer:LoadRepariertRanklist", function(p1, p2, p3)
    SendPlayersElektriker(p1, p2, p3)
end)

function SendPlayersElektriker(p1, p2, p3)
    SendNUIMessage({
        type = "Repariert",
        place = p1,
        name = p2,
        number = p3,
    })
end

RegisterNUICallback("ElektrikerStart", function(data)
    if inJob then
        inJob = false
        TriggerEvent("Mocko:Job:Elektriker:Stop")
    else
        inJob = true
        SetDisplay(false, ".Elektriker")
        TriggerEvent("Mocko:Job:Elektriker:Start")
    end
end)