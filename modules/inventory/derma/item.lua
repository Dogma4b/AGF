
Item = {
	
	Init = function( self )
		
		self:Droppable("Item")
		//self:SetMaterial(self.tbl.material)

		self:Receiver("Item", function( self, panel, IsDropped, MenuIndex, PosX, PosY )
			
			if IsDropped then

				if isnumber(self:GetParent().key) then

					self:GetParent():SetSlotItem( panel[1] )

				else

					self:GetParent():EquipItem( panel[1] )

				end

			end

		end)

	end,

	Paint = function( self, w, h )
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial(self.class.icon)
		surface.DrawTexturedRect(0,0,w,h)

	end,

	OnCursorEntered = function( self )
		
		local mouseX, mouseY = gui.MousePos()

		if ValidPanel(self.Window) then

			self.Window:SetPos(mouseX, mouseY)
			self.Window:SetDrawOnTop(true)
			self.Window:Show()

		else

			self.Window = vgui.Create("DPanel")
			self.Window:SetPos(mouseX, mouseY)
			self.Window:SetDrawOnTop(true)

		end

		self.Window.Paint = function( pnl, w, h )
			
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))

		end

		self.ItemInfo = self.Window:Add("AGF_ItemInfo_"..self.item.class.."_"..self.item.id)
		self.ItemInfo:RenderItem(self.item.params)

		local issx, issy = self.ItemInfo:GetChildren()[1]:GetSize()

		self.Window:SetSize(issx, issy)
		self.ItemInfo:SetSize(issx, issy)

	end,

	OnCursorExited = function( self )
		
		if ValidPanel(self.Window) then

			self.Window:Hide()
			self.ItemInfo:Remove()

		end

	end

}

derma.DefineControl("Item", "", Item, "DPanel")