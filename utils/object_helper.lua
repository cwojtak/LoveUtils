--object_helper.lua
--Author: Connor Wojtak
--Purpose: A utility to load objects, their attributes, and their sprites, and turn them into lists
--containing those attributes. This file also contains functions for reading the Object lists.
--TODO: ADD SUPPORT FOR SPECIAL AND FLAGS, ADD DONT REMOVE FLAG TO ENTITYOBJECT, FIX POSX AND POSY ENTITYOBJECT ATTRIBUTES.

--Imports
JSON_READER = require("utils/json/json")
UTILS = require("utils/utils")

--Directory
WORKING_DIRECTORY = love.filesystem.getRealDirectory("objects/computer.json")
local open = io.open

--Classes
Object = {}
EntityObject = {}

--Global Variables
GLOBAL_ENTITYOBJECT_LIST = {}
GLOBAL_OBJECT_LIST = {}
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions(1)

--DEPRECATED, USE OBJECT IMAGE PROPERTY
--Finds all of the images under the "sprites/" folder. Returns: List
function find_object_images()
	local spritesDirectory = love.filesystem.getDirectoryItems("sprites/")
	local returnList = {}
	for i, dir in ipairs(spritesDirectory) do
		if love.filesystem.isFile("sprites/" .. dir) == true then
			if string.find(dir, ".jpg") then
			   table.insert(returnList, dir)
			end
		end
	end
	return returnList
end

--DEPRECATED, USE OBJECT IMAGE PROPERTY
--Takes the return parameter from find_object_images() and makes it into LOVE images. Returns: List
function create_images(object_images)
	local images = {}
	for i, sprite in ipairs(object_images) do
		table.insert(images, love.graphics.newImage("sprites/" .. sprite))
	end
	return images
end

--Finds and reads all of the JSON files under the "objects/" folder. Returns: List
function find_objects()
	local JSONDirectory = love.filesystem.getDirectoryItems("objects/")
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile("objects/" .. dir) == true then
			if string.find(dir, ".json") then
			    local file = open(WORKING_DIRECTORY .. "/objects/" .. dir, "rb")
				if not file then return nil end
				local content = file:read "*a"
				table.insert(returnList, content)
				file:close()
			end
		end
	end
	return returnList
end

--Decodes JSON data and makes the image parameter from JSON file into a LOVE image. Returns: String, LOVE Image
function create_object_para(data) 
	local decoded_data = json.decode(data)
	
	return decoded_data["name"], love.graphics.newImage("sprites/" .. decoded_data["image"] .. ".jpg"), decoded_data["special"], decoded_data["flags"] -- TODO: ADD SUPPORT FOR SPECIAL AND FLAGS
end

--OBJECT CLASS
--Creates a new Object list, which will eventually be stored in a global list. Returns: List
function Object.new(inname, inimage, inspecial, inflags)
	table.insert(Object, inname)
	local inid = Object.getIDByName(inname)
	return {name = inname, image = inimage, special=inspecial, flags=inflags, id = inid} -- TODO: CURRENTLY NO SUPPORT FOR SPECIAL OR FLAGS
end

--Finds the ID of an object with the object's name based on where it is stored in the Object list. Returns: Integer OR Nil
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
	table.insert(EntityObject, obj)
	table.insert(GLOBAL_ENTITYOBJECT_LIST, {object = obj, begposx = begposx, begposy = begposy, speed = begspeed, direction = begdir, posx = begposx, posy = begposy})
	local ID = getTableLength(GLOBAL_ENTITYOBJECT_LIST)
	return {object = obj, posx = begposx, posy = begposy, speed = begspeed, direction = begdir, posx = begposx, posy = begposy}, ID
end

--Called by love.draw() to update where the EntityObjects are. Returns: Nothing
function EntityObject.updateObjects()
	for i, entObj in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		if entObj["posx"] - 64 >= WINDOW_WIDTH or entObj["posy"] - 64 >= WINDOW_HEIGHT or entObj["posx"] + 64 <= 0 or entObj["posy"] + 64 <= 0 then --Keeps EntityObjects
			table.remove(GLOBAL_ENTITYOBJECT_LIST, EntityObject.getIDByClass(entObj))
		end
		
		if entObj["speed"] ~= 0 then
			if entObj["direction"] == "left" then
				entObj["posx"] = entObj["posx"] - entObj["speed"]
			end
			if entObj["direction"] == "right" then
				entObj["posx"] = entObj["posx"] + entObj["speed"]
			end
			if entObj["direction"] == "up" then
				entObj["posy"] = entObj["posy"] - entObj["speed"]
			end
			if entObj["direction"] == "down" then
				entObj["posy"] = entObj["posy"] + entObj["speed"]
			end
		end
		print(entObj["posx"])
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

--Finds a given attribute of an EntityObject and returns it. Returns: String, Integer, Object or Nil
function EntityObject.getAttribute(attr, obj)
	if attr == "obj" then
		return obj["obj"]
	end
	if attr == "posx" then
		return obj["posx"]
	end
	if attr == "posy" then
		return obj["posy"]
	end
	if attr == "speed" then
		return obj["speed"]
	end
	if attr == "direction" then
		return obj["direction"]
	end
	if attr == "begposx" then
		return obj["begposx"]
	end
	if attr == "begposy" then
		return obj["begposy"]
	end
end