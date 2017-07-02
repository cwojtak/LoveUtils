--level_helper.lua
--v1.9.5
--Author: Connor Wojtak
--Purpose: A utility to load levels, their attributes, and their backgrounds, and turn them into
--lists containing those attributes. This file also contains functions for reading the Level lists.

--Imports
local JSON_READER = require("utils/json/json")
local UTILS = require("utils/utils")
local OBJECT_HELPER = require("utils/object_helper")
local SOUND_HELPER = require("utils/sound_helper")

--Global Variables
GLOBAL_LEVEL_LIST = {}
GLOBAL_LEVEL_INDEX = 0

--Classes
Level = {}

--Global Variables
LAST_LEVEL = nil
UPDATE_BACKGROUND = false

--Finds and reads all of the JSON files under the specified path. Returns: List
function find_levels()
	local JSONDirectory = love.filesystem.getDirectoryItems(LEVEL_PATH)
	local returnList = {}
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile(LEVEL_PATH .. dir) == true then
			if string.find(dir, ".json") then
			    local content = love.filesystem.read(LEVEL_PATH .. dir)
				if not content then print("ERROR: No level files loaded. If you are using levels, this will cause problems.") return nil end
				table.insert(returnList, content)
			end
		end
	end
	return returnList
end

--Decodes JSON data returns the parameters. Returns: String, LOVE Image
function create_level_para(data) 
	local decoded_data = json.decode(data)
	return decoded_data["name"], decoded_data["music"], decoded_data["background"]
end

--LEVEL CLASS
--Called on startup. Returns: Nothing
function Level.start()
	local levels = find_levels()
	if levels == nil or levels == {} then return end
	for i, obj in ipairs(levels) do
		local name, music, background = create_level_para(obj)
		local level = Level:new(name, music, background)
		table.insert(GLOBAL_LEVEL_LIST, level)
	end
end

--Creates a new Level. Returns: Level
function Level:new(inname, inmusic, inbackground)
	local inid = Utils.getTableLength(GLOBAL_LEVEL_LIST)
	local obj = {name = inname, music = inmusic, background = inbackground, id = inid}
	setmetatable(obj, self)
    self.__index = self
    return obj
end

--Starts a new level. Returns: Nothing
function Level.newLevel(level)
	LAST_LEVEL = level
	local music = level:getMusic()
	Sound.playByName(music)
end

--Stops the current running level. Returns: Nothing
function Level.stop()
	Sound.stopByName(LAST_LEVEL:getMusic())
	GLOBAL_ENTITYOBJECT_LIST = {}
	LAST_LEVEL = nil
end

--Called by love.draw() to draw the new background for the level. Returns: Nothing
function Level.updateBackground()
	love.graphics.draw(love.graphics.newImage(LAST_LEVEL:getBackground()), 1, 1, 0, WINDOW_WIDTH/1920, WINDOW_HEIGHT/1080, 0, 0, 0, 0)
end

--Finds a level with the level's name. Returns: Integer or Nil
function Level.getLevelByName(levelname)
	for i, level in ipairs(GLOBAL_LEVEL_LIST) do
		if level:getName() == levelname then
			return level
		end
	end
	return nil
end

--Finds a level with the level's ID. Returns: String or Nil
function Level.getLevelByID(id)
	for i, level in ipairs(GLOBAL_LEVEL_LIST) do
		if level:getID() == id then
			return GLOBAL_LEVEL_LIST[i]
		end
	end
end

--LEVEL ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Level. Returns: Attribute or Nil
function Level:getName()
	if not self == Level.getLevelByID(self:getID()) then print("WARNING: A Level is not synced to the level list! This may cause problems!") end
	return self["name"]
end
	
function Level:getMusic()
	if not self == Level.getLevelByID(self:getID()) then print("WARNING: A Level is not synced to the level list! This may cause problems!") end
	return self["music"]
end	
	
function Level:getBackground()
	if not self == Level.getLevelByID(self:getID()) then print("WARNING: A Level is not synced to the level list! This may cause problems!") end
	return self["background"]
end

function Level:getID()
	return self["id"]
end

function Level:setName(attr)
	local obj = Level.getLevelByID(self:getID())
	if obj == nil then return end
	obj["name"] = attr
	self["name"] = attr
end
	
function Level:setMusic(attr)
	local obj = Level.getLevelByID(self:getID())
	if obj == nil then return end
	obj["music"] = attr
	self["music"] = attr
end	
	
function Level:setBackground(attr)
	local obj = Level.getLevelByID(self:getID())
	if obj == nil then return end
	obj["background"] = attr
	self["background"] = attr
end