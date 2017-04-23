function love.load()
	--Initalize modules
	OBJECT_HELPER = require("utils/object_helper")
	LEVEL_HELPER = require("utils/level_helper")
	
	--Load objects and levels
	local objects = find_objects()
	local levels = find_levels()
	
	--Insert objects into the GLOBAL_OBJECT_LIST
	for i, obj in ipairs(objects) do
		local name, image, special, flags = create_object_para(obj)
		local object = Object.new(name, image, special, flags)
		table.insert(GLOBAL_OBJECT_LIST, object)
	end
	
	--Insert levels into the GLOBAL_LEVEL_LIST
	for i, obj in ipairs(levels) do
		local name, music, background = create_level_para(obj)
		local level = Level.new(name, music, background)
		table.insert(GLOBAL_LEVEL_LIST, level)
	end
	
	--Set default graphics, etc.
	love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0, 0, 0)
	WINDOW_WIDTHA, WINDOW_HEIGHTA = love.window.getDesktopDimensions(1)
	screen = love.window.setMode(WINDOW_WIDTHA, WINDOW_HEIGHTA)
	if screen == false then
		os.exit(1)
	end
	
	--Starts the level: "main_menu"
	Level.start(GLOBAL_LEVEL_LIST[Level.getIDByName("main_menu")])
	
	kitteh, kittehid = EntityObject.new(GLOBAL_OBJECT_LIST[Object.getIDByName("kitty")], 256, 256, 1, "up")
end

function love.update(dt)
end

function love.draw()
	--Update
	Level.updateBackground()
	EntityObject.updateObjects()
end

function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.keyreleased(key)
	if key == "x" then
		os.exit(0)
	end
end

function love.focus(f)
end

function love.quit()
end