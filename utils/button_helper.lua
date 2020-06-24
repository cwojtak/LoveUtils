--button_helper.lua
--v1.12.0
--Author: Connor Wojtak
--Purpose: A utility to allow for the creation of buttons.

--Imports
local UTILS = require("utils/utils")


--Classes
Button = {beginx=nil, beginy=nil, endx=nil, endy=nil, clickfunc=nil, hoverfunc=nil}

--Global Variables
GLOBAL_BUTTON_LIST = {}

--Creates a new button. Returns: Button
function Button:new(inbeginx, inbeginy, inendx, inendy, inclickfunc, inhoverfunc, innonhoverfunc)
	local obj = {beginx=inbeginx, beginy=inbeginy, endx=inendx, endy=inendy, clickfunc=inclickfunc, hoverfunc=inhoverfunc, nonhoverfunc=innonhoverfunc}
	setmetatable(obj, self)
    self.__index = self
	table.insert(GLOBAL_BUTTON_LIST, obj)
    return obj
end

--Destroys a button. Returns: Nothing
function Button:destroy()
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == self then
			table.remove(GLOBAL_BUTTON_LIST, i)
		end
	end
end

--Clears all buttons from the screen. Returns: Nothing
function Button.destroyAllButtons()
	GLOBAL_BUTTON_LIST = {}
end

--Called by love.draw() to update the buttons. Returns: Nothing
function Button.updateButtons()
	local x, y = love.mouse.getPosition()
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if x > b:getBeginningX() and x < b:getEndX() then
			if y > b:getBeginningY() and y < b:getEndY() then
				local hover = Button.getHoverEvent(b)
				if hover == nil then return end
				hover(b)
			else
				local nohover = Button.getNotHoveringEvent(b)
				if nohover == nil then return end
				nohover(b)
			end
		else
			local nohover = Button.getNotHoveringEvent(b)
			if nohover == nil then return end
			nohover(b)
		end
	end
end

--Called by love.mousepressed() to check if a button has been clicked.
function Button.onClickedHook(x, y, button, istouch)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if x > b:getBeginningX() and x < b:getEndX() then
			if y > b:getBeginningY() and y < b:getEndY() then
				local click = Button.getClickEvent(b)
				if click == nil then return end
				click(x, y, button, istouch, b)
			end
		end
	end
end

--Returns the function to be executed when the button is clicked. Returns: Function
function Button.getClickEvent(button)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == button then
			return button["clickfunc"]
		end
	end
end

--Returns the function to be executed while the button is being hovered over. Returns: Function
function Button.getHoverEvent(button)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == button then
			return button["hoverfunc"]
		end
	end
end

--Returns the function to be executed while the button is being hovered over. Returns: Function
function Button.getNotHoveringEvent(button)
	for i, b in ipairs(GLOBAL_BUTTON_LIST) do
		if b == button then
			return button["nonhoverfunc"]
		end
	end
end

--BUTTON ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a button. Returns: Attribute or Nothing
function Button:getBeginningX()
	return self["beginx"]
end
	
function Button:getEndX()
	return self["endx"]
end	
	
function Button:getBeginningY()
	return self["beginy"]
end

function Button:getEndY()
	return self["endy"]
end

function Button:setBeginningX(attr)
	self["beginx"] = attr
end
	
function Button:setEndX(attr)
	self["endx"] = attr
end	
	
function Button:setBeginningY(attr)
	self["beginy"] = attr
end

function Button:setEndY(attr)
	self["endy"] = attr
end
