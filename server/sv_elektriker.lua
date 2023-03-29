ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("close", function(source, args, raw)
    TriggerClientEvent("Mocko:Job:Elektriker:Close", source)
end)

RegisterNetEvent("Mocko:Job:Elektriker:InsertDatabaseData")
AddEventHandler("Mocko:Job:Elektriker:InsertDatabaseData", function(p1)
    local xPlayer = ESX.GetPlayerFromId(source)
    local repariert = p1
    local Identifier = GetPlayerIdentifier(source, 0)
    local name = ""

    MySQL.single('SELECT * FROM elektrikerdata WHERE identifier = ?', {Identifier}, function(row)
        if row then
            local reparierte = row.repariert+repariert
            MySQL.update('UPDATE elektrikerdata SET repariert = ? WHERE identifier = ?', {reparierte, Identifier})
        else
            local names = MySQL.single.await('SELECT firstname, lastname FROM users WHERE identifier = ?', {Identifier})
            if names then
                name = names.firstname.." "..names.lastname
            end
            MySQL.insert('INSERT INTO elektrikerdata (identifier, name, repariert) VALUES (?, ?, ?)', {Identifier, name, repariert})
        end
    end)
end)


RegisterNetEvent("Mocko:Job:Elektriker:LoadRankList")
AddEventHandler("Mocko:Job:Elektriker:LoadRankList", function()
    local _source = source
    local rangliste = {}
    local i2 = 50

    --Get Ranklist and Sort--
    MySQL.query('SELECT * FROM elektrikerdata', function(result)
        if result then
            if #result < 50 then
                i2 = #result
            end
            for i = 1, #result do
                local row = result[i]

                local name = row.name
                local reparierte = row.repariert

                rangliste[i] = {name = name, reparierte = reparierte}
            end
        end

        
        table.sort(rangliste, function(a, b)
            return tonumber(a.reparierte) > tonumber(b.reparierte)    
        end)

        for i = 1, i2 do
            local name = rangliste[i].name
            local reparierte = rangliste[i].reparierte

            TriggerClientEvent("Mocko:Job:Busfahrer:LoadRepariertRanklist", _source, i, name, reparierte)
            Wait(10)
        end
    end)
end)

RegisterNetEvent("Mocko:Job:Elektriker:Pay")
AddEventHandler("Mocko:Job:Elektriker:Pay", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local Min = Config.Elektriker.PayPerRepair.Min
    local Max = Config.Elektriker.PayPerRepair.Max
    local Pay = 0
    Pay = math.random(Min, Max)
    xPlayer.addMoney(Pay)
    --TriggerClientEvent("Mockos:Job:Busfahrer:Notify", source, "info", "LS-Transports", ""..Money.."$ durch "..j.." die eingestiegen sind.", 5000)


end)