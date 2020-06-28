--main.lua
--v1.12.0/pre1.4-v2.0.0
--Author: Connor Wojtak
--Purpose: This file tests the utilities.

function love.load()
	--Initalize modules
	local JSON_READER = require("utils/json/json")
	local OBJECT_HELPER = require("utils/object_helper")
	local LEVEL_HELPER = require("utils/level_helper")
	local EFFECT_HELPER = require("utils/effect_helper")
	local SOUND_HELPER = require("utils/sound_helper")
	local MENU_HELPER = require("utils/menu_helper")
	local TIMER_HELPER = require("utils/timer_helper")
	local DRAWABLE_HELPER = require("utils/drawable_helper")
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
	Menu.updateMenus()
	Utils.update(60, dt)
end

function love.draw()
	--Updates levels and objects.
	Level.updateBackground()
	EntityObject.updateObjects()
	EntityEffect.updateEffects()
	Drawable.updateDrawables()
	collectgarbage() -- Saves delicious memory from being eaten.
end

function love.mousepressed(x, y, button, istouch)
	Menu.updateMousePressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.keyreleased(key)
	if key == "x" then --Allows you to escape the program.
		os.exit(0)
	end
	if key == "b" then
		local menu = Menu:new("MainMenu")
		local buttonone = Button:new("button1", 0, 0, 100, 100, 
		function(x, y, button, istouch)
		EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 9.8, math.rad(270), {})
		Menu.removeMenuByName("MainMenu")
		end,
		function(x, y, button, istouch)
		EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 1, math.rad(270), {})
		end)
		menu:addComponent(buttonone)
	end
	if key == "e" then --Creates a kitty going up.
		local z = EntityObject:new(Object.getObjectByName("kitty"), 0, 0, 9.8, math.rad(315), {})
		z:applyDefaultEntityEffect() -- Applies the default EntityEffect.
		
		z:registerObjectEventHandler(function (entObj, obj, obj_list) -- Creates a new EventHandler.
		local entObjPosX = entObj:getPosX()
		local entObjPosY = entObj:getPosY()
		for i, obja in ipairs(obj_list) do
			if (obja:getPosX() - entObjPosX ~= 0) or (obja:getPosY() - entObjPosY ~= 0) then
				print("An object is in a different position than this object!")
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