--sound_helper.lua
--v1.1.2
--Author: Connor Wojtak
--Purpose: A utility used for playing and stopping sounds.

--Imports
JSON_READER = require("utils/json/json")
UTILS = require("utils/utils")

--Directory
WORKING_DIRECTORY = love.filesystem.getRealDirectory("objects/computer.json")

--Classes
Sound = {}

--SOUND CLASS
--Plays a sound. Returns: Nothing
function Sound.play(sound)
	sound = love.audio.newSource(sound)
	love.audio.play(sound)
	table.insert(Sound, "sound")
	return getTableLength(Sound)
end

--Stops a sound with a given ID, or if there is no given ID, stops all audio. Returns: Nothing
function Sound.stop(ID)
	if ID == nil then
		love.audio.stop()
		Sound = {}
	return 
	end
	
	love.audio.stop(Sound[ID])
end

--Finds the ID of an sound with the sound's name based on where it is stored in the Sound list. Returns: Integer OR Nil
function Sound.getIDByName(soundname)
	for i, snd in ipairs(Sound) do
		if string.find(snd, soundname) then
			return i
		end
	end
	return nil
end

--Finds the name of an sound with the sound's ID based on where it is stored in the Sound list. Returns: String or Nil
function Sound.getNameByID(soundID)
	return Sound[soundID]
ends