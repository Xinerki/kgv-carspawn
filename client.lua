
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
				
				repeat Wait(0) until GetPlayerSwitchState() == 3
				RequestModel(carModel)
				BeginTextCommandBusyspinnerOn("STRING")
				AddTextComponentString("LOADING "..args[1]:upper())
				EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)	
				-- Wait(600)
				BusyspinnerOff()
				
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				success, vec3, heading = GetRandomVehicleNode(x,y,z, 500.0, 1, true, true)
				success, vec3, heading = GetClosestVehicleNodeWithHeading(vec3.x, vec3.y, vec3.z, 1, 3, 0)
				
				local oldped = ClonePed(PlayerPedId(), 0.0, true, true)
				local veh = false
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					veh = true
					oldveh = GetVehiclePedIsIn(PlayerPedId(), 1)
				end
				
				RequestCollisionAtCoord(vec3.x, vec3.y, vec3.z)
				local car = CreateVehicle(carModel, vec3, heading, true, true)
				
				local dim = GetModelDimensions(carModel)
				vec3 = GetOffsetFromEntityInWorldCoords(car, dim.x, 0.0, 0.0)
				SetEntityCoords(car, vec3)
				
				SetPedIntoVehicle(PlayerPedId(), car, -1)
				
				Wait(50)
				
				if veh == true then 
					SetPedIntoVehicle(oldped, oldveh, -1)
					TaskVehicleDriveWander(oldped, oldveh, 10.0, 0)
				end
				
				Wait(150)
				
				SetEntityAsNoLongerNeeded(oldped)
				
				SetEntityAsNoLongerNeeded(car)
				SetModelAsNoLongerNeeded(carModel)
				
				SwitchInPlayer(PlayerPedId())
			end)
		end
	end, false)

	TriggerEvent('chat:addSuggestion', '/drop', 'drop acar!', { {name='MODEL', help="car model bro"} } )
	RegisterCommand("drop", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
			
				BeginTextCommandBusyspinnerOn("STRING")
				AddTextComponentString("LOADING "..args[1]:upper())
				EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)
				BusyspinnerOff()
			
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				success, vec3, heading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
				if vec3 == vector3(0,0,0) then vec3 = GetEntityCoords(PlayerPedId()) end
					
				local blip = AddBlipForEntity(car)
				SetBlipScale(blip, 0.5)
				SetBlipColour(blip, 3)
				
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

	TriggerEvent('chat:addSuggestion', '/summon', 'delivered car!', { {name='MODEL', help="car model bro"} } )
	RegisterCommand("summon", function(source, args, rawCommand)
		if args[1] then
			carModel = GetHashKey(args[1])
			pedHash = `s_m_y_xmech_01`
			if not IsModelValid(carModel) then return end
			if not IsModelInCdimage(carModel) then return end
			if not IsModelAVehicle(carModel) then return end
			Citizen.CreateThread(function()
			
				BeginTextCommandBusyspinnerOn("STRING")
				AddTextComponentString("LOADING "..args[1]:upper())
				EndTextCommandBusyspinnerOn(1)
				RequestModel(carModel)
				repeat Wait(0) until HasModelLoaded(carModel)
				BeginTextCommandBusyspinnerOn("STRING")
				AddTextComponentString("LOADING S_M_Y_XMECH_01")
				EndTextCommandBusyspinnerOn(1)
				RequestModel(pedHash)
				repeat Wait(0) until HasModelLoaded(pedHash)
				-- Wait(600)
				BusyspinnerOff()
				
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

	TriggerEvent('chat:addSuggestion', '/cab', 'Call a cab from Express Cab Service')
	RegisterCommand("cab", function(source, args, rawCommand)
		
		carModel = `rom`
		if args[1] == "custommodel" then carModel = GetHashKey(args[2]) end
		pedHash = `a_m_m_indian_01`
		if not IsModelValid(carModel) then return end
		if not IsModelInCdimage(carModel) then return end
		if not IsModelAVehicle(carModel) then return end
		if GetVehicleModelNumberOfSeats(carModel) < 2 then return end
		Citizen.CreateThread(function()
		
			-- BeginTextCommandBusyspinnerOn("STRING")
			-- AddTextComponentString("LOADING "..tostring(carModel):upper())
			-- EndTextCommandBusyspinnerOn(1)
			RequestModel(carModel)
			repeat Wait(0) until HasModelLoaded(carModel)
			-- BeginTextCommandBusyspinnerOn("STRING")
			-- AddTextComponentString("LOADING a_m_m_indian_01")
			-- EndTextCommandBusyspinnerOn(1)
			RequestModel(pedHash)
			repeat Wait(0) until HasModelLoaded(pedHash)
			-- Wait(600)
			-- BusyspinnerOff()
			
			local car = CreateVehicle(carModel, -45.65, -1826.75, 25.85, -39.7, true, true)
			local ped = CreatePedInsideVehicle(car, 4, pedHash, -1, true, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
			
			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
			success, vec3, heading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
			if vec3 == vector3(0,0,0) then vec3 = GetEntityCoords(PlayerPedId()) end
				
			local blip = AddBlipForEntity(car)
			SetBlipScale(blip, 0.5)
			SetBlipColour(blip, 3)
			
			-- TaskVehiclePark(ped, car, vec3, 0.0, 0, 20.0, false)
			local x, y, z = table.unpack(vec3)
			-- print(vec3)
			
			-- drivingFlag = 1074528293
			drivingFlag = 786980
			
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
			
			ClearPedTasks(PlayerPedId())
			
			local seat = 2
			if GetVehicleModelNumberOfSeats(carModel) < 4 then
				seat = 0
			end
			
			-- Wait(500)
			TaskEnterVehicle(PlayerPedId(), car, 15000, seat, 1, 0)
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