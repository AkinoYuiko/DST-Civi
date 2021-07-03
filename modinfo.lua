version = "6.1"
-- basic info --
name = locale == "zh" and "光暗魔法使" or "Civi"
author = locale == "zh" and "丁香女子学校" or "Civi, Potter_Lee, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 
- 去除MOD选项
- 移除道具：黑莲、光之莲、暗之莲
- 影背包现在不再能够插入黑宝石和白宝石
- 影刀现在可以插入黑宝石和白宝石了

* 通过吃黑/白宝石升/降级. 

* 专属道具和配方.
]] or "[Version: "..version..[[]

Changelog: 
- Remove mod configurations.
- Remove Black Lotus, Dark Lotus and Light Lotus.
- Night Backpack can no longer socket Dark/Light Gems.
- Dark Sword can socket Dark/Light Gems now.

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

configuration_options = {}
