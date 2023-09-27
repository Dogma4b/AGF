
AddCSLuaFile("derma/slot.lua")
AddCSLuaFile("derma/item.lua")

AGF.Inventory = {}

function AGF.Inventory.Load(ply)

	ply.AGF = ply.AGF or {}
	
	ply.AGF.Inventory = {}

	ply.AGF.Equip = {}

	AGF.DB.FilterEqual("uid", ply:UniqueID())

	local inventory_data = AGF.DB.Get("Inventory")
	
	if (inventory_data != "null") then
		
		inventory_data = inventory_data[1]
		
		table.RemoveByValue(inventory_data, ply:UniqueID())
		
		if (inventory_data[gmod.GetGamemode().FolderName] == nil) then
		
			AGF.Inventory.Create(ply)
		
		end
		
		for key, json in pairs(inventory_data) do
		
			ply.AGF.Inventory[key] = util.JSONToTable(json)
		
		end
	
	else
	
		AGF.Inventory.Create(ply)
	
	end

end

hook.Add("PlayerInitialSpawn", "Load Player Inventory", AGF.Inventory.Load)

function AGF.Inventory.Save(ply)

	local inventory_data = {}
	
	for key, tbl in pairs(ply.AGF.Inventory) do
	
		inventory_data[key] = util.TableToJSON(tbl)
	
	end

	AGF.DB.Update("Inventory", inventory_data, {uid = ply:UniqueID()})

end

hook.Add("PlayerDisconnected", "Save Player Inventory", AGF.Inventory.Save)

function AGF.Inventory.Give(ply,id_inv,class_item,id,params)

	local id_slot = AGF.Inventory.GetEmptySlot(ply,id_inv)
	
	if not params then

		ply.AGF.Inventory[id_inv][id_slot] = {class = class_item, id = id}

	else

		ply.AGF.Inventory[id_inv][id_slot] = {class = class_item, id = id, params = params}

	end

	AGF.Net.Player_AGF_Table_Send( ply )

end

function AGF.Inventory.GetEmptySlot(ply,id_inv)

	for key, tbl in pairs (ply.AGF.Inventory[id_inv]) do
	
		if (tbl.class == "empty") then
		
			return key
		
		end
	
	end

end

function AGF.Inventory.ChangeItemSlot( ply, cmd, args )
	
	local inv_id, slot_new, slot_last = args[1], tonumber(args[2]), args[3]

	if isnumber(tonumber(slot_last)) then

		local slot_last = tonumber(slot_last)

		ply.AGF.Inventory[inv_id][slot_new] = ply.AGF.Inventory[inv_id][slot_last]
		ply.AGF.Inventory[inv_id][slot_last] = {class = "empty"}

	else

		ply.AGF.Inventory[inv_id][slot_new] = ply.AGF.Inventory[inv_id].items_equipped[slot_last]
		ply.AGF.Inventory[inv_id].items_equipped[slot_last] = {class = "empty"}

		local item = ply.AGF.Inventory[inv_id][slot_new]

		AGF.Inventory.Items[item.class][item.id]:OnHolster( ply )

	end

end

