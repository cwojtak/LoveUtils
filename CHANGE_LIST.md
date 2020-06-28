# LoveUtils
<hr>
###TODO
*Add Player Helper
*Add Control Helper
*Add Animation Helper
*Add Multiplayer Helper
*Complete Menu Helper
*Streamline Effects
*Add different types of Effects
*Add Tutorial/Documentation
*Add ability to draw parts of objects and effects with different alphas
*Add scrolling ability to levels
*Add private and protected functions
*Add ability to add unique events to menus and buttons

<hr>
###Change List - v1.12.0/pre1.4-v2.0.0

####FEATURES
*Menus and Components (like buttons) have been added
*Basic structure for Menus, Components, Partitions, Buttons, Dropdowns, TextFields, Media, and CustomFields has been implemented (but no true functionality has been implemented other than in Buttons)
*Button.updateButtons() has been removed. Use Menu.update() instead
*Button.destroyAllButtons() has been removed. Use Menu:removeComponent() instead
*Button.destroy() has been removed. Use Menu:removeComponent() instead
*Button "endx" and "endy" attributes have been replaced with "sizex" and "sizey"
*Object.destroy() has been removed. Objects should not be destroyed.

####FIXED BUGS/OPTIMIZATIONS
*Removed lots and lots of extraneous code from the Object getters/setters
*Added an incrementing ENTITYOBJECT_ID instead of using the GLOBAL_ENTITYOBJECT_LIST length as more than one EntityObject could have the same ID
*Fixed changelist formatting

####NOTES
*The GLOBAL_OBJECT_LIST should not have any deletions or additons; all needed Objects for the entire game should be loaded on startup into this list


<hr>
###Change List - v1.12.0/pre1.3-v2.0.0

####FEATURES
*Added specification of sound type when reading sound .json files to better differentiate between sound effects and music
*You can now have as many effect states as you want instead of having precisely three
*Added x and y sizes to objects
*Change EntityObject direction to use radians
*Removed button_helper.lua; menu_helper.lua will contain Buttons

####FIXED BUGS/OPTIMIZATIONS
*Optimized the rendering of effects
*Removed unneccesary variables AGAIN

####NOTES
*Some Button class features are still available but are marked as deprecated; these will be replaced with Menu class features

<hr>
###Change List - v1.12.0/pre1.2-v2.0.0

####FEATURES
*Added experimental FPS limiter in utils.lua

####FIXED BUGS/OPTIMIZATIONS
*Removed extraneous GLOBAL_ENTITYOBJECT_INDEX from the Object Helper
*Fixed skipping frames when drawing EntityObjects
*Fixed EntityObjects flickering when another EntityObject was deleted
*Fixed main.lua again

<hr>
###Change List - v1.11.0/pre1.1-v2.0.0

####FEATURES
*Updated to LOVE 11.3

####FIXED BUGS/OPTIMIZATIONS
*Removed deprecated love.filesystem.isFile()
*Fixed EventHandler example