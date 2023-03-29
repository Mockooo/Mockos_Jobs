ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("Mocko:Job:Busfahrer:PasangerPay")
AddEventHandler("Mocko:Job:Busfahrer:PasangerPay", function(passangers)
    local j = passangers
    local xPlayer = ESX.GetPlayerFromId(source)
    local Min = Config.Busfahrer.PayPerPed.Min
    local Max = Config.Busfahrer.PayPerPed.Max
    local Money = 0
    local Pay = 0
    for i = 1, j do
        Pay = math.random(Min, Max)
        Money = Money+Pay
        Wait(0)
    end
    xPlayer.addMoney(Money)
    --TriggerClientEvent("Mockos:Job:Busfahrer:Notify", source, "info", "LS-Transports", ""..Money.."$ durch "..j.." die eingestiegen sind.", 5000)
end)

RegisterNetEvent("Mocko:Job:Busfahrer:RouteEndPay")
AddEventHandler("Mocko:Job:Busfahrer:RouteEndPay", function(route)
    local xPlayer = ESX.GetPlayerFromId(source)

    local Money = Config.Busfahrer.Routen[route].Pay
    local Name = Config.Busfahrer.Routen[route].Name

    xPlayer.addAccountMoney('bank', Money)
    --TriggerClientEventInternal("Mockos:Job:Busfahrer:Notify", source, "info", "LS-Transports", ""..Money.."$ durch die Route "..Name.." Gemacht!", 5000)
end)

RegisterNetEvent("Mocko:Job:Busfahrer:InsertDatabaseData")
AddEventHandler("Mocko:Job:Busfahrer:InsertDatabaseData", function(p1)
    local xPlayer = ESX.GetPlayerFromId(source)
    local passangers = p1
    local Identifier = GetPlayerIdentifier(source, 0)
    local name = xPlayer.getName()

    MySQL.single('SELECT * FROM busdriverdata WHERE identifier = ?', {Identifier}, function(row)
        if row then
            local fahrten = row.fahrten+1
            local passagiere = row.passagiere+passangers
            MySQL.update('UPDATE busdriverdata SET fahrten = ?, passagiere = ? WHERE identifier = ?', {fahrten, passagiere, Identifier})
        else
            local names = MySQL.single.await('SELECT firstname, lastname FROM users WHERE identifier = ?', {Identifier})
            if names then
                name = names.firstname.." "..names.lastname
            end
            MySQL.insert('INSERT INTO busdriverdata (identifier, name, fahrten, passagiere) VALUES (?, ?, ?, ?)', {Identifier, name, 1, passangers})
        end
    end)
end)


RegisterNetEvent("Mocko:Job:Busfahrer:LoadRankList")
AddEventHandler("Mocko:Job:Busfahrer:LoadRankList", function()
    local _source = source
    local ranglistef = {}
    local ranglistep = {}
    local i2 = 50

    --Get Ranklist and Sort--
    MySQL.query('SELECT * FROM busdriverdata', function(result)
        if result then
            if #result < 50 then
                i2 = #result
            end
            for i = 1, #result do
                local row = result[i]

                local name = row.name
                local fahrten = row.fahrten
                local passagiere = row.passagiere

                ranglistef[i] = {name = name, fahrten = fahrten}
                ranglistep[i] = {name = name, passagiere = passagiere}
            end
        end

        
        table.sort(ranglistef, function(a, b)
            return tonumber(a.fahrten) > tonumber(b.fahrten)    
        end)

        table.sort(ranglistep, function(a, b)
            return tonumber(a.passagiere) > tonumber(b.passagiere)    
        end)

        for i = 1, i2 do
            local name = ranglistef[i].name
            local fahrten = ranglistef[i].fahrten

            local name2 = ranglistep[i].name
            local passagiere = ranglistep[i].passagiere

            TriggerClientEvent("Mocko:Job:Busfahrer:LoadFahrtenranklist", _source, i, name, fahrten)
            TriggerClientEvent("Mocko:Job:Busfahrer:LoadPassagiereanklist", _source, i, name2, passagiere)
            Wait(10)
        end
    end)
end)

