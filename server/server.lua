local QBCore = exports['qb-core']:GetCoreObject()
local OldGrave = nil


local function ResetGraveTimer(OldGrave)
    local num = 345000  -- 5 minutes 45 seconds
    local time = tonumber(num)
    SetTimeout(time, function()
        Config.Graves[OldGrave].looted = false
        TriggerClientEvent('qb-graverobbing:ResetGrave', -1, OldGrave, false)
    end)
end

QBCore.Functions.CreateUseableItem("shovel", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("qb-graverobbing:shovelUse", src)
	end
end)

QBCore.Functions.CreateUseableItem("ccorn", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("qb-graverobbing:CCornUse", src)
        Player.Functions.RemoveItem('ccorn', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['ccorn'], "remove", 1)
	end
end)

QBCore.Functions.CreateUseableItem("hcandyg", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("qb-graverobbing:hcandygUse", src)
        Player.Functions.RemoveItem('hcandyg', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['hcandyg'], "remove", 1)
	end
end)

QBCore.Functions.CreateUseableItem("hcandyr", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("qb-graverobbing:hcandyrUse", src)
        Player.Functions.RemoveItem('hcandyr', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['hcandyr'], "remove", 1)
	end
end)

QBCore.Functions.CreateUseableItem("agraphicnovel", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("qb-graverobbing:agraphicnovelUse", src)
	end
end)

RegisterServerEvent('qb-graverobbing:SetLooted', function(CurGrave)
    local OldGrave = nil
    local src = source
    local OldGrave = CurGrave
    if Config.Graves[OldGrave].looted == false then 
        ResetGraveTimer(OldGrave)
        TriggerClientEvent('qb-graverobbing:SetGraveState', -1, OldGrave, true)
    end
    TriggerClientEvent('qb-graverobbing:BodyTime', src, OldGrave)
    Config.Graves[OldGrave].looted = true
end)

RegisterServerEvent("qb-graverobbing:body", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = math.random(1, #Config.BodyLoot)
    local lootfound = false
    local chance = math.random(1, 100)
    if chance <= Config.DeadLootChance then 
        lootfound = true
        Player.Functions.AddItem(Config.BodyLoot[reward], 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.BodyLoot[reward]], "add", 1)
    end
    if chance >= Config.DeadRare then
        lootfound = true 
        Player.Functions.AddItem(Config.RareBodyItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RareBodyItem], "add", 1)
    end
    if lootfound == true then 
        TriggerClientEvent('QBCore:Notify', src, 'You found something in their pockets.', 'success', 3500)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You found nothing.', 'error', 3500)
    end
end)


