
AGF.Interface.Panels.ScoreBoard = {
	
	Init = function( self )
		
		self.ScrollPanel = self:Add("DScrollPanel")
		self.ScrollPanel:SetSize(ScrW()-100, ScrH()-300)
		self.ScrollPanel:SetPos(0,0)

		self.Servers = self.ScrollPanel:Add("DCategoryList")
		self.Servers:SetSize(ScrW()-125, ScrH()-325)
		self.Servers:SetPos(5,5)
		self.Servers.Paint = function( pnl, w, h )
			
		end

		self.ServersList = {"DeathRun","BunnyHop","Jail","Zombie"}

		for id, server in pairs(self.ServersList) do

			self.Server = self.Servers:Add("")
			self.Server.Paint = function( pnl, w, h )
				
				draw.RoundedBox(0,0,0,w,20,Color(0,200,0,200))
				draw.DrawText(server,"AGF_SmallFont",w/2,2,Color(255,255,255,255),TEXT_ALIGN_CENTER)

			end

			for num, ply in pairs(player.GetAll()) do

				self.Player = {}

				self.Player.Frame = self.Server:Add("DPanel")
				self.Player.Frame:SetPos(0, 0)
				self.Player.Frame:SetSize(self.Server:GetWide(), 45)
				self.Player.Frame:SetText("")
				self.Player.Frame.Paint = function( pnl, w, h )
					
					draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
					draw.DrawText(ply:Name(),"AGF_SmallFont",45,13,Color(255,255,255,255),TEXT_ALIGN_LEFT)

				end

				self.Player.Avatar = self.Player.Frame:Add("AvatarImage")
				self.Player.Avatar:SetSize(32, 32)
				self.Player.Avatar:SetPos(6, 6)
				self.Player.Avatar:SetSteamID(LocalPlayer():SteamID64(), 16)

			end

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

AGF.Interface.MenuRegister(1, "ScoreBoard", AGF.Interface.Panels.ScoreBoard)