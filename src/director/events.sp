/*****************************************
				Events
*****************************************/

public Action:Event_InfectedDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	AddIntensity(GetRandomInt(1, 2));
	if (anger <= 2) AddIntensity(1);
}

public Action:Event_InfectedHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (GetRandomInt(1, 10) == 1) AddIntensity(1);
}

public Action:Event_FriendlyFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	AddIntensity(3);
}

public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	new userid2 = GetEventInt(event, "attacker");
	new attacker = GetClientOfUserId(userid2);
	new attackerent = GetEventInt(event, "attackerentid");
	if (client <= 0 || client > 8 && !IsClientInGame(client)) return Plugin_Continue;
	if (attacker <= 0) attacker = 1;
	decl String:attackerclass[64];
	if (attackerent != -1) GetEdictClassname(attackerent, attackerclass, sizeof(attackerclass));
	if (IsClientInGame(client))
	{
		if (StrEqual(attackerclass, "infected", false))
		{ //Attacker was an infected
			if (GetClientTeam(client) == 2) AddIntensity(2);
		}
		else if (GetClientTeam(attacker) == 3)
		{
			if (GetRandomInt(1, 6) == 1) AddIntensity(1);
		}
	}
	return Plugin_Continue;
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	//new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (!IsValidClient(victim)) return;	
	if (IsClientInfected(victim))
	{
		AddIntensity(5);
	}
	else if (IsClientSurvivor(victim))
	{
		AddIntensity(12);
	}
}

public Action:Event_PlayerIncap(Handle:event, const String:name[], bool:dontBroadcast)
{

}

public Action:Event_TankKilled(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (finalestarted)
	{
		CreateTimer(4.0, FinaleTankDeath);
	}
}

public Action:Event_FinaleStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (gamemode == 1) CoopFinale();
}

public Event_WitchKilled(Handle: event, const String: name[], bool: dontBroadcast)
{
	if (gamemode == 1 && intensity < 20 && anger > 5) SpawnHorde();
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	decl String:killer[128]; 
	GetClientName(client, killer, sizeof(killer));
}

public Action:Event_WeaponReload(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (GetRandomInt(1, 5) == 1) intensity++;
}


public Action:Event_PlayerLeftStartArea(Handle:event, const String:name[], bool:dontBroadcast)
{
	//Deprecated
}


public Action:Event_PlayerNowIt(Handle:event, const String:name[], bool:dontBroadcast)
{
	//Used in old apoc versus to increase zombies after a successful boom
}
