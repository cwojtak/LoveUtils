--utils.lua
--v1.9.0
--Author: Connor Wojtak
--Purpose: This utility provides a variety of different functions not relating to a certain class.

--Imports
local JSON_READER = require("utils/json/json")

--Global Variables
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions(1)
OBJECT_PATH = nil
EFFECT_PATH = nil
OBJECT_IMAGE_PATH = nil
EFFECT_IMAGE_PATH = nil
SOUND_PATH = nil
RAW_SOUND_PATH = nil
LEVEL_PATH = nil

--Classes
Utils = {}

--Gets the length of a table. Returns: Integer
function Utils.getTableLength(aTable)
  local count = 0
  for _ in pairs(aTable) do count = count + 1 end
  return count
end

function Utils.loadPathSettings()
	local content = nil
	local JSONDirectory = love.filesystem.getDirectoryItems("utils/")
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.isFile("utils/" .. dir) == true then
			if string.find(dir, ".json") then
				content = love.filesystem.read("utils/" .. dir)
				if content == nil then print("ERROR: Unable to find path file! Unable to load JSON files! Exiting!") os.exit(1) end
			end
		end
	end
	local decoded_data = json.decode(content)
	OBJECT_PATH = decoded_data["object_path"]
	EFFECT_PATH = decoded_data["effect_path"]
	OBJECT_IMAGE_PATH = decoded_data["object_image_path"]
	EFFECT_IMAGE_PATH = decoded_data["effect_image_path"]
	SOUND_PATH = decoded_data["sound_path"]
	RAW_SOUND_PATH = decoded_data["raw_sound_path"]
	LEVEL_PATH = decoded_data["level_path"]
end

function Utils.start()
	Utils.loadPathSettings()
end