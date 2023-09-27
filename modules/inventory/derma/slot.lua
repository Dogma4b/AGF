
local Slot = {
	
	Init = function( self )
		
		self:Receiver("Item", function( self, panel, IsDropped, MenuIndex, PosX, PosY )
			
			if IsDropped then

				if isnumber(self.key) then

					self:SetSlotItem( panel[1] )

				else

					self:EquipItem( panel[1] )

				end

			end

		end)

	end,

	SetSlotItem = function( self, item )
		
		local parent = item:GetParent()

		if parent == self then

			return

		end

		if self:GetChildren()[1] then

			if not isnumber(item:GetParent().key) and self:GetChildren()[1].item.class != item.item.class then return end

			self:GetChildren()[1]:SetParent( parent )

			AGF.Inventory.SwapItems(LocalPlayer(), AGF.Interface.Panels.Inventory.ActiveInventory, self.key, item:GetParent().key)

		else

			AGF.Inventory.ChangeItemSlot(LocalPlayer(), AGF.Interface.Panels.Inventory.ActiveInventory, self.key, item:GetParent().key)

		end

		item:SetParent( self )

		self.m_Item = item

	end,

	EquipItem = function( self, item )
		
		if self.key != item.item.class then return end

		local parent = item:GetParent()

		if parent == self then

			return

		end

		if self:GetChildren()[1] then

			self:GetChildren()[1]:SetParent( parent )

			AGF.Inventory.SwapItems(LocalPlayer(), AGF.Interface.Panels.Inventory.ActiveInventory, self.key, item:GetParent().key)

		else

			AGF.Inventory.EquipItem(LocalPlayer(), AGF.Interface.Panels.Inventory.ActiveInventory, self.key, item:GetParent().key)

		end

		item:SetParent( self )

		self.m_Item = item

	end,

	SetMaterial = function( self, material )
		
		self.Material = material

	end,

	Paint = function( self, w, h )
		
		local color = Color(64,64,64)

		if self:IsHovered() or self:IsChildHovered( 1 ) then

			surface.SetDrawColor(color.r*1.6,color.g*1.6,color.b*1.6)

		else

			surface.SetDrawColor(color)

		end

		if self.Material then

			if self:IsHovered() or self:IsChildHovered( 1 ) then

				surface.SetDrawColor(color.r*2.6,color.g*2.6,color.b*2.6)

			else

				surface.SetDrawColor(color.r*1.6,color.g*1.6,color.b*1.6)

			end

			surface.SetMaterial(self.Material)

			surface.DrawTexturedRect(0,0,w,h)

		else

			surface.DrawRect(0,0,w,h)

		end

	end

}

derma.DefineControl("Slot", "", Slot, "DPanel")