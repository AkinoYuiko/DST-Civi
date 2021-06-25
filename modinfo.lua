version = "5.25.1"
-- basic info --
name = locale == "zh" and "光暗魔法使" or "Civi"
author = locale == "zh" and "丁香女子学校" or "Civi, Potter_Lee, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 优化了文件结构.

* 通过吃黑/白宝石升/降级. 

* 专属道具和配方.

*** 请仔细看模组选项! ***
]] or "[Version: "..version..[[]

Changelog: modmain rework.

* Upgrades/Degrades by eating Dark/Light Gems.

* Exclusive items and recipes.


*** PLEAZE CHECK MOD OPTIONS!! ***]]

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
        ["DST-GlassicAPI"] = false,
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
		name = "WEAPONPLAN",
		label = (locale == "zh" and "选择武器方案" or "Specify weapon plan"),
		hover = "",
		options = {
			{description = (locale == "zh" and "【黑莲】" or "Black Lotus"),
			 hover = (locale == "zh" and "攻击力 59.5, 耐久 100, 可以使用【噩梦燃料】充能"
 			 						or "59.5 Damage, 100 Uses; Can be refueled."),
			 data = 1
			},
			{description = (locale == "zh" and "【暗莲】和【光莲】" or "Dark/Light Lotus"),
			 hover = (locale == "zh" and "【暗莲】: 攻击力 76.5, 耐久 100; 【光莲】: 攻击力 68, 耐久 150; "
 			 						or "Dark: 76.5 Damage, 100 Uses; Light: 68 Damage, 150 Uses."),
			 data = 2
			},
			-- {description = "Off", data = 0, hover = "Disable extra functions."},
		},
		default = 1,
	},
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