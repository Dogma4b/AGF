
AGF.Admin = {
	
	LoadPlayerProfile = function( ply )

		ply.AGF = ply.AGF or {}

		ply.AGF.Profile = {}

		AGF.DB.FilterEqual("uid", ply:UniqueID())

		local profile_data = AGF.DB.Get("Players")

		if (profile_data != "null") then

			ply.AGF.Profile = profile_data[1]

		else

			AGF.Admin.CreatePlayerProfile( ply )

		end

	end,

	CreatePlayerProfile = function( ply )
		
		local settings = AGF.GetSettings.Module("agf_admin")

		local profile_data = {

			uid = ply:UniqueID(),

			name = ply:Name(),

			group = "players",

			play_time = 1,

			agp = settings.default_agp,

			rur = settings.default_rur

		}

		hook.Call("AddPlayerProfileRow")

		for num, hk in pairs(AGF.hook["AddPlayerProfileRow"]) do

			profile_data[num] = hk

		end

		AGF.DB.Insert("Players", profile_data)

		ply.AGF.Profile = profile_data

	end,

	SavePlayerProfile = function( ply )
		
		AGF.DB.Update("Players", ply.AGF.Profile, {uid = ply:UniqueID()})

	end

}

hook.Add("PlayerInitialSpawn", "LoadPlayerProfile", AGF.Admin.LoadPlayerProfile)

hook.Add("PlayerDisconnected", "SavePlayerProfile", AGF.Admin.SavePlayerProfile)

function reload_map()
	
	game.ConsoleCommand("changelevel "..game.GetMap().."\n")

end
concommand.Add("reload_map", reload_map)