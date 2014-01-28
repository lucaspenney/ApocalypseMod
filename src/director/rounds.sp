public OnMapStart()
{
	transition = true;
}

public OnMapEnd()
{
	ResetDirector();
	transition = true;
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	ResetDirector();
	if (gamemode == 2) VersusRemoveItems();
	roundstarted = true;
	CreateTimer(2.0, StartRandomizing, _, TIMER_REPEAT);
	DebugMessage("Event_RoundStart");
} 

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	ResetDirector();
	RemoveGuns();
	roundstarted = false;
	transition = false;
	DebugMessage("Event_RoundEnd");
}

public Action:Event_MapTransition(Handle:event, const String:name[], bool:dontBroadcast)
{
	ResetDirector();
	roundstarted = false;
	transition = true;
}

/*****************************************
				Left Safe Area
*****************************************/

public Action:Event_PlayerLeftCheckpoint(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	if (userid != 0 && gamemode == 1 && !leftsafearea && ingame)
	{
		leftsafearea = true;
		SurvivorsLeaveSafeArea();
	}
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (!ingame)
	{
		if (GetClientTeam(GetClientOfUserId(GetEventInt(event, "userid"))) == 2)
		{
			leftsafearea = false;
			ingame = false;
			if (transition) CreateTimer(5.5, InGame);
			else CreateTimer(4.0, InGame);
		}
	}
}

public Action:InGame(Handle:timer)
{
	ingame = true;
}

public Action:Event_PlayerUse(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	if (gamemode == 2)
	{
		VersusPlayerUse(client);
	}
}

SurvivorsLeaveSafeArea()
{
	DebugMessage("Dynamic Director Activated");
	CreateTimer(1.0, SpecialTimer, _, TIMER_REPEAT);
	CreateTimer(1.0, AngerTimer, _, TIMER_REPEAT);
	CreateTimer(1.0, MobController, _, TIMER_REPEAT);
	CreateTimer(1.0, BossController, _, TIMER_REPEAT);
	CreateTimer(60.0, RoundTimeCounter, _, TIMER_REPEAT);
	CreateTimer(0.5, PostProcessTimer, _, TIMER_REPEAT);
}

public Action:RoundTimeCounter(Handle:Timer)
{
	if (!leftsafearea)
	{
		return Plugin_Stop;
	}
	else
	{
		roundtime++;
	}
	return Plugin_Continue;
}

//Resets director, called on map end, round start, and round end.
public ResetDirector()
{
	anger = 0;
	intensity = 0;
	leftsafearea = false;
	vs_billgiven = false;
	vs_francisgiven = false;
	vs_louisgiven = false;
	vs_zoeygiven = false;
	finalestarted = false;
	finaletanks = 0;
	finaleboss = false;
	isfinale = false;
	gunsrandomized = false;
	roundstarted = false;
	ingame = false;
	lastmobtime = 0;
	canpanic = true;
	spawnedbosses = 0;
	roundtime = 0;
	SurvivalReset()
	//Re-Get gamemode and difficulty
	GameMode = FindConVar("mp_gamemode");	
	decl String:sGameMode[16];
	GetConVarString(GameMode, sGameMode, sizeof(sGameMode));
	GetCurrentMap(mapname, 128);
	if (StrEqual(sGameMode, "coop", false))
	{
		gamemode = 1;
		//Get Difficulty on Round Start
		new Handle:hdifficulty;
		hdifficulty = FindConVar("z_difficulty");
		decl String:sdifficulty[16];
		GetConVarString(hdifficulty, sdifficulty, sizeof(sdifficulty));
		if (StrEqual(sdifficulty, "easy", false)) difficulty = 1;
		else if (StrEqual(sdifficulty, "normal", false)) difficulty = 2;
		else if (StrEqual(sdifficulty, "hard", false)) difficulty = 3;
		else if (StrEqual(sdifficulty, "impossible", false)) difficulty = 3;
	}
	else if (StrEqual(sGameMode, "versus", false))
	{
		difficulty = 2;
		gamemode = 2;
	}
	else
	{
		difficulty = 2;
		gamemode = 3;
	}
	decl String:map[128];
	GetCurrentMap(map, 128);
	if (StrContains(map, "05_") != -1 || StrContains(map, "_garage02_") != -1 || StrContains(map, "_river03_") != -1)
	{
		isfinale = true;
	}
}
