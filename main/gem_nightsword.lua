local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function InitContainer(inst)
    inst:AddTag("nogemsocket")

    if not TheWorld.ismastersim then return end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("nightsword")
    inst.components.container.canbeopened = false
end

local NIGHTSWORDGEM = Action({ mount_valid = true, priority = 2 })

NIGHTSWORDGEM.id = "NIGHTSWORDGEM"
NIGHTSWORDGEM.str = STRINGS.ACTIONS.GIVE.SOCKET
NIGHTSWORDGEM.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)

        target:InitContainer()

        doer:DoTaskInTime(0.2, function(inst)
			if doer.components.inventory:IsItemEquipped(target) then
		        if target.replica.container then
   		            target.replica.container:Open(doer)
   		        end
        	end
        end)

        target.components.container:GiveItem(item)

        return true
    end
end

ENV.AddAction(NIGHTSWORDGEM)
ENV.AddComponentAction("USEITEM", "nightgem", function(inst, doer, target, actions, right)
    if right and target.prefab == "nightsword" and not target:HasTag("nogemsocket") then
        table.insert(actions, ACTIONS.NIGHTSWORDGEM)
    end
end)

ENV.AddStategraphActionHandler("wilson", ActionHandler(NIGHTSWORDGEM, "doshortaction"))
ENV.AddStategraphActionHandler("wilson_client", ActionHandler(NIGHTSWORDGEM, "doshortaction"))

ENV.AddComponentAction("INVENTORY", "nightgem", function(inst, doer, actions, right)
    if doer.replica.inventory ~= nil and not doer.replica.inventory:IsHeavyLifting() then
        local sword = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if sword and sword.prefab == "nightsword"
            and sword.replica.container ~= nil and sword.replica.container:IsOpenedBy(doer)
            and sword.replica.container:CanTakeItemInSlot(inst) then

            table.insert(actions, ACTIONS.CHANGE_TACKLE)
        end
    end
end)

local function onequipfn(inst, data)
    if inst.components.container then
        inst.components.container:Open(data.owner)
    end
end

local function onunequipfn(inst)
    if inst.components.container then
        inst.components.container:Close()
    end
end

local function onitemget(inst, data)
    if inst.remove_container_task ~= nil then
        inst.remove_container_task:Cancel()
        inst.remove_container_task = nil
    end
    if data.item.prefab == "darkgem" then
        inst.components.weapon:SetDamage(76.5)
        inst.components.weapon.attackwearmultipliers:SetModifier("nightgem", 1.25)
        inst.components.equippable.dapperness = TUNING.CRAZINESS_MED * 1.5
    elseif data.item.prefab == "lightgem" then
        inst.components.weapon:SetDamage(68)
        inst.components.weapon.attackwearmultipliers:SetModifier("nightgem", 0.8)
        inst.components.equippable.dapperness = 0
    end
end

local function onitemlose(inst)
    inst.components.weapon:SetDamage(68)
    inst.components.weapon.attackwearmultipliers:RemoveModifier("nightgem")
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
    if inst.remove_container_task ~= nil then
        inst.remove_container_task:Cancel()
        inst.remove_container_task = nil
    end
    inst.remove_container_task = inst:DoTaskInTime(1, function(inst)
        if inst.components.container and inst.components.container:IsEmpty() then
            inst.components.container:Close()
            inst:RemoveComponent("container")
            inst:RemoveTag("nogemsocket")
            inst.remove_container_task = nil
        end
    end)
end

ENV.AddPrefabPostInit("nightsword", function(inst)
    if not TheWorld.ismastersim then return end

    local onfinished = inst.components.finiteuses.onfinished or function() end
    inst.components.finiteuses:SetOnFinished(function(inst, ...)
        local container = inst.components.container
        if container then
            local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
            local inv = owner and owner.components.inventory
            local item = container:RemoveItemBySlot(1)
            if item then
                inst.components.finiteuses:SetPercent(1)
                if owner and owner.prefab == "civi" then
                    local gem = inv:FindItem(function(new_item) return new_item.prefab == item.prefab end)
                    if gem then
                        -- local slot_widget
                        local slot = inv:GetItemSlot(gem)
                        local overflow = inv:GetOverflowContainer()
                        local controls = owner.HUD.controls
                        local slot_widget = slot and controls.inv.inv[slot] -- check inventory first
                            or ( inv:GetActiveItem() == gem and controls.inv.hovertile ) -- else, check active item
                            or ( overflow -- else, if backpack, check backpack
                                and (
                                    controls.containers[overflow.inst] -- if backpack is side-display
                                    and controls.containers[overflow.inst].inv[overflow:GetItemSlot(gem)]
                                    or controls.inv.backpackinv[overflow:GetItemSlot(gem)]
                                )
                            )
                        local single_gem = inv:RemoveItem(gem)
                        if single_gem then
                            local pos = slot_widget
                                and Vector3(TheSim:ProjectScreenPos(slot_widget:GetWorldPosition():Get()))
                                or inst:GetPosition()
                            container:GiveItem(single_gem, nil, pos)
                        end
                    end
                end
                item:Remove()
                return
            end
        end
        return onfinished(inst, ...)
    end)

    inst.InitContainer = InitContainer

    inst:ListenForEvent("equipped", onequipfn)
    inst:ListenForEvent("unequipped", onunequipfn)

    inst:ListenForEvent("itemget", onitemget)
    inst:ListenForEvent("itemlose", onitemlose)

    -- inst.components.finiteuses:SetMaxUses(1) -- for testing gem auto refiell
    -- inst.components.finiteuses:SetPercent(1) -- for testing gem auto refiell

    local on_save = inst.OnSave or function() end
    inst.OnSave = function(inst, data, ...)
        data._iscontainer = inst.components.container and true
        return on_save(inst, data, ...)
    end

    local on_preload = inst.OnPreLoad or function() end
    inst.OnPreLoad = function(inst, data, ...)
        if data and data._iscontainer then
            inst:InitContainer()
        end
        return on_preload(inst, data, ...)
    end
end)
