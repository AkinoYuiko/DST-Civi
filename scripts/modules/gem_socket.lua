local Action = GLOBAL.Action
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = GLOBAL.ActionHandler
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

local GEMTRADE = Action({mount_valid=true})

GEMTRADE.id = "GEMTRADE"

GEMTRADE.str = STRINGS.ACTIONS.GIVE.SOCKET

GEMTRADE.fn = function(act)
    local _d = act.doer
    local _t = act.target
    if _d.components.inventory then
        local _i = _d.components.inventory:RemoveItem(act.invobject)
        -- if _i and _t and _t.prefab == "nightpack"  then
            -- local wetmult = _f:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1

            -- _d.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        local isdummy = _d.prefab == "dummy" and true or nil
        if _t.OnGemTrade ~= nil then 
            if _i.prefab == "nightmarefuel" then _t.OnGemTrade(_t,"fuel") end
            if _i.prefab == "redgem" then _t.OnGemTrade(_t,"red",isdummy) end
            if _i.prefab == "bluegem" then _t.OnGemTrade(_t,"blue",isdummy) end
            if _i.prefab == "purplegem" then _t.OnGemTrade(_t,"purple",isdummy) end
            if _i.prefab == "yellowgem" then _t.OnGemTrade(_t,"yellow",isdummy) end
            if _i.prefab == "orangegem" then _t.OnGemTrade(_t,"orange",isdummy) end
            if _i.prefab == "greengem" then _t.OnGemTrade(_t,"green",isdummy) end
            if _i.prefab == "opalpreciousgem" then _t.OnGemTrade(_t,"opal",isdummy) end
            if _i.prefab == "darkgem" then _t.OnGemTrade(_t,"dark",isdummy) end
            if _i.prefab == "lightgem" then _t.OnGemTrade(_t,"light",isdummy) end
        end
            -- act.invobject:Remove()
            -- _f:Remove()
        -- end
        _i:Remove()
        return true
    end
end


AddAction(GEMTRADE)
local pack_table = {
    "nightpack",
    "nightback"
}
function SetupActionGemTrading(inst, doer, target, actions, right)
    if target.prefab == "nightpack" and target:HasTag("nofuelsocket") and inst.prefab == "nightmarefuel" then return end
    if doer.replica.rider:IsRiding() and table.contains(pack_table, target.prefab) and target.components.inventoryitem and target.components.inventoryitem.owner ~= doer then return end 
    if table.contains(pack_table, target.prefab) then
        table.insert(actions, 1, ACTIONS.GEMTRADE)
    end
    


end

AddComponentAction("USEITEM","nightgem",SetupActionGemTrading)

AddStategraphActionHandler("wilson", ActionHandler(GEMTRADE, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(GEMTRADE, "doshortaction"))

AddPrefabPostInit("nightmarefuel",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("redgem",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("bluegem",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("purplegem",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("yellowgem",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("orangegem",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("greengem",function(inst) inst:AddComponent("nightgem") end)
AddPrefabPostInit("opalpreciousgem",function(inst) inst:AddComponent("nightgem") end)