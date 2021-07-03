local assets =
{
--    Asset("ANIM", "anim/blacklotus.zip"),
--    Asset("ANIM", "anim/swap_darklotus.zip"),
--    Asset("ANIM", "anim/swap_lightlotus.zip"),
}

local function fx_enable(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
    if owner ~= nil then
        if inst._fx == nil then
            inst._fx = SpawnPrefab("nightsword_curve_fx")
            inst._fx.entity:AddFollower()
        end
        inst._fx.entity:SetParent(owner.entity)
        inst._fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -100, 0)
    end
end

local function fx_disable(inst)
    if inst._fx ~= nil then
        inst._fx:Remove()
        inst._fx = nil
    end
end

local function onremove(inst)
    fx_disable(inst)
end

local function onfinished(inst)
    local owner = inst.components.inventoryitem.owner or nil
    if owner ~= nil and owner.prefab == "civi" and owner.components.inventory then
        local inv = owner.components.inventory
        if inst.prefab == "darklotus" and inv:Has("darkgem",1) then
            inv:ConsumeByName("darkgem",1)
            inst.components.finiteuses:SetPercent(1)
            SpawnPrefab("pandorachest_reset").entity:SetParent(owner.entity)
        elseif inst.prefab == "lightlotus" and inv:Has("lightgem",1) then
            inv:ConsumeByName("lightgem",1)
            inst.components.finiteuses:SetPercent(1)
            SpawnPrefab("pandorachest_reset").entity:SetParent(owner.entity)
        else
            inst:Remove()
        end
    else
        inst:Remove()
    end
end

local function onequip_dark(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_darklotus", "swap_machete")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    fx_enable(inst)
end
local function onequip_light(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_lightlotus", "swap_machete")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    fx_disable(inst)
end

local function darkfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blacklotus")
    inst.AnimState:SetBuild("blacklotus")
    inst.AnimState:PlayAnimation("idle_dark")

    inst:AddTag("shadow")
    inst:AddTag("sharp")

    inst:AddTag("weapon")

    local swap_data = {sym_build = "swap_darklotus", sym_name = "swap_machete", bank = "blacklotus", anim="idle_dark"}
    MakeInventoryFloatable(inst, "med", -0.05, {1.0, 0.4, 1.0}, true, -18, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("halloweenmoonmutable")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(76.5)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip_dark)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = (TUNING.CRAZINESS_MED * 1.5)

    MakeHauntableLaunch(inst)

    inst.OnRemoveEntity = onremove

    inst:DoTaskInTime(0, function(inst)
        inst.components.halloweenmoonmutable:Mutate("nightsword")
    end)

    return inst
end


local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blacklotus")
    inst.AnimState:SetBuild("blacklotus")
    inst.AnimState:PlayAnimation("idle_light")

    inst:AddTag("shadow")
    inst:AddTag("sharp")

    inst:AddTag("weapon")

    local swap_data = {sym_build = "swap_lightlotus", sym_name = "swap_machete", bank = "blacklotus", anim="idle_light"}
    MakeInventoryFloatable(inst, "med", -0.05, {1.0, 0.4, 1.0}, true, -18, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("halloweenmoonmutable")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(120)
    inst.components.finiteuses:SetUses(120)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip_light)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst:DoTaskInTime(0, function(inst)
        inst.components.halloweenmoonmutable:Mutate("nightsword")
    end)

    return inst
end

return Prefab("darklotus", darkfn, assets),
        Prefab("lightlotus",lightfn, assets)
