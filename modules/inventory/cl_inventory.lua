
include("derma/slot.lua")
include("derma/item.lua")

AGF.Interface.Panels.Inventory = {
	
	Init = function( self )
		
		self.Frame = self:Add("Panel")
		self.Frame:SetPos(0, 0)
		self.Frame:SetSize(ScrW()-100, ScrH()-300)

		self.Inventory_Scroll = self.Frame:Add("DScrollPanel")
		self.Inventory_Scroll:SetPos(300, 30)
		self.Inventory_Scroll:SetSize(self.Frame:GetWide()-300, self.Frame:GetTall()-30)
		
		self.Inventory = self.Inventory_Scroll:Add("DIconLayout")
		self.Inventory:SetSize(self.Inventory_Scroll:GetWide()-15, self.Inventory_Scroll:GetTall()-30)
		self.Inventory:SetSpaceY(5)
		self.Inventory:SetSpaceX(5)
		self.Inventory_Scroll:AddItem( self.Inventory )

		local sinv = self.Inventory

		AGF.Interface.Panels.Inventory.Panel = self

		local ButtonX = 310
 
		for name, inv in SortedPairs(LocalPlayer().AGF.Inventory) do

			self.ChangeInventoryButton = self.Frame:Add("DButton")
			self.ChangeInventoryButton:SetPos(ButtonX, 5)
			self.ChangeInventoryButton:SetSize(100, 20)

			local settings = AGF.Settings.Modules["inventory"]

			self.ChangeInventoryButton:SetText(settings[name])

			ButtonX = ButtonX + 110

			self.ChangeInventoryButton.DoClick = function()
			
			AGF.Interface.Panels.Inventory.ActiveInventory = name

			sinv:Clear()

				---Inventory Player Profile---

				local ply = LocalPlayer()

				if self.PlayerProfile then

					self.PlayerProfile:Remove()

				end

				self.PlayerProfile = self.Frame:Add("Panel")
				self.PlayerProfile:SetSize(295, self.Frame:GetTall()-30)
				self.PlayerProfile:SetPos(0, 0)

				self.PlayerModel = self.PlayerProfile:Add("DModelPanel")
				self.PlayerModel:SetSize(200, self.PlayerProfile:GetTall())
				self.PlayerModel:SetPos(47.5, 0)
				self.PlayerModel:SetFOV(30)
				self.PlayerModel:SetModel(LocalPlayer():GetModel())
				self.PlayerModel:SetCursor("arrow")
				self.PlayerModel.LayoutEntity = function( pnl, ent )
					
					ent:SetAngles(Angle(0,40,0))

				end

				local Hat = self.PlayerProfile:Add("Slot")
				Hat:SetMaterial(Material("vgui/inventory/hat.png"))
				Hat:SetPos(5, self.PlayerProfile:GetTall()/10)
				Hat:SetSize(48, 48)
				Hat.key = "hat"

				if (ply.AGF.Inventory[name].items_equipped.hat.class != "empty") then

					local class = AGF.Items.Get(ply.AGF.Inventory[name].items_equipped.hat)

					local itm = Hat:Add("Item")
					itm.item = ply.AGF.Inventory[name].items_equipped.hat
					itm.class = class
					itm:SetSize(48, 48)
					itm:Droppable("Item")

				end

				local Back = self.PlayerProfile:Add("Slot")
				Back:SetMaterial(Material("vgui/inventory/back.png"))
				Back:SetPos(5, self.PlayerProfile:GetTall()/4)
				Back:SetSize(48, 48)
				Back.key = "back"

				if (ply.AGF.Inventory[name].items_equipped.back.class != "empty") then

					local class = AGF.Items.Get(ply.AGF.Inventory[name].items_equipped.back)

					local itm = Back:Add("Item")
					itm.item = ply.AGF.Inventory[name].items_equipped.back
					itm.class = class
					itm:SetSize(48, 48)
					itm:Droppable("Item")

				end

				local Boots = self.PlayerProfile:Add("Slot")
				Boots:SetMaterial(Material("vgui/inventory/boots.png"))
				Boots:SetPos(5, self.PlayerProfile:GetTall()/1.15)
				Boots:SetSize(48, 48)
				Boots.key = "boots"

				if (ply.AGF.Inventory[name].items_equipped.boots.class != "empty") then

					local class = AGF.Items.Get(ply.AGF.Inventory[name].items_equipped.boots)

					local itm = Boots:Add("Item")
					itm.item = ply.AGF.Inventory[name].items_equipped.boots
					itm.class = class
					itm:SetSize(48, 48)
					itm:Droppable("Item")

				end

				local Trail = self.PlayerProfile:Add("Slot")
				Trail:SetMaterial(Material("vgui/inventory/trail.png"))
				Trail:SetPos(self.PlayerProfile:GetWide()-53, self.PlayerProfile:GetTall()/1.15)
				Trail:SetSize(48, 48)
				Trail.key = "trail"

				if (ply.AGF.Inventory[name].items_equipped.trail.class != "empty") then

					local class = AGF.Items.Get(ply.AGF.Inventory[name].items_equipped.trail)

					local itm = Trail:Add("Item")
					itm.item = ply.AGF.Inventory[name].items_equipped.trail
					itm.class = class
					itm:SetSize(48, 48)
					itm:Droppable("Item")

				end

				local Model = self.PlayerProfile:Add("Slot")
				Model:SetMaterial(Material("vgui/inventory/trail.png"))
				Model:SetPos(self.PlayerProfile:GetWide()-53, self.PlayerProfile:GetTall()/10)
				Model:SetSize(48, 48)
				Model.key = "model"

				if (ply.AGF.Inventory[name].items_equipped.model.class != "empty") then

					local class = AGF.Items.Get(ply.AGF.Inventory[name].items_equipped.model)

					local itm = Model:Add("Item")
					itm.item = ply.AGF.Inventory[name].items_equipped.model
					itm.class = class
					itm:SetSize(48, 48)
					itm:Droppable("Item")

				end

				---Inventory Player Profile---

				for key, item in pairs(LocalPlayer().AGF.Inventory[name]) do

					if not isnumber(key) then return end

					local slot = sinv:Add("Slot")
					slot:SetSize(48, 48)
					slot.key = key

					if (item.class != "empty") then

						local class = AGF.Items.Get(item)

						local itm = slot:Add("Item")
						itm.item = item
						itm.class = class
						itm:SetSize(48, 48)
						itm:Droppable("Item")

					end

				end

			end

		end

	end,

	InventoryUpdate = function( self )
		
		self.Inventory:Clear()

		for key, item in pairs(LocalPlayer().AGF.Inventory[AGF.Interface.Panels.Inventory.ActiveInventory]) do

			if not isnumber(key) then return end

			local slot = self.Inventory:Add("Slot")
			slot:SetSize(48, 48)
			slot.key = key

			if (item.class != "empty") then

				local class = AGF.Items.Get(item)

				local itm = slot:Add("Item")
				itm.item = item
				itm.class = class
				itm:SetSize(48, 48)
				itm:Droppable("Item")

			end

		end

	end,

	Think = function( self )
		
		if self.PlayerModel then

			self.PlayerModel:SetModel(LocalPlayer():GetModel())

		end

	end,

	PerformLayout = function( self )
		
		self:SetSize( ScrW()-100, ScrH()-300 )
		self:SetPos( 0, 0 )

	end,

	Paint = function( pnl, w, h )
		
		draw.RoundedBoxEx(8,0,0,w,h,Color(0,0,0,200),true,true,true,true)

	end

}

