--main.lua
<<<<<<< HEAD
--v1.6.4
=======
--v1.9.5
>>>>>>> 69e2953524cf94c6a651a521aada35d35560a4c1
--Author: Connor Wojtak
--Purpose: This file tests the utilities.

function love.load()
	--Initalize modules
<<<<<<< HEAD
	OBJECT_HELPER = require("utils/object_helper")
	LEVEL_HELPER = require("utils/level_helper")
	EFFECT_HELPER = require("utils/effect_helper")
	SOUND_HELPER = require("utils/sound_helper")
=======
	local OBJECT_HELPER = require("utils/object_helper")
	local LEVEL_HELPER = require("utils/level_helper")
	local EFFECT_HELPER = require("utils/effect_helper")
	local SOUND_HELPER = require("utils/sound_helper")
	local UTILS = require("utils/utils")
>>>>>>> 69e2953524cf94c6a651a521aada35d35560a4c1
	
	--Load objects and levels
	Utils.start()
	Object.start(false)
	Level.start()
<<<<<<< HEAD
	Effect.start()
=======
	Effect.start(false)
>>>>>>> 69e2953524cf94c6a651a521aada35d35560a4c1
	Sound.start()
	
	--Set default graphics, etc.
	love.graphics.setNewFont(12)
<<<<<<< HEAD
	WINDOW_WIDTHA, WINDOW_HEIGHTA = love.window.getDesktopDimensions(1)
	screen = love.window.setMode(WINDOW_WIDTHA, WINDOW_HEIGHTA)
	if screen == false then
		os.exit(1)
	end
	
	--Starts the level: "main_menu"
	Level.newLevel(GLOBAL_LEVEL_LIST[Level.getIDByName("main_menu")])
=======
	screen = love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
	if screen == false then
		os.exit(1)
	end
	Level.newLevel(Level.getLevelByName("main_menu"))
>>>>>>> 69e2953524cf94c6a651a521aada35d35560a4c1
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
<<<<<<< HEAD
	if key == "a" then --Creates a kitty going left.
		kitteh, kittehid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("kitty")], 256, 256, 5, "left")
	end
	if key == "b" then --Creates a kitty going up.
		kitteh, kittehid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("kitty")], 256, 256, 5, "up")
	end
	if key == "c" then --Creates a kitty going right.
		kitteh, kittehid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("kitty")], 256, 256, 5, "right")
	end
	if key == "d" then --Creates a kitty going down.
		kitteh, kittehid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("kitty")], 256, 256, 5, "down")
	end
	if key == "e" then --Creates a computer.
		computer, computerid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("computer")], 1024, 0, 9.8, "down")
	end
	if key == "f" then --Creates a evil computer.
		computerevil, computerevilid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("computer_evil")], 1024, 0, 9.8, "down")
	end
	if key == "g" then --Creates a PotatOS.
		potatos, potatosid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("potatOS")], 1024, 0, 9.8, "down")
	end
	if key == "h" then --Creates a Invisible Bob.
		bob, bobid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("bob_the_invisible_guy")], 1024, 0, 9.8, "down")
	end
	if key == "i" then --Switches to a new level.
		Level.stop()
		Level.newLevel(GLOBAL_LEVEL_LIST[Level.getIDByName("ch1_intro_01")])
	end
	if key == "j" then --Switches to a new level.
		Level.stop()
		Level.newLevel(GLOBAL_LEVEL_LIST[Level.getIDByName("main_menu")])
=======
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
>>>>>>> 69e2953524cf94c6a651a521aada35d35560a4c1
	end
end

function love.focus(f)
end

function love.quit()
end
