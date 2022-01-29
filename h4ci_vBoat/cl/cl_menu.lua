Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end
end)

h4ci_conc = {
	catevehi = {},
	listecatevehi = {},
}

local derniervoituresorti = {}
local sortirvoitureacheter = {}


local open = false 
local mainMenu = RageUI.CreateMenu("Bateaux", "Concessionnaire Bateaux")
local subMenu = RageUI.CreateSubMenu(mainMenu, "Catégorie", " ")
local liste = RageUI.CreateSubMenu(subMenu, "Liste Véhicules", " ")
local achat = RageUI.CreateSubMenu(liste, "Achat", " ")
mainMenu:SetRectangleBanner(0, 0, 0)
subMenu:SetRectangleBanner(0, 0, 0)
liste:SetRectangleBanner(0, 0, 0)
achat:SetRectangleBanner(0, 0, 0)
mainMenu.Closed = function()   
	supprimerbateauxconcess()
    RageUI.Visible(mainMenu, false)
    open = false
end 

function OpenMenuBoat()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu,function() 

		   	RageUI.Separator('~r~↓ ~s~Accéder au Catalogue ~r~↓')

			RageUI.Button("Catalogue", nil , {RightLabel = "→"}, true , {
				onSelected = function()                       
				end
			}, subMenu)

		   end)


		   RageUI.IsVisible(subMenu,function() 

        	for i = 1, #h4ci_conc.catevehi, 1 do
				RageUI.Button("Catégorie - "..h4ci_conc.catevehi[i].label, nil , {RightLabel = "→"}, true , {
					onSelected = function()   
						nomcategorie = h4ci_conc.catevehi[i].label
						categorievehi = h4ci_conc.catevehi[i].name
						ESX.TriggerServerCallback('h4ci_boat:recupererlistevehicule', function(listevehi)
								h4ci_conc.listecatevehi = listevehi
						end, categorievehi)
					end                    
				}, liste)
			end

		   end)

		   RageUI.IsVisible(liste,function() 

			for i2 = 1, #h4ci_conc.listecatevehi, 1 do
				RageUI.Button(h4ci_conc.listecatevehi[i2].name, nil , {RightLabel = "~g~"..h4ci_conc.listecatevehi[i2].price.."$"}, true , {
					onSelected = function()  
						local nomvoiture = h4ci_conc.listecatevehi[i2].name
						prixvoiture = h4ci_conc.listecatevehi[i2].price
						modelevoiture = h4ci_conc.listecatevehi[i2].model
						supprimerbateauxconcess()
						chargementvoiture(modelevoiture)
						ESX.Game.SpawnLocalVehicle(modelevoiture, {x = -797.46, y = -1503.61, z = -0.15}, 103.59, function (vehicle)
						table.insert(derniervoituresorti, vehicle)
						FreezeEntityPosition(vehicle, true)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						SetModelAsNoLongerNeeded(modelevoiture)
						end) 
					end                    
				}, achat)
			end

		   end)

		   RageUI.IsVisible(achat,function() 

		   	RageUI.Separator ('~r~↓ ~s~Prix du Véhicule ~r~↓')
			RageUI.Separator (prixvoiture)

			RageUI.Button("Acheter le ~r~Véhicule", 'Cette Action est ~r~Définitive !', {RightLabel = "⚠️"}, true , {
				onSelected = function()  
					ESX.TriggerServerCallback('h4ci_boat:verifsousconcess', function(suffisantsous)
						if suffisantsous then
						supprimerbateauxconcess()
						chargementvoiture(modelevoiture)
						ESX.Game.SpawnVehicle(modelevoiture, {x = -797.46, y = -1503.61, z = -0.15}, 103.59, function (vehicle)
						table.insert(sortirvoitureacheter, vehicle)
						FreezeEntityPosition(vehicle, true)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						SetModelAsNoLongerNeeded(modelevoiture)
						local plaque     = GeneratePlate()
						local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
						vehicleProps.plate = plaque
						SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
						FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)
						TriggerServerEvent('shop:boat', vehicleProps, prixvoiture)
						ESX.ShowNotification("Vous avez achetez une ~b~"..modelevoiture..".")
						TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
						end)
						else
							ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent pour se bateaux')
						end
		
					end, prixvoiture)

				end                    
			})

		   end)

		
		 Wait(0)
		end
	 end)
  end
end

-- POS DU MENU --

local position = {
	{x = -795.82, y = -1511.63, z = 1.6}
}

Citizen.CreateThread(function()
    while true do

     	local wait = 750

        for k in pairs(position) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 8.0 then
            wait = 0
			DrawMarker(6, -795.82, -1511.63, 0.6, 0.0, 0.0, 0.0, -90.0,0.0,0.0, 0.8, 0.8, 0.8, 255, 0, 0 , 255, false, true, p19, true)  

            if dist <= 2.5 then
               wait = 0
			   	Visual.Subtitle("Appuyer sur ~r~[E]~s~ pour ouvrir le ~r~Menu", 0) 
                if IsControlJustPressed(1,51) then
					supprimerbateauxconcess()
					ESX.TriggerServerCallback('h4ci_boat:recuperercategorieavion', function(catevehi)
						h4ci_conc.catevehi = catevehi
					end)
					OpenMenuBoat()
            	end
            else RageUI.CloseAll()
        	end
    	end
    	Citizen.Wait(wait)
    end
end
end)

function supprimerbateauxconcess()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('shop_awaiting_model')
		EndTextCommandBusyString(4)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end
		RemoveLoadingPrompt()
	end
end

------Blips
local blips = {
    -- Exemple {title="", colour=, id=, x=, y=, z=},
        {title="Concessionnaire Bateaux", colour=67, id=427, x = -795.51, y = -1511.5, z = 1.6},
  }

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.8)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

