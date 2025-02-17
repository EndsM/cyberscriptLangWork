debugPrint(3,"CyberScript: utils module loaded")
cyberscript.module = cyberscript.module +1

--This file contains several functions that are used everywhere
function isActiveRipperDoc(vendorRecord)
	return vendorRecord:VendorType()
	and vendorRecord:VendorType():Type() == Enum.new('gamedataVendorType', 'RipperDoc')
	and vendorRecord:GetItemStockCount() > 0
	and vendorRecord:LocalizedName() ~= ''
	and Game.GetLocalizedText(vendorRecord:LocalizedName()) ~= 'DELETE'
end


function getVendorId()
	local ripperDocList = {}
	for _, vendorRecord in ipairs(TweakDB:GetRecords('gamedataVendor_Record')) do
		if isActiveRipperDoc(vendorRecord) then
			local ripperDocItem = {
				name = Game.GetLocalizedText(vendorRecord:LocalizedName()),
				desc = Game.GetLocalizedText(vendorRecord:LocalizedDescription()),
				vendorId = vendorRecord:GetID()
			}
			
			ripperDocItem.filter = ripperDocItem.name:upper()
			
			table.insert(ripperDocList, ripperDocItem)
		end
	end
	
	table.sort(ripperDocList, function(a, b)
		return a.name < b.name
	end)
	
	return ripperDocList[1].vendorId
	
end


function hex2rgb(hex)
    local hex = hex:gsub("#","")
    if hex:len() == 3 then
		return (tonumber("0x"..hex:sub(1,1))*17)/255, (tonumber("0x"..hex:sub(2,2))*17)/255, (tonumber("0x"..hex:sub(3,3))*17)/255
		else
		return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
	end
end


function checkVersionNumber(current,new) --true means the current is outdated
	
	local currentVersion = current
	local majorc, minorc, patchc = string.match(currentVersion, "(%d+)%.(%d+)%.(%d+)")
	
	
	
	if patch2 == nil then
        
		majorc, minorc = string.match(currentVersion, "(%d+)%.(%d+)")
		
        
	end
	if(majorc == nil or minorc == nil) then
		return true
	end
	
	local newVersion = new
	
	local majorn, minorn, patchn = string.match(newVersion, "(%d+)%.(%d+)%.(%d+)")
	
	
	
	
	if patchn == nil then
        
		majorn, minorn = string.match(newVersion, "(%d+)%.(%d+)")
        
	end
	if(majorn == nil or minorn == nil) then
		return true
	end
	
	if
		(tonumber(majorn) == 9999 and current ~= new ) or 
		(tonumber(majorc) == 9999 and current ~= new) or 
		(tonumber(majorn) > tonumber(majorc)) or 
		((tonumber(majorn) == tonumber(majorc)) and (tonumber(minorn) > tonumber(minorc))) or 
		(patchn ~= nil and patchc ~= nil and (tonumber(majorn) == tonumber(majorc)) and (tonumber(minorn) == tonumber(minorc)) and (tonumber(patchn) > tonumber(patchc))) then
		
		return true
		
		else
		
		return false
		
	end
    
end



function tonullstring(value)
	
	if(value == nil) then tostring("nil") else tostring(value) end
	
end



function locateValue( tab, value )
    local path = ''  --  placeholder
    
    for key, val in pairs( tab ) do
		
        if key == value then  --  found location
			
            return tab[key]  --  concatenate
			
			elseif type( tab[key] ) == 'table' then  --  go further down the rabbit hole
            local found = locatePath( tab[key], value )
            
            if found ~= '' then  --  found relevant path
                return tab[key][found]  --  concatenate location
				
			end  --  found
		end  --  recursion
	end  --  pairs
    return path
end  --  function

function locatePath( tab, value )
    local path = ''  --  placeholder
    
    for key, val in pairs( tab ) do
		
        if key == value then  --  found location
			
            return key --  concatenate
			
			elseif type( tab[key] ) == 'table' then  --  go further down the rabbit hole
            local found = locatePath( tab[key], value )
			
            if found ~= '' then  --  found relevant path
				
				return found
			end  --  found
		end  --  recursion
	end  --  pairs
    return path
end  --  function

function locatePathString( tab, value )
    local path = {}  --  placeholder
    
    for key, val in pairs( tab ) do
		
        if key == value then  --  found location
			
            table.insert(path,key) --  concatenate
			
			elseif type( tab[key] ) == 'table' then  --  go further down the rabbit hole
            local found = locatePath( tab[key], value )
			
            if found ~= '' then  --  found relevant path
				
				table.insert(path,key) 
                table.insert(path,found) 
			end  --  found
		end  --  recursion
	end  --  pairs
    return path
end  --  function


function splitDot(s, sep)
    local fields = {}
    
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    
    return fields
