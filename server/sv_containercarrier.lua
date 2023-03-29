ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Containers = {}
local j1 = 0
local j2 = 0

Citizen.CreateThread(function()

    while Config.ContainerCarrier.ContainerNames[j1+1] do
        j1 = j1+1
        Wait(0)
    end

    while Config.ContainerCarrier.ContainerWahre[j2+1] do
        j2 = j2+1
        Wait(0)
    end

    for i = 1, Config.ContainerCarrier.MaxJobOffers do
        Containers[i] = {
            Name = 0,
            Wahre = 0,
            Pay = 0,
        }
        Wait(0)
        TriggerEvent("Mocko:Job:ContainerCarrier:LoadJobOffer", i)
    end
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:LoadJobOffer")
AddEventHandler("Mocko:Job:ContainerCarrier:LoadJobOffer", function(i2)
    p1 = math.random(1, j1)
    p2 = math.random(1, j2)

    local i1 = i2

    if Containers[i1].Name == 0 then

        Containers[i1] = {
            Name = Config.ContainerCarrier.ContainerNames[p1],
            Wahre =  Config.ContainerCarrier.ContainerWahre[p2].Name,
            Pay = Config.ContainerCarrier.ContainerWahre[p2].Pay,
        }

        TriggerClientEvent("Mocko:Job:ContainerCarrier:LoadJobOfferintoUI", -1, i1, Containers[i1].Name, Containers[i1].Wahre, Containers[i1].Pay)

    else

        TriggerClientEvent("Mocko:Job:ContainerCarrier:DelteJobOfferfromUI", -1, i1)

        TriggerClientEvent("Mocko:Job:ContainerCarrier:SavePay", source, Containers[i1].Pay)

        Containers[i1] = {
            Name = 0,
            Wahre = 0,
            Pay = 0,
        }

        Wait(10*60000)

        if Containers[i1].Name == 0 then
            Containers[i1] = {
                Name = Config.ContainerCarrier.ContainerNames[p1],
                Wahre =  Config.ContainerCarrier.ContainerWahre[p2].Name,
                Pay = Config.ContainerCarrier.ContainerWahre[p2].Pay,
            }
        end
    end
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:InsertDatabaseData")
AddEventHandler("Mocko:Job:ContainerCarrier:InsertDatabaseData", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local Identifier = GetPlayerIdentifier(source, 0)
    local name = ""

    MySQL.single('SELECT * FROM containercargodata WHERE identifier = ?', {Identifier}, function(row)
        if row then
            local container = row.container+1
            MySQL.update('UPDATE containercargodata SET container = ? WHERE identifier = ?', {container, Identifier})
        else
            local names = MySQL.single.await('SELECT firstname, lastname FROM users WHERE identifier = ?', {Identifier})
            if names then
                name = names.firstname.." "..names.lastname
            end
            MySQL.insert('INSERT INTO containercargodata (identifier, name, container) VALUES (?, ?, ?)', {Identifier, name, 1})
        end
    end)
end)


RegisterNetEvent("Mocko:Job:ContainerCarrier:LoadRankList")
AddEventHandler("Mocko:Job:ContainerCarrier:LoadRankList", function()
    local _source = source
    local rangliste = {}
    local i2 = 50

    --Get Ranklist and Sort--
    MySQL.query('SELECT * FROM containercargodata', function(result)
        if result then
            if #result < 50 then
                i2 = #result
            end
            for i = 1, #result do
                local row = result[i]

                local name = row.name
                local container = row.container

                rangliste[i] = {name = name, container = container}
            end
        end

        
        table.sort(rangliste, function(a, b)
            return tonumber(a.container) > tonumber(b.container)    
        end)

        for i = 1, i2 do
            local name = rangliste[i].name
            local container = rangliste[i].container

            TriggerClientEvent("Mocko:Job:ContainerCarrier:LoadContainerRanklist", _source, i, name, container)
            Wait(10)
        end
    end)
end)

RegisterNetEvent("Mocko:Job:ContainerCarrier:Pay")
AddEventHandler("Mocko:Job:ContainerCarrier:Pay", function(p1)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Pay = p1
    xPlayer.addMoney(Pay)
    --TriggerClientEvent("Mockos:Job:Busfahrer:Notify", source, "info", "LS-Transports", ""..Money.."$ durch "..j.." die eingestiegen sind.", 5000)
end)

