local assets =
{
    Asset("ANIM", "anim/nightpack.zip"),
    -- Asset("ANIM", "anim/ui_backpack_2x4.zip"),
--     Asset("ANIM", "anim/ui_krampusbag_2x5.zip"),
}

-- local assets_green =
-- {
--     Asset("ANIM", "anim/nightpack.zip"),
-- }

-- local prefabs = {
--     "nightback",
--     "lanternlight"
-- }

-- local prefabs_green = {
--     "nightpack",
--     "lanternlight"
-- }

-- function RED --
local function IsValidVictim(victim)
    return not (victim:HasTag("veggie") or
            victim:HasTag("structure") or
            victim:HasTag("wall") or
            victim:HasTag("balloon") or
            victim:HasTag("soulless") or
            victim:HasTag("groundspike") or
            victim:HasTag("smashable"))
    and (  (victim.components.combat ~= nil and victim.components.health ~= nil)
        or victim.components.murderable ~= nil )
end


local function OnHealing(inst, data)
    local victim = data.inst
    if victim ~= nil and
        victim:IsValid() and
        (   victim == inst or
            (   not inst.components.health:IsDead() and
                IsValidVictim(victim) and victim.components.health:IsDead() and
                inst:IsNear(victim, 15)
            )
        ) then
        local epicmult = victim:HasTag("dualsoul") and 2
                    or (victim:HasTag("epic") and math.random(7, 8))
                    or 1
        if inst.components.health then inst.components.health:DoDelta(10 * epicmult) end
    end
end

local function OnEntityDeath(inst, data)
    if data.inst ~= nil and data.inst.components.lootdropper == nil then
        OnHealing(inst, data)
    end
end

local function OnStarvedTrapSouls(inst, data)
    local trap = data.trap
    if trap ~= nil and
        (data.numsouls or 0) > 0 and
        trap:IsValid() and
        inst:IsNear(trap, 15) then
        if inst.components.health then inst.components.health:DoDelta(5 * data.numsouls) end
    end
end

local function OnMurdered(inst, data)
    local victim = data.victim
    if victim ~= nil and
        victim:IsValid() and
        (   not inst.components.health:IsDead() and
            IsValidVictim(victim)
        ) then
        if inst.components.health then inst.components.health:DoDelta(5 * (data.stackmult or 1)) end

    end
end

local function RemoveListen(inst, owner)
    if inst._onentitydroplootfn ~= nil then
        inst:RemoveEventCallback("entity_droploot", inst._onentitydroplootfn, TheWorld)
        inst._onentitydroplootfn = nil
    end
    if inst._onentitydeathfn ~= nil then
        inst:RemoveEventCallback("entity_death", inst._onentitydeathfn, TheWorld)
        inst._onentitydeathfn = nil
    end
    if inst._onstarvedtrapsoulsfn ~= nil then
        inst:RemoveEventCallback("starvedtrapsouls", inst._onstarvedtrapsoulsfn, TheWorld)
        inst._onstarvedtrapsoulsfn = nil
    end
    if inst._onmurderedfn ~= nil then
        inst:RemoveEventCallback("murdered", inst._onmurderedfn, owner)
        inst._onmurderedfn = nil
    end
end

local function ActivateListen(inst, owner)
    if inst._onentitydroplootfn == nil then
        inst._onentitydroplootfn = function(src, data) OnHealing(owner, data) end
        inst:ListenForEvent("entity_droploot", inst._onentitydroplootfn, TheWorld)
    end
    if inst._onentitydeathfn == nil then
        inst._onentitydeathfn = function(src, data) OnEntityDeath(owner, data) end
        inst:ListenForEvent("entity_death", inst._onentitydeathfn, TheWorld)
    end
    if inst._onstarvedtrapsoulsfn == nil then
        inst._onstarvedtrapsoulsfn = function(src, data) OnStarvedTrapSouls(inst, data) end
        inst:ListenForEvent("starvedtrapsouls", inst._onstarvedtrapsoulsfn, TheWorld)
    end
    if inst._onmurderedfn == nil then
        inst._onmurderedfn = function(src, data) OnMurdered(owner, data) end
        inst:ListenForEvent("murdered", inst._onmurderedfn, owner)
    end
