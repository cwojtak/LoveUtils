--main.lua
--v1.10.14
--Author: Connor Wojtak
--Purpose: This file tests the utilities.

function love.load()
	--Initalize modules
	local OBJECT_HELPER = require("utils/object_helper")
	local LEVEL_HELPER = require("utils/level_helper")
	local EFFECT_HELPER = require("utils/effect_helper")
	local SOUND_HELPER = require("utils/sound_helper")
	local BUTTON_HELPER = require("utils/button_helper")
	local UTILS = require("utils/utils")
	
	--Load objects and levels
	Utils.start()
	Object.start(false)
	Level.start()
	Effect.start(false)
	Sound.start()
	
	--Start an example level.
	Level.newLevel(Level.getLevelByName("main_menu"))
end

function love.update(dt)
	Sound.updateSounds(dt)
	Button.updateButtons()
end

function love.draw()
	--Updates levels and objects.
	Level.updateBackground()
	EntityObject.updateObjects()
	EntityEffect.updateEffects()
	collectgarbage() -- Saves delicious memory from being eaten.
end

function love.mousepressed(x, y, button, istouch)
	Button.onClickedHook(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.keyreleased(key)
	if key == "x" then --Allows you to escape the program.
		os.exit(0)
	end
	if key == "b" then
		Button:new(10, 10, 100, 100, 
		function(x, y, button, istouch)
		EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 9.8, "down", {})
		end,
		function(x, y, button, istouch)
		EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 1, "down", {})
		end)
	end
	if key == "e" then --Creates a kitty going up.
		local z = EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 9.8, "right", {})
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