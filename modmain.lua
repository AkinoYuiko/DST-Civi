-- local GlassicAPI = GLOBAL.GlassicAPI
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

modimport("strings/civi_init.lua")
modimport("scripts/modules/prefabskin.lua")
modimport("strings/civi_str"..(table.contains({"zh","chs","cht"}, GLOBAL.LanguageTranslator.defaultlang) and "_chs" or "")..".lua")

-- mod config --
TUNING.WEAPONPLAN = GetModConfigData("WEAPONPLAN")
TUNING.GEARPLAN = GetModConfigData("GEARPLAN")

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
