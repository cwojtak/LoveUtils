--button_helper.lua
--v1.10.0
--Author: Connor Wojtak
--Purpose: A utility to allow for the creation of buttons.

--Imports
local UTILS = require("utils/utils")


--Classes
Button = {beginx=nil, beginy=nil, endx=nil, endy=nil, clickfunc=nil, hoverfunc=nil}

--Global Variables
GLOBAL_BUTTON_LIST = {}

function Button:new(inbeginx, inbeginy, inendx, inendy, inclickfunc, inhoverfunc)
	local obj = {beginx=inbeginx, beginy=inbeginy, endx=inendx, endy=inendy, clickfunc=inclickfunc, hoverfunc=inhoverfunc}
	setmetatable(obj, self)
    self.__index = self
	table.insert(GLOBAL_BUTTON_LIST, obj)
    return obj
end

function Button:destroy()
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == self then
			table.remove(GLOBAL_BUTTON_LIST, i)
		end
	end
end

function Button.updateButtons()
	local x, y = love.mouse.getPosition()
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if x > b["beginx"] and x < b["endx"] then
			if y > b["beginy"] and y < b["endy"] then
				local hover = Button.getHoverEvent(b)
				hover()
			end
		end
	end
end

function Button.getClickEvent(button)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == button then
			return button["clickfunc"]
		end
	end
end

function Button.getHoverEvent(button)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == button then
			return button["hoverfunc"]
		end
	end
end

function Button.onClickedHook(x, y, button, istouch)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if x > b["beginx"] and x < b["endx"] then
			if y > b["beginy"] and y < b["endy"] then
				local click = Button.getClickEvent(b)
				click(x, y, button, istouch)
			end
		end
	end
end