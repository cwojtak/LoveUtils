--main.lua
--v1.9.5
--Author: Connor Wojtak
--Purpose: This file tests the utilities.

function love.load()
	--Initalize modules
	local OBJECT_HELPER = require("utils/object_helper")
	local LEVEL_HELPER = require("utils/level_helper")
	local EFFECT_HELPER = require("utils/effect_helper")
	local SOUND_HELPER = require("utils/sound_helper")
	local UTILS = require("utils/utils")
	
	--Load objects and levels
	Utils.start()
	Object.start(false)
	Level.start()
	Effect.start(false)
	Sound.start()
	
	--Set default graphics, etc.
	love.graphics.setNewFont(12)
	screen = love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
	if screen == false then
		os.exit(1)
	end
	Level.newLevel(Level.getLevelByName("main_menu"))
end

function love.update(dt)
	Sound.updateSounds(dt)
end

function love.draw()
	--Updates levels and objects.
	Level.updateBackground()
	EntityObject.updateObjects()
	EntityEffect.updateEffects()
	collectgarbage() -- Saves delicious memory from being eaten.
end

function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.keyreleased(key)
	if key == "x" then --Allows you to escape the program.
		os.exit(0)
	end
	if key == "e" then --Creates a kitty going up.
		local z = EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 9.8, "up", {})
		z:applyDefaultEntityEffect() -- Applies the default EntityEffect.
		
		z:registerObjectEventHandler(function (entObj, obj, obj_list) -- Creates a new EventHandler.
		local entObjPosX = entObj:getPosX()
		local entObjPosY = entObj:getPosY()
		for i, obja in ipairs(obj_list) do
			if obja:getPosX() ~= entObjPosX then
				if obja:getPosY() ~= entObjPosY then
					print("An object is in a different position than this object!")
				end
			end
		end
		end)
	end
	if key == "i" then --Switches to a new level.
		Level.stop()
		Level.newLevel(Level.getLevelByName("ch1_intro_01"))
	end
	if key == "j" then --Switches to a new level.
		Level.stop()
		Level.newLevel(Level.getLevelByName("main_menu"))
	end
end

function love.focus(f)
end

function love.quit()
end