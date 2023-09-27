
include("cl_interface.lua")

---Net Library---

net.Receive( "Send_to_client_AGF_table", function( len )
	
	tbl = net.ReadTable()

	ply = LocalPlayer()

	if ( IsValid(ply) and ply:IsPlayer() ) then

		ply.AGF = tbl

		if ValidPanel(AGF.Interface.Panels.Inventory.Panel) then

			AGF.Interface.Panels.Inventory.Panel:InventoryUpdate()

		end

	end

end)

---Net Library---