end

-- function ORANGE --
local function autorefuel(inst, owner)
    if owner == nil then return end

    local function find_fn(prefab)
        return function(item)
            return item.prefab == prefab
        end
    end

    local eslots = owner.components.inventory and owner.components.inventory.equipslots

    if eslots and inst.components.equippable:IsEquipped() then
        for _, eprefab in ipairs(eslots) do
            if eprefab.components.finiteuses and eprefab.prefab == "blacklotus" then
                local uses = eprefab.components.finiteuses
                local inv = owner.components.inventory
                local refuel_percent = owner.prefab == "dummy" and 0.7 or 0.8
                if uses:GetPercent() <= refuel_percent and inv:Has("nightmarefuel", 1) then
                    SpawnPrefab("pandorachest_reset").entity:SetParent(eprefab.components.inventoryitem.owner.entity)
                    uses:SetPercent( math.min(1, (uses:GetPercent() + (1 - refuel_percent)) ))
                    inv:ConsumeByName("nightmarefuel", 1)
                    if eprefab.onrefuelfn then eprefab.onrefuelfn(eprefab, owner) end
                end
            elseif eprefab.components.fueled and ( eprefab.prefab == "lantern" or eprefab.prefab == "minerhat" or eprefab.prefab == "bottlelantern" ) then
                local fueled = eprefab.components.fueled
                local inv = owner.components.inventory
                local fuel = inv:RemoveItem(inv:FindItem(find_fn("lightbulb")) or inv:FindItem(find_fn("slurtleslime")))
                if fuel then
                    if not fueled:TakeFuelItem(fuel, owner) then
                        inv:GiveItem(fuel)
                    end
                end
            elseif eprefab.components.fueled and eprefab.prefab == "molehat" then
                local fueled = eprefab.components.fueled
                local inv = owner.components.inventory
                local fuel = inv:RemoveItem(inv:FindItem(find_fn("wormlight_lesser")) or inv:FindItem(find_fn("wormlight")))
                if fuel then
                    if not fueled:TakeFuelItem(fuel, owner) then
                        inv:GiveItem(fuel)
                    end
                end
            end
        end
    end
end


local function onfuelupdate(inst)
    -- local owner = inst.components.inventoryitem.owner
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lanternlight")
    end
    if inst._light ~= nil and inst._light:IsValid() then
        local fuelpercent = inst.components.fueled:GetPercent()
        inst._light.Light:SetIntensity(Lerp(0.3, 0.5, fuelpercent))
        inst._light.Light:SetRadius(Lerp(1.75, 2.25, fuelpercent))
        inst._light.Light:SetFalloff(.7)
        -- if owner ~= nil then
        --     inst._light.entity:SetParent(owner.entity)
        -- else
            inst._light.entity:SetParent(inst.entity)
        -- end
    end
end

local function nofuel(inst)
    inst.components.fueled:SetUpdateFn(nil)
    inst:RemoveComponent("fueled")
    if inst:HasTag("nofuelsocket") then
        inst:RemoveTag("nofuelsocket")
    end
    inst:RenewState()
end

