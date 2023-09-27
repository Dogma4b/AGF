
AGF.Interface.Panels.Admin = {
	
	Init = function( self )
		
		self.Menu = {}

		self.Menu.Map_Restart = self:Add("DButton")
		self.Menu.Map_Restart:SetPos(10, 10)
		self.Menu.Map_Restart:SetSize(100, 30)
		self.Menu.Map_Restart:SetText("Map Restart")
		self.Menu.Map_Restart.DoClick = function()
			
			RunConsoleCommand("reload_map")

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

AGF.Interface.MenuRegister(3, "Server management", AGF.Interface.Panels.Admin)

//vgui.Register("AGF_Panel_Admin",AGF.Interface.Panels.Admin,"DPanel")