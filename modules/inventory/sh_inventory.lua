
AGF.Inventory.Items = {}

AGF.Items = {
	
	LoadItems = function()
		
		local _, dirs = file.Find("agf/gamemode/modules/inventory/items/*", "LUA")

		for _, dir in pairs(dirs) do

			AGF.Inventory.Items[dir] = {}

			for key, name in pairs(file.Find("agf/gamemode/modules/inventory/items/"..dir.."/*", "LUA")) do

				if SERVER then AddCSLuaFile("items/"..dir.."/"..name) end

				Item = {

					id = string.gsub(string.lower(name), ".lua", ""),
					material = Material(""),
					OnEquip = function() end,
					OnHolster = function() end

				}

				include("items/"..dir.."/"..name)

				if Item.Model then

					util.PrecacheModel(Item.Model)

				end

				AGF.Inventory.Items[dir][Item.id] = Item

				Item = nil

			end

		end

	end,

	Get = function( item )
		
		return AGF.Inventory.Items[item.class][item.id]

	end

}

AGF.Items.LoadItems()