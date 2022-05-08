local QBCore = exports['glory-core']:GetCoreObject()

Doors = {
    ["F1"] = {{loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("qb-fleeca:startcheck")
AddEventHandler("qb-fleeca:startcheck", function(bank)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Fleeca.Banks[bank].onaction == true then
        if (os.time() - Fleeca.cooldown) > Fleeca.Banks[bank].lastrobbed then
            Fleeca.Banks[bank].onaction = true
            TriggerClientEvent("qb-fleeca:outcome", src, true, bank)
            TriggerClientEvent("qb-fleeca:policenotify", -1, bank)
        else
            TriggerClientEvent("qb-fleeca:outcome", src, false, "This bank recently robbed. You need to wait "..math.floor((Fleeca.cooldown - (os.time() - Fleeca.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((Fleeca.cooldown - (os.time() - Fleeca.Banks[bank].lastrobbed)), 60))
        end
    else
        TriggerClientEvent("qb-fleeca:outcome", src, false, "This bank is currently being robbed.")
    end
end)

RegisterCommand("testy", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = math.random(Fleeca.mincash, Fleeca.maxcash)
	
	if Fleeca.blackmoney then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(4500, 7000)})
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
    else
        if Fleeca.blackmoney then
            Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(4500, 7000)})
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
        end
    end
end)

RegisterServerEvent("qb-fleeca:lootup")
AddEventHandler("qb-fleeca:lootup", function(var, var2)
    TriggerClientEvent("qb-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("qb-fleeca:toggleVault")
AddEventHandler("qb-fleeca:toggleVault", function(key, state)
    Doors[key][1].locked = state
    TriggerClientEvent("qb-fleeca:toggleVault", -1, key, state)
end)

RegisterServerEvent("qb-fleeca:updateVaultState")
AddEventHandler("qb-fleeca:updateVaultState", function(key, state)
    Doors[key][1].state = state
end)

RegisterServerEvent("qb-fleeca:startLoot")
AddEventHandler("qb-fleeca:startLoot", function(data, name, players)
    local src = source

    for i = 1, #players, 1 do
        TriggerClientEvent("qb-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("qb-fleeca:startLoot_c", src, data, name)
end)

RegisterServerEvent("qb-fleeca:stopHeist")
AddEventHandler("qb-fleeca:stopHeist", function(name)
    TriggerClientEvent("qb-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("qb-fleeca:rewardCash")
AddEventHandler("qb-fleeca:rewardCash", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = math.random(Fleeca.mincash, Fleeca.maxcash)
	
	if Fleeca.blackmoney then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(3500, 5000)})
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
    else
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(4500, 7000)})
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "add")
    end
end)

RegisterServerEvent("qb-fleeca:setCooldown")
AddEventHandler("qb-fleeca:setCooldown", function(name)
    Fleeca.Banks[name].lastrobbed = os.time()
    Fleeca.Banks[name].onaction = false
    TriggerClientEvent("qb-fleeca:resetDoorState", -1, name)
end)

QBCore.Functions.CreateCallback("qb-fleeca:getBanks", function(source, cb)
    cb(Fleeca.Banks, Doors)
end)

-- QBCore.Functions.CreateCallback('qb-fleeca:getPolice', function(source, cb)
--     local amount = 0
--     for k, v in pairs(QBCore.Functions.GetPlayers()) do
--         local Player = QBCore.Functions.GetPlayer(v)

--         if Player.job.name == 'police' then
--             amount = amount + 1
--         end
--     end

--     cb(amount)
-- end)

QBCore.Functions.CreateCallback('qb-fleeca:server:HasItem', function(source, cb, ItemName)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(ItemName)
    if Player ~= nil then
       if Item ~= nil then
         cb(true)
       else
         cb(false)
       end
    end
end)

-- RegisterCommand("aan", function()
--     TriggerClientEvent('qb-fleeca:UseGreenLapTop', source)
-- end)

QBCore.Functions.CreateUseableItem("greenlaptop", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    print("Je moeder het werkt")
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        print(item.slot)
        TriggerClientEvent('qb-fleeca:UseGreenLapTop', source, item)
    end
end)

RegisterServerEvent('rick:removeLaptop')
AddEventHandler('rick:removeLaptop', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('greenlaptop', 1)
end)