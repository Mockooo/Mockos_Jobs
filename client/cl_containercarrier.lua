ESX = nil

CreateThread(function() 
    while ESX == nil do  
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end 
end)

local inJob = false
local Markerload = false
local Prop = 0
local DeliveryProp = 0
local vehicle = 0
local isAttached = false 
local deliverd = false
local Jobblip = 0
local DeliverBlip = 0
local hasContainer = false
local i1 = 0
local Pay = 0

Citizen.CreateThread(function()
    TriggerServerEvent("Mocko:Job:ContainerCarrier:LoadRankList")
    local Blip = AddBlipForCoord(Config.ContainerCarrier.Coords.Blip)

    SetBlipSprite(Blip, Config.ContainerCarrier.Blip.Type)
    SetBlipColour(Blip, Config.ContainerCarrier.Blip.Color)
    SetBlipScale(Blip, Config.ContainerCarrier.Blip.Size)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Container Fahrer")
    EndTextCommandSetBlipName(Blip)
end)

Citizen.CreateThread(function()
    while true do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Config.ContainerCarrier.Coords.Marker, true)
        if distance < 25 then
            if Markerload ~= true then
                Markerload = true
                TriggerEvent("Mocko:Job:ContainerCarrier:DrawMarker")
                TriggerEvent("Mocko:Job:ContainerCarrier:MarkerCheckDist")
            end
            Citizen.Wait(10000)
        else
            Markerload = false
        end
        Citizen.Wait(5000)
    end
end)

AddEventHandler("Mocko:Job:ContainerCarrier:MarkerCheckDist", function()
    while Markerload do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, Config.ContainerCarrier.Coords.Marker, true)
        if distance < 2 then
            ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um mit dem Fahren zu beginnen", true, true, 1000)
            if IsControlJustPressed(0, 38) then
                if not inJob then
                    SetDisplay(true, ".Cargo")
                else 
                    TriggerEvent("Mockos:Jobs:Notify", "error", "LS-Cargo", "Du bist in einem Job!", 5000)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler("Mocko:Job:ContainerCarrier:DrawMarker", function()
    while Markerload == true do
        DrawMarker(Config.ContainerCarrier.Marker.Type, Config.ContainerCarrier.Coords.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, Config.ContainerCarrier.Marker.Scale, Config.ContainerCarrier.Marker.Color, Config.ContainerCarrier.Marker.Alpha, false, false, 2, true, nil, nil, false)
        Citizen.Wait(0)
    end
end)

AddEventHandler("Mocko:Job:ContainerCarrier:Start", function()
    TriggerEvent("Mocko:Job:ContainerCarrier:Vehicle")
    TriggerEvent("Mocko:Job:ContainerCarrier:CreateContainer")
    TriggerEvent("Mocko:Job:ContainerCarrier:HandleContainer")
end)

AddEventHandler("Mocko:Job:ContainerCarrier:Vehicle", function()
    local Player = PlayerPedId()
    local DontSpawn = false
    local ModelHash = GetHashKey("handler")
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    local i = 1
    while DontSpawn == false and IsPositionOccupied(Config.ContainerCarrier.VehicleSpawns[i].x, Config.ContainerCarrier.VehicleSpawns[i].y, Config.ContainerCarrier.VehicleSpawns[i].z, 1, false, true, false, false, false, 0, false) do
        i = i+1
        if Config.ContainerCarrier.VehicleSpawns[i] == nil then
            TriggerEvent("Mockos:Jobs:Notify", "error", "LS-Cargo", "Alle Ausparkpunkte sind belegt!", 5000)
            DontSpawn = true
        end
        Wait(0)
    end
    if not DontSpawn then
        vehicle = CreateVehicle(ModelHash, Config.ContainerCarrier.VehicleSpawns[i], true, false)
        SetModelAsNoLongerNeeded(ModelHash)
        SetPedIntoVehicle(Player, vehicle, -1)
    end
end)

AddEventHandler("Mocko:Job:ContainerCarrier:CreateContainer", function()
    TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Cargo", "Fahre zum Vorgegebenen Container!", 5000)
    hasContainer = false
    local j = 0
    while Config.ContainerCarrier.ContainerSpawns[j+1] do
        j = j+1
        Wait(0)
    end
    if Prop then
        DeleteObject(Prop)
        Prop = 0
    end
    local i = math.random(1, j)
    local ModelHash = GetHashKey("prop_container_03b")
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    Prop = CreateObject(ModelHash, Config.ContainerCarrier.ContainerSpawns[i][1], Config.ContainerCarrier.ContainerSpawns[i][2], Config.ContainerCarrier.ContainerSpawns[i][3], true, false, false)
    FreezeEntityPosition(Prop, false)
    SetEntityHeading(Prop, Config.ContainerCarrier.ContainerSpawns[i][4])
    SetModelAsNoLongerNeeded(ModelHash)
    TriggerEvent("Mocko:Job:ContainerCarrier:CreateBlipforContainer", i)
end)

