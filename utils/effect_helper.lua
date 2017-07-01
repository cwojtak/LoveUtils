--effect_helper.lua
--v1.9.0
--Author: Connor Wojtak
--Purpose: A utility to add animated effects to an EntityObject.

--Imports
local JSON_READER = require("utils/json/json")
local UTILS = require("utils/utils")

--Classes
Effect = {name=nil, image1=nil, image2=nil, image3=nil}
EntityEffect = {}

--Global Variables
GLOBAL_EFFECT_LIST = {}
GLOBAL_ENTITYEFFECT_LIST = {}
GLOBAL_ENTITYEFFECT_INDEX = 0

--Variables
local INC_IMAGE_STATE = false

--Random
math.randomseed(os.time())
local randx = nil
local randy = nil

function getLengthOfEffectList()
	return Utils.getTableLength(GLOBAL_EFFECT_LIST)
end

function getLengthOfEntityEffectList()
	return Utils.getTableLength(GLOBAL_ENTITYEFFECT_LIST)
end

--Finds and reads all of the JSON files under the "effects/" folder. Returns: List
function find_effects()
	local JSONDirectory = love.filesystem.getDirectoryItems(EFFECT_PATH)
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile(EFFECT_PATH .. dir) == true then
			if string.find(dir, ".json") then
				local content = love.filesystem.read(EFFECT_PATH .. dir)
				if not content then print("ERROR: No effect files loaded. If you are using effects, this will cause problems.") return nil end
				table.insert(returnList, content)
			end
		end
	end
	return returnList
end

--Decodes JSON data returns the parameters. Returns: String, LOVE Image
function create_effect_para(data) 
	local decoded_data = json.decode(data)
	return decoded_data["name"], love.graphics.newImage(EFFECT_IMAGE_PATH .. decoded_data["image1"] .. ".jpg"), love.graphics.newImage("sprites/" .. decoded_data["image2"] .. ".jpg"), love.graphics.newImage("sprites/" .. decoded_data["image3"] .. ".jpg")
end

--EFFECT CLASS
--Called on startup. Returns: Nothing
function Effect.start(method, decoded_data)
	if method == true and decoded_data ~= nil then
		for i, eff in ipairs(decoded_data) do
			local effect = Effect:new(eff)
			table.insert(GLOBAL_EFFECT_LIST, effect)
		end
	end
	if not method == true then
		local effects = find_effects()
		if effects == nil or effects == {} then return end
		for i, eff in ipairs(effects) do
			local inname, inimage1, inimage2, inimage3  = create_effect_para(eff)
			local inid = Utils.getTableLength(GLOBAL_EFFECT_LIST)
			local effect = {name = inname, image1 = inimage1, image2 = inimage2, image3 = inimage3, id = inid}
			table.insert(GLOBAL_EFFECT_LIST, Effect:new(effect))
		end
	end
end

--Creates a new Effect, which will be stored in a list. Returns: Effect
function Effect:new(obj)
	setmetatable(obj, self)
    self.__index = self
    return obj
end

--Finds the ID of an effect with the effect's name based on where it is stored in the Effect list. Returns: Integer or Nil
function Effect.getEffectByName(effectname)
	for i, eff in ipairs(GLOBAL_EFFECT_LIST) do
		if eff:getName() == effectname then
			return eff
		end
	end
	return nil
end

--Finds the class of an effect with the effect's ID based on where it is stored in the Effect list. Returns: String or Nil
function Effect.getEffectByID(effectID)
	return GLOBAL_EFFECT_LIST[effectID]
end

--EFFECT ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of an Effect. Returns: Attribute or Nil
function Effect:getName()
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self["name"]
end
	
function Effect:getImage1()
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self["image1"]
end	
	
function Effect:getImage2()
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self["image2"]
end

function Effect:getImage3()
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self["image3"]
end

function Effect:getID()
	return self["id"]
end

function Effect:getCustomAttribute(attr)
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self[attr]
end

function Effect:setName(attr)
	local obj = Effect.getEffectByID(self:getID())
	if obj == nil then return end
	obj["name"] = attr
	self["name"] = attr
end
	
function Effect:setImage1(attr)
	local obj = Effect.getEffectByID(self:getID())
	if obj == nil then return end
	obj["image1"] = attr
	self["image1"] = attr
end	
	
function Effect:setImage2(attr)
	local obj = Effect.getEffectByID(self:getID())
	if obj == nil then return end
	obj["image2"] = attr
	self["image2"] = attr
end

function Effect:setImage3(attr)
	local obj = Effect.getEffectByID(self:getID())
	if obj == nil then return end
	obj["image3"] = attr
	self["image3"] = attr
end

function Effect:setCustomAttribute(attr, val)
	local obj = Effect.getEffectByID(self:getID())
	if obj == nil then return end
	obj[attr] = val
	self[attr] = val
end

