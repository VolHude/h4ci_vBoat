ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SpawnVehicle(vehicle, plate)
    x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = x,
		y = y,
		z = z 
	}, GetEntityHeading(PlayerPedId()), function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		--SetVehicleEngineHealth(callback_vehicle, 1000) -- Might not be needed
		--SetVehicleBodyHealth(callback_vehicle, 1000) -- Might not be needed
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
	end)
	TriggerServerEvent('garage:breakVehicleSpawn', plate, false)
end

function ReturnVehicle()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = GetPlayerPed(-1)
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate

		ESX.TriggerServerCallback('garage:returnVehicle', function(valid)
			if valid then
                BreakReturnVehicle(vehicle, vehicleProps)
			else
				ESX.ShowNotification('Tu ne peu pas garer ce véhicule')
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('Il n y a pas de véhicule à rangé dans le garage.')
	end
end

function BreakReturnVehicle(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('garage:breakVehicleSpawn', vehicleProps.plate, true)
	ESX.ShowNotification("Tu vien de ranger ton ~r~véhicule ~s~!")
end

-- Garage
CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Bateaux.Positions.Garage) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local pos = Bateaux.Positions.Garage
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

			if dist <= Bateaux.MarkerDistance then
				wait = 1
				DrawMarker(6, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, -90.0,0.0,0.0, Bateaux.MarkerSizeLargeur, Bateaux.MarkerSizeEpaisseur, Bateaux.MarkerSizeHauteur, 3, 252, 65, Bateaux.MarkerOpacite, false, true, p19, true)  

				if dist <= 2.5 then
				wait = 1
					Visual.Subtitle("Appuyer sur ~g~[E]~s~ pour ~g~sortir un bateaux ~s~!", 1) 
					if IsControlJustPressed(1,51) then
						ESX.TriggerServerCallback('garage:vehiclelist', function(ownedCars)
                            Garage.vehiclelist = ownedCars
                        end)
						OpenMenuGarage()
					end
				end
			end
    	end
	Wait(wait)
	end
end)

-- Fourrière 
Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Bateaux.Positions.Pound) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local pos = Bateaux.Positions.Pound
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

			if dist <= Bateaux.MarkerDistance then
				wait = 0
				DrawMarker(6, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, -90.0,0.0,0.0, Bateaux.MarkerSizeLargeur, Bateaux.MarkerSizeEpaisseur, Bateaux.MarkerSizeHauteur, 252, 157, 3, Bateaux.MarkerOpacite, false, true, p19, true)  

				if dist <= 2.5 then
				wait = 0
					Visual.Subtitle("Appuyer sur ~o~[E]~s~ pour accéder à la ~o~fourrière ~s~!", 1) 
					if IsControlJustPressed(1,51) then
						ESX.TriggerServerCallback('garage:vehiclelistfourriere', function(ownedCars)
                            Pound.poundlist = ownedCars
                        end)
						OpenMenuPound()
					end
				end
			end
    	end
	Wait(wait)
	end
end)

-- Ranger 
Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Bateaux.Positions.Return) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local pos = Bateaux.Positions.Return
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

			if dist <= Bateaux.MarkerDistance then
                wait = 1
                DrawMarker(6, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, -90.0,0.0,0.0, Bateaux.MarkerSizeLargeur, Bateaux.MarkerSizeEpaisseur, Bateaux.MarkerSizeHauteur, 252, 3, 3, Bateaux.MarkerOpacite, false, true, p19, true)  

				if dist <= 2.5 then
				wait = 1
					Visual.Subtitle("Appuyer sur ~g~[E]~s~ pour ~g~ranger un bateaux ~s~!", 1) 
					if IsControlJustPressed(1,51) then
						ReturnVehicle()
					end
				end
			end
    	end
	Wait(wait)
	end
end)


Citizen.CreateThread(function()
    if Bateaux.Blip then
        for k, v in pairs(Bateaux.Positions.Garage) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)

            SetBlipSprite(blip, 427)
            SetBlipScale (blip, 0.7)
            SetBlipColour(blip, 38)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Garage Bateaux')
            EndTextCommandSetBlipName(blip)
        end

		for k, v in pairs(Bateaux.Positions.Pound) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)

            SetBlipSprite(blip, 427)
            SetBlipScale (blip, 0.7)
            SetBlipColour(blip, 44)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Fourrière Bateaux')
            EndTextCommandSetBlipName(blip)
        end
    end
end)