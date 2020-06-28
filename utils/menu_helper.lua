--menu_helper.lua
--v1.12.0/pre1.4-v2.0.0
--Author: Connor Wojtak
--Purpose: A utility to allow for the creation of menus.

--Imports
local UTILS = require("utils/utils")


--Classes
Menu = {name=nil, components={}}
local Component = {name=nil}

--Global Variables
GLOBAL_MENU_LIST = {}

--MENU CLASS
--Creates a new Menu class. Returns: Menu
function Menu:new(inname)
	setmetatable({}, self)
	self.name = inname
	self.__index = self
	table.insert(GLOBAL_MENU_LIST, self)
	return self
end

--Adds a component to a Menu. Returns: Nothing
function Menu:addComponent(component)
	table.insert(self["components"], component)
end

--Removes a component from a Menu. Returns: Nothing
function Menu:removeComponentByName(name)
	for i, comp in ipairs(self["components"]) do
		if(comp:getName() == name) then
			table.remove(self["components"], i)
			return
		end
	end
end

--Should be called by love.update() to update the menu and its components. Returns: Nothing
function Menu.updateMenus()
	for i, m in ipairs(GLOBAL_MENU_LIST) do
		for j, c in ipairs(m["components"]) do
			c:update()
		end
	end
end

--Updates all Menu's components when there's a mouse click. Returns: Nothing
function Menu.updateMousePressed(x, y, mouse_button, istouch)
	for i, m in ipairs(GLOBAL_MENU_LIST) do
		for i, c in ipairs(m["components"]) do
			c:updateMousePressed(x, y, mouse_button, istouch)
		end
	end
end

--Removes a Menu with the specified name. Returns: Nothing
function Menu.removeMenuByName(inname)
	for i, m in ipairs(GLOBAL_MENU_LIST) do
		if(m:getName() == inname) then
			table.remove(GLOBAL_MENU_LIST, i)
			return
		end
	end
end

--MENU ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a menu. Returns: Attribute or Nothing
function Menu:getComponents()
	return self["components"]
end

function Menu:getName()
	return self["name"]
end

function Menu:setName(attr)
	self["name"] = name
end

--COMPONENT CLASS
--Creates a new component. Returns: Component 
function Component:new()
	self.__index = self
	setmetatable({name=nil}, self)
    return self
end

--[ABSTRACT] Updates the component. Returns: Nothing
function Component:update()
	error("Component:update() must be implemented by a subclass.")
end

--[ABSTRACT] Updates the component when there's a mouse click. Returns: Nothing
function Component:updateMousePressed(x, y, mouse_button, istouch)
	error("Component:updateMousePressed() must be implemented by a subclass.")
end

--COMPONENT ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Component. Returns: Attribute or Nothing
function Component:getName()
	return self["name"]
end

function Component:setName(attr)
	self["name"] = name
end

--PARTITION Class
--Creates a new partition, which holds other components. Returns: Partition
Partition = Component:new()

function Partition:new(inname, inbeginx, inbeginy, insizex, insizey)
	local obj = {name=inname, beginx=inbeginx, beginy=inbeginy, sizex=insizex, sizey=insizey}
	self.components = {}
	setmetatable(obj, self)
    self.__index = self
    return obj
end

--Updates the partition and its components. Returns: Nothing
function Partition:update()
	for j, c in ipairs(self["components"]) do
		c:update()
	end
end

--Updates the partition and its components when there is a mouse click. Returns: Nothing
function Partition:updateMousePressed(x, y, mouse_button, istouch)
	for i, c in ipairs(m["components"]) do
		c:updateMousePressed(x, y, mouse_button, istouch)
	end
end

--Adds a component to a Partition. Returns: Nothing
function Partition:addComponent(component)
	table.insert(self["components"], component)
end

--Removes a component from a Partition. Returns: Nothing
function Partition:removeComponentByName(name)
	for i, comp in ipairs(self["components"]) do
		if(comp:getName() == name) then
			table.remove(self["components"], i)
			return
		end
	end
end

--PARTITIONS ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Partition. Returns: Attribute or Nothing
function Partition:getBeginningX()
	return self["beginx"]
