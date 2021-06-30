local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("armorskeleton_none", {
	base_prefab = "armorskeleton",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "ANIM", "anim/armorskeleton_none.zip"),
        Asset( "INV_IMAGE", "armorskeleton_none"),
    },
    init_fn = function(inst) armorskeleton_init_fn(inst, "armorskeleton_none") end,
	skin_tags = { "ARMORSKELETON" },
}))

table.insert(prefabs, CreatePrefabSkin("skeletonhat_glass", {
	base_prefab = "skeletonhat",
	type = "item",
	rarity = "Glassic",
	assets = {
		Asset( "ANIM", "anim/skeletonhat_glass.zip"),
		Asset( "INV_IMAGE", "skeletonhat_glass"),
	},
	init_fn = function(inst) skeletonhat_init_fn(inst, "skeletonhat_glass") end,
	skin_tags = { "SKELETONHAT" },
}))

return unpack(prefabs)
