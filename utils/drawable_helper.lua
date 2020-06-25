--drawable_helper.lua
--v1.12.0/pre1.3-v2.0.0
--Author: Connor Wojtak
--Purpose: A utility to allow for the easy rendering of text and other objects.

--Imports
local UTILS = require("utils/utils")


--Classes
Drawable = {func=nil}

--Global Variables
GLOBAL_DRAWABLE_LIST = {}

--Creates a new function to be drawn. Returns: Nothing
function Drawable:new(infunc)
	local obj = {func=infunc}
	setmetatable(obj, self)
    self.__index = self
	table.insert(GLOBAL_DRAWABLE_LIST, obj)
	return obj
end

--Destroys a drawable. Returns: Nothing
function Drawable:destroy()
	for i, d in ipairs(GLOBAL_DRAWABLE_LIST) do
		if d == self then
			table.remove(GLOBAL_DRAWABLE_LIST, i)
		end
	end
end

--Clears all the things to be rendered from the list. Returns: Nothing
function Drawable.clearAll()
	GLOBAL_DRAWABLE_LIST = {}
end

--Called by love.draw() to render the drawables. Returns: Nothing
function Drawable.updateDrawables()
	for i, d in ipairs(GLOBAL_DRAWABLE_LIST) do
		local func = d:getFunction()
		func()
	end
end

function Drawable:getFunction()
	return self["func"]
end
