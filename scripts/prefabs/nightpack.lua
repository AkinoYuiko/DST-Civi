local assets =
{
    Asset("ANIM", "anim/glowingbackpack.zip"),
    Asset("ANIM", "anim/ui_backpack_2x4.zip"),
}

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
        if inst.components.health then inst.components.health:DoDelta(5 * epicmult) end
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
    if not owner then return end

    local eslots = owner.components.inventory and owner.components.inventory.equipslots

    if eslots and inst.components.equippable:IsEquipped() then
        for k1, v1 in pairs(eslots) do
            if v1.components.finiteuses and v1.prefab == "blacklotus" then
                local _u = v1.components.finiteuses
                local _i = owner.components.inventory
                local _P = owner.prefab == "dummy" and 0.7 or 0.8
                if _u:GetPercent() <= _P and _i:Has("nightmarefuel", 1) then
                    SpawnPrefab("pandorachest_reset").entity:SetParent(v1.components.inventoryitem.owner.entity)
                    _u:SetPercent( math.min(1, (_u:GetPercent() + (1 - _P)) ))
                    _i:ConsumeByName("nightmarefuel", 1)
                    if v1.onrefuelfn ~= nil then v1.onrefuelfn(v1, owner) end
                end
            elseif v1.components.fueled and ( v1.prefab == "lantern" or v1.prefab == "minerhat" or v1.prefab == "bottlelantern" ) then
                local _f = v1.components.fueled
                local _i = owner.components.inventory
                local _fuel = _i:Has("lightbulb", 1) and "lightbulb" -- 荧光果
                            or (_i:Has("slurtleslime", 1) and "slurtleslime") -- 蜗牛粘液
                            or nil
                local _fuelvalue = _fuel == "lightbulb" and TUNING.MED_LARGE_FUEL
                            or ( _fuel == "slurtleslime" and TUNING.MED_FUEL )
                            or nil
                if _fuel ~= nil and _f:GetPercent() + _fuelvalue/_f.maxfuel*_f.bonusmult <= 1 then
                    _f:DoDelta(_fuelvalue*_f.bonusmult)
                    _i:ConsumeByName(_fuel, 1)
                    if _f.ontakefuelfn ~= nil then _f.ontakefuelfn(v1) end
                end
            elseif v1.components.fueled and v1.prefab == "molehat" then
                local _f = v1.components.fueled
                local _i = owner.components.inventory
                local _fuel = _i:Has("wormlight_lesser", 1) and "wormlight_lesser" -- 小发光浆果
                            or (_i:Has("wormlight", 1) and "wormlight") -- 发光浆果
                            or nil
                local _fuelvalue = _fuel == "lightbulb" and TUNING.MED_LARGE_FUEL
                            or ( _fuel == "slurtleslime" and TUNING.MED_FUEL )
                            or nil
                if _fuel ~= nil and _f:GetPercent() + _fuelvalue/_f.maxfuel*_f.bonusmult <= 1 then
                    _f:DoDelta(_fuelvalue*_f.bonusmult)
                    _i:ConsumeByName(_fuel, 1)
                    if _f.ontakefuelfn ~= nil then _f.ontakefuelfn(v1) end
                end
            end
        end
    end
end

-- local function ApplyGreen(inst,owner)
--     local slots = inst.components.container and inst.components.container.slots or nil
--     local isopen = inst.components.container and inst.components.container:IsOpen()
--     local newpack = SpawnPrefab("nightback")
--     newpack.state_time=inst.state_time
--     if owner and owner.components.inventory ~= nil then
--         owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
--         owner.components.inventory:Equip(newpack)
--         if isopen == false then
--             newpack.replica.container:Close()
--         end
--     else
--         newpack.Transform:SetPosition(inst.Transform:GetWorldPosition())
--     end
--     for k,v in pairs(slots) do
--         if newpack.components.container then
--             newpack.components.container:GiveItem(v,k)
--         end
--     end
--     inst:Remove()
-- end

