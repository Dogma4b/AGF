
Item.icon = Material("icon16/user.png")

function Item:OnEquip()
	
	print("Item equipped!")

end

function Item:OnHolster()
	
	print("Item holster!")

end

if CLIENT then

	Test = {
		
		Init = function( self )
			


		end,

		RenderItem = function( self, item )
			
			local html = "Тестовая шапка"

			self.Window = self:Add("HTML")
			self.Window:SetSize(250,100)
			self.Window:SetHTML(html)

		end

	}

	derma.DefineControl("AGF_ItemInfo_hat_test", "", Test, "Panel")

end