--sound_helper.lua
--v1.6.9
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

--Finds and reads all of the JSON files under the "sounds/" folder. Returns: List
function find_sounds()
	local JSONDirectory = love.filesystem.getDirectoryItems("sounds/")
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile("sounds/" .. dir) == true then
			if string.find(dir, ".json") then
				local content = love.filesystem.read("sounds/" .. dir)
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
	return decoded_data["name"], love.audio.newSource("sounds/raw/" .. decoded_data["sound"]), decoded_data["length"], decoded_data["flags"]
end

--SOUND CLASS
--Plays a sound. Returns: Nothing
function Sound.start()
	local sounds = find_sounds()
	if sounds == nil or sounds == {} then return end
	for i, snd in ipairs(sounds) do
		local name, sounda, length, flags = create_sound_para(snd)
		local sound = Sound.new(name, sounda, length, flags)
		table.insert(GLOBAL_SOUND_LIST, sound)
	end
end

--Creates a new Sound list, which will eventually be stored in a global list. Returns: List
function Sound.new(inname, insound, inlength, inflags)
	table.insert(Sound, inname)
	local inid = Sound.getIDByName(inname)
	return {name = inname, sound = insound, length = tonumber(inlength), index = 0, flags = inflags}
end

--Plays a Sound. Returns: Nothing
function Sound.play(name)
	local sound = Sound.getClassByName(name)
	local sounda = sound["sound"]
	love.audio.play(sounda)
	table.insert(Sound, name)
	table.insert(GLOBAL_PLAY_LIST, sound)
end

--Updates all the sounds, based on how long they have been playing. Returns: Nothing
function Sound.updateSounds(dt)
	if GLOBAL_DT < 1 then GLOBAL_DT = GLOBAL_DT + dt return end --Used to update every second.
	GLOBAL_DT = 0
	for i, snd in ipairs(GLOBAL_PLAY_LIST) do
		--print(snd["flags"])
		if snd["flags"] == "repeat" then
			snd["index"] = snd["index"] + 1
			if snd["index"] >= snd["length"] then
				snd["index"] = 0
				Sound.stop(i)
				Sound.play(snd["name"])
			end
		end
	end
end

--Stops a sound with a given ID, or if there is no given ID, stops all audio. Returns: Nothing
function Sound.stop(ID)
	if ID == nil then
		love.audio.stop()
		Sound = {}
	return 
	end
	
	local sound = GLOBAL_PLAY_LIST[1]
	love.audio.stop(sound["sound"])
	table.remove(GLOBAL_PLAY_LIST, ID)
end

--Finds the ID of an sound with the sound's name based on where it is stored in the GLOBAL_SOUND_LIST. Returns: Integer OR Nil
function Sound.getIDByName(soundname)
	for i, snd in ipairs(GLOBAL_PLAY_LIST) do
		if string.find(snd["name"], soundname) then
			return i
		end
	end
	return nil
end

--Finds the ID of an sound with the sound's name based on where it is stored in the GLOBAL_SOUND_LIST. Returns: Integer OR Nil
function Sound.getClassByName(soundname)
	for i, snd in ipairs(GLOBAL_SOUND_LIST) do
		if string.find(snd["name"], soundname) then
			return snd
		end
	end
	return nil
end