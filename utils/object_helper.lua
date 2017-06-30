--object_helper.lua
--v1.7.3
--Author: Connor Wojtak
--Purpose: A utility to load and create objects, their attributes, and their sprites. This file also contains functions for reading attributes from Objects and EntityObjects.

--Imports
local JSON_READER = require("utils/json/json")
local UTILS = require("utils/utils")
local EFFECT_HELPER = require("utils/effect_helper")


--Classes
Object = {name=nil, image=nil, size=nil, effect=nil, flags=nil, id=nil, min_effect=nil, max_effect=nil}
EntityObject = {object=nil, speed=nil, direction=nil, posx=nil, posy=nil, flags=nil}

--Global Variables
GLOBAL_OBJECT_LIST = {}
GLOBAL_ENTITYOBJECT_LIST = {}
GLOBAL_ENTITYOBJECT_INDEX = 0

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
	return decoded_data["name"], love.graphics.newImage("sprites/" .. decoded_data["image"] .. ".jpg"), decoded_data["size"], decoded_data["effect"], decoded_data["flags"], decoded_data["min_effect"], decoded_data["max_effect"]
end

--OBJECT CLASS
--Called on startup. Returns: Nothing
function Object.start()
	local objects = find_objects()
	if objects == nil or objects == {} then return end
	for i, obj in ipairs(objects) do
		local name, image, size, effect, flags, min_effect, max_effect = create_object_para(obj)
		local object = Object:new(name, image, size, effect, flags, min_effect, max_effect)
		table.insert(GLOBAL_OBJECT_LIST, object)
	end
end

--Creates a new Object, which will be stored in a global list. Returns: Object
function Object:new(inname, inimage, insize, ineffect, inflags, minffect, maxffect)
	local inobj = Object.getObjectByName(inname)
	local inid = getTableLength(GLOBAL_OBJECT_LIST)
	local obj = {name = inname, image = inimage, size=insize, id = inid, effect = ineffect, flags = inflags, mineffect = minffect, maxeffect = maxffect}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

--Finds an Object in the global list using a given name. Returns: Object or Nil
function Object.getObjectByName(objectname)
	for i, obj in ipairs(GLOBAL_OBJECT_LIST) do
		if obj:getName() == objectname then
			return obj
		end
	end
	return nil
end

--Finds an Object in the global list using a given ID. Returns: Object or Nil
function Object.getObjectByID(objectID)
	for i, obj in ipairs(GLOBAL_OBJECT_LIST) do
		if obj:getID() == objectID then
			return obj
		end
	end
	return nil
end

--OBJECT ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of an Object. Returns: Attribute or Nil
function Object:getName()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["name"]
end
	
function Object:getImage()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["image"]
end	
	
function Object:getSize()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["size"]
end

function Object:getEffect()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["effect"]
end

function Object:getMinEffect()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["mineffect"]
end

function Object:getMaxEffect()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["maxeffect"]
end

function Object:getFlags()
	if not self == GLOBAL_OBJECT_LIST[self:getID()] then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["flags"]
end

function Object:getID()
	return self["id"]
end