AGF.Interface.MenuRegister(2, "Inventory", AGF.Interface.Panels.Inventory)

AGF.Inventory = {

	ChangeItemSlot = function( ply, inv_id, slot_new, slot_last )
		
		if isnumber(slot_last) then

			ply.AGF.Inventory[inv_id][slot_new] = ply.AGF.Inventory[inv_id][slot_last]
			ply.AGF.Inventory[inv_id][slot_last] = {class = "empty"}

		else

			ply.AGF.Inventory[inv_id][slot_new] = ply.AGF.Inventory[inv_id].items_equipped[slot_last]
			ply.AGF.Inventory[inv_id].items_equipped[slot_last] = {class = "empty"}

			local item = ply.AGF.Inventory[inv_id][slot_new]

			AGF.Inventory.Items[item.class][item.id]:OnHolster( ply )

		end
		
		RunConsoleCommand("inv_cng_itm_slot", inv_id, slot_new, slot_last)

	end,

	SwapItems = function( ply, inv_id, slot_new, slot_last )
		
		if isnumber(slot_new) and isnumber(slot_last) then

			local var_slot_new = ply.AGF.Inventory[inv_id][slot_new]
			local var_slot_last = ply.AGF.Inventory[inv_id][slot_last]

			ply.AGF.Inventory[inv_id][slot_new] = var_slot_last
			ply.AGF.Inventory[inv_id][slot_last] = var_slot_new

		else

			if isnumber(slot_last) then

				local var_slot_new = ply.AGF.Inventory[inv_id].items_equipped[slot_new]
				local var_slot_last = ply.AGF.Inventory[inv_id][slot_last]

				ply.AGF.Inventory[inv_id].items_equipped[slot_new] = var_slot_last
				ply.AGF.Inventory[inv_id][slot_last] = var_slot_new

			else

				local var_slot_new = ply.AGF.Inventory[inv_id][slot_new]
				local var_slot_last = ply.AGF.Inventory[inv_id].items_equipped[slot_last]

				ply.AGF.Inventory[inv_id][slot_new] = var_slot_last
				ply.AGF.Inventory[inv_id].items_equipped[slot_last] = var_slot_new

			end

		end
		RunConsoleCommand("inv_swap_items", inv_id, slot_new, slot_last)

	end,

	EquipItem = function( ply, inv_id, slot_new, slot_last )
		
		ply.AGF.Inventory[inv_id].items_equipped[slot_new] = ply.AGF.Inventory[inv_id][slot_last]
		ply.AGF.Inventory[inv_id][slot_last] = {class = "empty"}

		local item = ply.AGF.Inventory[inv_id].items_equipped[slot_new]

		AGF.Inventory.Items[item.class][item.id]:OnEquip( ply )

		RunConsoleCommand("inv_equip_item", inv_id, slot_new, slot_last)

	end

}