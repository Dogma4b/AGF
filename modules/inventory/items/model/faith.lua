Item.Name = "Faith Connors"
Item.Model = "models/player/faith.mdl"
Item.icon = Material('spawnicons/models/player/faith.png')

//**Register model**//

player_manager.AddValidModel( "Faith Connors", 		"models/player/faith.mdl" );
player_manager.AddValidHands( "Faith Connors", 	"models/player/faith_hands.mdl", 0, "00000000" )

//**Register model**//

function Item:OnEquip( ply )
	
	if SERVER then

		ply.AGF.Equip.DefaultPlayerModel = ply:GetModel()

		ply:SetModel(self.Model)
		ply:SetupHands()

	end

end

function Item:OnHolster( ply )
	
	if SERVER then

		ply:SetModel(ply.AGF.Equip.DefaultPlayerModel)
		ply:SetupHands()

	end

end

if CLIENT then

	local Faith = {

		RenderItem = function( self, item )
			
			local html = "Фэйт Коннарс"

			self.Window = self:Add("HTML")
			self.Window:SetSize(250,100)
			self.Window:SetHTML(html)

		end

	}

	derma.DefineControl("AGF_ItemInfo_model_faith", "", Faith, "Panel")

end