local function ApplyState(inst, state)
    local owner = inst.components.inventoryitem.owner
    local StateFns = {

        red = function()
            if owner then
                ActivateListen(inst, owner)
            end
        end,

        blue = function()
            if not inst:HasTag("fridge") then
                inst:AddTag("fridge")
            end
            if not inst:HasTag("nocool") then
                inst:AddTag("nocool")
            end
        end,

        purple = function()
            inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
        end,

        yellow = function()
            inst.components.waterproofer:SetEffectiveness(1)
        end,

        orange = function()
            autorefuel(inst, owner)
        end,

        green = function()
            if inst.prefab == "nightpack" then
                local slots = inst.components.container and inst.components.container.slots
                local isopen = inst.components.container and inst.components.container:IsOpen()
                local eslot = inst.components.equippable and inst.components.equippable.equipslot
                local newpack = SpawnPrefab("nightback")
                newpack:OnChangeState("green", inst.components.timer:GetTimeLeft("state_change"))
                if owner and owner.components.inventory then
                    owner.components.inventory:Unequip(eslot)
                    owner.components.inventory:Equip(newpack)
                    if not isopen then
                        newpack.replica.container:Close()
                    end
                else
                    newpack.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
                for k, v in pairs(slots) do
                    if newpack.components.container then
                        newpack.components.container:GiveItem(v, k)
                    end
                end
                inst:Remove()
            end
        end,

        opal = function()
            if not inst:HasTag("fridge") then
                inst:AddTag("fridge")
            end
            if inst:HasTag("nocool") then
                inst:RemoveTag("nocool")
            end
        end,

        dark = function()
            if owner and owner.components.combat ~= nil then
                owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.2, "nightpack")
            end
        end,

        light = function()
            if inst._light == nil or not inst._light:IsValid() then
                inst._light = SpawnPrefab("lanternlight")
            end
            if inst._light ~= nil or inst._light:IsValid() then
                inst._light.Light:SetIntensity(.5)
                inst._light.Light:SetRadius(3)
                inst._light.Light:SetFalloff(.7)
                -- if owner ~= nil then
                --     inst._light.entity:SetParent(owner.entity)
                -- else
                    inst._light.entity:SetParent(inst.entity)
                -- end
            end
        end,

        fuel = function()
            if not inst:HasTag("nofuelsocket") then
                inst:AddTag("nofuelsocket")
            end
            if inst.components.fueled == nil then
                inst:AddComponent("fueled")
                inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
                inst.components.fueled:InitializeFuelLevel(300)
                inst.components.fueled:SetPercent(0.6)
                inst.components.fueled:SetDepletedFn(nofuel)
                inst.components.fueled:SetUpdateFn(onfuelupdate)
                inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
                inst.components.fueled.accepting = true

                inst.components.fueled:StartConsuming()
            end
        end

    }
    if state and inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName("nightpack_"..state)
        inst.MiniMapEntity:SetIcon("nightpack_"..state..".tex")
        inst.AnimState:PlayAnimation(state)
    end
    StateFns[state]()
end

local function RenewState(inst, gemtype, isdummy)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    -- healing --
    RemoveListen(inst, owner)
    -- dark --
    if owner and owner.components.combat ~= nil then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst, "nightpack")
    end
    -- light
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
    -- cancel task
    if inst.state_task ~= nil then
        inst.state_task:Cancel()
        inst.state_task = nil
    end
    -- <renew pack> --
    local slots = inst.components.container and inst.components.container.slots or nil
    local isopen = inst.components.container and inst.components.container:IsOpen()
    local newpack = SpawnPrefab("nightpack")
    if owner ~= nil then
        if owner.components.inventory ~= nil then
            owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
            owner.components.inventory:Equip(newpack)
            if isopen==false then
                newpack.replica.container:Close()
            end
        end
    else
        newpack.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
    for k, v in pairs(slots) do
        if k <= 8 and newpack.components.container then
            newpack.components.container:GiveItem(v, k)
        elseif k >= 9 then
            if owner ~= nil then
                owner.components.inventory:GiveItem(v, nil, owner:GetPosition())
            else
                newpack.components.container:GiveItem(v, k)
            end
        end
    end
    inst:Remove()
    if gemtype then
        newpack:OnGemTrade(gemtype, isdummy)
    end
end

-- local function InitFuelState(inst)
--     if inst.components.fueled == nil then
--         inst:AddComponent("fueled")
--         inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
--         inst.components.fueled:InitializeFuelLevel(300)
--         inst.components.fueled:SetDepletedFn(onfuelupdate)
--         inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
--         inst.components.fueled:SetPercent(0.6)
--         inst.components.fueled.accepting = true
--         onfuelupdate(inst)
--     end
-- end

