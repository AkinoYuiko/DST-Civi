local Action = GLOBAL.Action
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = GLOBAL.ActionHandler
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

local REFUELBL = Action({mount_valid=true})
local REFUELBLWET = Action({mount_valid=true})

REFUELBL.id = "REFUELBL"
REFUELBLWET.id = "REFUELBLWET"

REFUELBL.str = ACTIONS.ADDFUEL.str
REFUELBLWET.str = ACTIONS.ADDWETFUEL.str

REFUELBL.fn = function(act)
    local _d = act.doer
    local _t = act.target
    if _d.components.inventory then
        local _f = _d.components.inventory:RemoveItem(act.invobject)
        if _f and _f.prefab == "nightmarefuel" and _t and _t.prefab == "blacklotus" and _t.components.finiteuses then
            local wetmult = _f:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
            local dummymult = _d.prefab == "dummy" and 1.25 or 1
            _t.components.finiteuses:Use(-20 * wetmult * dummymult)
            if _t.components.finiteuses:GetPercent() >= 1 then
                _t.components.finiteuses:SetPercent(1)
            end
            if _t.onrefuelfn ~= nil then _t.onrefuelfn(_t,_d) end
        end
        _f:Remove()
        return true
    end
end

REFUELBLWET.fn = REFUELBL.fn

AddAction(REFUELBL)
AddAction(REFUELBLWET)

function SetupActionRefueling(inst, doer, target, actions, right)
    if not (inst.prefab == "nightmarefuel" and target.prefab == "blacklotus") then return end
    if inst:GetIsWet() then
        table.insert(actions, ACTIONS.REFUELBLWET)
    else
        table.insert(actions, ACTIONS.REFUELBL)
    end
end

AddComponentAction("USEITEM","fuel",SetupActionRefueling)

AddStategraphActionHandler("wilson", ActionHandler(REFUELBL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(REFUELBL, "doshortaction"))

AddStategraphActionHandler("wilson", ActionHandler(REFUELBLWET, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(REFUELBLWET, "doshortaction"))
