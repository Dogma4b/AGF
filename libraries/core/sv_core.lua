
AddCSLuaFile("cl_interface.lua")
AddCSLuaFile("cl_menu.lua")

---ConVars---

AGF.ConVar = {
	
	table = {},

	name_table = "ConVars",
		
	Set = function(name, var)

		local data = {

			ServerID = AGF.Settings.ServerID,
			ConVar = name,
			Var = var

		}

		AGF.DB.InsertOrUpdate(AGF.ConVar.name_table, data)

		RunConsoleCommand(name, var)

	end,

	Get = function(ConVar)
		
		return GetConVar(ConVar):GetString()
		
		/*AGF.DB.FilterEqual("ServerID", AGF.Settings.ServerID)
		
		AGF.DB.FilterEqual("ConVar", ConVar)

		local data = AGF.DB.Get(AGF.ConVar.name_table)
		
		return data[1]["Var"]*/

	end,

	GetAll = function()
		
		AGF.DB.Select("ConVar")
		
		AGF.DB.Select("Var")
		
		AGF.DB.FilterEqual("ServerID", AGF.Settings.ServerID)

		local data = AGF.DB.Get(AGF.ConVar.name_table)
		
		return data

	end,

	SetupConVar = function()

		for num, data in pairs (AGF.ConVar.GetAll()) do
		
			if ConVarExists(data.ConVar) then

				RunConsoleCommand(data.ConVar, data.Var)

			else

				CreateConVar(data.ConVar, data.Var)
				
			end
		
		end

	end

}

---ConVars---

---Settings---

AGF.GetSettings = {

	Library = function( name )
	
		return AGF.Settings.Libraries[name]

	end,

	Module = function( name )
	
		return AGF.Settings.Modules[name]

	end

}

---Settings---

---Net Library---

AGF.Net = {

	Player_AGF_Table_Send = function( ply )

		util.AddNetworkString("Send_to_client_AGF_table")

		timer.Simple(1.50, function()

			net.Start("Send_to_client_AGF_table")

				net.WriteTable(ply.AGF)

			net.Send(ply)

		end)

	end

}

hook.Add("PlayerInitialSpawn", "SendAGFtabletoclient", AGF.Net.Player_AGF_Table_Send)

---Net Library---