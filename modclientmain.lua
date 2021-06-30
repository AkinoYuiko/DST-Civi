if GLOBAL.TheNet:GetIsClient() or GLOBAL.TheNet:GetIsServer() then return end

PrefabFiles = {
    "civi"
}

Assets = {
    Asset( "ATLAS", "bigportraits/civi_none.xml" ),
    Asset( "ATLAS", "images/names_civi.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_civi.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_civi.xml" ),
    Asset( "ATLAS", "images/avatars/self_inspect_civi.xml" ),
    Asset( "ATLAS", "images/saveslot_portraits/civi.xml" ),
}

AddModCharacter("civi", "MALE")

modimport("strings/civi_init.lua")
modimport("strings/civi_str"..(table.contains({"zh","chs","cht"}, GLOBAL.LanguageTranslator.defaultlang) and "_chs" or "")..".lua")

local SkinHandler = require("skinhandler")
SkinHandler.AddModSkins({
    civi = {
        is_char = true,
        "civi_none"
    },
})
