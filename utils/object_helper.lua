--object_helper.lua
--v1.11.0
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

--Gets the length of the GLOBAL_OBJECT_LIST.
function getLengthOfObjectList()
	return Utils.getTableLength(GLOBAL_OBJECT_LIST)
end

--Gets the length of the GLOBAL_ENTITYOBJECT_LIST.
function getLengthOfEntityObjectList()
	return Utils.getTableLength(GLOBAL_ENTITYOBJECT_LIST)
end

--Finds and reads all of the JSON files under the specified path. Returns: List
function find_objects()
	local JSONDirectory = love.filesystem.getDirectoryItems(OBJECT_PATH)
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.getInfo(OBJECT_PATH .. dir) ~= nil then
			if string.find(dir, ".json") then
			    local content = love.filesystem.read(OBJECT_PATH .. dir)
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
	return decoded_data["name"], love.graphics.newImage(OBJECT_IMAGE_PATH .. decoded_data["image"] .. ".jpg"), decoded_data["size"], decoded_data["effect"], decoded_data["flags"], decoded_data["min_effect"], decoded_data["max_effect"]
end

--OBJECT CLASS
--Called by love.load() on startup. Uses a default or custom JSON loading method. Returns: Nothing
function Object.start(method, decoded_data)
	if method == true and decoded_data ~= nil then
		for i, obj in ipairs(decoded_data) do
			local object = Object:new(obj)
			table.insert(GLOBAL_OBJECT_LIST, object)
		end
	end

	if method == false or method == nil then
		local objects = find_objects()
		if objects == nil or objects == {} then return end
		for i, obj in ipairs(objects) do
			local inname, inimage, insize, ineffect, inflags, minffect, maxffect = create_object_para(obj)
			local inid = Utils.getTableLength(GLOBAL_OBJECT_LIST)
		
			local obja = {name = inname, image = inimage, size=insize, id = inid, effect = ineffect, flags = inflags, mineffect = minffect, maxeffect = maxffect}
			local object = Object:new(obja)
			table.insert(GLOBAL_OBJECT_LIST, object)
		end
	end
end

--Creates a new Object, which will be stored in a global list. Returns: Object
function Object:new(obj)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

--Deletes a loaded object. Returns: Nothing
function Object.destroy(obj)
	table.remove(GLOBAL_OBJECT_LIST, obj:getID())
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
--Gets or sets an attribute of an Object. Returns: Attribute or Nothing
function Object:getName()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["name"]
end
	
function Object:getImage()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["image"]
end	
	
function Object:getSize()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["size"]
end

function Object:getEffect()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["effect"]
end

function Object:getMinEffect()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["mineffect"]
end

function Object:getMaxEffect()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["maxeffect"]
end

function Object:getFlags()
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self["flags"]
end

function Object:getID()
	return self["id"]
end

function Object:getCustomAttribute(attr)
	if not self == Object.getObjectByID(self:getID()) then print("WARNING: An Object is not synced to the object list! This may cause problems!") end
	return self[attr]
end

