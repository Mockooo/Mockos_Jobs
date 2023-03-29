ESX = nil
local display = false

CreateThread(function() 
    while ESX == nil do  
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end 
end)

local Busfahrer = Config.Busfahrer
local inJob = false
local vehicle = 0
local NumberofPassanger = 0
local TotalNumberofPassanger = 0

Citizen.CreateThread(function()
    local Blip = AddBlipForCoord(Busfahrer.Coords.Blip)

    SetBlipSprite(Blip, Busfahrer.Blip.Type)
    SetBlipColour(Blip, Busfahrer.Blip.Color)
    SetBlipScale(Blip, Busfahrer.Blip.Size)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Busfahrer")
    EndTextCommandSetBlipName(Blip)
end)

Citizen.CreateThread(function()
    while true do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Busfahrer.Coords.Marker, true)
        if distance < 25 then
            if Markerload ~= true then
                Markerload = true
                TriggerEvent("Mocko:Job:Busfahrer:DrawMarker")
                TriggerEvent("Mocko:Job:Busfahrer:MarkerCheckDist")
            end
            Citizen.Wait(10000)
        else
            Markerload = false
        end
        Citizen.Wait(5000)
    end
end)

AddEventHandler("Mocko:Job:Busfahrer:MarkerCheckDist", function()
    while Markerload do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Busfahrer.Coords.Marker, true)
        if distance < 2 then
            ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um mit dem Fahren zu beginnen", true, true, 1000)
            if IsControlJustPressed(0, 38) then
                if not inJob then
                    SetDisplay(true, ".Busfahrer")
                end
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler("Mocko:Job:Busfahrer:DrawMarker", function()
    while Markerload == true do
        DrawMarker(Busfahrer.Marker.Type, Busfahrer.Coords.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, Busfahrer.Marker.Scale, Busfahrer.Marker.Color, Busfahrer.Marker.Alpha, false, false, 2, true, nil, nil, false)
        Citizen.Wait(0)
    end
end)

local Ped = {}
local stationen = {}


Citizen.CreateThread(function() 
    for i = 1, 15 do
        Ped[i] = nil
        stationen[i] = nil
        Wait(0)
    end
end)

AddEventHandler("Mocko:Job:Busfahrer:Start", function()
    local Player = PlayerPedId()
    local DontSpawn = false
    local ModelHash = GetHashKey("bus")
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    local i = 1
    while DontSpawn == false and IsPositionOccupied(Busfahrer.VehicleSpawns[i].x, Busfahrer.VehicleSpawns[i].y, Busfahrer.VehicleSpawns[i].z, 1, false, true, false, false, false, 0, false) do
        i = i+1
        if Busfahrer.VehicleSpawns[i] == nil then
            TriggerEvent("Mockos:Jobs:Notify", "error", "LS-Transports", "Alle Bus Parkplätze sind belegt!", 5000)
            DontSpawn = true
        end
        Wait(0)
    end
    if not DontSpawn then
        inJob = true
        TriggerEvent("Mocko:Job:Busfahrer:StartJob")
        vehicle = CreateVehicle(ModelHash, Busfahrer.VehicleSpawns[i], true, false)
        SetVehicleNumberPlateText(vehicle, "LS Trans")
        SetModelAsNoLongerNeeded(ModelHash)
        SetPedIntoVehicle(Player, vehicle, -1)
        TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Transport", "Route "..Config.Busfahrer.Routen[i1].Name.." Gestartet.", 5000)
    end
end)

AddEventHandler("Mocko:Job:Busfahrer:SpawnPeds", function(x, y, z)
    if Busfahrer.SpawnPeds then
        for i = 1, 15 do
            if Ped[i] ~= nil then
                stationen[i] = stationen[i]-1
                if stationen[i] == 0 then
                    DeletePed(Ped[i])
                    Ped[i] = nil
                    stationen[i] = nil
                end
            end

            if Ped[i] == nil then
                local truefalse = math.random(1, 2)
                if truefalse == 1 then
                    local random = math.random(1, Busfahrer.PedsNumber)
                    local ModelHash = GetHashKey(Busfahrer.Peds[random])
    
                    RequestModel(ModelHash)
                    while not HasModelLoaded(ModelHash) do
                        Citizen.Wait(10)
                    end
    
                    Ped[i] = CreatePedInsideVehicle(vehicle, PED_TYPE_CIVFEMALE, ModelHash, i, false, false)
                    stationen[i] = math.random(1, 3)
                    FreezeEntityPosition(Ped[i], true)
                    if Config.Busfahrer.PedsGiveMoney then
                        NumberofPassanger = NumberofPassanger+1
                    end
                end
            end
            Wait(0)
        end
        if Config.Busfahrer.PedsGiveMoney then
            TriggerServerEvent("Mocko:Job:Busfahrer:PasangerPay", NumberofPassanger)
            TotalNumberofPassanger = TotalNumberofPassanger+NumberofPassanger
            NumberofPassanger = 0
        end
    end
end)

