Assets = {}
PrefabFiles = {
	"civi",
    "civi_amulets",
    "civi_gems",
    "civi_skins",
    "blacklotus",
    "lightlotus",
    "nightpack",
}

GlassicAPI.InitCharacterAssets("civi", "MALE", Assets)
GlassicAPI.InitMinimapAtlas("civi_minimap", Assets)
GlassicAPI.RegisterItemAtlas("civi_inventoryimages", Assets)

local main_files = {
    "gem_socket",
    "lotus_switch",
    "night_switch",
    "prefabskin",
    "recipes",
    "refuel_sword",
    "sanity_calc_rework",
    "strings",
    "tuning",
}

for _,v in pairs(main_files) do modimport("main/"..v) end
