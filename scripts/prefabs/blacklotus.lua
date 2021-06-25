local assets =
{
    Asset("ANIM", "anim/blacklotus.zip"),
    Asset("ANIM", "anim/swap_blacklotus.zip"),
}

local function fx_enable(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
    if owner ~= nil then
        if inst._fx == nil then
            inst._fx = SpawnPrefab("nightsword_sharp_fx")
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
    -- inst:Remove()
end

local function onupdate(inst, dt)
	inst.boost_time = inst.boost_time - dt
	if inst.boost_time <= 0 then
		inst.boost_time = 0
		if inst.boosted_task ~= nil then
            fx_disable(inst)
			inst.boosted_task:Cancel()
			inst.boosted_task = nil
		end
        inst.components.weapon:SetDamage(59.5)
        inst.components.equippable.dapperness = -1/3
	else
        fx_enable(inst)
        inst.components.weapon:SetDamage(72.25)
        inst.components.equippable.dapperness = -3/8
    end
end

local function onlongupdate(inst,dt)
	inst.boost_time = math.max(0,inst.boost_time - dt)
end

local function startboost(inst,duration)
	inst.boost_time = duration
	if inst.boosted_task == nil then
		inst.boosted_task = inst:DoPeriodicTask(1, onupdate, nil, 1)
		onupdate(inst,0)
end end

local function onrefuel(inst,player)
    inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    if player ~= nil and player.prefab == "civi" or player.prefab == "miotan" then
        startboost(inst,10)
    elseif player ~= nil and player.prefab == "dummy" then
        startboost(inst,12)
    else
        startboost(inst,8)
    end
end

local function onload(inst,data)
	if data ~= nil and data.boost_time ~= nil then startboost(inst,data.boost_time) end
end

local function onsave(inst,data)
	data.boost_time = inst.boost_time > 0 and inst.boost_time or nil
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blacklotus", "swap_machete")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if inst.boosted_task ~= nil then fx_enable(inst) end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    fx_disable(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blacklotus")
    inst.AnimState:SetBuild("blacklotus")
    inst.AnimState:PlayAnimation("idle")
    -- inst.AnimState:SetMultColour(1, 1, 1, .6)

    inst:AddTag("shadow")
    inst:AddTag("sharp")

    inst:AddTag("weapon")

    -- local swap_data = {sym_build = "swap_realnightsword", bank = "realnightsword"}

    local swap_data = {sym_build = "swap_blacklotus", sym_name = "swap_machete", bank = "blacklotus"}
    MakeInventoryFloatable(inst, "med", -0.05, {1.0, 0.4, 1.0}, true, -18, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("halloweenmoonmutable")


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(59.5)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst.onrefuelfn = onrefuel

	inst.boost_time = 0
    inst.boosted_task = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED

    MakeHauntableLaunch(inst)

    inst.OnLongUpdate = onlongupdate
    inst.OnSave = onsave
    inst.OnLoad = onload

    inst.OnRemoveEntity = onremove

    if TUNING.WEAPONPLAN ~= 1 then
        inst:DoTaskInTime(0, function(inst)
            inst.components.halloweenmoonmutable:Mutate("nightsword")
        end)
    end

    return inst
end

return Prefab("blacklotus", fn, assets)