local function OnChangeState(inst, state, duration)
    inst._state = state
    inst.components.timer:StopTimer("state_change")
    if duration then
        inst.components.timer:StartTimer("state_change", duration)
    end
    ApplyState(inst, inst._state)
end

local days = 480
local gemtype_time_table = {
    red     = 1 * days,
    dark    = 1 * days,
    purple  = 2.5 * days,
    light   = 2.5 * days,
    blue    = 5 * days,
    yellow  = 7.5 * days,
    orange  = 7.5 * days,
    green   = 15 * days,
    opal    = 15 * days,
}

local function OnGemTrade(inst, gemtype, isdummy)
    if inst._state ~= nil and inst._state ~= gemtype then
        inst:RenewState(gemtype, isdummy)
        return
    end

    if inst._state ~= gemtype then
        local target = (inst.components.inventoryitem and inst.components.inventoryitem.owner ) or inst
        SpawnPrefab("pandorachest_reset").entity:SetParent(target.entity)
        if gemtype == "fuel" then
            inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        else
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        end
    end
    -- if gemtype == "fuel" then
    --     OnChangeState(inst, gemtype)
    -- else
        OnChangeState(inst, gemtype, gemtype_time_table[gemtype] and gemtype_time_table[gemtype] * ( isdummy and 1.2 or 1 ) )
    -- end
end

local function onequip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
    if inst._state then
        ApplyState(inst, inst._state)
    end
end

local function onunequip(inst, owner)
    if inst.components.container then
        inst.components.container:Close(owner)
    end
    -- healing --
    RemoveListen(inst, owner)
    -- dark --
    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst, "nightpack")
    end
    -- light
    -- if owner ~= nil then
    --     if inst._light ~= nil and inst._light:IsValid() then
    --     inst._light:Remove()
    --     end
    -- end
    -- if inst._state == "fuel" then
    --     onfuelupdate(inst)
    -- else
    -- if inst._state == "light" then
    --     ApplyState(inst, "light")
    -- end
end

-- local function ondropped(inst)
--     if inst._state == "fuel" then
--         onfuelupdate(inst)
--     end
-- end

local function OnLoad(inst, data)
    if data and data._state then
        inst._state = data.state
        ApplyState(inst, data._state)
    end
end

local function OnSave(inst, data)
    if data then
        data._state = inst._state
    end
end

local function OnRemove(inst)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
    end
end

local function toberemoved(inst)
    if inst.components.container then inst.components.container:DropEverything() end
    OnRemove(inst)
    inst:Remove()
end

local function common_fn(is_green)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightpack")
    inst.AnimState:SetBuild("nightpack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    inst:AddTag("waterproofer")

    inst.MiniMapEntity:SetIcon("nightpack.tex")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst, "small", 0.3, .7)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup(is_green and "krampus_sack" or "backpack")
        end
        return inst
    end

    inst._light = nil
    inst._state = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    -- inst.components.inventoryitem:SetOnDroppedFn(ondropped)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup(is_green and "krampus_sack" or "backpack")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function(inst) inst:RenewState() end)

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst.OnGemTrade = OnGemTrade
    inst.RenewState = RenewState
    inst.OnChangeState = OnChangeState

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemove

    if is_green then
        inst:SetPrefabNameOverride("nightpack")
        inst:DoTaskInTime(0, function(inst)
            if inst._state ~= "green" then
                inst:RenewState()
            end
        end)
    end
    if TUNING.GEARPLAN ~= 1 then inst:DoTaskInTime(0, toberemoved) end

    return inst
end

local function fn()
    return common_fn()
end

local function fn_green()
    return common_fn(true)
end

return Prefab("nightpack", fn, assets),
       Prefab("nightback", fn_green, assets)