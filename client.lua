
Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/spawn', 'car!', { {name='MODEL', help="car model bro"} } )
	RegisterCommand("spawn", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
				SwitchOutPlayer(PlayerPedId(), 0, 2)
				
				SetPlayerControl(PlayerId(), false, 0)
				
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					TaskVehicleDriveWander(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 10.0, 0)
				end
				
				repeat Wait(0) until GetPlayerSwitchState() == 3
				RequestModel(carModel)
				-- BeginTextCommandBusyspinnerOn("STRING")
				-- AddTextComponentString("LOADING "..args[1]:upper())
				-- EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)	
				-- Wait(600)
				-- BusyspinnerOff()
				
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				success, vec3, heading = GetRandomVehicleNode(x,y,z, 500.0, 1, true, true)
				success, vec3, heading = GetClosestVehicleNodeWithHeading(vec3.x, vec3.y, vec3.z, 1, 3, 0)
				
				local oldped = ClonePed(PlayerPedId(), true, false, true)
				local veh = false
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					veh = true
					oldveh = GetVehiclePedIsIn(PlayerPedId(), 1)
				end
				
				RequestCollisionAtCoord(vec3.x, vec3.y, vec3.z)
				
				if IsThisModelAHeli(carModel) or IsThisModelAPlane(carModel) then
					vec3 = vec3 + vector3(0.0, 0.0, 150.0)
				end
				
				local car = CreateVehicle(carModel, vec3, heading, true, true)
				
				local dim = GetModelDimensions(carModel)
				vec3 = GetOffsetFromEntityInWorldCoords(car, dim.x, 0.0, 0.0)
				
				SetEntityCoords(car, vec3)
				SetEntityRotation(car, 0.0, 0.0, heading)
				
				if IsThisModelAHeli(carModel) then
					SetHeliBladesFullSpeed(car)
					ControlLandingGear(car, 3)
				end
				
				SetPedIntoVehicle(PlayerPedId(), car, -1)
				
				FreezeEntityPosition(car, true)
				
				if IsThisModelAPlane(carModel) then
					TaskVehicleTempAction(PlayerPedId(), car, 9, 3000)
					SetHeliBladesFullSpeed(car)
					ControlLandingGear(car, 3)
					-- Wait(2000)
				end
				
				Wait(50)
				
				if veh == true then 
					SetPedIntoVehicle(oldped, oldveh, -1)
					TaskVehicleDriveWander(oldped, oldveh, 10.0, 0)
				end
				
				Wait(150)
				
				SetEntityAsNoLongerNeeded(oldped)
				
				SwitchInPlayer(PlayerPedId())
				
				repeat Wait(0) until HasCollisionLoadedAroundEntity(PlayerPedId())
				
				-- Wait(2000)
				-- SetEntityRotation(car, 0.0, 0.0, heading)
				-- Wait(100)
				-- SetVehicleForwardSpeed(car, 30.0)
				
				SetPlayerControl(PlayerId(), true, 0)
				
				FreezeEntityPosition(car, false)
				if IsThisModelAPlane(carModel) then
					SetEntityRotation(car, 0.0, 0.0, heading)
					Wait(50)
					SetVehicleForwardSpeed(car, 200.0)
				else
					SetVehicleOnGroundProperly(car)
				end
				
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
			end)
		end
	end, false)

	TriggerEvent('chat:addSuggestion', '/order', 'order a delivery!', { {name='MODEL', help="car model bro"} })
	RegisterCommand("order", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)

				-- local heliModel = `cargobob4`
				local heliModel = `cargobob`
				RequestModel(heliModel)
				repeat Wait(0) until HasModelLoaded(heliModel)

				local pedModel = `s_m_m_ciasec_01`
				RequestModel(pedModel)
				repeat Wait(0) until HasModelLoaded(pedModel)
			
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				success, vec3, heading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
				if vec3 == vector3(0,0,0) then vec3 = GetEntityCoords(PlayerPedId()) end
				local destination = vec3

				local angle = math.random(360)
				local x = math.sin(math.rad(angle)) * 250.0
				local y = math.cos(math.rad(angle)) * 250.0
				local z = 50.0
				local heliPos = GetEntityCoords(PlayerPedId()) + vector3(x, y, 0.0)
				
				success, vec3, heading = GetClosestVehicleNodeWithHeading(heliPos.x, heliPos.y, heliPos.z, 1, 3, 0)
				if vec3 == vector3(0,0,0) then vec3 = heliPos end

				local heli = CreateVehicle(heliModel, vec3.x, vec3.y, vec3.z + z, heading, true, true)
				SetHeliBladesFullSpeed(heli)
				local ped = CreatePedInsideVehicle(heli, 4, pedModel, -1, true, true)
				SetBlockingOfNonTemporaryEvents(ped, true)
				local car = CreateVehicle(carModel, heliPos.x, heliPos.y, z - 7.0, heading, true, true)
				Wait(100)
				CreatePickUpRopeForCargobob(heli, 0)
				-- N_0x56eb5e94318d3fb6(heli, true)
				Wait(100)
				-- SetCargobobPickupMagnetReducedStrength(heli, car)
				-- SetCargobobPickupMagnetActive(heli, true)
				AttachVehicleToCargobob(heli, car, -1, 0.0, 0.0, 0.0)

				TaskHeliMission(ped, heli, nil, nil, destination.x, destination.y, destination.z + 10.0, 4, 25.0, 5.0, -1, 100, 20)
				
				local delivered = false
				local atLocationTime = 0

				while not delivered do Wait(0)
					local dist = #(GetEntityCoords(heli) - (destination + vector3(0.0, 0.0, 20.0))).xy
					if GlobalState.debug then
						print(dist, atLocationTime)
					end
					if dist < 10.0 then
						atLocationTime = atLocationTime + GetFrameTime()
						if atLocationTime > 8.0 then
							delivered = true
						end
					else
						atLocationTime = 0
					end
				end

				-- SetCargobobPickupMagnetActive(heli, false)
				DetachVehicleFromCargobob(heli, car)
				Wait(100)
				TaskHeliMission(ped, heli, nil, nil, destination.x, destination.y, destination.z + 20.0, 8, 100.0, 2.0, -1, 100, 20)
				Wait(100)
				
				SetEntityAsNoLongerNeeded(ped)
				SetModelAsNoLongerNeeded(pedModel)
				SetEntityAsNoLongerNeeded(heli)
				SetModelAsNoLongerNeeded(heliModel)
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
			end)
		end
	end)

	TriggerEvent('chat:addSuggestion', '/drop', 'drop acar!', { {name='MODEL', help="car model bro"} } )
	RegisterCommand("drop", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
			
				-- BeginTextCommandBusyspinnerOn("STRING")
				-- AddTextComponentString("LOADING "..args[1]:upper())
				-- EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)
				-- BusyspinnerOff()
			
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				success, vec3, heading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
				if vec3 == vector3(0,0,0) then vec3 = GetEntityCoords(PlayerPedId()) end
				
				-- TaskVehiclePark(ped, car, vec3, 0.0, 0, 20.0, false)
				local x, y, z = table.unpack(vec3)
					
				local car = CreateVehicle(carModel, x, y, z+50.0, heading, true, true)
				
				SetEntityVelocity(car, 0.0, 0.0, -50.0)
				
				Wait(1000)
				
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
			end)
		end
	end, false)

	--[[
	TriggerEvent('chat:addSuggestion', '/get', 'just get it!', { {name='MODEL', help="man just take it"} } )
	RegisterCommand("get", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
			
				-- BeginTextCommandBusyspinnerOn("STRING")
				-- AddTextComponentString("LOADING "..args[1]:upper())
				-- EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)
				-- BusyspinnerOff()
			
				local pos = GetEntityCoords(PlayerPedId())
				local heading = GetEntityHeading(PlayerPedId())
					
				local car = CreateVehicle(carModel, pos, heading, true, true)
				
				SetPedIntoVehicle(PlayerPedId(), car, -1)
				-- SetEntityVelocity(car, 0.0, 0.0, -50.0)
				
				Wait(1000)
				
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
			end)
		end
	end, false)
	]]

	TriggerEvent('chat:addSuggestion', '/summon', 'delivered car!', { {name='MODEL', help="car model bro"} } )
	RegisterCommand("summon", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			pedHash = `s_m_y_xmech_01`
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
			
				-- BeginTextCommandBusyspinnerOn("STRING")
				-- AddTextComponentString("LOADING "..args[1]:upper())
				-- EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)
				-- BeginTextCommandBusyspinnerOn("STRING")
				-- AddTextComponentString("LOADING S_M_Y_XMECH_01")
				-- EndTextCommandBusyspinnerOn(1)
				RequestModel(pedHash)
				repeat Wait(0) until HasModelLoaded(pedHash)
				-- Wait(600)
				-- BusyspinnerOff()
				
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				success, vec3, heading = GetRandomVehicleNode(x,y,z, 500.0, 1, true, true)
				success, vec3, heading = GetClosestVehicleNodeWithHeading(vec3.x, vec3.y, vec3.z, 1, 3, 0)
				
				local veh = false
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					veh = true
					oldveh = GetVehiclePedIsIn(PlayerPedId(), 1)
				end
				local car = CreateVehicle(carModel, vec3, heading, true, true)
				
				local dim = GetModelDimensions(carModel)
				vec3 = GetOffsetFromEntityInWorldCoords(car, dim.x, 0.0, 0.0)
				SetEntityCoords(car, vec3)
				
				local blip = AddBlipForEntity(car)
				SetBlipScale(blip, 0.5)
				SetBlipColour(blip, 3)
				
				Wait(50)
				
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				
				success, vec3, heading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
				
				local ped = CreatePedInsideVehicle(car, 4, pedHash, -1, true, true)
				SetBlockingOfNonTemporaryEvents(ped, true)
				
				if not success then vec3 = GetEntityCoords(PlayerPedId()) end
				
				TaskVehiclePark(ped, car, vec3, 0.0, 0, 20.0, false)
				
				repeat Wait(0) until GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(car)) < 10.0
				
				TaskLeaveVehicle(ped, car, 0)
				TaskWanderStandard(ped, 10.0, 10)
				SetEntityAsNoLongerNeeded(ped)
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
				
				repeat Wait(0) until IsPedInVehicle(PlayerPedId(), car, true)
				
				RemoveBlip(blip)
				
			end)
		end
	end, false)

	TriggerEvent('chat:addSuggestion', '/demand', 'car on demand!', { {name='MODEL', help="car model bro"} } )
	RegisterCommand("demand", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
			
				-- BeginTextCommandBusyspinnerOn("STRING")
				-- AddTextComponentString("LOADING "..args[1]:upper())
				-- EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)
				-- Wait(600)
				-- BusyspinnerOff()
				
				-- success, vec3, heading = GetRandomVehicleNode(x,y,z, 500.0, 1, true, true)
				-- success, vec3, heading = GetClosestVehicleNodeWithHeading(vec3.x, vec3.y, vec3.z, 1, 3, 0)
				
				local i = 10
				repeat
					local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
					success, vec3, heading = GetNthClosestVehicleNodeWithHeading(x, y, z, i, 9, 3.0, 2.5)
					i = i + 1
				until IsSphereVisible(vec3.x, vec3.y, vec3.z, 5.0) == false
				
				local car = CreateVehicle(carModel, vec3, heading, true, true)
				
				local dim = GetModelDimensions(carModel)
				vec3 = GetOffsetFromEntityInWorldCoords(car, dim.x, 0.0, 0.0)
				SetEntityCoords(car, vec3)
				
				local blip = AddBlipForEntity(car)
				SetBlipScale(blip, 0.5)
				SetBlipColour(blip, 3)
				
				Wait(50)
				
				local now = GetGameTimer()
				
				-- repeat Wait(0) until GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(car)) < 10.0
				repeat Wait(0) until GetVehiclePedIsEntering(PlayerPedId()) == car or IsEntityDead(car) or GetGameTimer() > now + (1000 * 30)
				
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
				
				-- repeat Wait(0) until IsPedInVehicle(PlayerPedId(), car, true)
				
				RemoveBlip(blip)
				
			end)
		end
	end, false)

	TriggerEvent('chat:addSuggestion', '/cab', 'Call a cab from Express Cab Service')
	RegisterCommand("cab", function(source, args, rawCommand)
		
		carModel = `rom`
		if args[1] == "custommodel" then carModel = GetHashKey(args[2]) end
		pedHash = `mp_m_niko_01`
		-- pedHash = `a_m_m_indian_01`
		if not IsModelValid(carModel) then return end
		if not IsModelInCdimage(carModel) then return end
		if not IsModelAVehicle(carModel) then return end
		if GetVehicleModelNumberOfSeats(carModel) < 4 then return end
		Citizen.CreateThread(function()
		
			-- BeginTextCommandBusyspinnerOn("STRING")
			-- AddTextComponentString("LOADING "..tostring(carModel):upper())
			-- EndTextCommandBusyspinnerOn(1)
			RequestModel(carModel)
			repeat Wait(0) until HasModelLoaded(carModel)
			-- BeginTextCommandBusyspinnerOn("STRING")
			-- AddTextComponentString("LOADING mp_m_niko_01")
			-- AddTextComponentString("LOADING a_m_m_indian_01")
			-- EndTextCommandBusyspinnerOn(1)
			RequestModel(pedHash)
			repeat Wait(0) until HasModelLoaded(pedHash)
			-- Wait(600)
			-- BusyspinnerOff()
			
			local car = CreateVehicle(carModel, -45.65, -1826.75, 25.85, -39.7, true, true)
			SetVehRadioStation(car, "RADIO_01_CLASS_ROCK")
			SetVehicleRadioLoud(car, true)
			
			local ped = CreatePedInsideVehicle(car, 4, pedHash, -1, true, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetPedConfigFlag(ped, 251, true)
			
			SetDriverAbility(ped, 1.0)
			SetDriverAggressiveness(ped, 1.0)
			
			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
			success, vec3, heading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
			if vec3 == vector3(0,0,0) then vec3 = GetEntityCoords(PlayerPedId()) end
				
			local blip = AddBlipForEntity(car)
			SetBlipScale(blip, 0.5)
			SetBlipColour(blip, 3)
			
			-- TaskVehiclePark(ped, car, vec3, 0.0, 0, 20.0, false)
			local x, y, z = table.unpack(vec3)
			-- print(vec3)
			
			drivingFlag = 1074528293
			-- drivingFlag = 786734
			-- drivingFlag = 786980
			
			TaskVehicleDriveToCoord(ped, car, x, y, z, 500.0, 0.0, carModel, drivingFlag, 20.0, true)
			
			repeat Wait(0)
				if IsPedDeadOrDying(ped) or IsEntityDead(car) then
					SetEntityAsNoLongerNeeded(ped)
					SetEntityAsNoLongerNeeded(car)
					SetModelAsNoLongerNeeded(carModel)
					RemoveBlip(blip)
					return
				end
			until GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(car)) < 20.0
			
			BringVehicleToHalt(car, 10.0, 1000, 0)
			SetGameplayVehicleHint(car, 0.0, 0.0, 0.0, true, 2500, 1500, 1500)
			
			-- if GetVehicleModelNumberOfSeats(carModel) < 4 then
				-- SetPedVehicleForcedSeatUsage(PlayerPedId(), car, 0, 2)
			-- else
				-- SetPedVehicleForcedSeatUsage(PlayerPedId(), car, 2, 0)
			-- end
			
			-- Citizen.InvokeNative(0x952F06BEECD775CC, PlayerPedId(), car, 2, 0, -2)
			
			-- SetPedVehicleForcedSeatUsage(PlayerPedId(), car, 0, 2)
			-- Citizen.InvokeNative(0XA4885BC60A517BA5, PlayerPedId(), car, true)
			
			repeat Wait(0)
				if IsPedDeadOrDying(ped) or IsEntityDead(car) then
					SetEntityAsNoLongerNeeded(ped)
					SetEntityAsNoLongerNeeded(car)
					SetModelAsNoLongerNeeded(carModel)
					RemoveBlip(blip)
					return
				end
			until GetVehiclePedIsEntering(PlayerPedId()) == car
			
			-- print("forcing player to backseat")
			
			-- ClearPedTasks(PlayerPedId())
			
			-- local seat = 2
			-- if GetVehicleModelNumberOfSeats(carModel) < 4 then
				-- seat = 0
			-- end
			
			-- Wait(500)
			-- TaskEnterVehicle(PlayerPedId(), car, 15000, seat, 1, 0)
			
			RemoveBlip(blip)
			
			repeat Wait(0) until IsPedInVehicle(PlayerPedId(), car, false) and IsWaypointActive()
			
			local waypoint = GetFirstBlipInfoId(8)
			local x, y, z = table.unpack(GetBlipCoords(waypoint))
			
			TaskVehicleDriveToCoord(ped, car, x, y, z, 500.0, 0.0, carModel, drivingFlag, 20.0, true)
			
			repeat Wait(0)
				if IsPedDeadOrDying(ped) or not IsPedInVehicle(PlayerPedId(), car, true) then
					TaskVehicleDriveWander(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 500.0, drivingFlag)
					
					SetEntityAsNoLongerNeeded(ped)
					SetEntityAsNoLongerNeeded(car)
					SetModelAsNoLongerNeeded(carModel)
					return
				end
			until GetDistanceBetweenCoords(x, y, z, GetEntityCoords(car)) < 100.0
			
			BringVehicleToHalt(car, 10.0, 1000, 0)
			TaskLeaveVehicle(PlayerPedId(), car, 0)
			
			repeat Wait(0) until not IsPedInVehicle(PlayerPedId(), car, true)
			
			Wait(5000)
			
			TaskVehicleDriveWander(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 500.0, drivingFlag)
			
			SetEntityAsNoLongerNeeded(ped)
			SetEntityAsNoLongerNeeded(car)
			SetModelAsNoLongerNeeded(carModel)
			
		end)
	end, false)
end)