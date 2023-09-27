Item.Name = "Lara Croft"
Item.Model = "models/player/lara_croft.mdl"
Item.icon = Material('spawnicons/models/player/lara_croft.png')

//**Register model**//

player_manager.AddValidModel( "Lara Croft", 	"models/player/lara_croft.mdl" );
player_manager.AddValidHands( "Lara Croft", 	"models/player/lara_croft_hands.mdl", 0, "00000000" )

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

	local Lara_Croft = {

		RenderItem = function( self, item )
			
			local html = "Лара Крофт"

			self.Window = self:Add("HTML")
			self.Window:SetSize(250,100)
			self.Window:SetHTML(html)

		end

	}

	derma.DefineControl("AGF_ItemInfo_model_lara_croft", "", Lara_Croft, "Panel")

end