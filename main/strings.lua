local STRINGS = GLOBAL.STRINGS
local strings = {
    NAMES = 
    {
        CIVI = "Civi",
        LIGHTAMULET = "Light Amulet",
        DARKAMULET = "Dark Amulet",
        NIGHTPACK = "Night Backpack",
        DARKGEM = "Dark Gem",
        LIGHTGEM = "Light Gem"
    },
    RECIPE_DESC =
    {
        REDGEM = "Change ice into fire.",
        BLUEGEM = "Change fire into ice.",
        NIGHTPACK = "Dark away.",
        DARKAMULET = "Powerful but dark.",
        LIGHTAMULET = "Keep away from dark things.",
        DARKGEM = "Upgrades!",
        LIGHTGEM = "Degrades!",
    },
    SKIN_NAMES = 
    {
        civi_none = "Civi",
        armorskeleton_none = "Emperor's Formal",
		skeletonhat_glass = "Crystal Skull",
    },
    SKIN_DESCRIPTIONS = 
    {
        civi_none = "Civi can control magic, turning lights into darks, or turning darks into lights."
    },
    CIVI_GEMS = 
    {
        FEEL_DARK = "I felt the dark.",
        ALREADY_DARK = "I've already in the dark.",
        FEEL_LIGHT = "I felt the light.",
        ALREADY_LIGHT = "I've already in the light.",
    },
    CHARACTERS =
    {
        GENERIC =
        {
            DESCRIBE =
            {
                NIGHTPACK = "It seems to need some glowing materials.",
                DARKAMULET = "I can feel the darkness coming.",
                LIGHTAMULET = "I can feel the darkness away.",
                DARKGEM = "Get closer to dark!",
                LIGHTGEM = "Get closer to light!",
            }
        },
        CIVI = require("speech_civi"),
        -- MIOTAN = require("speech_miotan")
    },
    -- character
    CHARACTER_NAMES = 
    {
        civi = "Civi"
    },
    CHARACTER_TITLES = 
    {
        civi = "Mogician of Light and Dark"
    },
    CHARACTER_ABOUTME = 
    {
        civi = "Civi can control magic, turning lights into darks, or turning darks into lights."
    },
    CHARACTER_DESCRIPTIONS = 
    {
        civi = "*Travel between light and dark.\n*Can control nightmare."
    },
    CHARACTER_QUOTES = 
    {
        civi = "\"Get close to Nightmare!\""
    },
    CHARACTER_BIOS = 
    {
        civi = {
            { title = "Birthday", desc = "Feb 25" },
            { title = "Favorite Food", desc = "Lv.0 - "..STRINGS.NAMES.BONESOUP.."\nLv.1 - "..STRINGS.NAMES.MEATBALLS.."\nLv.2 - "..STRINGS.NAMES.VOLTGOATJELLY },
            -- { title = "Secret Knowledge", desc = "While toiling away in his home laboratory late one night, Wilson was startled to hear a voice on the radio speaking directly to him. At first he feared he'd gone mad from too many late nights of experiments and accidentally-inhaled chemical fumes, but the voice assured him that it was no mere figment of the imagination. In fact, the voice had a proposition for him: if Wilson would build a machine according to their specifications, then he would be rewarded with secret knowledge, the likes of which no one had ever seen. Casting aside his better judgement (after all, what harm could come from making a vague bargain with a mysterious disembodied voice?) Wilson threw himself into constructing the machine. When at long last it was finally completed, the gentleman scientist had a moment of hesitation... a moment that might have saved him from his impending fate, had he been just a bit stronger of will. But at the voice's insistence, Wilson flipped the switch and activated his creation... and was never seen again.\nWell, at least not in this world." },
        }
    },
    CHARACTER_SURVIVABILITY = 
    {
        civi = STRINGS.CHARACTER_SURVIVABILITY.wilson
    },
}

-- GlassicAPI.MergeStringsToGLOBAL(require("speech_wortox"), strings.CHARACTERS.MIOTAN, true)
GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeTranslationFromPO(MODROOT.."languages")

GLOBAL.UpdateCiviStrings = function()
    local file, errormsg = GLOBAL.io.open(MODROOT .. "scripts/speech_civi.lua", "w")
    if not file then print("Can't update " .. MODROOT .. "scripts/speech_civi.lua", "\n", tostring(errormsg)) return end
    GlassicAPI.MergeSpeechFile(require("speech_civi"), file)
    local file, errormsg = GLOBAL.io.open(MODROOT .. "languages/strings.pot", "w")
    if not file then print("Can't generate " .. MODROOT .. "languages/strings.pot", "\n", tostring(errormsg)) return end
    GlassicAPI.MakePOTFromStrings(file, strings)
end

-- GLOBAL.UpdateCiviStrings()