end
	
function Partition:getSizeX()
	return self["sizex"]
end	
	
function Partition:getBeginningY()
	return self["beginy"]
end

function Partition:getSizeY()
	return self["sizey"]
end

function Partition:getName()
	return self["name"]
end

function Partition:getComponents()
	return self["components"]
end

function Partition:setBeginningX(attr)
	self["beginx"] = attr
end
	
function Partition:setSizeX(attr)
	self["sizex"] = attr
end	
	
function Partition:setBeginningY(attr)
	self["beginy"] = attr
end

function Partition:setSizeY(attr)
	self["sizey"] = attr
end

function Partition:setName(attr)
	self["name"] = attr
end

--BUTTON CLASS
--Creates a new Button. Returns: Button
Button = Component:new()

function Button:new(inname, inbeginx, inbeginy, insizex, insizey, inclickfunc, inhoverfunc, innonhoverfunc)
	local obj = {name=inname, beginx=inbeginx, beginy=inbeginy, sizex=insizex, sizey=insizey, clickfunc=inclickfunc, hoverfunc=inhoverfunc, nonhoverfunc=innonhoverfunc}
	self.__index = self
	setmetatable(obj, self)
    return obj
end

--Updates the Button and its components. Function calls should originate from love.update(). Returns: Nothing
function Button:update()
	local x, y = love.mouse.getPosition()
	if x > self:getBeginningX() and x < self:getSizeX() + self:getBeginningX() then
		if y > self:getBeginningY() and y < self:getSizeY() + self:getBeginningY() then
			local hover = self:getHoverEvent()
			if hover == nil then return end
			hover(self)
		else
			local nohover = self:getNotHoveringEvent()
			if nohover == nil then return end
			nohover(self)
		end
	else
		local nohover = self:getNotHoveringEvent()
		if nohover == nil then return end
		nohover(self)
	end
end

--Originates from love.mousepressed() to check if a Button has been clicked. Returns: Nothing
function Button:updateMousePressed(x, y, mouse_button, istouch)
	if x > self:getBeginningX() and x < self:getSizeX() + self:getBeginningX() then
		if y > self:getBeginningY() and y < self:getSizeY() + self:getBeginningY() then
			local click = self:getClickEvent()
			if click == nil then return end
			click(x, y, mouse_button, istouch, self)
		end
	end
end

--BUTTON ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Button. Returns: Attribute or Nothing
function Button:getBeginningX()
	return self["beginx"]
end
	
function Button:getSizeX()
	return self["sizex"]
end	
	
function Button:getBeginningY()
	return self["beginy"]
end

function Button:getSizeY()
	return self["sizey"]
end

function Button:getName()
	return self["name"]
end

function Button:setBeginningX(attr)
	self["beginx"] = attr
end
	
function Button:setSizeX(attr)
	self["sizex"] = attr
end	
	
function Button:setBeginningY(attr)
	self["beginy"] = attr
end

function Button:setSizeY(attr)
	self["sizey"] = attr
end

function Button:setName(attr)
	self["name"] = attr
end

--Returns the function to be executed when the Button is clicked. Returns: Function
function Button:getClickEvent()
	return self["clickfunc"]
end

--Returns the function to be executed while the Button is being hovered over. Returns: Function
function Button:getHoverEvent()
	return self["hoverfunc"]
end

--Returns the function to be executed while the Button is not being hovered over. Returns: Function
function Button:getNotHoveringEvent()
	return self["nonhoverfunc"]
end

--DROPDOWN CLASS
--Creates a new Dropdown. Returns: Dropdown
Dropdown = Component:new()

function Dropdown:new(inname, inbeginx, inbeginy, insizex, insizey, insizex_open, insizey_open, inclickfunc, inhoverfunc, innonhoverfunc, inclosed)
	local obj = {name=inname, beginx=inbeginx, beginy=inbeginy, sizex_closed=insizex, sizey_closed=isizey, sizex_open=insizex_open, sizey_open=insizey_open, clickfunc=inclickfunc, hoverfunc=inhoverfunc, nonhoverfunc=innonhoverfunc, closed=inclosed}
	self.__index = self
	setmetatable(obj, self)
    return obj
