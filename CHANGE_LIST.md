# LoveUtils
<hr>
TODO
>Add Player Helper
>Add Control Helper
>Add Animation Helper
>Complete Menu Helper
>Streamline Effects
>Add different types of Effects
>Add Tutorial/Documentation
>Add ability to draw parts of objects and effects with different alphas
>Add scrolling ability to levels

<hr>
Change List - v1.12.0/pre1.3-v2.0.0

FEATURES
>Added specification of sound type when reading sound .json files to better differentiate between sound effects and music
>You can now have as many effect states as you want instead of having precisely three
>Added x and y sizes to objects
>Change EntityObject direction to use radians
>Removed button_helper.lua; menu_helper.lua will contain Buttons

FIXED BUGS
>Optimized the rendering of effects
>Removed unneccesary variables AGAIN

NOTES
>Some Button class features are still available but are marked as deprecated; these will be replaced with Menu class features

<hr>
Change List - v1.12.0/pre1.2-v2.0.0

FEATURES
>Added experimental FPS limiter in utils.lua

FIXED BUGS
>Removed extraneous GLOBAL_ENTITYOBJECT_INDEX from the Object Helper
>Fixed skipping frames when drawing EntityObjects
>Fixed EntityObjects flickering when another EntityObject was deleted
>Fixed main.lua again

<hr>
Change List - v1.11.0/pre1.1-v2.0.0

FEATURES
>Updated to LOVE 11.3

FIXED BUGS
>Removed deprecated love.filesystem.isFile()
>Fixed EventHandler example