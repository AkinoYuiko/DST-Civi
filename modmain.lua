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

modimport("main/tuning")
modimport("main/strings")

modimport("scripts/modules/prefabskin.lua")

-- Special Recipe by Civi --
modimport("scripts/modules/civi_recipes.lua")

-- Refuel Black Lotus by Civi --
modimport("scripts/modules/refuel_sword.lua")

-- Gem trade on Nightpack by Civi --
modimport("scripts/modules/gem_socket.lua")

-- NightSwitch by Civi --
modimport("scripts/modules/nightswitch.lua")
modimport("scripts/modules/lotusswitch.lua")

-- Sanity Rework by Civi --
modimport("scripts/modules/sanity_calc_rework.lua")
