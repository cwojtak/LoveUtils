--object_helper.lua
--v1.1.7
--Author: Connor Wojtak
--Purpose: A utility to load objects, their attributes, and their sprites, and turn them into lists
--containing those attributes. This file also contains functions for reading the Object lists.

--Imports
JSON_READER = require("utils/json/json")
UTILS = require("utils/utils")
EFFECT_HELPER = require("utils/effect_helper")


--Classes
Object = {}
EntityObject = {}

--Global Variables
GLOBAL_ENTITYOBJECT_LIST = {}
GLOBAL_ENTITYOBJECT_INDEX = 0
GLOBAL_OBJECT_LIST = {}
GLOBAL_POSITION_LIST = {}
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions(1)

--Finds and reads all of the JSON files under the "objects/" folder. Returns: List
function find_objects()
	local JSONDirectory = love.filesystem.getDirectoryItems("objects/")
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile("objects/" .. dir) == true then
			if string.find(dir, ".json") then
			    local content = love.filesystem.read("objects/" .. dir)
				if not content then print("ERROR: No object files loaded. If you are using objects, this will cause problems.") return nil end
				table.insert(returnList, content)
			end
		end
	end
	return returnList
end

--Decodes JSON data returns the parameters. Returns: String, LOVE Image
function create_object_para(data) 
	local decoded_data = json.decode(data)
	
	return decoded_data["name"], love.graphics.newImage("sprites/" .. decoded_data["image"] .. ".jpg"), decoded_data["special"], decoded_data["flags"], decoded_data["min_effect"], decoded_data["max_effect"]
end

--OBJECT CLASS
--Called on startup. Returns: Nothing
function Object.start()
	local objects = find_objects()
	if objects == nil or objects == {} then return end
	for i, obj in ipairs(objects) do
		local name, image, special, flags, min_effect, max_effect = create_object_para(obj)
		local object = Object.new(name, image, special, flags, min_effect, max_effect)
		table.insert(GLOBAL_OBJECT_LIST, object)
	end
end

--Creates a new Object list, which will eventually be stored in a global list. Returns: List
function Object.new(inname, inimage, inspecial, inflags, minffect, maxffect)
	table.insert(Object, inname)
	local inid = Object.getIDByName(inname)
	return {name = inname, image = inimage, special = inspecial, flags = inflags, id = inid, special = inspecial, flags = inflags, mineffect = minffect, maxeffect = maxffect}
end

--Finds the ID of an object with the object's name based on where it is stored in the Object list. Returns: Integer or Nil
function Object.getIDByName(objectname)
	for i, obj in ipairs(Object) do
		if string.find(obj, objectname) then
			return i
		end
	end
	return nil
end

--Finds the name of an object with the object's ID based on where it is stored in the Object list. Returns: String or Nil
function Object.getNameByID(objectID)
	return Object[objectID]
end

--Finds an Object based on where it is stored in the GLOBAL_OBJECT_LIST. Returns: List or Nil
function Object.getClassByID(objectID)
	return GLOBAL_OBJECT_LIST[objectID]
end

--Finds a given attribute of an object and returns it. Returns: String, Integer, Image or Nil
function Object.getAttribute(attr, obj)
	if attr == "name" then
		return obj["name"]
	end
	if attr == "image" then
		return obj["image"]
	end
	if attr == "special" then
		return obj["special"]
	end
	if attr == "flags" then
		return obj["flags"]
	end
	if attr == "id" then
		return obj["id"]
	end
end

--ENTITYOBJECT CLASS
--Creates a new EntityObject list that is able to move from place to place. Returns: List, Integer
function EntityObject.new(obj, begposx, begposy, begspeed, begdir)
	local obj_special = Object.getAttribute("special", obj)
	local obj_flags = Object.getAttribute("flags", obj) 
	
	if obj_flags == "can_go_offscreen" then
		table.insert(EntityObject, obj)
		table.insert(GLOBAL_POSITION_LIST, {posx = begposx, posy = begposy})
		table.insert(GLOBAL_ENTITYOBJECT_LIST, {object = obj, begposx = begposx, begposy = begposy, speed = begspeed, 	direction = begdir, posx = begposx, posy = begposy, flags = "can_go_offscreen"})
	else
		table.insert(EntityObject, obj)
		table.insert(GLOBAL_POSITION_LIST, {posx = begposx, posy = begposy})
		table.insert(GLOBAL_ENTITYOBJECT_LIST, {object = obj, begposx = begposx, begposy = begposy, speed = begspeed, 	direction = begdir, posx = begposx, posy = begposy})
	end
	local ID = getTableLength(GLOBAL_ENTITYOBJECT_LIST)
	
	if obj_special == nil or obj_special == "" then return 
		{object = object, posx = begposx, posy = begposy, speed = begspeed, direction = begdir, posx = begposx, posy = begposy, flags = nil}, ID 
	end
	
	EntityEffect.new(GLOBAL_EFFECT_LIST[Effect.getIDByName(obj_special)], begposx, begposy, 1, obj["mineffect"], obj["maxeffect"], ID)
	
	return {object = object, posx = begposx, posy = begposy, speed = begspeed, direction = begdir, posx = begposx, posy = begposy, flags = nil}, ID