end

--Updates the Dropdown and its components. Function calls should originate from love.update(). Returns: Nothing
function Dropdown:update()
end

--Originates from love.mousepressed() for updating the Dropdown when there is a mouse click. Returns: Nothing
function Dropdown:updateMousePressed(x, y, mouse_button, istouch)
end

--Dropdown ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Dropdown. Returns: Attribute or Nothing
function Dropdown:getBeginningX()
	return self["beginx"]
end
	
function Dropdown:getClosedSizeX()
	return self["sizex_closed"]
end	

function Dropdown:getOpenSizeX()
	return self["sizex_open"]
end	
	
function Dropdown:getBeginningY()
	return self["beginy"]
end

function Dropdown:getClosedSizeY()
	return self["sizey_closed"]
end

function Dropdown:getOpenSizeY()
	return self["sizey_open"]
end

function Dropdown:getName()
	return self["name"]
end

function Dropdown:getIfClosed()
	return self["closed"]
end

function Dropdown:setBeginningX(attr)
	self["beginx"] = attr
end
	
function Dropdown:setSizeX(attr)
	self["sizex"] = attr
end	
	
function Dropdown:setBeginningY(attr)
	self["beginy"] = attr
end

function Dropdown:setSizeY(attr)
	self["sizey"] = attr
end

function Dropdown:setName(attr)
	self["name"] = attr
end

function Dropdown:close()
	self["closed"] = true
end

function Dropdown:open()
	self["closed"] = false
end

--Returns the function to be executed when the Dropdown is clicked. Returns: Function
function Dropdown:getClickEvent()
	return self["clickfunc"]
end

--Returns the function to be executed while the Dropdown is being hovered over. Returns: Function
function Dropdown:getHoverEvent()
	return self["hoverfunc"]
end

--Returns the function to be executed while the Dropdown is not being hovered over. Returns: Function
function Dropdown:getNotHoveringEvent()
	return self["nonhoverfunc"]
end

--TEXTFIELD CLASS
--Creates a new TextField. Returns: TextField
TextField = Component:new()

function TextField:new(inname, inbeginx, inbeginy, insizex, insizey, inclickfunc, inhoverfunc, innonhoverfunc)
	local obj = {name=inname, beginx=inbeginx, beginy=inbeginy, sizex=insizex, sizey=insizey, clickfunc=inclickfunc, hoverfunc=inhoverfunc, nonhoverfunc=innonhoverfunc}
	self.__index = self
	setmetatable(obj, self)
    return obj
end

--Updates the TextField and its components. Function calls should originate from love.update(). Returns: Nothing
function TextField:update()
end

--Originates from love.mousepressed() for updating the TextField when there is a mouse click. Returns: Nothing
function TextField:updateMousePressed(x, y, mouse_button, istouch)
end

--TEXTFIELD ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a TextField. Returns: Attribute or Nothing
function TextField:getBeginningX()
	return self["beginx"]
end
	
function TextField:getSizeX()
	return self["sizex"]
end	
	
function TextField:getBeginningY()
	return self["beginy"]
end

function TextField:getSizeY()
	return self["sizey"]
end

function TextField:getName()
	return self["name"]
end

function TextField:setBeginningX(attr)
	self["beginx"] = attr
end
	
function TextField:setSizeX(attr)
	self["sizex"] = attr
end	
	
function TextField:setBeginningY(attr)
	self["beginy"] = attr
end

function TextField:setSizeY(attr)
	self["sizey"] = attr
end

function TextField:setName(attr)
	self["name"] = attr
end

--Returns the function to be executed when the TextField is clicked. Returns: Function
function TextField:getClickEvent()
	return self["clickfunc"]
end

--Returns the function to be executed while the TextField is being hovered over. Returns: Function
function TextField:getHoverEvent()
	return self["hoverfunc"]
end

--Returns the function to be executed while the TextField is not being hovered over. Returns: Function
function TextField:getNotHoveringEvent()
	return self["nonhoverfunc"]
end

