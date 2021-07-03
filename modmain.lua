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
    "tuning",
    "strings",

    "gem_nightsword",
    "gem_socket",
    "night_switch",
    "prefabskin",
    "recipes",
    "sanity_calc_rework",
    "widgets",
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end