end

--Called by love.draw() to update where the EntityObjects are. Returns: Nothing
function EntityObject.updateObjects()
	for i, entObj in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		if entObj["posx"] - 64 >= WINDOW_WIDTH or entObj["posy"] - 64 >= WINDOW_HEIGHT or entObj["posx"] + 64 <= 0 or entObj["posy"] + 64 <= 0 then --Keeps EntityObjects from eating delicious memory.
			if entObj["flags"] == nil then 
				table.remove(GLOBAL_ENTITYOBJECT_LIST, EntityObject.getIDByClass(entObj))
				table.remove(GLOBAL_POSITION_LIST, EntityObject.getIDByClass(entObj))
			end
		end
		
		local newposx = nil
		local newposy = nil
		
		if entObj["speed"] ~= 0 then
			if entObj["direction"] == "left" then
				entObj["posx"] = entObj["posx"] - entObj["speed"]
				newposx = entObj["posx"]
			end
			if entObj["direction"] == "right" then
				entObj["posx"] = entObj["posx"] + entObj["speed"]
				newposx = entObj["posx"]
			end
			if entObj["direction"] == "up" then
				entObj["posy"] = entObj["posy"] - entObj["speed"]
				newposy = entObj["posy"]
			end
			if entObj["direction"] == "down" then
				entObj["posy"] = entObj["posy"] + entObj["speed"]
				newposy = entObj["posy"]
			end
		end
		
		local entID = EntityObject.getIDByClass(entObj)
		if entObj == nil or entID == nil then return end -- Used when the EntityObject is deleted.
		
		if GLOBAL_ENTITYOBJECT_INDEX >= 100000 then
			GLOBAL_POSITION_LIST[EntityObject.getIDByClass(entObj)] = {posx = newposx, posy = newposy}
			GLOBAL_ENTITYOBJECT_INDEX = 0
		end
		GLOBAL_ENTITYOBJECT_INDEX = GLOBAL_ENTITYOBJECT_INDEX + 1
		
		local object = entObj["object"]
		love.graphics.draw(object["image"], entObj["posx"], entObj["posy"], 0, 1, 1, 0, 0, 0, 0)
	end
end

--Changes the velocity of an object. Returns: Nothing
function EntityObject.changeVelocity(objID, speed, direction)
	local object = GLOBAL_ENTITYOBJECT_LIST[objID]
	if object == nil then return end --Used in cases when the EntityObject list is cleared and an object is changing direction.
	object["speed"] = speed
	object["direction"] = direction
end

--Finds the ID of an EntityObject by indexing the GLOBAL_ENTITYOBJECT_LIST with the given EntityObject. Returns: Integer or Nil
function EntityObject.getIDByClass(class)
	for i, ent in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		if ent == class then
			return i
		end
	end
	return nil
end

--Finds the name of an EntityObject with the object's ID based on where it is stored in the EntityObject list. Returns: String or Nil
function EntityObject.getEntityObjectByID(objectID)
	return EntityObject[objectID]
end

--DEPRECATED: USE ENTITYOBJECT PROPERTIES
--Finds a given attribute of an EntityObject and returns it. Returns: String, Integer, Object or Nil
--function EntityObject.getAttribute(attr, obj)
	--if attr == "object" then
		--return obj["obj"]
	--end
	--if attr == "posx" then
		--return obj["posx"]
	--end
	--if attr == "posy" then
		--print(obj["posy"])
		--return obj["posy"]
	--end
	--if attr == "speed" then
		--return obj["speed"]
	--end
	--if attr == "direction" then
		--return obj["direction"]
	--end
	--if attr == "begposx" then
		--return obj["begposx"]
	--end
	--if attr == "begposy" then
		--return obj["begposy"]
	--end
--end

--DEPRECATED, USE OBJECT IMAGE PROPERTY
--Finds all of the images under the "sprites/" folder. Returns: List
--function find_object_images()
	--local spritesDirectory = love.filesystem.getDirectoryItems("sprites/")
	--local returnList = {}
	--for i, dir in ipairs(spritesDirectory) do
		--if love.filesystem.isFile("sprites/" .. dir) == true then
			--if string.find(dir, ".jpg") then
			   --table.insert(returnList, dir)
			--end
		--end
	--end
	--return returnList
--end

--DEPRECATED, USE OBJECT IMAGE PROPERTY
--Takes the return parameter from find_object_images() and makes it into LOVE images. Returns: List
--function create_images(object_images)
	--local images = {}
	--for i, sprite in ipairs(object_images) do
		--table.insert(images, love.graphics.newImage("sprites/" .. sprite))
	--end
	--return images
--end