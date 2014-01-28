Apocalypse Mod
==============

Apocalypse Mod is a fully featured server-side mod for Left 4 Dead. It is a redesign of several of the mechanics of the game as well as an implementation of several new mechanics and features. The mod is broken into 4 SourceMod plugins, and some Stripper: Source configuration files

- ApocalypseMod core plugin
- Dynamic Director plugin (director.sp)
- Custom items plugin (customitems.sp
- Lighting plugin (lightingmod.sp)
- Stripper:Source global_filters and individual map filters.


Installation
--------------

To install Apocalypse Mod on your Left 4 Dead server, you will first need to install [MetaMod](http://sourcemm.net/), [SourceMod](http://sourcemod.net), and [Stripper:Source](http://www.bailopan.net/stripper/) addons on your server.

From there, take the 'build' folder of the Apocalypse Mod Project, and copy it into your left 4 dead server directly, ensuring that the left4dead_dlc3 and left4dead/addons folder match up correctly. 

When you start your server, you should see a message in console 'Apocalypse Mod Loaded'. 

Usage
----------
Apocalypse Mod should work on it's own, without requiring any configuration. There are a few configuration options and commands:

`apoc_gore 1 //setting this to zero will turn off extra blood effects`

`dd_debug 0 //setting this to 1 will print dynamic director debug messages`

`use_customitem_6 //this command is bound to players '6' key when they connect. Uses custom items (if the player has one)`

`customitemmenu //this command opens up the custom item selection menu`