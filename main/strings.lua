local STRINGS = GLOBAL.STRINGS
local strings = {
    NAMES = 
    {
        LIGHTAMULET = "Light Amulet",
        DARKAMULET = "Dark Amulet",
        NIGHTPACK = "Night Backpack",
        BLACKLOTUS = "Black Lotus",
        DARKLOTUS = "Dark Lotus",
        DARKGEM = "Dark Gem",
        LIGHTGEM = "Light Gem"
    },
    RECIPE_DESC =
    {
        REDGEM = "Change ice into fire.",
        BLUEGEM = "Change fire into ice.",
        BLACKLOTUS = "Shine in the darkness.",
        NIGHTPACK = "Dark away.",
        DARKAMULET = "Powerful but dark.",
        LIGHTAMULET = "Keep away from dark things.",
        DARKGEM = "Upgrades!",
        LIGHTGEM = "Degrades!",
    },
    SKIN_NAMES = 
    {
        civi_none = "Civi",
        armorskeleton_none = "Emperor's Formal"
    },
    SKIN_DESCRIPTIONS = 
    {
        civi_none = "Civi can control magic, turning lights into darks, or turning darks into lights."
    },
    CIVI_GEMS = 
    {
        FEEL_DARK = "I felt the dark.",
        ALREADY_DARK = "I've already in the dark."
    },
    CHARACTERS =
    {
        GENERIC =
        {
            DESCRIBE =
            {
                BLACKLOTUS = "Is it real?",
                DARKLOTUS = "Is it real?",
                LIGHTLOTUS = "Is it real?",
                NIGHTPACK = "It seems to need some glowing materials.",
                DARKAMULET = "I can feel the darkness coming.",
                LIGHTAMULET = "I can feel the darkness away.",
                DARKGEM = "Get closer to dark!",
                LIGHTGEM = "Get closer to light!",
            }
        }
    },
    -- character
    CHARACTER_NAMES = 
    {
        civi = "Civi"
    },
    CHARACTER_TITLES = 
    {
        civi = "Civi"
    },
    CHARACTER_ABOUTME = 
    {
        civi = "Civi"
    },
    CHARACTER_DESCRIPTIONS = 
    {
        civi = "Civi"
    },
    CHARACTER_QUOTES = 
    {
        civi = "Civi"
    },
    CHARACTER_BIOS = 
    {
        civi = {
            { title = "Birthday", desc = "Feb 25" },
            { title = "Favorite Food", desc = "Lv.0 - "..STRINGS.NAMES.BONESOUP.."\nLv.1 - "..STRINGS.NAMES.MEATBALLS.."\nLv.2 - "..STRINGS.NAMES.VOLTGOATJELLY },
            -- { title = "Secret Knowledge", desc = "While toiling away in his home laboratory late one night, Wilson was startled to hear a voice on the radio speaking directly to him. At first he feared he'd gone mad from too many late nights of experiments and accidentally-inhaled chemical fumes, but the voice assured him that it was no mere figment of the imagination. In fact, the voice had a proposition for him: if Wilson would build a machine according to their specifications, then he would be rewarded with secret knowledge, the likes of which no one had ever seen. Casting aside his better judgement (after all, what harm could come from making a vague bargain with a mysterious disembodied voice?) Wilson threw himself into constructing the machine. When at long last it was finally completed, the gentleman scientist had a moment of hesitation... a moment that might have saved him from his impending fate, had he been just a bit stronger of will. But at the voice's insistence, Wilson flipped the switch and activated his creation... and was never seen again.\nWell, at least not in this world." },
        }
    },
}

GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeTranslationFromPO(MODROOT.."languages", "zh")

GLOBAL.UpdateCiviStrings = function()
    local file, errormsg = GLOBAL.io.open(MODROOT .. "languages/strings.pot", "w")
    if not file then print("Can't generate " .. MODROOT .. "languages/strings.pot", "\n", tostring(errormsg)) return end
    GlassicAPI.MakePOTFromStrings(file, strings)
end

-- GLOBAL.UpdateCiviStrings()
