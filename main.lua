--main.lua
--v1.6.4
--Author: Connor Wojtak
--Purpose: This file tests the utilities.

function love.load()
	--Initalize modules
	OBJECT_HELPER = require("utils/object_helper")
	LEVEL_HELPER = require("utils/level_helper")
	EFFECT_HELPER = require("utils/effect_helper")
	SOUND_HELPER = require("utils/sound_helper")
	
	--Load objects and levels
	Object.start()
	Level.start()
	Effect.start()
	Sound.start()
	
	--Set default graphics, etc.
	love.graphics.setNewFont(12)
	WINDOW_WIDTHA, WINDOW_HEIGHTA = love.window.getDesktopDimensions(1)
	screen = love.window.setMode(WINDOW_WIDTHA, WINDOW_HEIGHTA)
	if screen == false then
		os.exit(1)
	end
	
	--Starts the level: "main_menu"
	Level.newLevel(GLOBAL_LEVEL_LIST[Level.getIDByName("main_menu")])
end

function love.update(dt)
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
	end
end

function love.focus(f)
end

function love.quit()
end