--ENTITYEFFECT CLASS
--Creates a new EntityEffect. Returns: EntityEffect, Integer
function EntityEffect:new(eff, startimg, mineffect, maxeffect, inentobj)
	local rand = math.random(mineffect, maxeffect)
	local ID = Utils.getTableLength(GLOBAL_ENTITYEFFECT_LIST) + 1
	local eobj = {name = eff:getName(), image1 = eff:getImage1(), image2 = eff:getImage2(), image3 = eff:getImage3(), posx = {}, posy = {}, imgstate = startimg, am_effect = rand, id = ID, entobj=inentobj}
	setmetatable(eobj, self)
    self.__index = self
	table.insert(GLOBAL_ENTITYEFFECT_LIST, eobj)
	return eobj
end

--Called by love.draw() to update the effects. Returns: Nothing
function EntityEffect.updateEffects()
	GLOBAL_ENTITYEFFECT_INDEX = GLOBAL_ENTITYEFFECT_INDEX + 1
	if GLOBAL_ENTITYEFFECT_INDEX == 75 then
		INC_IMAGE_STATE = true
		GLOBAL_ENTITYEFFECT_INDEX = 0
	end

	for i, eff in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if INC_IMAGE_STATE == true then
			eff:setImageState(eff:getImageState() + 1)
		end
		local entity_id = eff:getID()
		local entity_object = eff:getEntityObject()
		if entity_object == nil then table.remove(GLOBAL_ENTITYEFFECT_LIST, i) return end -- Used when EntityObject is deleted. 
		local object = entity_object:getObject()
		if object == nil then return end
		
		local size = object:getSize()
		
		local entityposx = entity_object:getPosX()
		local entityposy = entity_object:getPosY()
		local x = eff:getPosX()
		local y = eff:getPosY()
		
		if GLOBAL_ENTITYEFFECT_INDEX == 0 or GLOBAL_ENTITYEFFECT_INDEX == 15 or GLOBAL_ENTITYEFFECT_INDEX == 30 or GLOBAL_ENTITYEFFECT_INDEX == 45 or GLOBAL_ENTITYEFFECT_INDEX == 60 then
			local r = 0
			while(r ~= eff:getEffectAmount()) do
				x[r] = math.random(-size/8, size) * 2
				y[r] = math.random(-size/8, size) * 2
				r = r + 1
			end
		end
		z = 0
		if eff:getImageState() == 4 then eff:setImageState(1) end
		if eff:getImageState() == 1 then
			while(z ~= eff:getEffectAmount()) do
				if x[z] == nil or y[z] == nil then return end
				love.graphics.draw(eff:getImage1(), entityposx + x[z], entityposy + y[z], 0, size/(size*8), size/(size*8), 0, 0, 0, 0)
				z = z + 1
			end
		end
		if eff:getImageState() == 2 then
			while(z ~= eff:getEffectAmount()) do
				if x[z] == nil or y[z] == nil then return end
				love.graphics.draw(eff:getImage2(), entityposx + x[z], entityposy + y[z], 0, size/(size*8), size/(size*8), 0, 0, 0, 0)
				z = z + 1
			end
		end
		if eff:getImageState() == 3 then
			while(z ~= eff:getEffectAmount()) do
				if x[z] == nil or y[z] == nil then return end
				love.graphics.draw(eff:getImage3(), entityposx + x[z], entityposy + y[z], 0, size/(size*8), size/(size*8), 0, 0, 0, 0)
				z = z + 1
			end
		end
	end
	INC_IMAGE_STATE = false
	collectgarbage()
end

--Finds the ID of an EntityEffect by indexing the EntityEffect list with the given ID. Returns: Integer or Nil
function EntityEffect.getEntityEffectByID(ID)
	for i, ent in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if ent:getID() == ID then
			return ent
		end
	end
	return nil
end

--Finds the name of an EntityEffect with the effect's name based on where it is stored in the EntityEffect list. Returns: String or Nil
function EntityEffect.getEntityEffectByName(name)
	for i, eff in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if eff:getName() == name then
			return eff
		end
	end
	return nil
end

--ENTITYEFFECT ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of an EntityEffect. Returns: Attribute or Nil
function EntityEffect:getName()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["name"]
end
	
function EntityEffect:getImage1()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["image1"]
end	
	
function EntityEffect:getImage2()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["image2"]
end

function EntityEffect:getImage3()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["image3"]
end

function EntityEffect:getPosX()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["posx"]
end

function EntityEffect:getPosY()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["posy"]
end

function EntityEffect:getImageState()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["imgstate"]
end

function EntityEffect:getEntityObject()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["entobj"]
end

function EntityEffect:getEffectAmount()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["am_effect"]
end

function EntityEffect:getID()
	return self["id"]
end

function EntityEffect:setName(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then return end
	obj["name"] = attr
	self["name"] = attr
end
	
function EntityEffect:setImage1(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then return end
	obj["image1"] = attr
	self["image1"] = attr
end	
	
function EntityEffect:setImage2(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then return end
	obj["image2"] = attr
	self["image2"] = attr
end

function EntityEffect:setImage3(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then  return end
	obj["image3"] = attr
	self["image3"] = attr
end

function EntityEffect:setImageState(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then  return end
	obj["imgstate"] = attr
	self["imgstate"] = attr
end

function EntityEffect:setEntityObject(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then return end
	obj["entobj"] = attr
	self["entobj"] = attr
end

function EntityEffect:setEffectAmount(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then return end
	obj["am_effect"] = attr
	self["am_effect"] = attr
end