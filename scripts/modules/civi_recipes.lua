local ENV = env
GLOBAL.setfenv(1, GLOBAL)
local AddRecipe = ENV.AddRecipe

-- 黑宝石 --
AddRecipe("civi_darkgem",
{Ingredient("purplegem", 1),Ingredient("nightmarefuel", 4)},
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, "nightmaregem", nil, "darkgem.tex",nil,"darkgem")
AllRecipes["civi_darkgem"].sortkey = AllRecipes["purplegem"].sortkey + 0.1
STRINGS.NAMES.CIVI_DARKGEM = STRINGS.NAMES.DARKGEM

-- 白宝石 --
AddRecipe("civi_lightgem",
{Ingredient("purplegem", 1),Ingredient("nightmarefuel", 4)},
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, "nightmaregem", nil, "lightgem.tex",nil,"lightgem" )
AllRecipes["civi_lightgem"].sortkey = AllRecipes["civi_darkgem"].sortkey + 0.1
STRINGS.NAMES.CIVI_LIGHTGEM = STRINGS.NAMES.LIGHTGEM

-- 红宝石 --
AddRecipe("civi_redgem",
{Ingredient("bluegem", 1),Ingredient("nightmarefuel", 1)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true,nil, "nightmaregem", nil, "redgem.tex", nil, "redgem")
STRINGS.NAMES.CIVI_REDGEM = STRINGS.NAMES.REDGEM


-- 蓝宝石 --
AddRecipe("civi_bluegem",
{Ingredient("redgem", 1),Ingredient("nightmarefuel", 1)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true,nil, "nightmaregem", nil, "bluegem.tex",nil, "bluegem" )
STRINGS.NAMES.CIVI_BLUEGEM = STRINGS.NAMES.BLUEGEM

    -- 黑莲 --
if TUNING.WEAPONPLAN == 1 then
    AddRecipe("blacklotus",
    {Ingredient("nightsword", 1), Ingredient("darkgem",1), Ingredient("lightgem",1)},
    RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem")
elseif TUNING.WEAPONPLAN == 2 then
    AddRecipe("darklotus",
    {Ingredient("livinglog", 1), Ingredient("darkgem",1), Ingredient("nightmarefuel",10)}, nil, TECH.LOST)
    AddRecipe("lightlotus",
    {Ingredient("livinglog", 1), Ingredient("lightgem",1), Ingredient("nightmarefuel",10)}, nil, TECH.LOST)
end

    -- 影背包, 黑白护符 --
if TUNING.GEARPLAN == 1 then
    AddRecipe("nightpack",
    -- AddRecipe("glowingbackpack",
    {Ingredient("darkgem", 1), Ingredient("lightgem",1),Ingredient("nightmarefuel", 5)},
    RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem")
else
    -- 黑暗护符 --
    AddRecipe("civi_darkamulet",
    {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("darkgem",1)},
    RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem", nil, "darkamulet.tex", nil, "darkamulet")
    STRINGS.NAMES.CIVI_DARKAMULET = STRINGS.NAMES.DARKAMULET

    AddRecipe("darkamulet",
    {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("darkgem",1)},
    RECIPETABS.ANCIENT, TECH.ANCIENT_TWO,  nil, nil, true)
    AllRecipes["darkamulet"].sortkey = AllRecipes["greenamulet"].sortkey + 0.1
    -- 光明护符 --
    AddRecipe("civi_lightamulet",
    {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("lightgem",1)},
    RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem", nil, "lightamulet.tex", nil, "lightamulet")
    STRINGS.NAMES.CIVI_LIGHTAMULET = STRINGS.NAMES.LIGHTAMULET

    AddRecipe("lightamulet",
    {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("lightgem",1)},
    RECIPETABS.ANCIENT, TECH.ANCIENT_TWO,  nil, nil, true)
    AllRecipes["lightamulet"].sortkey = AllRecipes["darkamulet"].sortkey + 0.1
end

