GLOBAL.setfenv(1, GLOBAL)

if not rawget(_G, "armorskeleton_clear_fn") then
    armorskeleton_init_fn = function(inst, build)
        
        local function onequipfn(inst, data)
            data.owner.AnimState:ClearOverrideSymbol("swap_body")
        end


        if not TheWorld.ismastersim then return end

        inst.skinname = build
        inst.AnimState:SetBuild(build)
        if inst.components.inventoryitem then 
            inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
        end

        inst:ListenForEvent("equipped", onequipfn)
        inst.OnSkinChange = function(inst) 
            inst:RemoveEventCallback("equipped", onequipfn)
        end
    end
    armorskeleton_clear_fn = function(inst)
        inst.AnimState:SetBuild("armor_skeleton")
        if not TheWorld.ismastersim then return end
    	inst.components.inventoryitem:ChangeImageName()
    end
end

GlassicAPI.SkinHandler.AddModSkins({
    civi = { 
        is_char = true,
        "civi_none"
    },
    armorskeleton = {
        { name = "armorskeleton_none", test_fn = GlassicAPI.SetExclusiveToPlayer("civi") },
    }
})