--MEDIA CLASS
--Creates a new Media. Returns: Media
Media = Component:new()

function Media:new(inname, inbeginx, inbeginy, insizex, insizey, inclickfunc, inhoverfunc, innonhoverfunc)
	local obj = {name=inname, beginx=inbeginx, beginy=inbeginy, sizex=insizex, sizey=insizey, clickfunc=inclickfunc, hoverfunc=inhoverfunc, nonhoverfunc=innonhoverfunc}
	self.__index = self
	setmetatable(obj, self)
    return obj
end

--Updates the Media and its components. Function calls should originate from love.update(). Returns: Nothing
function Media:update()
end

--Originates from love.mousepressed() for updating the Media when there is a mouse click. Returns: Nothing
function Media:updateMousePressed(x, y, mouse_button, istouch)
end

--MEDIA ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a Media. Returns: Attribute or Nothing
function Media:getBeginningX()
	return self["beginx"]
end
	
function Media:getSizeX()
	return self["sizex"]
end	
	
function Media:getBeginningY()
	return self["beginy"]
end

function Media:getSizeY()
	return self["sizey"]
end

function Media:getName()
	return self["name"]
end

function Media:setBeginningX(attr)
	self["beginx"] = attr
end
	
function Media:setSizeX(attr)
	self["sizex"] = attr
end	
	
function Media:setBeginningY(attr)
	self["beginy"] = attr
end

function Media:setSizeY(attr)
	self["sizey"] = attr
end

function Media:setName(attr)
	self["name"] = attr
end

--Returns the function to be executed when the Media is clicked. Returns: Function
function Media:getClickEvent()
	return self["clickfunc"]
end

--Returns the function to be executed while the Media is being hovered over. Returns: Function
function Media:getHoverEvent()
	return self["hoverfunc"]
end

--Returns the function to be executed while the Media is not being hovered over. Returns: Function
function Media:getNotHoveringEvent()
	return self["nonhoverfunc"]
end

--CUSTOMFIELD CLASS
--Creates a new CustomField. Returns: CustomField
CustomField = Component:new()

function CustomField:new(inname, inbeginx, inbeginy, insizex, insizey, inclickfunc, inhoverfunc, innonhoverfunc)
	local obj = {name=inname, beginx=inbeginx, beginy=inbeginy, sizex=insizex, sizey=insizey, clickfunc=inclickfunc, hoverfunc=inhoverfunc, nonhoverfunc=innonhoverfunc}
	self.__index = self
	setmetatable(obj, self)
    return obj
end

--Updates the CustomField and its components. Function calls should originate from love.update(). Returns: Nothing
function CustomField:update()
end

--Originates from love.mousepressed() for updating the CustomField when there is a mouse click. Returns: Nothing
function CustomField:updateMousePressed(x, y, mouse_button, istouch)
end

--CUSTOMFIELD ATTRIBUTE GETTERS/SETTERS
--Gets or sets an attribute of a CustomField. Returns: Attribute or Nothing
function CustomField:getBeginningX()
	return self["beginx"]
end
	
function CustomField:getSizeX()
	return self["sizex"]
end	
	
function CustomField:getBeginningY()
	return self["beginy"]
end

function CustomField:getSizeY()
	return self["sizey"]
end

function CustomField:getName()
	return self["name"]
end

function CustomField:setBeginningX(attr)
	self["beginx"] = attr
end
	
function CustomField:setSizeX(attr)
	self["sizex"] = attr
end	
	
function CustomField:setBeginningY(attr)
	self["beginy"] = attr
end

function CustomField:setSizeY(attr)
	self["sizey"] = attr
end

function CustomField:setName(attr)
	self["name"] = attr
end

--Returns the function to be executed when the CustomField is clicked. Returns: Function
function CustomField:getClickEvent()
	return self["clickfunc"]
end

--Returns the function to be executed while the CustomField is being hovered over. Returns: Function
function CustomField:getHoverEvent()
	return self["hoverfunc"]
end

--Returns the function to be executed while the CustomField is not being hovered over. Returns: Function
function CustomField:getNotHoveringEvent()
	return self["nonhoverfunc"]
end