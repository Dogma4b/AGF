
AGF = {}

AGF.Settings = {}

function Initialization( gm, folder_name )
	
	local folder_name_lower = string.lower(folder_name)

	print("************"..folder_name.."************")

	AGF.Settings[folder_name] = AGF.Settings[folder_name] or {}

	local path = gm.."/gamemode/"..folder_name_lower.."/"

	local files, folders = file.Find(path.."*","LUA")

	for num, folder in pairs(folders) do
		include(path..folder.."/settings.lua")
		
		AddCSLuaFile(path..folder.."/settings.lua")

		AGF.Settings[folder_name][folder] = Settings
			
		print(folder_name.." "..Settings.name.." (version "..Settings.version..") initialisation")
		
		for num, File in pairs(file.Find(path..folder.."/sv_"..folder..".lua","LUA")) do
			include(path..folder.."/"..File)
		end
		
		for num, File in pairs(file.Find(path..folder.."/sh_"..folder..".lua","LUA")) do
			include(path..folder.."/"..File)
			AddCSLuaFile(path..folder.."/"..File)
		end

		for num, File in pairs(file.Find(path..folder.."/cl_"..folder..".lua","LUA")) do
			AddCSLuaFile(path..folder.."/"..File)
		end
		
		print("----------------Ok----------------")
		
	end

end

print("//////////////////////////////////")
print("////////AGF Initialisation////////")
print("//////////////////////////////////")

--Settings--

include("config/settings.lua")

AddCSLuaFile("config/settings.lua")

--Settings--

if AGF.Settings.BaseGM then

	DeriveGamemode(AGF.Settings.BaseGM)

end

Initialization(GM.FolderName, "Libraries")
Initialization(GM.FolderName, "Modules")

//Initialization(gmod.GetGamemode().FolderName, "Libraries")
//Initialization(gmod.GetGamemode().FolderName, "Modules")

print("//////////////////////////////////")
print("///AGF Initialisation complete////")
print("//////////////////////////////////")

function GM:OnGamemodeLoaded()

	AGF.ConVar.SetupConVar()

	local gm_folder = gmod.GetGamemode().FolderName

	if(gm_folder != "agf") then

		print("////////"..gm_folder.." Initialisation////////")
		print("//////////////////////////////////")

		GM = gmod.GetGamemode()

		Initialization(gm_folder, "Modules")

		print("//////////////////////////////////")
		print("///"..gm_folder.." Initialisation complete////")

	end
	
end