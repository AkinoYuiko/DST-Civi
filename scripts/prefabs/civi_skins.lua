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

return unpack(prefabs)