local function ApplyState(inst, state)
    if state then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        if inst.components.inventoryitem then
            inst.components.inventoryitem:ChangeImageName(state ~= "fuel" and "nightpack_"..state.."" or "nightpack")
            inst.MiniMapEntity:SetIcon(state ~= "fuel" and "nightpack_"..state..".tex" or "nightpack.tex")
        end
        if state == "red" then
            if owner then ActivateListen(inst, owner) end
        elseif state == "blue" then
            if not inst:HasTag("fridge") then inst:AddTag("fridge") end
            if not inst:HasTag("nocool") then inst:AddTag("nocool") end
        elseif state == "purple" then
            if inst.components.equippable then inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE end
        elseif state == "yellow" then
            if inst.components.waterproofer then inst.components.waterproofer:SetEffectiveness(1) end
        elseif state == "orange" then
            if owner then autorefuel(inst, owner) end
        elseif state == "green" then
            inst.components.container:WidgetSetup("krampus_sack")
            inst.is_greenpack:set(true)
            if owner then
                local isopen = inst.components.container and inst.components.container:IsOpen()
                inst.components.container:Close()
                if isopen then
                    inst:DoTaskInTime(0, function(inst)
                        inst.components.container:Open(owner)
                    end)
                end
            end
        elseif state == "opal" then
            if not inst:HasTag("fridge") then inst:AddTag("fridge") end
            if inst:HasTag("nocool") then inst:RemoveTag("nocool") end
        elseif state == "dark" then
            if owner and owner.components.combat then
                owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.2, "nightpack")
            end
        elseif state == "light" then
            if inst._light == nil or not inst._light:IsValid() then
                inst._light = SpawnPrefab("lanternlight")
                -- end
            end
            if inst._light ~= nil or inst._light:IsValid() then
                inst._light.Light:SetIntensity(0.5)
                inst._light.Light:SetRadius(3)
                inst._light.Light:SetFalloff(0.7)
                if owner ~= nil then
                    inst._light.entity:SetParent(owner.entity)
                else
                    inst._light.entity:SetParent(inst.entity)
                end
            end
        end
    end
end

local function RenewState(inst, gemtype, isdummy)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
    if owner then RemoveListen(inst, owner) end
    -- dark --
    if owner and owner.components.combat then
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
    local slots = inst.components.container and inst.components.container.slots
    local isopen = inst.components.container and inst.components.container:IsOpen()
    local eslot = inst.components.equippable and inst.components.equippable.equipslot
    local newpack = SpawnPrefab("nightpack")

    if owner and owner.components.inventory then
        owner.components.inventory:Unequip(eslot)
        owner.components.inventory:Equip(newpack)
        if isopen == false then
            print("isopen = "..isopen)
            newpack.components.container:Close()
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
        newpack.OnGemTrade(newpack, gemtype, isdummy)
    end
end


local function onfuelupdate(inst)
    local owner = inst.components.inventoryitem.owner or nil
    if inst.components.fueled then
        if not inst.components.fueled:IsEmpty() then
            inst.components.fueled:StartConsuming()
            if inst._light == nil or not inst._light:IsValid() then
                inst._light = SpawnPrefab("lanternlight")
            end
            if inst._light ~= nil or inst._light:IsValid() then
                local fuelpercent = inst.components.fueled:GetPercent()
                inst._light.Light:SetIntensity(Lerp(0.3, 0.5, fuelpercent))
                inst._light.Light:SetRadius(Lerp(1.75, 2.25, fuelpercent))
                inst._light.Light:SetFalloff(.7)
                if owner ~= nil then
                    inst._light.entity:SetParent(owner.entity)
                else
                    inst._light.entity:SetParent(inst.entity)
                end
            end
        else
            inst.components.fueled:StopConsuming()
            inst:RemoveComponent("fueled")
    		if inst:HasTag("nofuelsocket") then inst:RemoveTag("nofuelsocket") end
            RenewState(inst)
        end
    end
end

