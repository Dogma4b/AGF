Item.Name = "Aiden Pearce"
Item.Model = "models/player/aiden_pearce.mdl"
Item.icon = Material('spawnicons/models/player/aiden_pearce.png')

//**Register model**//

player_manager.AddValidModel( "Aiden Pearce", 		"models/player/aiden_pearce.mdl" );
player_manager.AddValidHands( "Aiden Pearce", 	"models/player/aiden_pearce_hands.mdl", 0, "00000000" )

//**Register model**//

function Item:OnEquip( ply )
	
	if SERVER then

		ply.AGF.Equip.DefaultPlayerModel = ply:GetModel()

		ply:SetModel(self.Model)
		ply:SetBodygroup(1,math.random(0,1))
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

	local Aiden_Pearce = {

		RenderItem = function( self, item )
			
			local html = [[
				<style>
					table {
					color: #D8D8D8;
					}
				</style>
				<table>
				  <tr>
				    <td><img src="materials/spawnicons/models/player/aiden_pearce.png"></td>
				    <td>Эйден Пирс</td>
				  </tr>
				  <tr>
				    <td>Описание модели</td>
				  </tr>
				</table>
			]]

			self.Window = self:Add("HTML")
			self.Window:SetSize(250,100)
			self.Window:SetHTML(html)

		end

	}

	derma.DefineControl("AGF_ItemInfo_model_aiden_pearce", "", Aiden_Pearce, "Panel")

end