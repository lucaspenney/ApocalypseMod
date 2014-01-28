#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = 
{
	name = "Dark Lighting Mod",
	author = "Lucas Penney",
	description = "Allows for the server to darken the maps lighting",
	version = "1.0",
	url = "http://apocalypsemod.com/"
}

public OnMapStart()
{
	//This is a stock sdktools function
	/*
	
	SetLightStyle(style, const String:value[])
	
	Syntax:
	 native SetLightStyle(style, const String:value[]);

	Usage:
	 style			Light style (from 0 to MAX_LIGHTSTYLES-1)
	 value			Light value string (see world.cpp/light.cpp in dlls)
	Notes:
	 Sets a light style.

	Return:
	 No return.
	
	*/
	SetLightStyle(0, "b");
	
	//Other possible values
	/*
	"a" - super dark
	"m" - normal 
	"mmnmmommommnonmmonqnmmo" - FLICKER (first variety)
	"abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba" - SLOW STRONG PULSE
	"mmmmmaaaaammmmmaaaaaabcdefgabcdefg" -  CANDLE (first variety)
	"mamamamamama" - FAST STROBE
	"jklmnopqrstuvwxyzyxwvutsrqponmlkj" - GENTLE PULSE 1
	"nmonqnmomnmomomno" - FLICKER (second variety)
	"mmmaaaabcdefgmmmmaaaammmaamm" - CANDLE (second variety)
	"mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa",  - CANDLE (third variety)
	"aaaaaaaazzzzzzzz"  -  SLOW STROBE (fourth variety)
	"mmamammmmammamamaaamammma"  - FLUORESCENT FLICKER
	"abcdefghijklmnopqrrqponmlkjihgfedcba"  -  SLOW PULSE NOT FADE TO BLACK
	*/
	
	//This changes server side data that is transmitted to clients when they connect and when it is applied.
	//Constant changing is not tested
	//Not all lights are effected. Specifically, any compile-time determined lighting remains the same, such as props with lighting_origins.
	//This can result in strange lighting that may have to compensated with other lighting effects
}