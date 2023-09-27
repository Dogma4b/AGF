
AGF.Interface = {
	
	Menu = {},

	MenuRegister = function( id, name, panel )
		
		vgui.Register("AGF_Panel_"..name, panel, "DPanel")
		
		AGF.Interface.Menu[id] = {name = name, gui = "AGF_Panel_"..name}

	end

}

//include("cl_menu.lua")

surface.CreateFont("AGF_MediumFont", {
	font = "RUSBoycott",
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("AGF_SmallFont", {
	font = "Arial",
	size = 18,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

AGF.Interface.Panels = {}

AGF.Interface.Panels.Main = {

	Init = function( self )

		self:Menu()

		self.Profile = {}

		self.Profile.Frame = self:Add("Panel")
		self.Profile.Frame:SetPos(ScrW()-338, 0)
		self.Profile.Frame:SetSize(338,148)

		self.Profile.Avatar = self.Profile.Frame:Add("AvatarImage")
		self.Profile.Avatar:SetSize(128, 128)
		self.Profile.Avatar:SetPos(200, 10)
		self.Profile.Avatar:SetPlayer(LocalPlayer(), 128)

	end,

	Menu = function( self )
		
		local ButtonPosX = 10

		self.Menu = {}

		self.Menu.Frame = self:Add("Panel")
		self.Menu.Frame:SetPos(20, 20)
		self.Menu.Frame:SetSize(ScrW()/1.6, 108)

		for k, button in pairs(AGF.Interface.Menu) do

			local strlen = string.len(button['name']) * 12

			self.Menu.Button = self:Add("DButton")
			self.Menu.Button:SetSize(strlen, 30)
			self.Menu.Button:SetPos(ButtonPosX, 50)
			self.Menu.Button:SetText("")

			self.Menu.Button.DoClick = function()
				
				self:ShowGui(button['gui'])

			end

			self.Menu.Button.Paint = function( pnl, w, h )
			
				draw.DrawText(button['name'], "AGF_MediumFont", 10, 0, Color(255,255,255,255))

			end

			ButtonPosX = ButtonPosX + strlen + 15

		end

	end,

	ShowGui = function( self, gui_name )
		
		local gui = self.tbl_gui['gui_'..gui_name]
	
		if (self.ActiveGui == nil) or (gui != self.ActiveGui) then
			if (self.ActiveGui != nil) then
				self.ActiveGui:SetVisible(false)
			end
			if ValidPanel(gui) then
				gui:SetVisible(true)
			else

				self.Window = self.Window or nil

				if not (ValidPanel(self.Window)) then

					self.Window = self:Add("Panel")
					self.Window:SetPos(50, 200)
					self.Window:SetSize(ScrW()-100, ScrH()-300)

				end

				self.tbl_gui['gui_'..gui_name] = vgui.Create(gui_name, self.Window)
				gui = self.tbl_gui['gui_'..gui_name]
			end
		end
		
		self.ActiveGui = gui

	end,

	PerformLayout = function( self )
		
		self:SetSize( ScrW(), ScrH() )
		self:SetPos( 0, 0 )
		self:MakePopup()

	end,

	Paint = function( pnl, w, h )
		
		draw.RoundedBox(0,0,0,w,148,Color(0,0,0,200))
		draw.DrawText(LocalPlayer():Name(),"AGF_SmallFont",ScrW()-150,10,Color(255,255,255,255),TEXT_ALIGN_RIGHT)
		draw.DrawText("Group: "..LocalPlayer().AGF.Profile.group,"AGF_SmallFont",ScrW()-150,30,Color(255,255,255,255),TEXT_ALIGN_RIGHT)
		draw.DrawText("AGP: "..LocalPlayer().AGF.Profile.agp,"AGF_SmallFont",ScrW()-150,50,Color(255,255,255,255),TEXT_ALIGN_RIGHT)

	end,

	Think = function( pnl, w, h )



	end,

	ActiveGui = nil,

	tbl_gui = {},

	gui = nil

}

vgui.Register("AGF_Panel_Main",AGF.Interface.Panels.Main,"DPanel")

function GM:ScoreboardShow()
	
	if (AGF.Interface.Panels.Main.gui) then

		AGF.Interface.Panels.Main.gui:SetVisible(true)
		AGF.Interface.Panels.Main.gui:Show()

	else

		AGF.Interface.Panels.Main.gui = vgui.Create("AGF_Panel_Main")

	end

end

function GM:ScoreboardHide()
	
	AGF.Interface.Panels.Main.gui:SetVisible(false)
	AGF.Interface.Panels.Main.gui:Hide()

end