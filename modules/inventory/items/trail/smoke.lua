Item.Name = "Трейл 'Smoke'"
Item.Material = 'trails/smoke.vmt'
Item.icon = Material(Item.Material)
Item.Color = Color(255,255,255)


function Item:OnEquip( ply )
	
	if SERVER then

		ply.AGF.Equip.Trail = util.SpriteTrail(ply, 0, self.Color, false, 30, 1, 4, 0.125, self.Material)

	end

end

function Item:OnHolster( ply )
	
	if SERVER then

		SafeRemoveEntity(ply.AGF.Equip.Trail)

	end

end

if CLIENT then

	local Smoke = {

		RenderItem = function( self, item )
			
			local html = "Трейл 'Smoke'"

			self.Window = self:Add("HTML")
			self.Window:SetSize(250,100)
			self.Window:SetHTML(html)

		end

	}

	derma.DefineControl("AGF_ItemInfo_trail_smoke", "", Smoke, "Panel")

end