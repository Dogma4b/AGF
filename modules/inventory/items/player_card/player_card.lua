
Item.icon = Material("vgui/inventory/player_card.png")

if CLIENT then

	Player_card = {
		
		Init = function( self )
			


		end,

		RenderItem = function( self, item )

			http.Fetch( "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=6D10B01773EDB525DE2C06804823083D&steamids="..LocalPlayer():SteamID64(), 
				function( body, len, headers, code )

					local html = [[<style> .avatar {width:64px; height:64px; float:left; margin-left:0px; text-align:center; } .user_info {width:150px; height:64px; float:left; margin-left:5px; text-align:left; } </style> <div> <div class="avatar"><img src="]]..util.JSONToTable(body).response.players[1].avatarmedium..[["></div> <div class="user_info">]]..item.name..[[<br>Ранг: Lolka</div> <div> <center>Время на серверах</center> </div> </div>]]
					
					if self.Window then

						self.Window:SetHTML(html)
						
					end

				end)

			self.Window = self:Add("HTML")
			self.Window:SetSize(350,200)
			self.Window:SetHTML("")

		end

	}

	derma.DefineControl("AGF_ItemInfo_player_card_player_card", "", Player_card, "Panel")

end