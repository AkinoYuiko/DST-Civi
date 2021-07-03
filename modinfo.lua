version = "6.0.RC1"
-- basic info --
name = locale == "zh" and "光暗魔法使" or "Civi"
author = locale == "zh" and "丁香女子学校" or "Civi, Potter_Lee, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 
- 抛弃旧版武器方案
- 影刀现在可以插入黑宝石和白宝石了

* 通过吃黑/白宝石升/降级. 

* 专属道具和配方.
]] or "[Version: "..version..[[]

Changelog: 
- Remove old weapon plans.
- Dark Sword can socket dark/light gems now.

* Upgrades/Degrades by eating Dark/Light Gems.

* Exclusive items and recipes.
]]

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 18
mod_dependencies = {
    {
        workshop = "workshop-2521851770",    -- Glassic API
        ["GlassicAPI"] = false,
        ["[API] Glassic API - DEV"] = true
    },
}
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = name .. " - DEV"
end

configuration_options =
{
	{
		name = "GEARPLAN",
		label = (locale == "zh" and "选择装备方案" or "Specify gear plan"),
		hover = "",
		options = {
			{description = (locale == "zh" and "背包" or "Night Backpack"),
			 hover = (locale == "zh" and "启用【影背包】" or "Enable Night Backpack."),
			 data = 1
			},
			{description = (locale == "zh" and "护符" or "Amulets"),
			 hover = (locale == "zh" and "启用【黑暗护符】和【光明护符】" or "Enable Dark Amulet and Light Amulet."),
			 data = 2
			},
			-- {description = "Off", data = 0, hover = "Disable gears."},
		},
		default = 1,
	}
}