AddEventHandler("Mocko:Job:Busfahrer:StartJob", function()
    local Checkpoint = 0
    local i2 = 1
    local i3 = i2+1
    local Ziel = false
    local blip = 0
    Checkpoint = CreateCheckpoint(1, Busfahrer.Routen[i1][i2].Coords, Busfahrer.Routen[i1][i3].Coords, Busfahrer.Routen[i1][i2].Radius, 0, 0, 255, 75, 0)
    blip = AddBlipForCoord(Busfahrer.Routen[i1][i2].Coords)
    SetBlipRoute(blip, true)
    SetBlipColour(blip, 38)
    SetBlipRouteColour(blip, 38)
    Citizen.CreateThread(function() 
        while inJob do
            local Player = PlayerPedId()
            local CoordsPlayer = vector3(GetEntityCoords(Player))
            local distance = GetDistanceBetweenCoords(CoordsPlayer, Busfahrer.Routen[i1][i2].Coords, false)
            if distance < Busfahrer.Routen[i1][i2].Radius then
                if GetVehiclePedIsUsing(Player) == vehicle then
                    if not Ziel then

                        DeleteCheckpoint(Checkpoint)
                        RemoveBlip(blip)

                        if Busfahrer.Routen[i1][i2].Type == "Haltestelle" then
                            FreezeEntityPosition(Player, true)
                            FreezeEntityPosition(vehicle, true)
                            for i = 0, 3 do
                                SetVehicleDoorOpen(vehicle, i, false, false)
                            end
                            Wait(3000)
                            TriggerEvent("Mocko:Job:Busfahrer:SpawnPeds", Busfahrer.Routen[i1][i2].Coords.x, Busfahrer.Routen[i1][i2].Coords.y, Busfahrer.Routen[i1][i2].Coords.z)
                            Wait(3000)
                            FreezeEntityPosition(Player, false)
                            FreezeEntityPosition(vehicle, false)
                            for i = 0, 3 do
                                SetVehicleDoorShut(vehicle, i, false)
                            end
                        end

                        i2 = i2+1
                        i3 = i2+1

                        if Busfahrer.Routen[i1][i2].Type == "Ziel" then
                            Checkpoint = CreateCheckpoint(4, Busfahrer.Routen[i1][i2].Coords, Busfahrer.Routen[i1][i2].Coords, Busfahrer.Routen[i1][i2].Radius, 0, 0, 255, 75, 0)
                            blip = AddBlipForCoord(Busfahrer.Routen[i1][i2].Coords)
                            SetBlipRoute(blip, true)
                            SetBlipColour(blip, 38)
                            SetBlipRouteColour(blip, 38)
                            Ziel = true
                        else
                            Checkpoint = CreateCheckpoint(1, Busfahrer.Routen[i1][i2].Coords, Busfahrer.Routen[i1][i3].Coords, Busfahrer.Routen[i1][i2].Radius, 0, 0, 255, 75, 0)
                            blip = AddBlipForCoord(Busfahrer.Routen[i1][i2].Coords)
                            SetBlipRoute(blip, true)
                            SetBlipColour(blip, 38)
                            SetBlipRouteColour(blip, 38)
                        end
                    else
                        RemoveBlip(blip)
                        DeleteCheckpoint(Checkpoint)
                        inJob = false
                        TriggerEvent("Mockos:Job:Busfahrer:Ende")
                        TriggerEvent("Mockos:Jobs:Notify", "success", "LS-Transports", "Route beendet!", 5000)
                    end
                else
                    TriggerEvent("Mockos:Jobs:Notify", "error", "LS-Transports", "Du bist nicht in deinem Bus!", 5000) 
                end
            end
            Wait(50)
        end
    end)
end)

AddEventHandler("Mockos:Job:Busfahrer:Ende", function()
    local Player = PlayerPedId()
    if Busfahrer.SpawnPeds then
        for i = 1, 15 do
            if Ped[i] ~= nil then
                DeletePed(Ped[i])
                Ped[i] = nil
                stationen[i] = nil
            end
        end
    end
    DeleteVehicle(vehicle)
    SetEntityCoords(Player, Busfahrer.Coords.Marker, 0, 0, 180, false)
    TriggerServerEvent("Mocko:Job:Busfahrer:RouteEndPay", i1)
    TriggerServerEvent("Mocko:Job:Busfahrer:InsertDatabaseData", TotalNumberofPassanger)
    TotalNumberofPassanger = 0
end)

RegisterNetEvent("Mocko:Job:Busfahrer:LoadFahrtenranklist")
AddEventHandler("Mocko:Job:Busfahrer:LoadFahrtenranklist", function(p1, p2, p3)
    SendPlayersBusdriver("Fahrten", p1, p2, p3)
end)

RegisterNetEvent("Mocko:Job:Busfahrer:LoadPassagiereanklist")
AddEventHandler("Mocko:Job:Busfahrer:LoadPassagiereanklist", function(p1, p2, p3)
    SendPlayersBusdriver("Passagiere", p1, p2, p3)
end)

Citizen.CreateThread(function()
    local i = 0
    while Config.Busfahrer.Routen[i+1] do
        local j = 0
        local stops = 0
        while Config.Busfahrer.Routen[i+1][j+1] do
            if Config.Busfahrer.Routen[i+1][j+1].Type == "Haltestelle" then
                stops = stops+1
            end
            Citizen.Wait(0)
            j = j+1
        end
        SendRoutes(i+1, Config.Busfahrer.Routen[i+1].Name, stops, Config.Busfahrer.Routen[i+1].Pay)
        i = i+1
        Citizen.Wait(0)
    end
end)

function SendRoutes(p1, p2, p3, p4)
    SendNUIMessage({
        type = "Routen",
        number = p1,
        name = p2,
        stops = p3,
        zahlung = p4,
    })
end

function SendPlayersBusdriver(p1, p2, p3, p4) --type (p1)= Passagiere oder Fahrten
    SendNUIMessage({
        type = p1,
        place = p2,
        name = p3,
        number = p4,
    })
end

Citizen.CreateThread(function()
    TriggerServerEvent("Mocko:Job:Busfahrer:LoadRankList")
end)

RegisterNUICallback("startBus", function(data)
    SetDisplay(false, ".Busfahrer")
    i1 = data.number
    TriggerEvent("Mocko:Job:Busfahrer:Start")
end)