local function InitFuelState(inst)
    if inst.components.fueled == nil then
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
        inst.components.fueled:InitializeFuelLevel(300)
        inst.components.fueled:SetDepletedFn(onfuelupdate)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        inst.components.fueled:SetPercent(0.6)
        inst.components.fueled.accepting = true
        onfuelupdate(inst)
    end
end

local function OnStateChange(inst, state, duration)
    inst._state = state
    if inst._state ~= "fuel" then
        inst.components.timer:StopTimer("state_change")
        inst.components.timer:StartTimer("state_change", duration)
        ApplyState(inst, inst._state)
    else
        inst:AddTag("nofuelsocket")
        InitFuelState(inst)
        ApplyState(inst, inst._state)
    end
end

local function OnGemTrade(inst, gemtype, isdummy)
    if inst._state ~= nil and inst._state ~= gemtype then
        RenewState(inst, gemtype, isdummy)
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

    local dummymult = isdummy and 1.2 or 1

    if gemtype == "fuel" then
        OnStateChange(inst, gemtype)
    elseif gemtype == "red" or gemtype == "dark" then
        OnStateChange(inst, gemtype, 480 * dummymult)
    elseif gemtype == "purple" or gemtype == "light" then
        OnStateChange(inst, gemtype, 1200 * dummymult)
    elseif gemtype == "blue" then
        OnStateChange(inst, gemtype, 2400 * dummymult)
    elseif gemtype == "yellow" or gemtype == "orange" then
        OnStateChange(inst, gemtype, 3000 * dummymult)
    elseif gemtype == "green" or gemtype == "opal" then
        OnStateChange(inst, gemtype, 7200 * dummymult)
    end
end

local function onequip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
    if inst._state ~= nil and inst._state ~= "fuel" then
        ApplyState(inst, inst._state)
    elseif inst._state == "fuel" then
        onfuelupdate(inst)
    end
end

local function onunequip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
    -- healing --
    RemoveListen(inst, owner)
    -- dark --
    if owner and owner.components.combat ~= nil then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst, "nightpack")
    end
    -- light
    if owner ~= nil then
        if inst._light ~= nil and inst._light:IsValid() then
        inst._light:Remove()
        end
    end
    if inst._state == "fuel" then
        onfuelupdate(inst)
    elseif inst._state == "light" then
        ApplyState(inst, "light")
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

local function OnSave(inst, data)
    data._state = inst._state or nil
    data.fuel_percent = inst.components.fueled and inst.components.fueled:GetPercent() or nil
end

local function OnLoad(inst, data)
    if data ~= nil and data._state then
        inst._state = data._state
        if data._state == "fuel" and data.fuel_percent ~= nil then
            InitFuelState(inst)
            inst.components.fueled:SetPercent(data.fuel_percent)
        end
        ApplyState(inst, data._state)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("glowingbackpack")
    inst.AnimState:SetBuild("glowingbackpack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    inst:AddTag("waterproofer")

    inst.MiniMapEntity:SetIcon("nightpack.tex")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst, "small", 0.3, 0.7)

    inst.entity:SetPristine()

    inst.is_greenpack = net_bool(inst.GUID, "is_greenpack")

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            local AttachClassified = inst.replica.container.AttachClassified
            inst.replica.container.AttachClassified = function(self, ...)
                if inst.is_greenpack:value() then
                    self:WidgetSetup("krampus_sack")
                end
                return AttachClassified(self, ...)
            end
            inst.replica.container:WidgetSetup("backpack")
        end
        return inst
    end

    inst._light = nil
    inst._state = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem:SetOnDroppedFn(function(inst)
        if inst._state == "fuel" then
            onfuelupdate(inst)
        end
    end)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("backpack")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", function(inst) RenewState(inst) end)

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst.OnGemTrade = OnGemTrade
    inst.RenewState = RenewState

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemove

    if TUNING.GEARPLAN ~= 1 then inst:DoTaskInTime(0, toberemoved) end

    return inst
end

return Prefab("nightpack", fn, assets)