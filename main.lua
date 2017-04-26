--main.lua
--v1.0.0
--Author: Connor Wojtak
--Purpose: This file tests the utilities.

function love.load()
	--Initalize modules
	OBJECT_HELPER = require("utils/object_helper")
	LEVEL_HELPER = require("utils/level_helper")
	
	--Load objects and levels
	Object.start()
	Level.start()
	Effect.start()
	
	--Set default graphics, etc.
	love.graphics.setNewFont(12)
    --love.graphics.setBackgroundColor(0, 0, 0)
	WINDOW_WIDTHA, WINDOW_HEIGHTA = love.window.getDesktopDimensions(1)
	screen = love.window.setMode(WINDOW_WIDTHA, WINDOW_HEIGHTA)
	if screen == false then
		os.exit(1)
	end
	
	--Starts the level: "main_menu"
	Level.newLevel(GLOBAL_LEVEL_LIST[Level.getIDByName("main_menu")])
	
	--Creates a kitteh object.
	kitteh, kittehid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("kitty")], 256, 256, 5, "up")
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
end

function love.focus(f)
end

function love.quit()
end