function AGF.Inventory.SwapItems( ply, cmd, args )
	
	local inv_id, slot_new, slot_last = args[1], args[2], args[3]

	if isnumber(tonumber(slot_new)) and isnumber(tonumber(slot_last)) then

		local slot_new, slot_last = tonumber(slot_new), tonumber(slot_last)

		local var_slot_new = ply.AGF.Inventory[inv_id][slot_new]
		local var_slot_last = ply.AGF.Inventory[inv_id][slot_last]

		ply.AGF.Inventory[inv_id][slot_new] = var_slot_last
		ply.AGF.Inventory[inv_id][slot_last] = var_slot_new

	else

		if isnumber(tonumber(slot_last)) then

			local slot_last = tonumber(slot_last)

			local var_slot_new = ply.AGF.Inventory[inv_id].items_equipped[slot_new]
			local var_slot_last = ply.AGF.Inventory[inv_id][slot_last]

			ply.AGF.Inventory[inv_id].items_equipped[slot_new] = var_slot_last
			ply.AGF.Inventory[inv_id][slot_last] = var_slot_new

			local item = ply.AGF.Inventory[inv_id][slot_last]

			AGF.Inventory.Items[item.class][item.id]:OnHolster( ply )

			local item = ply.AGF.Inventory[inv_id].items_equipped[slot_new]

			AGF.Inventory.Items[item.class][item.id]:OnEquip( ply )

		else

			local slot_new = tonumber(slot_new)

			local var_slot_new = ply.AGF.Inventory[inv_id][slot_new]
			local var_slot_last = ply.AGF.Inventory[inv_id].items_equipped[slot_last]

			ply.AGF.Inventory[inv_id][slot_new] = var_slot_last
			ply.AGF.Inventory[inv_id].items_equipped[slot_last] = var_slot_new

			local item = var_slot_last

			AGF.Inventory.Items[item.class][item.id]:OnHolster( ply )

			local item = var_slot_new

			AGF.Inventory.Items[item.class][item.id]:OnEquip( ply )

		end

	end

end

function AGF.Inventory.EquipItem( ply, cmd, args )
	
	local inv_id, slot_new, slot_last = args[1], args[2], tonumber(args[3])

	ply.AGF.Inventory[inv_id].items_equipped[slot_new] = ply.AGF.Inventory[inv_id][slot_last]
	ply.AGF.Inventory[inv_id][slot_last] = {class = "empty"}

	local item = ply.AGF.Inventory[inv_id].items_equipped[slot_new]

	AGF.Inventory.Items[item.class][item.id]:OnEquip( ply )

end

concommand.Add("inv_cng_itm_slot", AGF.Inventory.ChangeItemSlot)
concommand.Add("inv_swap_items", AGF.Inventory.SwapItems)
concommand.Add("inv_equip_item", AGF.Inventory.EquipItem)

function AGF.Inventory.Create(ply)

	local data_table = {}
	
	data_table["uid"] = ply:UniqueID()
	
	hook.Call("AddInventoryCategory")

	if (ply.AGF.Inventory.agf == nil) then
	
		ply.AGF.Inventory["agf"] = {}
		
		for key = 1, 35 do
		
			ply.AGF.Inventory["agf"][key] = {class = "empty"}
		
		end
		
		for name, data in pairs(AGF.hook["AddInventoryCategory"]) do

			ply.AGF.Inventory["agf"][name] = data

		end

		data_table["agf"] = util.TableToJSON(ply.AGF.Inventory["agf"])
		
	end
	
	local GameModeName = gmod.GetGamemode().FolderName
	
	ply.AGF.Inventory[GameModeName] = {}
	
	for key = 1, 35 do
	
		ply.AGF.Inventory[GameModeName][key] = {class = "empty"}
	
	end

	for name, data in pairs(AGF.hook["AddInventoryCategory"]) do

			ply.AGF.Inventory[GameModeName][name] = data

	end

	data_table[GameModeName] = util.TableToJSON(ply.AGF.Inventory[GameModeName])
	
	AGF.DB.InsertOrUpdate("Inventory", data_table)

end

function AGF.Inventory.CheckServerColumn()
	
	local GameModeName = gmod.GetGamemode().FolderName
	
	local result = AGF.DB.Query("SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'agf' AND TABLE_NAME = 'Inventory' AND COLUMN_NAME = '"..GameModeName.."'")
	
	if (result == "null") then
	
		AGF.DB.Query("ALTER TABLE Inventory ADD COLUMN "..GameModeName.." TEXT")
		
		print("Column Inventory for this server created")
	
	end
	
end

hook.Add("OnGamemodeLoaded", "Inventory check server", AGF.Inventory.CheckServerColumn)