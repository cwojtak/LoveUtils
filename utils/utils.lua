--utils.lua
--v1.12.0
--Author: Connor Wojtak
--Purpose: This utility provides a variety of different functions not relating to a certain class.

--Imports
local JSON_READER = require("utils/json/json")

--Global Variables
SCREEN = nil
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

--Completes various updates. The first argument is an integer value that the FPS should be limited to. Entering zero disables the FPS limiter. Returns: Nothing
function Utils.update(limitFPS, dt)
	if(limitFPS ~= 0) then
		if dt < 1/limitFPS then
			love.timer.sleep(1/limitFPS-dt)
		end
	end
end

--Loads all paths required to find objects, effects, levels, and sounds. Returns: Nothing
function Utils.loadPathSettings()
	local content = nil
	local JSONDirectory = love.filesystem.getDirectoryItems("utils/")
	for i, dir in ipairs(JSONDirectory) do
		if love.filesystem.getInfo("utils/" .. dir) ~= nil then
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

--Starts the Utilities, which are required to run. Returns: Nothing
function Utils.start()
	Utils.loadPathSettings()
end