end
function stringToPath(table, path)
	local split  = splitDot(path, '.')
	local result = {}
    if(#split > 0) then
        
		for i,v in ipairs(split) do
            if(i == 1) then
				
                result = table[v]
                
                else
                
                result = result[v]
                
			end
			
            
            
			
		end
	end
    return result
    
    
end

function SetValuestringToPath(table, path,value)
	local split  = split(path, '.')
	local result = {}
    if(#split > 0) then
        
		for i,v in ipairs(split) do
            if(i == 1) then
				
                result = table[v]
                
                else
                
                result = result[v]
                
			end
            
			
            
            
			
		end
	end
	
    
    
end
function setValueToTablePath(obj, keys, value)
    for i = 1, #keys - 1 do
        obj = obj[keys[i]]
	end
	
    -- Merely "obj = value" would affect only this local variable
    -- (as above in the loop), rather than modify the table.
    -- So the last index has to be done separately from the loop:
    obj[keys[#keys]] = value
	
end

function table_contains(tables,value,checkkey)
	local result = false
	
	if(tables ~= nil) then
		if(checkkey == false) then
			if(tables[1] == nil) then
				
				for k,v in pairs(tables) do
					
					if(v == value) then
						result = true
					end
				end
				
				else
				
				for i,v in ipairs(tables) do
					
					if(v == value) then
						result = true
					end
				end
				
			end
			
			else
			
			for k,v in pairs(tables) do
				
				if(k == value) then
					result = true
				end
			end
			
		end
	end
	
	return result
	
end

function gamecolor(r,g,b,a)
	return Color.ToHDRColorDirect(Color.new({ Red = r, Green = g, Blue = b, Alpha = a }))
end

function gamecolorStyle(color)
	return Color.ToHDRColorDirect(Color.new({ Red = color.red, Green = color.green, Blue = color.blue, Alpha = 1 }))
end

function modDirectory(filename)
	
	if file_exists("./bin/x64/plugins/cyber_engine_tweaks/mods/quest_mod/"..filename) then
		return "./bin/x64/plugins/cyber_engine_tweaks/mods/quest_mod/"
		
		elseif file_exists("./plugins/cyber_engine_tweaks/mods/quest_mod/"..filename) then
		return "./plugins/cyber_engine_tweaks/mods/quest_mod/"
		
		elseif file_exists("./cyber_engine_tweaks/mods/quest_mod/"..filename) then
		return "./cyber_engine_tweaks/mods/quest_mod/"
		
		elseif file_exists("./mods/quest_mod/"..filename) then
		return "./mods/quest_mod/"
		
		elseif file_exists("./quest_mod/"..filename) then
		return "./quest_mod/"
		
		elseif  file_exists("./"..filename) then
		return "./"
	end
	
	debugPrint(2,"wtf")
end

function ObjectToText(objectName, object)
	local text = objectName .. ": " .. tostring(object or "nil")
	
	ImGui.Text(text)
	
end

function CNameDraw(funcName, CName)
	if CName ~= nil then 
		ImGui.Text(funcName .. ": " .. Game.NameToString(CName))
		else
		ImGui.Text(funcName .. " - nil")
	end
end

function TextDraw(funcName, CName)
	if CName ~= nil then 
		ImGui.Text(funcName .. ": " .. CName)
		else
		ImGui.Text(funcName .. " - nil")
	end
end

function IsAFakeDoor(value)
	if type(value) == "FakeDoor" then
		return true
	end
	
	if value == nil or (type(value) ~= "userdata" and type(value) ~= "table") then
		return false
	end
	
	if value["IsA"] then
		return value:IsA("FakeDoor")
	end
	
	if value["ToString"] then
		return value:ToString() == kind
	end
	
	return false
end

function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function getCWD(mod_name)
	if file_exists("bin/x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
		return "bin/x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/"
		elseif file_exists("x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
		return "x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/"
		elseif file_exists("plugins/cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
		return "plugins/cyber_engine_tweaks/mods/"..mod_name.."/"
		elseif file_exists("cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
		return "cyber_engine_tweaks/mods/"..mod_name.."/"
		elseif file_exists("mods/"..mod_name.."/init.lua") then
		return "mods/"..mod_name.."/"
		elseif file_exists(mod_name.."/init.lua") then
		return mod_name.."/"
		elseif file_exists("init.lua") then
		return "s"
	end
end

function ImportLanguage()
	debugPrint(2,"Importing Language...")
	debugPrint(2,file_exists("lang/language.json"))
	
	debugPrint(2,"Language default...")
	
	local f = io.open("lang/default.json")
	lines = f:read("*a")
	if(lines ~= "") then
		lang = trydecodeJSOn(lines, f,filepath)
	end
	
	f:close()
	
	if file_exists("lang/language.json") then
		debugPrint(2,"Language founded... overwrite default")
		
		local f = io.open("lang/language.json")
		
		lines = f:read("*a")
		if(lines ~= "") then
			newlang =  trydecodeJSOn(lines, f,"lang/language.json")
			for key, value in pairs(newlang) do 
				
				lang[key] = value
			end
		end
		
		f:close()
	end
	
	debugPrint(2,lang.testOverwrite)
	
	return true
end


function ftos(number)
	return string.format( "%.3f", number)
end

function ftos2(number)
	return string.format( "%.0f", number)
end

function vecToString(vec4)
	return "x: " .. ftos(vec4.x) .. " y: " .. ftos(vec4.y) .. " z: " .. ftos(vec4.z)
end

function vecToRdString(vec4)
	return "x: " .. ftos2(vec4.x) .. " y: " .. ftos2(vec4.y) .. " z: " .. ftos2(vec4.z)
end

function checkPos(vec4, x, y,radius)
	boole = false
	
	
	
	
	
	
	
	
	if(vec4.x >= x-radius and vec4.x <= x+radius) then
		
		if (vec4.y >= y-radius and vec4.y <= y+radius) then
			boole = true
			
		end
	end
	return boole
end

function check3DPos(vec4, x, y, z,radius, zradius)
	boole = false
	
	
	if(vec4.x >= x-radius and vec4.x <= x+radius) then
		
		if (vec4.y >= y-radius and vec4.y <= y+radius) then
			
			if zradius ~= nil then 
				
				
				
				if (vec4.z >= z-zradius and vec4.z <= z+zradius) then
					
					boole = true
					
				end
				else
				
				if (vec4.z >= z-radius and vec4.z <= z+radius) then
					
					boole = true
					
				end
			end
		end
	end
	return boole
end

function splitByChunk(text, chunkSize)
	local s = {}
	for i=1, #text, chunkSize do
		s[#s+1] = text:sub(i,i+chunkSize - 1)
		
	end
	local result = ""
	for i,v in ipairs(s) do
		
		result = result .. "\n" .. v
		
	end
	return result
end

function split(s, sep)
    local fields = {}
    
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    
    return fields
end

function checkPosFixer(vec4, x, y,fixerrange)
	boole = false
	--rint(vecToRdString(vec4))
	-- --debugPrint(2,"x "..ftos2(vec4.x))
	-- --debugPrint(2,"y "..ftos2(vec4.y))
	
	
	
	--local fixerrange = getUserSetting("FixerRangeDetectionArea")
	
	
	if(vec4.x >= x-fixerrange and vec4.x <= x+fixerrange) then
		
		if (vec4.y >= y-fixerrange and vec4.y <= y+fixerrange) then
			boole = true
			
		end
	end
	return boole
end

function getDistanceFrom(startPoint, endPoint)
	
	local resX = ((startPoint.x - endPoint.x)^2)
	--debugPrint(2,resX)
	local resY = ((startPoint.y - endPoint.y)^2)
	--debugPrint(2,resY)
	local resZ = ((startPoint.z - endPoint.z)^2)
	--debugPrint(2,resZ)
	
	return math.sqrt(resX + resY + resZ)
end

function getAllNPCInRange(range)
	local player = Game.GetPlayer()
	
	local query = Game["TSQ_NPC;"]()
	query.maxDistance = range
	
	local ranged = nil
	
	local success, entities = Game.GetTargetingSystem():GetTargetParts(player, query, {})
	
	if success then
		ranged = {}
		
		for i, value in ipairs(entities) do
			local ent = value:GetComponent(value):GetEntity()
			if ent:IsNPC() then
				table.insert(ranged, ent)
			end
		end
		
		
		return ranged
	end
	
	
end

function getCurrentDistrict2()
	local preventionSystem = Game.GetScriptableSystemsContainer():Get('PreventionSystem')
	local districtManager = preventionSystem.districtManager
	
	if districtManager and districtManager:GetCurrentDistrict() then
		currentDistricts2.districtId = districtManager:GetCurrentDistrict():GetDistrictID()
		currentDistricts2.districtLabels = {}
		currentDistricts2.factionLabels = {}
		
		local tweakDb = GetSingleton('gamedataTweakDBInterface')
		local districtRecord = tweakDb:GetDistrictRecord(currentDistricts2.districtId)
		repeat
			
			local districtLabel = Game.GetLocalizedText(districtRecord:EnumName())
			
			table.insert(currentDistricts2.districtLabels, 1, districtLabel)
			
			
			
			local myfaction = {}
			
			local mydistrict = {}
			
			for i = 1, #arrayDistricts do
				
				if arrayDistricts[i].EnumName:upper() == districtLabel:upper() then
					mydistrict = arrayDistricts[i]
					currentDistricts2.customdistrict =  arrayDistricts[i]
					
				end
				
			end
			
			myfaction = getFactionByDistrictTag(mydistrict.Tag)
			currentDistricts2.Tag = mydistrict.Tag
			for i = 1, #myfaction do
				
				table.insert(currentDistricts2.factionLabels, 1, myfaction[i])
			end
			
			districtRecord = districtRecord:ParentDistrict()
		until districtRecord == nil
		
		currentDistricts2.districtCaption = table.concat(currentDistricts2.districtLabels, ' / ')
	end
end

function getOsTimeHHmm()
	
	local times = os.date('*t')
	
	return times
	
end

function getGameTimeHHmm()
	
	-- local enginetime = Game.GetTimeSystem()
	-- local times = enginetime:GetGameTimeStamp() 
	-- local temp = os.date('!*t', times)
	-- local t = os.time()
	-- local ut = os.date('!*t',t)
	-- local lt = os.date('*t',t)
	
	local gameTime = Game.GetTimeSystem():GetGameTime()
	
	
	local temp = {}
	temp.hour = GetSingleton('GameTime'):Hours(gameTime)
	temp.min = GetSingleton('GameTime'):Minutes(gameTime)
	temp.sec = GetSingleton('GameTime'):Seconds(gameTime)
	temp.day = GetSingleton('GameTime'):Days(gameTime)
	
	
	-- local thour = lt.hour - ut.hour
	-- -- tmin = lt.min - ut.min
	-- --debugPrint(2,"timezone"..thour)
	-- -- debugPrint(2,tmin)
	-- --debugPrint(2,"first date "..temp.hour.." "..temp.min)
	-- --temp.hour = temp.hour - thour
	
	
	local tempzero = ""
	-- -- if(temp.hour == 1)then
	-- -- temp.hour = 25
	-- -- end
	
	-- -- if(temp.hour == 2)then
	-- -- temp.hour = 0
	-- -- end
	
	-- -- if(temp.hour == 0)then
	-- -- temp.hour = 24
	-- -- end
	
	if(temp.min < 10)then
		tempzero = "0"
	end
	
	
	return temp.hour..tempzero..temp.min
	
end

function get_timezone()
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)))
end

-- Return a timezone string in ISO 8601:2000 standard form (+hhmm or -hhmm)
function get_tzoffset(timezone)
	local h, m = math.modf(timezone / 3600)
	return string.format("%+.4d", 100 * h + 60 * m)
end

function addGameTime(temp, value)
	
	local nexttemp = temp.hour + value
	if(nexttemp > 24) then
		nexttemp = nexttemp -24
	end
	
	Game.GetTimeSystem():SetGameTimeByHMS(nexttemp, 00,00)
	debugPrint(2,nexttemp)
	return getGameTime()
	
end

function setGameTime(hour,minutes)
	
	local nexttemp = {}
	
	nexttemp.hour = hour
	nexttemp.min = minutes
	nexttemp.sec = 0
	
	if(nexttemp.hour == 1)then
		nexttemp.hour = 25
	end
	
	if(nexttemp.hour == 2)then
		nexttemp.hour = 0
	end
	
	if(nexttemp.hour == 0)then
		nexttemp.hour = 24
	end
	
	nexttemp.hour = nexttemp.hour-2
	
	Game.GetTimeSystem():SetGameTimeByHMS(nexttemp.hour, nexttemp.min,nexttemp.sec)
	
	return getGameTime()
	
end

function getTest()
end

function getCurrentDistrict(psi,arrayDistricts)
	
	
	local pti = {}
	
	
	
	pti.x = psi.x
	pti.y = psi.y
	
	
	local unknow = {}
	unknow.Name = "Unknown"
	unknow.Tag = "district_unknown"
	unknow.Polygon = {}
	unknow.POI = {}
	
	nameD=unknow
	--debugPrint(2,arrayDistricts[1].Name)
	
	for i = 1, #arrayDistricts do
		
		if(insidePolygon(arrayDistricts[i].Polygon,pti))then
			
			nameD = arrayDistricts[i]
			
			
			
		end
		
	end
	return nameD
	
end

function searchAround()
	
	local player = Game.GetPlayer()
	local targetingSystem = Game.GetTargetingSystem()
	local parts = {}
	
	local searchQuery = Game["TSQL_ALL;"]
	searchQuery.maxDistance = Game["SNameplateRangesData::GetDisplayRange;"]
	searchQuery.searchFilter = Game["TSF_Quickhackable;"]
	success, parts = targetingSystem:GetTargetParts(player, searchQuery, parts)
	
	for _,v in ipairs(parts) do
		local obj = v:GetComponent(v):GetEntity()
		local targetPS = obj:GetDevicePS()
		if targetPS ~= nil then
			
			if targetPS.currentTimeToDepart  ~= nil then
				
				debugPrint(2,targetPS.currentTimeToDepart)
				
				
			end
			
			
		end
	end
	
end

function insidePolygon(polygon, point)
	local tx = point.x
	local ty = point.y
	local pgon = polygon
	local i, yflag0, yflag1, inside_flag
	local vtx0, vtx1
	
	local numverts = #pgon
	vtx0 = pgon[numverts]
	vtx1 = pgon[1]
	
	-- get test bit for above/below X axis
	yflag0 = ( vtx0.y >= ty )
	inside_flag = false
	
	for i=2,numverts+1 do
		yflag1 = ( vtx1.y >= ty )
		
		
		if ( yflag0 ~= yflag1 ) then
			
			if ( ((vtx1.y - ty) * (vtx0.x - vtx1.x) >= (vtx1.x - tx) * (vtx0.y - vtx1.y)) == yflag1 ) then
				inside_flag = not inside_flag
				
			end
		end
		
		-- Move to the next pair of vertices, retaining info as possible.
		yflag0  = yflag1
		vtx0    = vtx1
		vtx1    = pgon[i]
	end
	
	return  inside_flag
end

function checkWithFixer(curPos)
	
	for k,v in pairs(arrayFixer) do
		--debugPrint(2,arrayFixer[i].Name)
		if(arrayFixer[k].fixer.Name ~= "Delamain")then
			if(checkPosFixer(curPos,arrayFixer[k].fixer.LOC_X,arrayFixer[k].fixer.LOC_Y,arrayFixer[k].fixer.range))then
				Game.ChangeZoneIndicatorSafe()
				return arrayFixer[k].fixer
				
			end
			
			else
			inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
			if (inVehicule) then
				vehicule = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
				
				if(vehicule ~=nil) then
					isDelamainDrived = (string.find(vehicule:GetDisplayName(), "Delamain") ~= nil)
					if isDelamainDrived then
						
						return arrayFixer[k].fixer
						
					end
				end
			end
			
		end
	end
	
	
	
	
end

function checkNearFastTravel(curPos)
	
	for i=1, #arrayFastTravel do
		local FT = arrayFastTravel[i]
		debugPrint(2,curPos.x)
		debugPrint(2,curPos.y)
		if(checkPos(curPos, FT.x, FT.y,10)) then 
			
			return true
			
		end
		
		
	end
	
	return false
	
	
	
end

function IsInDelamainCar()

inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
if (inVehicule) then
vehicule = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())

isDelamainDrived = (string.find(vehicule:GetDisplayName(), "Delamain") ~= nil)

if isDelamainDrived then

return true

end
end
return false
end

function GetVehicleName(t)
return tostring(t:GetDisplayName())
end

function drawMappin(posx,posy)
debugPrint(2,posx)
debugPrint(2,posy)
local posX = posx
local posY = posy

if(mappinPoint ~= nil) then
debugPrint(2,"Unregister mappinPoint")
Game.GetMappinSystem():UnregisterMappin(mappinPoint)

end


mappinData = NewObject('gamemappinsMappinData')
mappinData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
mappinData.variant = Enum.new('gamedataMappinVariant', 'ExclamationMarkVariant')
mappinData.visibleThroughWalls = true
debugPrint(2,"Point draw at x:"..tostring(posX).." y:"..tostring(posY))

offset = ToVector4{ x = posX, y = posY, z = 200 , w = 1} -- Move the pin a bit up relative to the target


mappinPoint = Game.GetMappinSystem():RegisterMappin(mappinData, offset)

Game.GetMappinSystem():SetMappinActive(mappinPoint,true)

updatePlayerData(currentSave.arrayPlayerData)

end

function draw3DMappin(posx,posy,posz)
debugPrint(2,posx)
debugPrint(2,posy)
local posX = posx
local posY = posy
local posZ = posz

if(mappinPoint ~= nil) then
debugPrint(2,"Unregister mappinPoint")
Game.GetMappinSystem():UnregisterMappin(mappinPoint)

end


mappinData = NewObject('gamemappinsMappinData')
mappinData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
mappinData.variant = Enum.new('gamedataMappinVariant', 'ExclamationMarkVariant')
mappinData.visibleThroughWalls = true
debugPrint(2,"Point draw at x:"..tostring(posX).." y:"..tostring(posY).." Z:"..tostring(posZ))

offset = ToVector4{ x = posX, y = posY, z = posZ , w = 1} -- Move the pin a bit up relative to the target


mappinPoint = Game.GetMappinSystem():RegisterMappin(mappinData, offset)

Game.GetMappinSystem():SetMappinActive(mappinPoint,true)

updatePlayerData(currentSave.arrayPlayerData)

end

function drawCustomMappin(posx,posy)
debugPrint(2,posx)
debugPrint(2,posy)
local posX = posx
local posY = posy

if(customMappinPoint ~= nil) then
debugPrint(2,"Unregister customMappinPoint")
Game.GetMappinSystem():UnregisterMappin(customMappinPoint)

updatePlayerData(currentSave.arrayPlayerData)

end


mappinCustomData = NewObject('gamemappinsMappinData')
mappinCustomData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
mappinCustomData.variant = Enum.new('gamedataMappinVariant', 'CustomPositionVariant')
mappinCustomData.visibleThroughWalls = true
debugPrint(2,"Point draw at x:"..tostring(posX).." y:"..tostring(posY))

offset = ToVector4{ x = posX, y = posY, z = 35 , w = 1} -- Move the pin a bit up relative to the target


customMappinPoint = Game.GetMappinSystem():RegisterMappin(mappinCustomData, offset)

Game.GetMappinSystem():SetMappinActive(customMappinPoint,true)

updatePlayerData(currentSave.arrayPlayerData)

end

function draw3DCustomMappin(posx,posy,posz)
debugPrint(2,posx)
debugPrint(2,posy)
local posX = posx
local posY = posy
local posZ = posz

if(customMappinPoint ~= nil) then
debugPrint(2,"Unregister customMappinPoint")
Game.GetMappinSystem():UnregisterMappin(customMappinPoint)

updatePlayerData(currentSave.arrayPlayerData)

end


mappinCustomData = NewObject('gamemappinsMappinData')
mappinCustomData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
mappinCustomData.variant = Enum.new('gamedataMappinVariant', 'CustomPositionVariant')
mappinCustomData.visibleThroughWalls = true
debugPrint(2,"Point draw at x:"..tostring(posX).." Y:"..tostring(posY).." Z:"..tostring(posZ))

offset = ToVector4{ x = posX, y = posY, z = posZ , w = 1} -- Move the pin a bit up relative to the target


customMappinPoint = Game.GetMappinSystem():RegisterMappin(mappinCustomData, offset)

Game.GetMappinSystem():SetMappinActive(customMappinPoint,true)

updatePlayerData(currentSave.arrayPlayerData)

end

function registerMappin(posx,posy,posz,tag,typemap,wall,active,mapgroup,extra,title,desc)

local mappinData = NewObject('gamemappinsMappinData')
mappinData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
mappinData.variant = Enum.new('gamedataMappinVariant', typemap)

mappinData.visibleThroughWalls = wall or true

local posZ = posz or 200
-- print(posx)
-- print(posy)
-- print(posZ)
local position  = ToVector4{ x = posx, y = posy, z = posZ , w = 1}

local mapId = Game.GetMappinSystem():RegisterMappin(mappinData, position)


local activeMap = active or true

if title == nil then title = "Something happens here" end
if desc == nil then desc = "Something happens here" end 


Game.GetMappinSystem():SetMappinActive(mapId,activeMap)

local obj = {}
obj.id = mapId
obj.tag = tag
obj.position = position
obj.variant =  Enum.new('gamedataMappinVariant', typemap)
obj.title = getLang(title)
obj.desc = getLang(desc)

if(mapgroup) then
obj.group = mapgroup
end
if(extra) then
obj.extra = extra
end

mappinManager[tag] = obj



print("set mappin"..tag)

end

function registerMappintoEntity(target,tag,typemap,wall,active,mapgroup, title, desc)









if target then
local mappinData = NewObject('gamemappinsMappinData')
mappinData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
mappinData.variant = typemap
mappinData.visibleThroughWalls = wall or true

local slot = 'poi_mappin'
local offset = ToVector3{ x = 0, y = 0, z = 2 } -- Move the pin a bit up relative to the target
if title == nil then title = "Something happens here" end
if desc == nil then desc = "Something happens here" end
local mapId =Game.GetMappinSystem():RegisterMappinWithObject(mappinData, target, slot, offset)
local activeMap = active or true

Game.GetMappinSystem():SetMappinActive(mapId,activeMap)
local obj = {}
obj.id = mapId
obj.tag = tag
obj.position = target:GetWorldPosition()
obj.title = title
obj.desc = desc

if(mapgroup) then
obj.group = mapgroup
end

mappinManager[tag] = obj

end



end

function deleteMappinByTag(tag)
local mappin = getMappinByTag(tag)

if(mappin ~= nil and mappin.id ~= nil)then
Game.GetMappinSystem():UnregisterMappin(mappin.id)
mappinManager[tag] = nil
end
end	

function activeMappinByTag(tag,active)
local mappin = getMappinByTag(tag)
if(mappin)then
Game.GetMappinSystem():UnregisterMappin(mappin.id)
end
end	

function printGameDump(value)
debugPrint(2,GameDump(value))
end

function setMappinPositionByTag(tag,posx,posy,posZ)
local mappin = getMappinByTag(tag)
if(mappin)then
local position  = ToVector4{ x = posx, y = posy, z = posZ , w = 1}
Game.GetMappinSystem():SetMappinPosition(mappin.id,position)
mappin.position = position
end
end	

function setMappinTypeByTag(tag,typeMap)
local mappin = getMappinByTag(tag)
if(mappin)then

Game.GetMappinSystem():ChangeMappinVariant(mappin.id,typeMap)
end
end	

function setMappinTrackingByTag(tag,target)
local mappin = getMappinByTag(tag)

local target = getMappinByTag(target)
if(mappin and target)then

Game.GetMappinSystem():SetMappinTrackingAlternative(mappin.id,target.id)
end
end	

function testCollision(pos,destination)

local filters = {

'Static', -- Buildings, Concrete Roads, Crates, etc.

'Terrain'

}

local from = pos
local to = destination

local collision = false


for _, filter in ipairs(filters) do
local success, result = Game.GetSpatialQueriesSystem():SyncRaycastByCollisionGroup(from, to, filter, false, false)

if success then
collision = true
--debugPrint(2,"collision"..filter)
end
end


return collision

end

function giveGoodPath(pos,destination,axis)

local filters = {

'Static', -- Buildings, Concrete Roads, Crates, etc.

'Terrain'

}

local from = pos
local to = destination

local collision = false


for _, filter in ipairs(filters) do
local success, result = Game.GetSpatialQueriesSystem():SyncRaycastByCollisionGroup(from, to, filter, false, false)

if success then
collision = true
--debugPrint(2,"collision"..filter)
end
end

if(collision == false) then


return to

else	

local haveangood = false

local positive = false
local negative = false

local testpos = destination

--test positive
for i=1,500 do

if haveangood == false then

local testpos = destination

if(axis == "x") then
testpos.y = testpos.y+0.5
local result = testCollision(from,testpos)
if result == false then

haveangood = true
return testpos
end

end

if(axis == "y") then
testpos.x = testpos.x+0.5
local result = testCollision(from,testpos)
if result == false then
haveangood = true
return testpos
end
end

if(axis == "z") then
testpos.z = testpos.z+0.5

testpos.x = testpos.x+0.5
local result = testCollision(from,testpos)
if result == false then
haveangood = true
return testpos
else
testpos.x = testpos.x-0.5
testpos.y = testpos.y+0.5
local result = testCollision(from,testpos)
if result == false then
haveangood = true
return testpos
else
testpos.y = testpos.y-0.5
end
end

end

end

end

testpos = destination

--test negative
for i=1,500 do

if haveangood == false then



if(axis == "x") then

testpos.y = testpos.y-0.5
local result = testCollision(from,testpos)
if result == false then
return testpos
end



end

if(axis == "y") then
testpos.x = testpos.x-0.5
local result = testCollision(from,testpos)
if result == false then
return testpos
end


end

if(axis == "z") then
testpos.z = testpos.z-0.5

testpos.x = testpos.x-0.5
local result = testCollision(from,testpos)
if result == false then
haveangood = true
return testpos
else
testpos.x = testpos.x+0.5
testpos.y = testpos.y-0.5
local result = testCollision(from,testpos)
if result == false then
haveangood = true
return testpos
else
testpos.y = testpos.y+0.5
end
end

end



end
end


return from

end

end

function getValue(object,value,parameter,index)

local result = nil

if(object == "fixer") then

if(index == nil or index == 0 or index == "") then

result = getFixerByTag(value)[parameter]

else

result = getFixerByTag(value)[parameter][index]

end


end

if(object == "faction") then

if(index == nil or index == 0 or index == "") then

result = getFactionByTag(value)[parameter]

else

result = getFactionByTag(value)[parameter][index]

end


end


if(object == "variable") then



result = getVariableKey(value,parameter)



end


if(object == "score") then



result = getScoreKey(value,"Score")



end


return result

end



function checkItem(item)

local itemTDBID = TweakDBID(item)
local itemFound = false

local success, items = Game.GetTransactionSystem():GetItemList(Game.GetPlayer())

for _, itemData in ipairs(items) do
--------debugPrint(2,tostring(itemData:GetID().id))
if tostring(itemData:GetID().id) == tostring(itemTDBID) then
itemFound = true
break
end
end


return itemFound



end

function checkItemAmount(item,amount)
local count = 0
local itemTDBID = TweakDBID.new(item)
local itemFound = false

local success, items = Game.GetTransactionSystem():GetItemList(Game.GetPlayer())

for _, itemData in ipairs(items) do
--------debugPrint(2,tostring(itemData:GetID().id))
if tostring(itemData:GetID().id) == tostring(itemTDBID) then
count = count +1
end
end

if(count >= amount)then
itemFound = true

else

itemFound = checkStackableItemAmount(item,amount)

end



return itemFound



end

function checkStackableItemAmount(item,amount)


local itemFound = false

local count = 0
count = getStackableItemAmount(item)


if(count >= amount)then
itemFound = true

else

itemFound = false

end

return itemFound


end

function getItemAmount(item)
local count = 0

local itemTDBID = TweakDBID(item)

local success, items = Game.GetTransactionSystem():GetItemList(Game.GetPlayer())

for _, itemData in ipairs(items) do
--------debugPrint(2,tostring(itemData:GetID().id))
if tostring(itemData:GetID().id) == tostring(itemTDBID) then
count = count +1

end
end

if(count > 0)then


count = getStackableItemAmount(item)

end

if(count == nil) then 
count = 0
end


return count



end

function getStackableItemAmount(item)

local itemTDBID = TweakDBID(item)


local amount = Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), ItemID.new(itemTDBID))

if(amount == nil) then 
amount = 0
end

return amount



end

function table.empty (self)
for _, _ in pairs(self) do
return false
end
return true
end

function sleep (a) 
local sec = tonumber(os.clock() + a); 
while (os.clock() < sec) do 
end 
end

function setNewFixersPoint() 



for k,v in pairs(arrayFixer) do

if(mappinManager[arrayFixer[k].fixer.Tag] == nil) then

registerMappin(arrayFixer[k].fixer.LOC_X,arrayFixer[k].fixer.LOC_Y,arrayFixer[k].fixer.LOC_Z,arrayFixer[k].fixer.Tag,'FixerVariant',true,false,"Fixer",nil,arrayFixer[k].fixer.Name,arrayFixer[k].fixer.Name)

end


end

end

function ShowMessage(text)
if messageController and not isVehicle() then
local message = NewObject('gameSimpleScreenMessage')
message.isShown = true
message.duration = 5.0
message.message = text

messageController.screenMessage = message
messageController:UpdateWidgets()
end
end

function ShowWarning(text, duration)
Game['PreventionSystem::ShowMessage;GameInstanceStringFloat'](text, duration or 5.0)
end

function has_value (tab, val)
for index, value in ipairs(tab) do
if value == val then
return true
end
end

return false
end

function entEntityIDDraw(entEntityID)
ImGui.Indent()

-- Properties
ImGui.Text("hash: " .. tostring(entEntityID.hash))

ImGui.Unindent()
end

function deepcopy(orig, copies)
copies = copies or {}
local orig_type = type(orig)
local copy
if orig_type == 'table' then
if copies[orig] then
copy = copies[orig]
else
copy = {}
copies[orig] = copy
for orig_key, orig_value in next, orig, nil do
copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
end
setmetatable(copy, deepcopy(getmetatable(orig), copies))
end
else -- number, string, boolean, etc
copy = orig
end
return copy
end	





function tableHasKey(table)

for key,value in pairs(table) do
if(value ~= nil)then
return true   
end
end

return false

end

function round(x)
return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function table.print(table)
for key, value in pairs(table) do
printf('(%s)=(%s)\n', tostring(key), tostring(value))
end
end




function diffVector(from, to)
-- print(dump(from))
-- print(dump(to))

return Vector4.new(to.x - from.x, to.y- from.y, to.z - from.z, to.w - from.w)
end

function reverseTable(mytable)
newtable = {}

for i=1, #mytable do

table.insert(newtable,mytable[#mytable + 1 - i])


end

return newtable
end

function getMainStash()


local stashId = NewObject('entEntityID')
stashId.hash = 16570246047455160070ULL

return Game.FindEntityByID(stashId)

end

function tostringorempty(value)
if value == nil then value = "" end

return tostring(value)
end


function getTransgressionFromTweakId(trans)

for i,value in ipairs(transgressionsTweakList) do

if(trans == TweakDBID.new("Transgression."..value)) then

return value

end


end

return nil

end

function getAffiliationsFromTweakId(aff)

for i,value in ipairs(affiliationTweakList ) do

if(aff == TweakDBID.new("Factions."..value)) then

return value

end


end

return nil

end




function getRandomPairfromTable(myTable)


local keyset = {}
for k in pairs(myTable) do
table.insert(keyset, k)
end
-- now you can reliably return a random key
random_elem = {}
random_elem.key = keyset[math.random(#keyset)]
random_elem.value = myTable[random_elem.key]
return random_elem
end



function table.contains(table,value)

for i, element in ipairs(table) do
if(value == element) then
return true
end
end
return false
end

function table.compare(tablepoi, tablepoi2) 

for i,v in ipairs(tablepoi) do

if table.contains(tablepoi2,v) then

return true

end

end
return false
end

function SearchinTable(tables, prop, value,subitem) 

local obj = nil 

if(subitem == nil) then

for k,v in pairs(tables) do

if(v[prop] == value) then

obj = v
break

end

end

else


for k,v in pairs(tables) do

if(v[subitem][prop] == value) then

obj = v[subitem]
break

end

end


end



return obj
end

function isArray(t)
if('table' == type(t) and t[1] ~= nil) then
return true
else
return false
end
end


function TweakDbtoKey(data)
if type(data) == 'number' then
return data
end

if type(data) == 'string' then
data = TweakDbtoTweakId(data)
end

if type(data) == 'userdata' then
data = TweakDbextract(data)
end

if type(data) == 'table' then
return data.length * 0x100000000 + data.hash
--return (data.length << 32 | data.hash)
end

return 0
end

function TweakDbisRealKey(key)
return key <= 0xFFFFFFFFFF
end

function TweakDbtoStruct(data)
if type(data) == 'table' then
return data
end

if type(data) == 'number' then
-- { hash = data & 0xFFFFFFFF, length = data >> 32 }
local length = math.floor(data / 0x100000000)
local hash = data - (length * 0x100000000)
return { hash = hash, length = length }
end

if type(data) == 'string' then
data = TweakDbtoTweakId(data)
end

if type(data) == 'userdata' then
return TweakDbextract(data)
end

return nil
end

function TweakDbtoType(tweakId, prefix)
if type(tweakId) == 'string' then
return str.with(tweakId, prefix)
end

return ''
end

function TweakDbtoAlias(tweakId--[[, prefix]])
return tweakId

--if type(tweakId) == 'string' then
--	return str.without(tweakId, prefix)
--end
--
--return ''
end

function TweakDbtoTweakId(tweakId, prefix)
if type(tweakId) == 'number' then
tweakId = TweakDbtoStruct(tweakId)
end

if type(tweakId) == 'table' then
return TweakDBID.new(tweakId.hash, tweakId.length)
end

if type(tweakId) == 'string' then
local hashHex, lenHex = tweakId:match('^<TDBID:([0-9A-Z]+):([0-9A-Z]+)>$')
if hashHex and lenHex then
return TweakDBID.new(tonumber(hashHex, 16), tonumber(lenHex, 16))
elseif tweakId:find('%.') then
return TweakDBID.new(tweakId)
else
return TweakDBID.new(str.with(tweakId, prefix))
end
end

if type(tweakId) == 'userdata' then
return tweakId
end
end

function TweakDbtoItemId(tweakId, seed)
if type(tweakId) == 'string' then
tweakId = TweakDbtoItemTweakId(tweakId)
end

if seed then
return ItemID.new(tweakId, seed)
elseif seed == false then
return ItemID.new(tweakId)
else
return GetSingleton('gameItemID'):FromTDBID(tweakId)
end
end

function TweakDbtoItemTweakId(tweakId)
return TweakDbtoTweakId(tweakId, 'Items.')
end

function TweakDbtoItemType(alias)
return TweakDbtoType(alias, 'Items.')
end

function TweakDbtoItemAlias(type)
return TweakDbtoAlias(type, 'Items.')
end

function TweakDbtoVehicleTweakId(tweakId)
return TweakDbtoTweakId(tweakId, 'Vehicle.')
end

function TweakDbtoVehicleType(alias)
return TweakDbtoType(alias, 'Vehicle.')
end

function TweakDbtoVehicleAlias(type)
return TweakDbtoAlias(type, 'Vehicle.')
end



function TweakDbtoSlotType(alias)
return TweakDbtoType(alias, 'AttachmentSlots.')
end

function TweakDblocalize(tweakId)
tweakId = TweakDbtoTweakId(tweakId)

return {
name = Game.GetLocalizedTextByKey(Game['TDB::GetLocKey;TweakDBID'](TweakDBID.new(tweakId, '.displayName'))),
comment = Game.GetLocalizedTextByKey(Game['TDB::GetLocKey;TweakDBID'](TweakDBID.new(tweakId, '.localizedDescription'))),
}
end

function TweakDbextract(data)
if data.hash then
return { hash = data.hash, length = data.length }
end

if data.id then
return { id = { data.id.hash, length = data.id.length }, rng_seed = data.rng_seed }
end

return data
end