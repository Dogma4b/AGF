
AGF.PC = {}

function AGF.PC.AddSlotsToPlayerProfile()
	
	local items_equipped = {

		hat = {

			class = "empty"

		},

		back = {

			class = "empty"

		},

		boots = {

			class = "empty"

		},

		trail = {

			class = "empty"

		},

		model = {

			class = "empty"

		},

		weapons = {



		}

	}

	AGF.hook["AddInventoryCategory"]["items_equipped"] = items_equipped

	/*for num, hk in pairs(AGF.hook["RegisterWeaponSlot"]) do

		table.insert(Items_Equipped.agf.weapons, hk)
		table.insert(Items_Equipped[gmod.GetGamemode().FolderName].weapons, hk)

	end*/

end

hook.Add("AddInventoryCategory", "Adding row equipped items to table", AGF.PC.AddSlotsToPlayerProfile)

function AGF.PC.SetUpPlayerProfile( ply )
	
	for _, cat in pairs(ply.AGF.Inventory) do

		for key, slot in pairs(cat.items_equipped) do

			if slot.class and slot.id then
				
				if not slot.class == "model" then

					AGF.Inventory.Items[slot.class][slot.id]:OnEquip( ply )

				else

					timer.Simple(0.5, function()
						
						AGF.Inventory.Items[slot.class][slot.id]:OnEquip( ply )

					end)

				end

			end

		end

	end

end

hook.Add("PlayerSpawn", "Set Up Player Profile", AGF.PC.SetUpPlayerProfile)

function AGF.PC.HolsterPlayerProfile( ply )
	
	for _, cat in pairs(ply.AGF.Inventory) do

		for key, slot in pairs(cat.items_equipped) do

			if slot.class and slot.id then
				
				if not slot.class == "model" then

					AGF.Inventory.Items[slot.class][slot.id]:OnHolster( ply )

				else

					timer.Simple(0.5, function()
						
						AGF.Inventory.Items[slot.class][slot.id]:OnHolster( ply )

					end)

				end

			end

		end

	end

end

hook.Add("PlayerDeath", "Holster Player Profile", AGF.PC.HolsterPlayerProfile)

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end