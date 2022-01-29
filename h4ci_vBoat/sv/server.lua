ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'boat', 'alerte Concess boat', true, true)

TriggerEvent('esx_society:registerSociety', 'boat', 'Concessionnaire', 'society_boat', 'society_boat', 'society_boat', {type = 'public'})

ESX.RegisterServerCallback('h4ci_boat:recuperercategorieavion', function(source, cb)
    local catevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM boat_categories', {}, function(result)
        for i = 1, #result, 1 do
            table.insert(catevehi, {
                name = result[i].name,
                label = result[i].label
            })
        end
        cb(catevehi)
    end)
end)
ESX.RegisterServerCallback('h4ci_boat:recupererlistevehicule', function(source, cb, categorievehi)
    local catevehi = categorievehi
    local listevehi = {}
    MySQL.Async.fetchAll('SELECT * FROM boat WHERE category = @category', {
        ['@category'] = catevehi
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listevehi, {
                name = result[i].name,
                model = result[i].model,
                price = result[i].price
            })
        end
        cb(listevehi)
    end)
end)
ESX.RegisterServerCallback('h4ci_boat:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_boat WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)
RegisterServerEvent('h4ci_boat:vendrevoiturejoueur')
AddEventHandler('h4ci_boat:vendrevoiturejoueur', function (playerId, vehicleProps, prix)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boat', function (account)
            account.removeMoney(prix)
    end)
    MySQL.Async.execute('INSERT INTO owned_boat (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
    {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function (rowsChanged)
    TriggerClientEvent('esx:showNotification', xPlayer, "Tu as reçu le bateaux ~g~"..nom.."~s~ immatriculé ~g~"..plaque.." pour ~g~" ..prix.. "$")
    end)
end)
RegisterServerEvent('shop:boat')
AddEventHandler('shop:boat', function(vehicleProps, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boat', function (account)
        xPlayer.removeMoney(prix)
end)
    MySQL.Async.execute('INSERT INTO owned_boat (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', xPlayer, "Tu as reçu le bateaux ~g~"..json.encode(vehicleProps).."~s~ immatriculé ~g~"..vehicleProps.plate.." pour ~g~" ..prix.. "$")
        TriggerClientEvent('esx:showNotification', xPlayer, "Tu as reçu le bateaux ~g~"..json.encode(vehicleProps).."~s~ immatriculé ~g~"..vehicleProps.plate.." pour ~g~" ..prix.. "$")
    end)
end)

ESX.RegisterServerCallback('h4ci_boat:verifsousconcess', function(source, cb, prixvoiture)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boat', function (account)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.getMoney() >= prixvoiture then
            cb(true)
        else
            cb(false)
        end
    end)
end)
