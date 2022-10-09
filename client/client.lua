local QBCore = exports['qb-core']:GetCoreObject()

local Headwarning = false
local DeadBody = nil 
local Diggin = false

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('qb-graverobbing:ResetGrave', function(OldGrave, state)
    Config.Graves[OldGrave].looted = state
end)

RegisterNetEvent("qb-graverobbing:shovelUse", function()
    local hasItem = QBCore.Functions.HasItem('shovel')
    if hasItem then
        if Diggin == false then
            if GetClockHours() >= 21 or GetClockHours() < 6 and GetClockHours() >= 0 then
                local ped = PlayerPedId()
                local PlayerPos = GetEntityCoords(ped)
                for k, v in pairs(Config.Graves) do
                    dist = #(PlayerPos - vector3(Config.Graves[k].coords))
                    if dist <= 1.5 then
                        if Config.Graves[k].looted == false then 
                            Config.Graves[k].looted = true
                            Headwarning = true
                            CurGrave = k
                            Wait(1000)
                            TriggerEvent('animations:client:EmoteCommandStart', {"dig"})
                            QBCore.Functions.Progressbar("digging", "Digging...", math.random(8000, 15000), false, true, {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                Diggin = true
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                TriggerServerEvent('qb-graverobbing:SetLooted', CurGrave)
                            end, function() -- Cancel
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                QBCore.Functions.Notify("Cancelled.", "error")
                            end)
                        else
                            Headwarning = true
                            QBCore.Functions.Notify("This body has already been removed.", "error", 3500)
                        end 
                    end 
                end
                if Headwarning == false then 
                    QBCore.Functions.Notify("Must be near headstone.", "error", 3500)
                end 
            else 
                QBCore.Functions.Notify("Someone may see me doing this....", "error", 3500)
            end
        else 
            QBCore.Functions.Notify("I should wait a min...", "error", 3500)
        end
    end
    Headwarning = false
end)

RegisterNetEvent('qb-graverobbing:BodyTime', function(OldGrave)
    Gender = math.random(1, #Config.NpcSkins)
    PedSkin = math.random(1, #Config.NpcSkins[Gender])
    model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
    heading = GetEntityHeading(PlayerPedId())
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    DeadBody = CreatePed(3, model, Config.Graves[OldGrave].coords.x, Config.Graves[OldGrave].coords.y, Config.Graves[OldGrave].coords.z, heading, false, true)
    StopPedSpeaking(DeadBody, true)
    DisablePedPainAudio(DeadBody, true)
    ApplyPedDamagePack(DeadBody,"BigHitByVehicle", 0.0, 9.0)
    ApplyPedDamagePack(DeadBody,"SCR_Dumpster", 0.0, 9.0)
    ApplyPedDamagePack(DeadBody,"SCR_Torture", 0.0, 9.0)
    loadAnimDict("combat@drag_ped@")
    local pid = PlayerPedId()
    Wait(1000)
    TaskPlayAnim(pid, "combat@drag_ped@", "injured_drag_plyr", 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    TaskPlayAnim(DeadBody, "combat@drag_ped@", "injured_drag_ped", 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    Wait(3000)
    StopAnimTask(pid, "combat@drag_ped@", "injured_drag_plyr", 1.0)
    StopAnimTask(DeadBody, "combat@drag_ped@", "injured_drag_ped", 1.0)
    ClearPedTasks(DeadBody)
    SetEntityHealth(DeadBody, 0)
    RemoveAnimDict("combat@drag_ped@")
    exports['qb-target']:AddTargetEntity(DeadBody, {
        options = {
            {
                type = "client",
                event = "qb-graverobbing:SearchBody",
                icon = "fas fa-search",
                label = "Search",
            },
        },
        distance = 3.0
    })
    TriggerEvent("qb-graverobbing:BodyCleanup")
end)

RegisterNetEvent("qb-graverobbing:BodyCleanup", function()
    Wait(120000)
    Diggin = false
    ending = false
    rarelives = false
    if DeadBody2 then 
        DeleteEntity(DeadBody2)
    end
    if DeadBody then 
        DeleteEntity(DeadBody)
    end
end)

RegisterNetEvent("qb-graverobbing:SearchBody", function()
    local ped = PlayerPedId()
    local chance = math.random(1, 100)
    local deadbodyPos = GetEntityCoords(DeadBody)
    TriggerEvent('animations:client:EmoteCommandStart', {"medic"})
    Wait(2000)
    QBCore.Functions.Progressbar("search", "Searching Body...", math.random(5000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if chance <= Config.Zombie then
            TriggerServerEvent("qb-graverobbing:body")
            Wait(5000)
            DeleteEntity(DeadBody)
            DoScreenFadeOut(1000)
            AnimpostfxPlay("rampage" , 1 ,false)
            TriggerEvent("qb-graverobbing:ZombStart1")
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        else
            TriggerServerEvent("qb-graverobbing:body")
            Wait(5000)
            DeleteEntity(DeadBody)
            TriggerEvent("qb-graverobbing:ZombReset")
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled.", "error")
    end)
end)

RegisterNetEvent("qb-graverobbing:ZombStart1", function()
    local ped = PlayerPedId()
    local PedCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    DeadBody2 = CreatePed(3, model, PedCoords.x, PedCoords.y, PedCoords.z, heading, false, true)
    SetEntityHealth(DeadBody2, 200)
    SetEntityMaxHealth(DeadBody2, 200)
    SetPedFleeAttributes(DeadBody2, 0, 0)
    ForcePedMotionState(DeadBody2, -1115154469, 0, 0, 0)
    SetPedCombatAttributes(DeadBody2, 46, true)
    SetPedCombatAttributes(DeadBody2, 0, false)
    TaskCombatPed(DeadBody2, ped, 0, 16)
    AddRelationshipGroup('PLAYER')
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('zomb')
    SetPedRelationshipGroupHash(DeadBody2, 'zomb')
    SetRelationshipBetweenGroups(5, 'zomb', 'PLAYER')
    SetRelationshipBetweenGroups(5, 'PLAYER', 'zomb')
    SetPedKeepTask(DeadBody2, true)
    StopPedSpeaking(DeadBody2,true)
    DisablePedPainAudio(DeadBody2, true)

    DoScreenFadeIn(1000)
    TriggerEvent("qb-graverobbing:ZombStart")

end)

local ending = false
local rarelives = false
RegisterNetEvent("qb-graverobbing:ZombStart", function()
    TriggerEvent("qb-graverobbing:ZombReset")
    Wait(5000)
    rarelives = true
    while true do
        Wait(1000)
        if rarelives == true then
            Wait(1000)
            local health = GetEntityHealth(DeadBody2)
            if health <= 0 then
                rarelives = false
                SetEntityHealth(DeadBody2, 200)
                SetEntityMaxHealth(DeadBody2, 200)
                SetPedCombatAttributes(DeadBody2, 46, true)
                SetPedCombatAttributes(DeadBody2, 0, false)
                SetCurrentPedWeapon(DeadBody2, 656458692, true)
                SetPedArmour(DeadBody2, 100)
                ForcePedMotionState(DeadBody2, -1115154469, 0, 0, 0)
                DisablePedPainAudio(DeadBody2, true)
                StopPedSpeaking(DeadBody2,true)
                TaskCombatPed(DeadBody2, PlayerPedId(), 0, 16)
                SetPedFleeAttributes(DeadBody2, 0, 0)
                SetPedKeepTask(DeadBody2, true)
                TriggerEvent("qb-graverobbing:ZombStart2")
            end
        end
    end
end)

RegisterNetEvent("qb-graverobbing:ZombStart2", function()
    Wait(4000)
    ending = true 
    while true do
        Wait(1000)
        if ending == true then 
            Wait(1000)
            local health = GetEntityHealth(DeadBody2)
            if health <= 0 then
                ending = false
                Wait(5000)
                NetworkFadeOutEntity(DeadBody2,false,false)
                Wait(1000)
                DeleteEntity(DeadBody2)
                AnimpostfxStopAll()
            end
        end
    end 
end)

RegisterNetEvent("qb-graverobbing:ZombReset", function()

    Wait(60000)
    Diggin = false
    ending = false
    rarelives = false
    if DeadBody2 then 
        DeleteEntity(DeadBody2)
    end
    if DeadBody then 
        DeleteEntity(DeadBody)
    end
    AnimpostfxStopAll()
end)

RegisterNetEvent("qb-graverobbing:CCornUse", function()
    if Config.PSBuffs == true then
        exports['ps-buffs']:StaminaBuffEffect(15000, 1.4)
    end
end)

RegisterNetEvent("qb-graverobbing:hcandygUse", function()
    if Config.PSBuffs == true then
        exports['ps-buffs']:AddHealthBuff(10000, 10)
    end
    SetTimecycleModifier("drug_flying_01")
    Wait(30000)
    ClearTimecycleModifier()
end)

RegisterNetEvent("qb-graverobbing:hcandyrUse", function()
    if Config.PSBuffs == true then
        exports['ps-buffs']:AddStressBuff(15000, 10)
    end
    SetTimecycleModifier("new_stripper_changing")
    Wait(30000)
    ClearTimecycleModifier()
end)
