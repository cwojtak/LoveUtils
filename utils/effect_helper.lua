--effect_helper.lua
--v1.1.2
--Author: Connor Wojtak
--Purpose: A utility to add animated effects to an object.

--Imports
JSON_READER = require("utils/json/json")
UTILS = require("utils/utils")

--Directory
WORKING_DIRECTORY = love.filesystem.getRealDirectory("effects/computer.json")
local open = io.open

--Classes
Effect = {}
EntityEffect = {}

--Global Variables
GLOBAL_EFFECT_LIST = {}
GLOBAL_ENTITYEFFECT_LIST = {}
GLOBAL_ENTITYEFFECT_INDEX = 0

--Random
math.randomseed(os.time())

--Finds and reads all of the JSON files under the "effects/" folder. Returns: List
function find_effects()
	local JSONDirectory = love.filesystem.getDirectoryItems("effects/")
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile("effects/" .. dir) == true then
			if string.find(dir, ".json") then
			    local file = open(WORKING_DIRECTORY .. "/effects/" .. dir, "rb")
				if not file then return nil end
				local content = file:read "*a"
				table.insert(returnList, content)
				file:close()
			end
		end
	end
	return returnList
end

--Decodes JSON data returns the parameters. Returns: String, LOVE Image
function create_effect_para(data) 
	local decoded_data = json.decode(data)
	return decoded_data["name"], love.graphics.newImage("sprites/" .. decoded_data["image1"] .. ".jpg"), love.graphics.newImage("sprites/" .. decoded_data["image2"] .. ".jpg"), love.graphics.newImage("sprites/" .. decoded_data["image3"] .. ".jpg")
end

--EFFECT CLASS
--Called on startup. Returns: Nothing
function Effect.start()
	local effects = find_effects()
	for i, eff in ipairs(effects) do
		local name, image1, image2, image3  = create_effect_para(eff)
		local effect = Effect.new(name, image1, image2, image3)
		table.insert(GLOBAL_EFFECT_LIST, effect)
	end
end

--Creates a new Effect list, which will eventually be stored in a global list. Returns: List
function Effect.new(inname, inimage1, inimage2, inimage3)
	table.insert(Effect, inname)
	local inid = Effect.getIDByName(inname)
	return {name = inname, image1 = inimage1, image2 = inimage2, image3 = inimage3}
end

--Draws an effect and applies any effects to it. Returns: Nothing
function Effect.draw(eff, posx, posy, sx, sy)
	local eff_img = Effect.getAttribute("image", eff)
	love.graphics.draw(eff_img, posx, posy, 0, sx, sy, 0, 0, 0, 0)
end

--Finds the ID of an effect with the effect's name based on where it is stored in the Effect list. Returns: Integer or Nil
function Effect.getIDByName(effectname)
	for i, eff in ipairs(Effect) do
		if string.find(eff, effectname) then
			return i
		end
	end
	return nil
end

--Finds the name of an effect with the effect's ID based on where it is stored in the Effect list. Returns: String or Nil
function Effect.getNameByID(effectID)
	return Effect[effectID]
end

--Finds a given attribute of an effect and returns it. Returns: String, Integer, Image or Nil
function Effect.getAttribute(attr, eff)
	if attr == "name" then
		return eff["name"]
	end
	if attr == "image" then
		return eff["image"]
	end
	if attr == "special" then
		return eff["special"]
	end
	if attr == "flags" then
		return eff["flags"]
	end
	if attr == "id" then
		return eff["id"]
	end
end

--ENTITYEFFECT CLASS
--Creates a new EntityEffect list. Returns: List, Integer
function EntityEffect.new(eff, inposx, inposy, startimg, mineffect, maxeffect, EID)
	local rand = math.random(mineffect, maxeffect)
	table.insert(EntityEffect, eff)
	table.insert(GLOBAL_ENTITYEFFECT_LIST, {name = eff["name"], image1 = eff["image1"], image2 = eff["image2"], image3 = eff["image3"], posx = inposx, posy = inposy, imgstate = startimg, am_effect = rand, ent_id =  EID})
	local ID = getTableLength(GLOBAL_ENTITYEFFECT_LIST)
	return {name = eff["name"], image1 = eff["image1"], image2 = eff["image2"], image3 = eff["image3"], posx = inposx, posy = inposy, imgstate = startimg, am_effect = rand, ent_id =  EID}, ID
end

--Called by love.draw() to update the effects. Returns: Nothing
function EntityEffect.updateEffects()
	for i, eff in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		local entity_id = eff["ent_id"]
		local entity_object = GLOBAL_ENTITYOBJECT_LIST[entity_id]
		if entity_object == nil then table.remove(GLOBAL_ENTITYEFFECT_LIST, i) return end -- Used when EntityObject is deleted.
		local entityposx = entity_object["posx"]
		local entityposy = entity_object["posy"]

		local i = 0
		if eff["imgstate"] == 4 then eff["imgstate"] = 1 end
		if eff["imgstate"] == 1 then
			while(i ~= eff["am_effect"]) do
				love.graphics.draw(eff["image1"], entityposx + math.random(0, 60), entityposy + math.random(0, 60), 0, 0.2, 0.2, 0, 0, 0, 0)
				i = i + 1
			end
		end
		if eff["imgstate"] == 2 then
			while(i ~= eff["am_effect"]) do
				love.graphics.draw(eff["image2"], entityposx + math.random(0, 60), entityposy + math.random(0, 60), 0, 0.2, 0.2, 0, 0, 0, 0)
				i = i + 1
			end
		end
		if eff["imgstate"] == 3 then
			while(i ~= eff["am_effect"]) do
				love.graphics.draw(eff["image3"], entityposx + math.random(0, 60), entityposy + math.random(0, 60), 0, 0.2, 0.2, 0, 0, 0, 0)
				i = i + 1
			end
		end
		if GLOBAL_ENTITYEFFECT_INDEX >= 75 then
			eff["imgstate"] = eff["imgstate"] + 1
			GLOBAL_ENTITYEFFECT_INDEX = 0
		end
		GLOBAL_ENTITYEFFECT_INDEX = GLOBAL_ENTITYEFFECT_INDEX + 1
	end
end

--Finds the ID of an EntityEffect by indexing the GLOBAL_ENTITYEFFECT_LIST with the given EntityEffect. Returns: Integer or Nil
function EntityEffect.getIDByClass(class)
	for i, ent in ipairs(GLOBAL_ENTITYEFFECT_LIST) do
		if ent == class then
			return i
		end
	end
	return nil
end

--Finds the name of an EntityEffect with the effect's ID based on where it is stored in the EntityEffect list. Returns: String or Nil
function EntityEffect.getEntityEffectByID(effID)
	return EntityEffect[effID]
end

--Finds a given attribute of an EntityEffect and returns it. Returns: String, Integer, effect or Nil
function EntityEffect.getAttribute(attr, eff)
	if attr == "name" then
		return eff["name"]
	end
	if attr == "posx" then
		return eff["posx"]
	end
	if attr == "posy" then
		return eff["posy"]
	end
	if attr == "image1" then
		return eff["image1"]
	end
	if attr == "image2" then
		return eff["image2"]
	end
	if attr == "image3" then
		return eff["image3"]
	end
	if attr == "imgstate" then
		return eff["imgstate"]
	end
end