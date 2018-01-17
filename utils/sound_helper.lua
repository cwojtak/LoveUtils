--sound_helper.lua
--v1.10.14
--Author: Connor Wojtak
--Purpose: A utility used for playing and stopping sounds.

--Imports
local JSON_READER = require("utils/json/json")
local UTILS = require("utils/utils")

--Classes
Sound = {}

--Global Variables
GLOBAL_SOUND_LIST = {}
GLOBAL_PLAY_LIST = {}
GLOBAL_DT = 0

--Gets the length of the GLOBAL_SOUND_LIST.
function getLengthOfSoundList()
	return Utils.getTableLength(GLOBAL_SOUND_LIST)
end

--Gets the length of the GLOBAL_PLAY_LIST(contains all sounds currently playing).
function getLengthOfPlayingList()
	return Utils.getTableLength(GLOBAL_PLAY_LIST)
end

--Finds and reads all of the JSON files under the specified path. Returns: List
function find_sounds()
	local JSONDirectory = love.filesystem.getDirectoryItems(SOUND_PATH)
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile(SOUND_PATH .. dir) == true then
			if string.find(dir, ".json") then
				local content = love.filesystem.read(SOUND_PATH .. dir)
				if not content then print("ERROR: No sound files loaded. If you are using sounds, this will cause problems.") return nil end
				table.insert(returnList, content)
			end
		end
	end
	return returnList
end

--Decodes JSON data returns the parameters. Returns: String, Integer, LOVE Sound
function create_sound_para(data) 
	local decoded_data = json.decode(data)
	return decoded_data["name"], love.audio.newSource(RAW_SOUND_PATH .. decoded_data["sound"]), decoded_data["length"], decoded_data["flags"]
end

--SOUND CLASS
--Plays a sound. Returns: Nothing
function Sound.start()
	local sounds = find_sounds()
	if sounds == nil or sounds == {} then return end
	for i, snd in ipairs(sounds) do
		local name, sounda, length, flags = create_sound_para(snd)
		local sound = Sound:new(name, sounda, length, flags)
		table.insert(GLOBAL_SOUND_LIST, sound)
	end
end

--Creates a new Sound, which will eventually be stored in a global list. Returns: List
function Sound:new(inname, insound, inlength, inflags)
	local obj = {name = inname, sound = insound, length = tonumber(inlength), index = 0, flags = inflags, id = Utils.getTableLength(GLOBAL_SOUND_LIST)}
	setmetatable(obj, self)
    self.__index = self
    return obj
end

--Deletes a loaded sound. Returns: Nothing
function Sound.destroy(sound)
	table.remove(GLOBAL_SOUND_LIST, sound:getID())
end

--Plays a sound using the sound's name. Returns: Nothing
function Sound.playByName(name)
	local sound = Sound.getSoundByName(name)
	local sounda = sound:getSound()
	love.audio.play(sounda)
	table.insert(GLOBAL_PLAY_LIST, sound)
end

--Plays a sound using the sound's id. Returns: Nothing
function Sound.playByID(id)
	local sound = Sound.getSoundByID(id)
	local sounda = sound:getSound()
	love.audio.play(sounda)
	table.insert(GLOBAL_PLAY_LIST, sound)
end

--Updates all the sounds, based on how long they have been playing. Returns: Nothing
function Sound.updateSounds(dt)
	if GLOBAL_DT < 1 then GLOBAL_DT = GLOBAL_DT + dt return end --Used to update every second.
	GLOBAL_DT = 0
	for i, snd in ipairs(GLOBAL_PLAY_LIST) do
		if snd:getFlags() == "repeat" then
			snd:setIndex(snd:getIndex() + 1)
			if snd:getIndex() >= snd:getLength() then
				snd:setIndex(0)
				Sound.stopByID(snd:getID())
				Sound.playByID(snd:getID())
			end
		end
	end
end

--Stops a sound with a given ID, or if there is no given ID, stops all audio. Returns: Nothing
function Sound.stopByID(ID)
	if ID == nil then
		love.audio.stop()
		GLOBAL_PLAY_LIST = {}
		return 
	end
	
	local sound = Sound.getSoundByID(ID)
	love.audio.stop(sound:getSound())
	table.remove(GLOBAL_PLAY_LIST, ID)
end

--Stops a sound with a given name, or if there is no given name, stops all audio. Returns: Nothing
function Sound.stopByName(name)
	if name == nil then
		love.audio.stop()
		GLOBAL_PLAY_LIST = {}
		return 
	end
	
	local sound = Sound.getSoundByName(name)
	if sound ~= nil and sound ~= "" then
		love.audio.stop(sound:getSound())
		table.remove(GLOBAL_PLAY_LIST, sound:getID())
	end
end

--Finds a sound with the sound's name. Returns: Integer OR Nil
function Sound.getSoundByName(soundname)
	for i, snd in ipairs(GLOBAL_SOUND_LIST) do
		if snd:getName() == soundname then
			return snd
		end
	end
	return nil
end

--Finds a sound with the sound's id. Returns: Integer OR Nil
function Sound.getSoundByID(id)
	for i, snd in ipairs(GLOBAL_SOUND_LIST) do
		if snd:getID() == id then
			return snd
		end
	end
	return nil
end

--SOUND ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Sound. Returns: Attribute or Nothing
function Sound:getName()
	if not self == Sound.getSoundByID(self:getID()) then print("WARNING: A Sound is not synced to the sound list! This may cause problems!") end
	return self["name"]
end
	
function Sound:getSound()
	if not self == Sound.getSoundByID(self:getID()) then print("WARNING: A Sound is not synced to the sound list! This may cause problems!") end
	return self["sound"]
end	
	
function Sound:getLength()
	if not self == Sound.getSoundByID(self:getID()) then print("WARNING: A Sound is not synced to the sound list! This may cause problems!") end
	return self["length"]
end

function Sound:getIndex()
	if not self == Sound.getSoundByID(self:getID()) then print("WARNING: A Sound is not synced to the sound list! This may cause problems!") end
	return self["index"]
end

function Sound:getFlags()
	if not self == Sound.getSoundByID(self:getID()) then print("WARNING: A Sound is not synced to the sound list! This may cause problems!") end
	return self["flags"]
end

function Sound:getID()
	return self["id"]
end

function Sound:setName(attr)
	local obj = Sound.getSoundByID(self:getID())
	if obj == nil then return end
	obj["name"] = attr
	self["name"] = attr
end
	
function Sound:setSound(attr)
	local obj = Sound.getSoundByID(self:getID())
	if obj == nil then return end
	obj["sound"] = attr
	self["sound"] = attr
end	
	
function Sound:setLength(attr)
	local obj = Sound.getSoundByID(self:getID())
	if obj == nil then return end
	obj["length"] = attr
	self["length"] = attr
end

function Sound:setIndex(attr)
	local obj = Sound.getSoundByID(self:getID())
	if obj == nil then return end
	obj["index"] = attr
	self["index"] = attr
end

function Sound:setFlags(attr)
	local obj = Sound.getSoundByID(self:getID())
	if obj == nil then return end
	obj["flags"] = attr
	self["flags"] = attr
end