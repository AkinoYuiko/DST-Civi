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

if not rawget(_G, "skeletonhat_clear_fn") then
	skeletonhat_init_fn = function(inst, build)

		local function onequipfn(inst, data)
			data.owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
		--	data.owner.AnimState:ClearOverrideSymbol("swap_body")
		end
		
		if not TheWorld.ismastersim then return end

		inst.skinname = build
		inst.AnimState:SetBuild(build)
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
		end

		inst:ListenForEvent("equipped", onequipfn)
		inst.OnSkinChange = function(isnt)
			inst:RemoveEventCallback("equipped", onequipfn)
		end
	end

	skeletonhat_clear_fn = function(inst)
		inst.AnimState:SetBuild("hat_skeleton")
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
    },
	skeletonhat = {
		{ name = "skeletonhat_glass", test_fn = GlassicAPI.SetExclusiveToPlayer("civi") },
	}
})