AddEventHandler("Mocko:Job:ContainerCarrier:CreateBlipforContainer", function(i)
    if Jobblip then
        RemoveBlip(Jobblip)
        Jobblip = 0
    end
    Jobblip = AddBlipForCoord(Config.ContainerCarrier.ContainerSpawns[i][1], Config.ContainerCarrier.ContainerSpawns[i][2], Config.ContainerCarrier.ContainerSpawns[i][3])
    SetBlipSprite(Jobblip, Config.ContainerCarrier.BlipforContainer.Type)
    SetBlipColour(Jobblip, Config.ContainerCarrier.BlipforContainer.Color)
    SetBlipScale(Jobblip, Config.ContainerCarrier.BlipforContainer.Size)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Container")
    EndTextCommandSetBlipName(Blip)
end)

AddEventHandler("Mocko:Job:ContainerCarrier:DeliverContainer", function()
    hasContainer = true
    --Remove JobBlip
    RemoveBlip(Jobblip)
    Jobblip = 0
    --Box
    local i = 1
    TriggerEvent("Mocko:Job:ContainerCarrier:LoadDeliverBox", i)
    --Blip
    if DeliverBlip then
        RemoveBlip(DeliverBlip)
        DeliverBlip = 0
    end
    DeliverBlip = AddBlipForCoord(Config.ContainerCarrier.ContainerDeliverSpots[i][1], Config.ContainerCarrier.ContainerDeliverSpots[i][2], Config.ContainerCarrier.ContainerDeliverSpots[i][3])
    SetBlipSprite(DeliverBlip, Config.ContainerCarrier.BlipforContainer.Type)
    SetBlipColour(DeliverBlip, Config.ContainerCarrier.BlipforContainer.Color)
    SetBlipScale(DeliverBlip, Config.ContainerCarrier.BlipforContainer.Size)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Abgabe")
    EndTextCommandSetBlipName(DeliverBlip)
end)    

AddEventHandler("Mocko:Job:ContainerCarrier:LoadDeliverBox", function(i)
    TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Cargo", "Bringe denn Container zum vorgegebenen Ablieferort!", 5000)
    local j = 0
    while Config.ContainerCarrier.ContainerDeliverSpots[j+1] do
        j = j+1
        Wait(0)
    end
    local i = math.random(1, j)
    local ModelHash = GetHashKey("prop_container_03b")
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    DeliveryProp = CreateObject(ModelHash, Config.ContainerCarrier.ContainerDeliverSpots[i][1], Config.ContainerCarrier.ContainerDeliverSpots[i][2], Config.ContainerCarrier.ContainerDeliverSpots[i][3], false, false, false)
    SetEntityHeading(DeliveryProp, Config.ContainerCarrier.ContainerDeliverSpots[i][4])
    SetEntityAlpha(DeliveryProp, 102, false)
    SetEntityDrawOutline(DeliveryProp, true)
    SetEntityDrawOutlineColor(DeliveryProp, 255, 255, 255, 102)
    SetEntityCompletelyDisableCollision(DeliveryProp, true, true)
    SetEntityNoCollisionEntity(DeliveryProp, Prop, true)
end)

AddEventHandler("Mocko:Job:ContainerCarrier:CheckDistanceFromContainers", function()
    while not isAttached and hasContainer do
        local pos1 = GetEntityCoords(DeliveryProp)
        local pos2 = GetEntityCoords(Prop)

        local distance = GetDistanceBetweenCoords(pos1, pos2, true)

        if distance < 1.0 then
            DeleteObject(DeliveryProp)
            DeliveryProp = 0
            RemoveBlip(DeliverBlip)
            DeliverBlip = 0
            Wait(500)
            FreezeEntityPosition(Prop, true)
            SetEntityHasGravity(Prop, false)
            DeleteObject(Prop)
            Prop = 0
            TriggerEvent("Mocko:Job:ContainerCarrier:EndofJob")
            TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Cargo", "Du hast deinen Container Erfolgreich abgeliefert!", 5000)
        end
        Wait(500)
    end
end)

AddEventHandler("Mocko:Job:ContainerCarrier:EndofJob", function()
    local Player = PlayerPedId()
    inJob = false
    hasContainer = false
    TriggerServerEvent("Mocko:Job:ContainerCarrier:Pay", Pay)
    Pay = 0
    Wait(100)
    TriggerServerEvent("Mocko:Job:ContainerCarrier:LoadJobOffer", tonumber(i1))
    TriggerServerEvent("Mocko:Job:ContainerCarrier:InsertDatabaseData")
    DeleteVehicle(vehicle)
    vehicle = 0
    SetEntityCoordsNoOffset(Player, Config.ContainerCarrier.Coords.Marker, 0, 0, 0)
end)



