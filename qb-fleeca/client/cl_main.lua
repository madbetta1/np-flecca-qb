local QBCore = exports['glory-core']:GetCoreObject()

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    --MissionNotification()
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload",function()
    isLoggedIn = false
end)

---Madbetta's scripts 


Freeze = {F1 = 0, F2 = 0, F3 = 0, F4 = 0, F5 = 0, F6 = 0}
Check = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
SearchChecks = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
LootCheck = {
    F1 = {Stop = false, Loot = false},
    F2 = {Stop = false, Loot = false},
    F3 = {Stop = false, Loot = false},
    F4 = {Stop = false, Loot = false},
    F5 = {Stop = false, Loot = false},
    F6 = {Stop = false, Loot = false}
}
Doors = {}
local disableinput = false
local initiator = false
local startdstcheck = false
local currentname = nil
local currentcoords = nil
local done = true
local dooruse = false
local helpTextShowing = false

Citizen.CreateThread(function() while true do local enabled = false Citizen.Wait(1) if disableinput then enabled = true  end if not enabled then Citizen.Wait(500) end end end)

RegisterNetEvent("qb-fleeca:resetDoorState")
AddEventHandler("qb-fleeca:resetDoorState", function(name)
    Freeze[name] = 0
end)

RegisterNetEvent("qb-fleeca:lootup_c")
AddEventHandler("qb-fleeca:lootup_c", function(var, var2)
    LootCheck[var][var2] = true
end)

RegisterNetEvent("qb-fleeca:outcome")
AddEventHandler("qb-fleeca:outcome", function(oc, arg)
    for i = 1, #Check, 1 do
        Check[i] = false
    end
    for i = 1, #LootCheck, 1 do
        for j = 1, #LootCheck[i] do
            LootCheck[i][j] = false
        end
    end
    if oc then
        Check[arg] = true
        TriggerEvent("qb-fleeca:startheist", Fleeca.Banks[arg], arg)
    elseif not oc then
        TriggerEvent("DoLongHudText", arg, 2)
    end
end)

RegisterNetEvent("qb-fleeca:startLoot_c")
AddEventHandler("qb-fleeca:startLoot_c", function(data, name)
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    if not LootCheck[name].Stop then
        Citizen.CreateThread(function()
            while true do
                local pedcoords = GetEntityCoords(PlayerPedId())
                local dst = GetDistanceBetweenCoords(pedcoords, data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z, true)

                if dst < 40 then
                    if not LootCheck[name].Loot then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley.x, data.trolley.y, data.trolley.z +1, true)
                        if dst1 <= 0.75 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent("qb-fleeca:lootup", name, "Loot")
                            StartGrab(name)
                        end
                    end

                    if LootCheck[name].Stop or (LootCheck[name].Loot) then
                        LootCheck[name].Stop = false
                        if initiator then
                            TriggerEvent("qb-fleeca:reset", name, data)
                            return
                        end
                        return
                    end
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1000)
                end
            end
        end)
    end
end)

RegisterNetEvent("qb-fleeca:stopHeist_c")
AddEventHandler("qb-fleeca:stopHeist_c", function(name)
    LootCheck[name].Stop = true
end)

-- MAIN DOOR UPDATE --

AddEventHandler("qb-fleeca:freezeDoors", function()
    Citizen.CreateThread(function()
        doVaultStuff = function()
            while true do
                local pcoords = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Doors) do
                    if GetDistanceBetweenCoords(v[1].loc, pcoords, true) <= 20.0 then
                        if v[1].state ~= nil then
                            local obj
                            if k ~= "F4" then
                                obj = GetClosestObjectOfType(v[1].loc, 1.5, GetHashKey("v_ilev_gb_vauldr"), false, false, false)
                            else
                                obj = GetClosestObjectOfType(v[1].loc, 1.5, 4231427725, false, false, false)
                            end
                            SetEntityHeading(obj, v[1].state)
                            Citizen.Wait(1000)
                            return doVaultStuff()
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
                Citizen.Wait(1)
            end
        end
        doVaultStuff()
    end)
end)