function Object:setName(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["name"] = attr
	self["name"] = attr
end
	
function Object:setImage(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["image"] = attr
	self["image"] = attr
end	
	
function Object:setSize(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["size"] = attr
	self["size"] = attr
end

function Object:setEffect(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["effect"] = attr
	self["effect"] = attr
end

function Object:setMinEffect(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["mineffect"] = attr
	self["mineffect"] = attr
end

function Object:setMaxEffect(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["maxeffect"] = attr
	self["maxeffect"] = attr
end

function Object:setFlags(attr)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj["flags"] = attr
	self["flags"] = attr
end

function Object:setCustomAttribute(attr, val)
	local obj = Object.getObjectByID(self:getID())
	if obj == nil then return end
	obj[attr] = val
	self[attr] = val
end

--ENTITYOBJECT CLASS
--Creates a new EntityObject, an object that can move across the screen. Returns: EntityObject
function EntityObject:new(obj, begposx, begposy, begspeed, begdir, eventhandlersin)
	local obj_effect = obj:getEffect()
	local obj_flags = obj:getFlags()
	local ID = Utils.getTableLength(GLOBAL_ENTITYOBJECT_LIST)
	
	local eobj = {object = obj, speed = begspeed, direction = begdir, posx = begposx, posy = begposy, id = ID, eventhandler = eventhandlersin}
	
	setmetatable(eobj, self)
    self.__index = self
	table.insert(GLOBAL_ENTITYOBJECT_LIST, eobj)
	return eobj
end

--Destroys an EntityObject. Returns: Nothing
function EntityObject:destroy()
	for i, b in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		if b == self then
			table.remove(GLOBAL_ENTITYOBJECT_LIST, i)
		end
	end
end

--Creates a new custom EntityObject(allows for values to be accessed manually through EntityObject:GetCustomAttribute()), an object that can move across the screen. Returns: EntityObject
function EntityObject:newCustomEntityObject(eobj)
	setmetatable(eobj, self)
    self.__index = self
	table.insert(GLOBAL_ENTITYOBJECT_LIST, eobj)
	return eobj
end

--Creates a new EntityEffect. Returns: Nothing
function EntityObject:applyDefaultEntityEffect()
	local obj = self:getObject()
	EntityEffect:new(Effect.getEffectByName(obj:getEffect()), 1, obj:getMinEffect(), obj:getMaxEffect(), self)
end

--Creates a new EntityEffect. Returns: Nothing
function EntityObject:applyEntityEffect(name)
	local obj = self:getObject()
	obj:setEffect(name)
	EntityEffect:new(Effect.getEffectByName(name), 1, obj:getMinEffect(), obj:getMaxEffect(), self)
end

--Removes an EntityEffect. Returns: Nothing
function EntityObject:removeEntityEffect(name)
	EntityEffect.destroy(self)
end

--Called by love.draw() to update the EntityObjects. Returns: Nothing
function EntityObject.updateObjects()
	for i, entObj in ipairs(GLOBAL_ENTITYOBJECT_LIST) do
		local innerobj = entObj:getObject()
		local size = innerobj:getSize()
		if entObj:getPosY() - size >= WINDOW_HEIGHT or entObj:getPosX() - size >= WINDOW_WIDTH or entObj:getPosY() + size*2 <= 0 or entObj:getPosX() + size*2 <= 0 then --Keeps EntityObjects from eating delicious memory.
			if innerobj:getFlags() == "offscreen" then 
				--The object is good, nothing needs to happen.
			else
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
		
		local skip = false
		local i = 0
		for i, obj in ipairs(entObj:getAllObjectEventHandlers()) do
			if skip == false then
				obj(entObj, innerobj, GLOBAL_ENTITYOBJECT_LIST)
				skip = true
			else
				skip = false
			end
			i = i + 1
		end
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
--Gets or sets an attribute of an object. Returns: Attribute or Nothing
function EntityObject:getObject()
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["object"]
end
	
function EntityObject:getPosX()
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["posx"]
end	
	
function EntityObject:getPosY()
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["posy"]
end

function EntityObject:getSpeed()
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["speed"]
end

function EntityObject:getDirection()
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["direction"]
end

function EntityObject:getID()
	return self["id"]
end

function EntityObject:getCustomAttribute(attr)
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self[attr]
end

--Gets a event handler from the list of object event handlers. Returns: EventHandler or Nil
function EntityObject:getObjectEventHandler(id)
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	local skip = false
	local i = 0
	local list = self["eventhandler"]
	for i, obj in ipairs(list) do
		if skip == false then
			if obj == id then
				return list[i - 1]
			end
			skip = true
		end
		i = i + 1
		if skip == true then
			skip = false
		end
	end
end

--Gets a list of all event handlers. Returns List
function EntityObject:getAllObjectEventHandlers(id)
	if not self == EntityObject.getEntityObjectByID(self:getID()) then print("WARNING: An EntityObject is not synced to the object list! This may cause problems!") end
	return self["eventhandler"]
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

function EntityObject:setCustomAttribute(attr, val)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	obj[attr] = val
	self[attr] = val
end

--Links a new EventHandler to an EntityObject. The func argument takes a valid anonymous function that takes the arguments: EntityObject, Object, EntityObject List, and checks for the event conditions, and acts accordingly. This is called every loop, so be careful to not put resource intensive code in here.  Returns: Nothing
function EntityObject:registerObjectEventHandler(func)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	table.insert(obj["eventhandler"], func)
	table.insert(self["eventhandler"], func)
	return Utils.getTableLength(self["eventhandler"])
end

--Removes an EventHandler from the Object's EventHandler list. Returns: Nothing
function EntityObject:removeObjectEventHandler(id)
	local obj = EntityObject.getEntityObjectByEntityObject(self)
	if obj == nil then return end
	local skip = false
	local i = 0
	for i, obj in ipairs(obj["eventhandler"]) do
		if skip == false then
			if obj == id then
				table.remove(obj["eventhandler"], i)
				table.remove(obj["eventhandler"], i - 1)
			end
		skip = true
		end
		i = i + 1
		if skip == true then
			skip = false
		end
	end
	
	local skip = false
	local i = 0
	for i, obj in ipairs(self["eventhandler"]) do
		if skip == false then
			if obj == id then
				table.remove(self["eventhandler"], i)
				table.remove(self["eventhandler"], i - 1)
			end
		skip = true
		end
		i = i + 1
		if skip == true then
			skip = false
		end
	end
end