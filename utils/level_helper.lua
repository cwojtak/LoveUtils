--level_helper.lua
--Author: Connor Wojtak
--Purpose: A utility to load levels, their attributes, and their backgrounds, and turn them into
--lists containing those attributes. This file also contains functions for reading the Level lists.

--Imports
JSON_READER = require("utils/json/json")
UTILS = require("utils/utils")
OBJECT_HELPER = require("utils/object_helper")

--Global Variables
GLOBAL_LEVEL_LIST = {}

--Directory
WORKING_DIRECTORY = love.filesystem.getRealDirectory("objects/computer.json")
local open = io.open

--Classes
Level = {}

--Global Variables
LAST_LEVEL = nil
UPDATE_BACKGROUND = false

--Finds and reads all of the JSON files under the "levels/" folder. Returns: List
function find_levels()
	local JSONDirectory = love.filesystem.getDirectoryItems("levels/")
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile("levels/" .. dir) == true then
			if string.find(dir, ".json") then
			    local file = open(WORKING_DIRECTORY .. "/levels/" .. dir, "rb")
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
function create_level_para(data) 
	local decoded_data = json.decode(data)
	return decoded_data["name"], decoded_data["music"], decoded_data["background"]
end

--LEVEL CLASS
--Creates a new Level list. Returns: List
function Level.new(inname, inmusic, inbackground)
	table.insert(Level, inname)
	local inid = Level.getIDByName(inname)
	return {name = inname, music = inmusic, background = inbackground, id = inid}
end

--Starts a new level. Returns: Nothing
function Level.start(level)
	sound = love.audio.newSource(level["music"])
	LAST_LEVEL = {lvl = level, snd = sound, background = level["background"]}
	UPDATE_BACKGROUND = true
	love.audio.play(sound)
end

--Stops the current running level. Returns: Nothing
function Level.stop()
	local level = LAST_LEVEL
	love.audio.stop(level["snd"])
	GLOBAL_ENTITYOBJECT_LIST = {}
	LAST_LEVEL = nil
end

--Called by love.draw() to draw the new background for the level. Returns: Nothing
function Level.updateBackground()
	if UPDATE_BACKGROUND == true then
		love.graphics.draw(love.graphics.newImage(LAST_LEVEL["background"]), 0, 0, 0, 1, 1, 0, 0, 0, 0)
	end
end

--Finds the ID of an level with the level's name based on where it is stored in the Level list. Returns: Integer or Nil
function Level.getIDByName(levelname)
	for i, level in ipairs(Level) do
		if string.find(level, levelname) then
			return i
		end
	end
	return nil
end

--Finds the name of an level with the level's ID based on where it is stored in the Level list. Returns: String or Nil
function Level.getNameByID(levelID)
	return Level[levelID]
end

--Finds a given attribute of an level and returns it. Returns: String, Integer, Image or Nil
function Level.getAttribute(attr, obj)
	if attr == "name" then
		return obj["name"]
	end
	if attr == "id" then
		return obj["id"]
	end
	if attr == "music" then
		return obj["music"]
	end
	if attr == "background" then
		return obj["background"]
	end
end