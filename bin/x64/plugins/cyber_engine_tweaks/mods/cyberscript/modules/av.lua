debugPrint(3,"CyberScript: AV module loaded")
cyberscript.module = cyberscript.module +1

--TAKEN AND ADAPTED FROM FREEFLY, This mod was created by keanuWheeze from CP2077 Modding Tools Discord. Check his page : https://www.nexusmods.com/cyberpunk2077/mods/780?tab=files



function fly(directions, angle)
	
	local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
	if(inVehicule) then
	local vehicules = GetMountedVehicle(Game.GetPlayer())
	
	local newPos = vehicules:GetWorldPosition()
	
	local record = vehicules:GetRecord()
	
	
	
	local uiData = record:VehicleUIData()
	
	local vehimass = MeasurementUtils.ValueToImperial(uiData:Mass(), EMeasurementUnit.Kilogram)

	local mass = math.floor(vehimass)

	
	
	
	local newAngle = {}
	newAngle.yaw = AVyaw
	newAngle.roll = AVroll
	newAngle.pitch = AVPitch
	
	local group =getGroupfromManager("AV")
	
	
	for i=1, #group.entities do 
		local entityTag = group.entities[i]
		local isplayer = false
		
		
		if entityTag == "player" then
			-- isplayer = true
		end
		
		local obj = getEntityFromManager(entityTag)
		local enti = Game.FindEntityByID(obj.id)
		
		if(enti ~= nil) then
			
			
			local newpostouse = newPos
			
			
			
			
			--local test = Game.GetPlayer():GetFPPCameraComponent():GetLocalOrientation()
			
			
			
			
			
			for directionKey, state in pairs(directions) do
				if state == true and (directionKey ~= "left" or directionKey ~= "right") then
				
					if((directionKey=="forward" or directionKey=="backwards") or entityTag == "fake_av") then
						
						newpostouse.z = newpostouse.z+0.2
						
					end
					
					
					if(entityTag == "fake_av") then
						
						mass = 3000
						
					end
					
					
				newPos =  calculateNewPos(directionKey, newpostouse, vehicules,mass)
					
					
					
					
					
				end
				
				
			--	if state == true and (directionKey == "left" or directionKey == "right" or directionKey == "rollleft" or directionKey == "rollright") then
			
				if state == true then
					calculateNewAngle(directionKey)
					
					
					
					
					
					
					
				end
				
				
				
				
			end
			
			newAngle.yaw = AVyaw
			newAngle.roll = AVroll
			newAngle.pitch = AVPitch
			
			teleportTo(enti, newPos, newAngle, false)
			
			end
			
		end
		
--teleportTo(vehicule, newPos, newAngle, false)
		Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(0, 0-AVrollCam, 0)))
	AVrollCam = 0
	
	end
	
end

function calculateNewPos(direction, newPos, vehicule,mass)
	
	if direction == "forward" or direction == "backwards" then
		--direc = Game.GetCameraSystem():GetActiveCameraForward()
		direc = getForwardPosition(vehicule, AVspeed)
		
	end
	local collision = false
	
	local from = Vector4.new(
		newPos.x + 1 ,
		newPos.y + 1,
		newPos.z,
		newPos.w
	)
	
	local forward = getForwardPosition(vehicule, 1)
	local to = Vector4.new(
		from.x + (forward.x * AVspeed),
		from.x + (forward.x * AVspeed),
		from.z,
		from.w
	)
	
	local filters = {
		
		'Static', -- Buildings, Concrete Roads, Crates, etc.
		
		'Terrain'
		
	}
	
	
	
	if direction == "backwards"  then
		
		forward =getBehindPosition(vehicule,1)
		
		from = Vector4.new(
			newPos.x ,
			newPos.y ,
			newPos.z,
			newPos.w
		)
		to = Vector4.new(
			from.x - (forward.x * AVspeed),
			from.x - (forward.x * AVspeed),
			from.z,
			from.w
		)
		
		
	end
	
	if direction == "down"  then
		
		
		
		from = Vector4.new(
			newPos.x ,
			newPos.y ,
			newPos.z,
			newPos.w
		)
		to = Vector4.new(
			from.x - (forward.x * AVspeed),
			from.x - (forward.x * AVspeed),
			from.z - (1 * AVspeed),
			from.w
		)
		
		filters = {'Terrain'}
		
	end
	
	
	
	
	
	for _, filter in ipairs(filters) do
		local success, result = Game.GetSpatialQueriesSystem():SyncRaycastByCollisionGroup(from, to, filter, false, false)
		
		if success then
			collision = true
			--debugPrint(2,"collision"..filter)
		end
	end
	
	if direction == "forward" and (collision == false or collision == true)  then
		direc = getForwardPosition(vehicule, AVspeed)
		
		
		newPos.x = newPos.x + (direc.x * AVspeed)
		newPos.y = newPos.y + (direc.y * AVspeed)
		
		newPos.x = direc.x 
		newPos.y = direc.y
		
		
		if(AVPitch ~= 0) then
			
			if(AVPitch > 0) then
				AVPitch = AVPitch -  0.1
				else
				
				AVPitch = AVPitch +  0.1
			end
		end
		--newPos.z = newPos.z + (direc.z * AVspeed)
        elseif direction == "backwards" and collision == false  then
		direc = getBehindPosition(vehicule,AVspeed)
	
		newPos.x = newPos.x - (direc.x * AVspeed)
		newPos.y = newPos.y - (direc.y * AVspeed)
		-- newPos.z = newPos.z - (direc.z * AVspeed)
		
		if(AVPitch ~= 0) then
			
			if(AVPitch > 0) then
				AVPitch=AVPitch  -  0.1
				else
				
				AVPitch= AVPitch +  0.1
			end
		end
		
	
		
		newPos.x = direc.x 
		newPos.y = direc.y
	
	
		
        elseif direction == "up" then
		
		
		newPos.z = newPos.z + (1 * AVspeed)
		AVPitch= AVPitch + 0.1
		
	
		
		
        elseif direction == "down" and collision == false then
		
		newPos.z = newPos.z - (1 * AVspeed)
		AVPitch= AVPitch -  0.1
		
	
	end
	
	if collision == true then
		AVspeed = 0.3
		else
		AVspeed =  getvelocity(AVspeed,AVVelocity,mass)
	end
	
	return newPos
end

function getvelocity(speed,velocity,mass)

local minmass = mass/1000

local massveloce = minmass * 0.001

local result = speed + (velocity-massveloce)

return result

end

function calculateNewAngle(direction)
	
	
	--debugPrint(2,direction)
	if direction == "right"  then
		
		AVyaw = AVyaw + 0.7
		AVroll = AVroll-0.15
		AVrollCam = 1
		
		
        elseif direction == "left"  then
		
		AVyaw = AVyaw - 0.7
		AVroll = AVroll+0.15
		AVrollCam = -1
		
		
	   
		
		else

		
	if(AVroll ~= 0) then
			
			if(AVroll > 0) then
				AVroll=AVroll  -  0.05
				else
				
				AVroll= AVroll +  0.05
			end
		end
		
		end
		
	
	
end