AddEventHandler("Mocko:Job:ContainerCarrier:AtachContainertoVehicle", function()
    if isAttached then
        isAttached = false
        DetachEntity(Prop, true, true)
        FreezeEntityPosition(Prop, false)
        SetEntityHasGravity(Prop, true)
        TriggerEvent("Mocko:Job:ContainerCarrier:CheckDistanceFromContainers")
        TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Cargo", "Container Abgestellt!", 5000)
    else
        isAttached = true
        AttachEntityToEntity(Prop, vehicle, 15, 0.0, 1.8, -2.875, 0.0, 0, 90.0, false, true, true, false, 2, true)
        TriggerEvent("Mocko:Job:ContainerCarrier:DeliverContainer")
        TriggerEvent("Mockos:Jobs:Notify", "info", "LS-Cargo", "Container Aufgesammelt!", 5000)
    end
end)

AddEventHandler("Mocko:Job:ContainerCarrier:HandleContainer", function()
    while inJob do
        if not isAttached then

		    local pos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.0, 0.0)
            local propcoords = GetOffsetFromEntityInWorldCoords(Prop, 0.0, 2.0, 0.0)
            local distance = GetDistanceBetweenCoords(pos, propcoords, false)
            local propangle1 = GetEntityHeading(Prop)-90
            local propangle2 = GetEntityHeading(Prop)+90
            local angle = GetEntityHeading(vehicle)

		    if distance < 6.0 and IsPedInAnyVehicle(PlayerPedId(), false) then

                if angle-propangle1 < 10 and angle-propangle1 > -10 or angle-propangle2 < 10 and angle-propangle2 > -10 then

                    ESX.ShowHelpNotification("Drücke ~b~[H]~w~ um Denn Container Aufzunehmen", true, false, 1000)
                    if IsControlJustPressed(0, 74) then
		                local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        
	                    if GetEntityModel(currentVehicle) == `handler` then
                            TriggerEvent("Mocko:Job:ContainerCarrier:AtachContainertoVehicle")
                        end
                    end
                end
            end
        else
            ESX.ShowHelpNotification("Drücke ~b~[H]~w~ um Denn Container abzustellen", true, false, 1000)
            if IsControlJustPressed(0, 74) then
                local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                
                if GetEntityModel(currentVehicle) == `handler` then
                    TriggerEvent("Mocko:Job:ContainerCarrier:AtachContainertoVehicle")
                else
                    TriggerEvent("Mockos:Jobs:Notify", "error", "LS-Cargo", "Du sitzt im falschen Auto!", 5000)
                end
            end
        end
        Wait(10)
    end
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:SavePay")
AddEventHandler("Mocko:Job:ContainerCarrier:SavePay", function(p1)
    Pay = p1
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:LoadContainerRanklist")
AddEventHandler("Mocko:Job:ContainerCarrier:LoadContainerRanklist", function(p1, p2, p3)
    SendPlayersCargo(p1, p2, p3)
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:LoadJobOfferintoUI")
AddEventHandler("Mocko:Job:ContainerCarrier:LoadJobOfferintoUI", function(i, p1, p2, p3)
    SendJobOffer(i, p1, p2, p3)
end)

AddEventHandler("Mocko:Job:ContainerCarrier:DeleteContainer", function()
    DeleteObject(Prop)
    Prop = 0
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:DelteJobOfferfromUI")
AddEventHandler("Mocko:Job:ContainerCarrier:DelteJobOfferfromUI", function(p1)
    DeleteJobOffer(p1)
end)

function SendPlayersCargo(p1, p2, p3) --type (p1)= Passagiere oder Fahrten
    SendNUIMessage({
        type = "Container",
        place = p1,
        name = p2,
        number = p3,
    })
end

function DeleteJobOffer(p1)
    SendNUIMessage({
        type = "CargoDelteJobOffer",
        number = p1,
    })
end

function SendJobOffer(p1, p2, p3, p4)
    SendNUIMessage({
        type = "CargoCreateJobOffer",
        number = p1,
        name = p2,
        wahre = p3,
        zahlung = p4,
    })
end

RegisterNUICallback("startCargo", function(data)
    SetDisplay(false, ".Cargo")
    i1 = data.number
    TriggerServerEvent("Mocko:Job:ContainerCarrier:LoadJobOffer", tonumber(i1))
    inJob = true
    TriggerEvent("Mocko:Job:ContainerCarrier:Start")
end)