function Object:setName(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["name"] = attr
	self["name"] = attr
end
	
function Object:setImage(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["image"] = attr
	self["image"] = attr
end	
	
function Object:setSize(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["size"] = attr
	self["size"] = attr
end

function Object:setEffect(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["effect"] = attr
	self["effect"] = attr
end

function Object:setMinEffect(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["mineffect"] = attr
	self["mineffect"] = attr
end

function Object:setMaxEffect(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["maxeffect"] = attr
	self["maxeffect"] = attr
end

function Object:setFlags(attr)
	local obj = GLOBAL_OBJECT_LIST[self:getID()]
	if obj == nil then return end
	obj["flags"] = attr
	self["flags"] = attr
end

--ENTITYOBJECT CLASS
--Creates a new EntityObject, an object that can move across the screen. Returns: EntityObject
function EntityObject:new(obj, begposx, begposy, begspeed, begdir)
	local obj_effect = obj:getEffect()
	local obj_flags = obj:getFlags()
	local ID = getTableLength(GLOBAL_ENTITYOBJECT_LIST)
	
	local eobj = {object = obj, speed = begspeed, direction = begdir, posx = begposx, posy = begposy, id = ID}
	
	setmetatable(eobj, self)
    self.__index = self
	
	table.insert(GLOBAL_ENTITYOBJECT_LIST, eobj)
	
	if obj_effect == nil or obj_effect == "" then return eobj end
	
	EntityEffect:new(Effect.getEffectByName(obj_effect), begposx, begposy, 1, obj:getMinEffect(), obj:getMaxEffect(), eobj)
	
	return eobj
end

--Called by love.draw() to update the EntityObjects. Returns: Nothing
function EntityObject.updateObjects()
	for i, entObj in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		local innerobj = entObj:getObject()
		local size = innerobj:getSize()
	
		if entObj:getPosX() - size*4 >= WINDOW_WIDTH or entObj:getPosY() - size*4 >= WINDOW_HEIGHT or entObj:getPosX() + size*4 <= 0 or entObj:getPosY() + size*4 <= 0 then --Keeps EntityObjects from eating delicious memory.
			if innerobj:getFlags() == nil then 
				table.remove(GLOBAL_ENTITYOBJECT_LIST, i)
				return
			end
		end
		
		local newposx = nil
		local newposy = nil
		
		if entObj:getSpeed() ~= 0 then
			if entObj:getDirection() == "left" then
				entObj:setPosX(entObj:getPosX() - entObj:getSpeed())
			end
			if entObj:getDirection() == "right" then
				entObj:setPosX(entObj:getPosX() + entObj:getSpeed())
			end
			if entObj:getDirection() == "up" then
				entObj:setPosY(entObj:getPosY() - entObj:getSpeed())
			end
			if entObj:getDirection() == "down" then
				entObj:setPosY(entObj:getPosY() + entObj:getSpeed())
			end
		end
		
		if GLOBAL_ENTITYOBJECT_INDEX >= 100000 then
			GLOBAL_ENTITYOBJECT_INDEX = 0
		end
		GLOBAL_ENTITYOBJECT_INDEX = GLOBAL_ENTITYOBJECT_INDEX + 1
		
		love.graphics.draw(innerobj:getImage(), entObj:getPosX(), entObj:getPosY(), 0, 1, 1, 0, 0, 0, 0)
	end
end

--Finds an EntityObject using a given ID. Returns: Integer or Nil
function EntityObject.getEntityObjectByID(id)
	for i, ent in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		if ent:getID() == id then
			return ent
		end
	end
	return nil
end

--Finds the EntityObject in the EntityObject list using an EntityObject. Returns EntityObject or Nil
function EntityObject.getEntityObjectByEntityObject(class)
	for i, ent in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		if ent == class then
			return ent
		end
	end
	return nil
end


--ENTITYOBJECT ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of an object. Returns: Attribute or Nil
function EntityObject:getObject()
	if not self == GLOBAL_ENTITYOBJECT_LIST[self:getID()] then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["object"]
end
	
function EntityObject:getPosX()
	if not self == GLOBAL_ENTITYOBJECT_LIST[self:getID()] then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["posx"]
end	
	
function EntityObject:getPosY()
	if not self == GLOBAL_ENTITYOBJECT_LIST[self:getID()] then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["posy"]
end

function EntityObject:getSpeed()
	if not self == GLOBAL_ENTITYOBJECT_LIST[self:getID()] then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["speed"]
end

function EntityObject:getDirection()
	if not self == GLOBAL_ENTITYOBJECT_LIST[self:getID()] then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["direction"]
end

function EntityObject:getID()
	return self["id"]
end

function EntityObject:setObject(attr)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	obj["object"] = attr
	self["object"] = attr
end
	
function EntityObject:setPosX(attr)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	obj["posx"] = attr
	self["posx"] = attr
end	
	
function EntityObject:setPosY(attr)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	obj["posy"] = attr
	self["posy"] = attr
end

function EntityObject:setSpeed(attr)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	obj["speed"] = attr
	self["speed"] = attr
end

function EntityObject:setDirection(attr)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	obj["direction"] = attr
	self["direction"] = attr
end