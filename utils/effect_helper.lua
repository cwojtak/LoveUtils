--effect_helper.lua
--v1.12.0/pre1.3-v2.0.0
--Author: Connor Wojtak
--Purpose: A utility to add animated effects to an EntityObject.

--Imports
local JSON_READER = require("utils/json/json")
local UTILS = require("utils/utils")

--Classes
Effect = {name=nil, states={}, id=nil}
EntityEffect = {name=nil, states={}, posx={}, posy={}, imgstate=nil, am_effect=nil, id=nil, entobj=nil}

--Global Variables
GLOBAL_EFFECT_LIST = {}
GLOBAL_ENTITYEFFECT_LIST = {}
ID_INDEX = 0
GLOBAL_ENTITYEFFECT_INDEX = 0

--Variables
local INC_IMAGE_STATE = false

--Random
math.randomseed(os.time())
local randx = nil
local randy = nil

--Gets the length of the GLOBAL_EFFECT_LIST.
function getLengthOfEffectList()
	return Utils.getTableLength(GLOBAL_EFFECT_LIST)
end

--Gets the length of the GLOBAL_ENTITYEFFECT_LIST.
function getLengthOfEntityEffectList()
	return Utils.getTableLength(GLOBAL_ENTITYEFFECT_LIST)
end

--Finds and reads all of the JSON files under the specified path. Returns: List
function find_effects()
	local JSONDirectory = love.filesystem.getDirectoryItems(EFFECT_PATH)
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.getInfo(EFFECT_PATH .. dir) ~= nil then
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
	local list = {}
	for i, snd in ipairs(decoded_data["states"]) do
		table.insert(list, love.graphics.newImage(EFFECT_IMAGE_PATH .. snd .. ".jpg"))
	end
	return decoded_data["name"], list
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
			local inname, list  = create_effect_para(eff)
			local inid = Utils.getTableLength(GLOBAL_EFFECT_LIST)
			local effect = {name = inname, states = list, id = inid}
			table.insert(GLOBAL_EFFECT_LIST, Effect:new(effect))
		end
	end
end

--Creates a new Effect, which is stored in the GLOBAL_EFFECT_LIST. Returns: Effect
function Effect:new(obj)
	setmetatable(obj, self)
    self.__index = self
    return obj
end

--Destroys a loaded effect. Returns: Nothing
function Effect.destroy(eff)
	table.remove(GLOBAL_EFFECT_LIST, eff:getID())
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
--Gets or sets an attribute of an Effect. Returns: Attribute or Nothing
function Effect:getName()
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self["name"]
end
	
function Effect:getStates()
	if not self == Effect.getEffectByID(self:getID()) then print("WARNING: An Effect is not synced to the effect list! This may cause problems!") end
	return self["states"]
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
	
function Effect:setStates(attr)
	local obj = Effect.getEffectByID(self:getID())
	if obj == nil then return end
	obj["states"] = attr
	self["states"] = attr
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
	local ID = ID_INDEX
	ID_INDEX = ID_INDEX + 1
	local eobj = {name = eff:getName(), states = eff:getStates(), posx = {}, posy = {}, imgstate = startimg, am_effect = rand, id = ID, entobj=inentobj}
	setmetatable(eobj, self)
    self.__index = self
	table.insert(GLOBAL_ENTITYEFFECT_LIST, eobj)
	return eobj
end

--Removes an exisiting EntityEffect from an object. Returns: Nothing
function EntityEffect.destroy(entobj)
	for i, e in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if e:getEntityObject() == entobj then
			table.remove(GLOBAL_ENTITYEFFECT_LIST, i)
			return
		end
	end
end

--Called by love.draw() to update the effects. Returns: Nothing
function EntityEffect.updateEffects()
	GLOBAL_ENTITYEFFECT_INDEX = GLOBAL_ENTITYEFFECT_INDEX + 1
	if GLOBAL_ENTITYEFFECT_INDEX == 5 then
		INC_IMAGE_STATE = true
		GLOBAL_ENTITYEFFECT_INDEX = 0
	end

	for i, eff in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if INC_IMAGE_STATE == true then
			eff:setImageState(eff:getImageState() + 1)
		end
		local entity_id = eff:getID()
		local entity_object = eff:getEntityObject()
		if entity_object == nil then table.remove(GLOBAL_ENTITYEFFECT_LIST, i) return end 
		if EntityObject.getEntityObjectByEntityObject(entity_object) == nil then table.remove(GLOBAL_ENTITYEFFECT_LIST, i) return end -- Used when EntityObject is deleted. 
		local object = entity_object:getObject()
		if object == nil then goto continue end
		
		local sizex = object:getSizeX()
		local sizey = object:getSizeX()
		
		local entityposx = entity_object:getPosX()
		local entityposy = entity_object:getPosY()
		local x = eff:getPosX()
		local y = eff:getPosY()
		
		if GLOBAL_ENTITYEFFECT_INDEX == 0 or GLOBAL_ENTITYEFFECT_INDEX == 15 or GLOBAL_ENTITYEFFECT_INDEX == 30 or GLOBAL_ENTITYEFFECT_INDEX == 45 or GLOBAL_ENTITYEFFECT_INDEX == 60 then
			local r = 0
			while(r ~= eff:getEffectAmount()) do
				x[r] = math.random(-sizex/8, sizex) * 2
				y[r] = math.random(-sizey/8, sizey) * 2
				r = r + 1
			end
		end
		z = 0
		if eff:getImageState() == Utils.getTableLength(eff:getStates()) then eff:setImageState(1) end
		while(z ~= eff:getEffectAmount()) do
				if x[z] == nil or y[z] == nil then return end
				love.graphics.draw(eff:getStates()[eff:getImageState()], entityposx + x[z], entityposy + y[z], 0, sizex/(sizex*8), sizey/(sizey*8), 0, 0, 0, 0)
				z = z + 1
		end
		::continue::
	end
	INC_IMAGE_STATE = false
	collectgarbage()
end

--Finds the EntityEffect by its name. Returns: Integer or Nil
function EntityEffect.getEntityEffectByID(ID)
	for i, ent in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if ent:getID() == ID then
			return ent
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
	
function EntityEffect:getStates()
	if not self == EntityEffect.getEntityEffectByID(self:getID()) then print("WARNING: An EntityEffect is not synced to the entity effect list! This may cause problems!") end
	return self["states"]
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
	
function EntityEffect:setStates(attr)
	local obj = EntityEffect.getEntityEffectByID(self:getID())
	if obj == nil then return end
	obj["states"] = attr
	self["states"] = attr
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