RegisterNetEvent("qb-fleeca:toggleVault")
AddEventHandler("qb-fleeca:toggleVault", function(key, state)
    dooruse = true
    if Fleeca.Banks[key].hash == nil then
        if not state then
            local obj = GetClosestObjectOfType(Fleeca.Banks[key].doors.startloc.x, Fleeca.Banks[key].doors.startloc.y, Fleeca.Banks[key].doors.startloc.z, 2.0, GetHashKey(Fleeca.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][1].locked = state
            TriggerServerEvent("qb-fleeca:updateVaultState", key, Doors[key][1].state)
        elseif state then
            local obj = GetClosestObjectOfType(Fleeca.Banks[key].doors.startloc.x, Fleeca.Banks[key].doors.startloc.y, Fleeca.Banks[key].doors.startloc.z, 2.0, GetHashKey(Fleeca.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][1].locked = state
            TriggerServerEvent("qb-fleeca:updateVaultState", key, Doors[key][1].state)
        end
    else
        if not state then
            local obj = GetClosestObjectOfType(Fleeca.Banks.F4.doors.startloc.x, Fleeca.Banks.F4.doors.startloc.y, Fleeca.Banks.F4.doors.startloc.z, 2.0, Fleeca.Banks.F4.hash, false, false, false)
            local count = 0
            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][1].locked = state
            TriggerServerEvent("qb-fleeca:updateVaultState", key, Doors[key][1].state)
        elseif state then
            local obj = GetClosestObjectOfType(Fleeca.Banks.F4.doors.startloc.x, Fleeca.Banks.F4.doors.startloc.y, Fleeca.Banks.F4.doors.startloc.z, 2.0, Fleeca.Banks.F4.hash, false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][1].locked = state
            Doors[key][1].state = GetEntityHeading(obj)
            TriggerServerEvent("qb-fleeca:updateVaultState", key, Doors[key][1].state)
        end
    end
    dooruse = false
end)

AddEventHandler("qb-fleeca:reset", function(name, data)
    for i = 1, #LootCheck[name], 1 do
        LootCheck[name][i] = false
    end
    Check[name] = false
    QBCore.Functions.Notify("VAULT DOOR WILL CLOSE IN 1 MINUTE!", "error")
    Citizen.Wait(100000)
    QBCore.Functions.Notify("VAULT DOOR CLOSING", "error")
    TriggerServerEvent("qb-fleeca:toggleVault", name, true)
    TriggerEvent("qb-fleeca:cleanUp", data, name)
end)


AddEventHandler("qb-fleeca:startheist", function(data, name)
    disableinput = true
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    initiator = true
    disableinput = false
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerServerEvent("qb-fleeca:toggleVault", name, false)
    startdstcheck = true
    currentname = name
    SpawnTrolleys(data, name)
end)

AddEventHandler("qb-fleeca:cleanUp", function(data, name)
    Citizen.Wait(10000)
    for i = 1, 1, 1 do -- full trolley clean
        local obj = GetClosestObjectOfType(data.objects[i].x, data.objects[i].y, data.objects[i].z, 0.75, GetHashKey("ch_prop_ch_cash_trolly_01c"), false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    for j = 1, 1, 1 do -- empty trolley clean
        local obj = GetClosestObjectOfType(data.objects[j].x, data.objects[j].y, data.objects[j].z, 0.75, GetHashKey("ch_prop_gold_trolly_01c_empty"), false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    if DoesEntityExist(IdProp) then
        DeleteEntity(IdProp)
    end
    if DoesEntityExist(IdProp2) then
        DeleteEntity(IdProp2)
    end
    TriggerServerEvent("qb-fleeca:setCooldown", name)
    initiator = false
end)

function SpawnTrolleys(data, name)
    RequestModel("ch_prop_ch_cash_trolly_01c")
    while not HasModelLoaded("ch_prop_ch_cash_trolly_01c") do
        Citizen.Wait(1)
    end
    Trolley = CreateObject(GetHashKey("ch_prop_ch_cash_trolly_01c"), data.trolley.x, data.trolley.y, data.trolley.z, 1, 1, 0)
    local hand = GetEntityHeading(Trolley)

    SetEntityHeading(Trolley, hand + Fleeca.Banks[name].trolley.h)
    local closePlayers = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 20.0)
    local missionplayers = {}
    local ply = PlayerId()

    for i = 1, #closePlayers, 1 do
        if closePlayers[i] ~= ply then
            table.insert(missionplayers, GetPlayerServerId(closePlayers[i]))
        end
    end
    TriggerServerEvent("qb-fleeca:startLoot", data, name, missionplayers)
    done = false
end

function StartGrab(name)
    --TriggerEvent("client:newStress", true, 500)
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("ch_prop_ch_cash_trolly_01c"), false, false, false)

    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end

	local trollyobj = Trolley
    local emptyobj = GetHashKey("ch_prop_gold_trolly_01c_empty")

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(0)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(0)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    --SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	CashAppear()

	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000)

	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))

    DeleteObject(trollyobj)
	while DoesEntityExist(trollyobj) do
		Citizen.Wait(0)
		NetworkRequestControlOfEntity(trollyobj)
	end

    PlaceObjectOnGroundProperly(NewTrolley)
    SetEntityAsMissionEntity(NewTrolley, 1, 1)
    Citizen.SetTimeout(5000, function()
        DeleteObject(NewTrolley)
        while DoesEntityExist(NewTrolley) do
            Citizen.Wait(0)
            DeleteEntity(NewTrolley)
        end
    end)        

    Citizen.Wait(1800)
    if DoesEntityExist(bag) then
        DeleteEntity(bag)
    end

    --SetPedComponentVariation(ped, 5, 45, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    disableinput = false
    TriggerServerEvent("qb-fleeca:rewardCash")
end

Citizen.CreateThread(function()
    while true do
        if startdstcheck then
            if initiator then
                local playercoord = GetEntityCoords(PlayerPedId())

                if (GetDistanceBetweenCoords(playercoord, currentcoords, true)) > 20 then
                    LootCheck[currentname].Stop = true
                    startdstcheck = false
                    TriggerServerEvent("qb-fleeca:stopHeist", currentname)
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('qb-fleeca:darkmail')
AddEventHandler('qb-fleeca:darkmail', function()
    Citizen.Wait(1000)
    TriggerServerEvent('glory-phone:server:sendNewMail', {
        sender = "MadBetta",
        subject = "Dark Mail",
        message = "Good Job: <br><br> Hi, </b><br><br> You Bypassed the hack wait around 1-5 minutes, im getting this vault door open.",
    })
end)

RegisterNetEvent('qb-fleeca:UseGreenLapTop')
AddEventHandler('qb-fleeca:UseGreenLapTop', function(item)
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    local p = promise:new()

    QBCore.Functions.TriggerCallback("qb-fleeca:getBanks", function(bank, door)
        Fleeca.Banks = bank
        Doors = door
    end)
	TriggerEvent("qb-fleeca:freezeDoors")

    for k, v in pairs(Fleeca.Banks) do
        if not v.onaction then
	        local dist = GetDistanceBetweenCoords(plyCoords, v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z, true)
            if dist < 1.0 then
                QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
                   if HasItem then
                        TriggerServerEvent('rick:removeLaptop')
                        ClearPedTasksImmediately(ply)
                        Wait(0)
                        TaskGoStraightToCoord(ply, v.doors.startloc.animcoords.x, v.doors.startloc.animcoords.y, v.doors.startloc.animcoords.z, 2.0, -1, v.doors.startloc.animcoords.h)
    
                        local hackAnimDict = "anim@heists@ornate_bank@hack"
    
                        RequestAnimDict(hackAnimDict)
                        RequestModel("hei_prop_hst_laptop")
                        RequestModel("hei_p_m_bag_var22_arm_s")
                        RequestModel("hei_prop_heist_card_hack_02")
                        while not HasAnimDictLoaded(hackAnimDict)
                            or not HasModelLoaded("hei_prop_hst_laptop")
                            or not HasModelLoaded("hei_p_m_bag_var22_arm_s")
                            or not HasModelLoaded("hei_prop_heist_card_hack_02") do
                            Wait(0)
                        end
                        Wait(0)
                        while GetIsTaskActive(ply, 35) do
                            Wait(0)
                        end
                        ClearPedTasksImmediately(ply)
                        Wait(0)
                        SetEntityHeading(ply, v.doors.startloc.animcoords.h)
                        Wait(0)
                        TaskPlayAnimAdvanced(ply, hackAnimDict, "hack_enter", v.doors.startloc.animcoords.x, v.doors.startloc.animcoords.y, v.doors.startloc.animcoords.z, 0, 0, 0, 1.0, 0.0, 8300, 0, 0.3, false, false, false)
                        Wait(0)
                        SetEntityHeading(ply, v.doors.startloc.animcoords.h)
                        while IsEntityPlayingAnim(ply, hackAnimDict, "hack_enter", 3) do
                            Wait(0)
                        end
                        local laptop = CreateObject(`hei_prop_hst_laptop`, GetOffsetFromEntityInWorldCoords(ply, 0.2, 0.6, 0.0), 1, 1, 0)
                        Wait(0)
                        SetEntityRotation(laptop, GetEntityRotation(ply, 2), 2, true)
                        PlaceObjectOnGroundProperly(laptop)
                        Wait(0)
                        TaskPlayAnim(ply, hackAnimDict, "hack_loop", 1.0, 0.0, -1, 1, 0, false, false, false)
                    
                        Wait(1000)

                        if exports["minigame-fleeca"]:HackingFleeca(10000, 1) then
                            StopAnimTask(PlayerPedId(), hackAnimDict, "hack_loop", 1.0)
                            TriggerEvent('qb-fleeca:darkmail')
                            DeleteObject(laptop)
                            ClearPedTasksImmediately(ply)    
                            Citizen.SetTimeout(120000, function()
                                TriggerServerEvent("qb-fleeca:startcheck", k)
                            end)

                        end
                        -- QBCore.Functions.TriggerCallback("qb-fleeca:getPolice", function(amount)			
                        --     CurrentCops = amount
                        --     if CurrentCops >= Fleeca.mincops then
                        --             --TriggerEvent("client:newStress", true, 500)
                        --             TriggerServerEvent("qb-fleeca:startcheck", k)
                        --         else
                        --             QBCore.Functions.Notify("Gefaald.", "error")
                        --         end
                        --     else
                        --         QBCore.Functions.Notify("geen politie.", "error")
                        --     end     
                    
                        --     DeleteObject(laptop)
                        --     ClearPedTasksImmediately(ply)    
                        return p
                    else
                        QBCore.Functions.Notify("No Laptop", "error")
                    end
                end, "greenlaptop")
            end 
        end      		
    end  
end)