local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("armorskeleton_none", {
	base_prefab = "armorskeleton",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/armorskeleton_none.zip" ),
        Asset( "PKGREF", "anim/dynamic/armorskeleton_none.dyn" ),
    },
    init_fn = function(inst) armorskeleton_init_fn(inst, "armorskeleton_none") end,
	skin_tags = { "ARMORSKELETON" },
}))

table.insert(prefabs, CreatePrefabSkin("skeletonhat_glass", {
	base_prefab = "skeletonhat",
	type = "item",
	rarity = "Glassic",
	assets = {
		Asset( "DYNAMIC_ANIM", "anim/dynamic/skeletonhat_glass.zip" ),
		Asset( "PKGREF", "anim/dynamic/skeletonhat_glass.dyn" ),
	},
	init_fn = function(inst) skeletonhat_init_fn(inst, "skeletonhat_glass") end,
	skin_tags = { "SKELETONHAT" },
}))

return unpack(prefabs)
