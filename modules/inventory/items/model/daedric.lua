Item.Name = "Daedric"
Item.Model = "models/player/daedric.mdl"
Item.icon = Material('spawnicons/models/player/daedric.png')

//**Register model**//

player_manager.AddValidModel( "Daedric", 	"models/player/daedric.mdl" );
player_manager.AddValidHands( "Daedric", 	"models/player/daedric_hands.mdl", 0, "00000000" )

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

	local Daedric = {

		RenderItem = function( self, item )
			
			local html = "Даэдрик"

			self.Window = self:Add("HTML")
			self.Window:SetSize(250,100)
			self.Window:SetHTML(html)

		end

	}

	derma.DefineControl("AGF_ItemInfo_model_daedric", "", Daedric, "Panel")

end