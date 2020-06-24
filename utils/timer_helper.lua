--timer_helper.lua
--v1.12.0
--Author: Connor Wojtak
--Purpose: A utility to allow for pausing of the application, while still rendering the application.

--Imports
local UTILS = require("utils/utils")


--Classes
Timer = {}

--Global Variables
GLOBAL_TIMER_LIST = {}

--Creates a new timer. Returns: Timer
function Timer:start(w, f)
	local obj = {wait=w, func=f, enabled=true}
	setmetatable(obj, self)
    self.__index = self
	table.insert(GLOBAL_TIMER_LIST, obj)
    return obj
end

--Stops a timer, which can be restarted later. Returns: Nothing
function Timer:stop()
	self:setEnabled(false)
end

--Destroys a Timer. Returns: Nothing
function Timer:destroy()
	for i, b in ipairs(GLOBAL_TIMER_LIST) do
		if b == self then
			table.remove(GLOBAL_TIMER_LIST, i)
		end
	end
end

--Called by love.update() to update the timers. Returns: Nothing
function Timer.updateTimers(dt)
	for i, t in ipairs(GLOBAL_TIMER_LIST) do
		if t:getEnabled() == true then
			t:setTime(t:getTime() - dt)
			if t:getTime() <= 0 then
				local func = t:getFunction()
				func()
				t:destroy()
			end
		end
	end
end

--TIMER ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a timer. Returns: Attribute or Nothing
function Timer:getTime()
	return self["wait"]
end
	
function Timer:getFunction()
	return self["func"]
end	
	
function Timer:getEnabled()
	return self["enabled"]
end

function Timer:setTime(attr)
	self["wait"] = attr
end
	
function Timer:setFunction(attr)
	self["func"] = attr
end	
	
function Timer:setEnabled(attr)
	self["enabled"] = attr
end

