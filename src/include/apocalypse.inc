//Apocalypse Mod Include
//
//Contains various stock functions for Apocalypse Mod
//Version 1.0
//
//http://apocalypsemod.com

/*****************************************
 Apocalypse Mod Base Include File
*****************************************/

#if !defined _sdktools_included
	#include <sdktools>
#endif

//Dynamic Director Natives (deprecated as of 0.1.0)
native DD_GetIntensity();
native DD_AddIntensity(amount);
native DD_GetAnger();
native DD_GetActiveCommons();

stock L4D1Check()
{
	decl String:sGame[256];
	GetGameFolderName(sGame, sizeof(sGame));
	if (!StrEqual(sGame, "left4dead", false))
	{
		SetFailState("Apocalypse Mod (and it's individual components) does not support lame sequels");
		ServerCommand("_restart");
	}
}

stock IsServerEmpty( bool:inGameOnly = false ) 
{
	new clients = 0;
	for( new i = 1; i <= GetMaxClients(); i++ ) 
	{
		if( ( ( inGameOnly ) ? IsClientInGame( i ) : IsClientConnected( i ) ) && !IsFakeClient( i ) ) 
		{
			clients++;
		}
	}
	if (clients == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock IsValidClient(client)
{
	if (client >= 1 && client <= 8)
	{
		if (IsClientConnected(client))
		{
			if (IsClientInGame(client))
			{
				return true;
			}
		}
	}
	return false;
}

stock String:GetMapName()
{
	decl String:buffer[512];
	GetCurrentMap(buffer, sizeof(buffer));
	return buffer;
}

//Gets any client randomly
stock GetRandomClient() 
{
	new bool:clientchosen;
	while(!clientchosen) 
	{
		new client = GetRandomInt(1, GetClientCount());
		if (IsClientInGame(client)) 
		{
			clientchosen = true;
			return client;
		}
	}
	return 0;
}
//Gets random client on the survivor team
stock GetRandomSurvivor() 
{
	new bool:clientchosen;
	while(!clientchosen) 
	{
		new client = GetRandomInt(1, GetClientCount());
		if (IsClientInGame(client) && GetClientTeam(client) == 2) 
		{
			clientchosen = true;
			return client;
		}
	}
	return 0;
}
//Gets a random client on the infected team
stock GetRandomInfected() 
{
	new bool:clientchosen;
	while(!clientchosen) 
	{
		new client = GetRandomInt(1, GetClientCount());
		if (IsClientInGame(client)) 
		{
			if (GetClientTeam(client) == 3) 
			{
				clientchosen = true;
				return client;
			}
		}
	}
	return 0;
}

stock IsClientSurvivor(client)
{
	if (GetClientTeam(client) == 2)
		return true;
	return false;
}

stock IsClientInfected(client)
{
	if (GetClientTeam(client) == 3)
		return true;
	return false;
}
//Chance allows for more interesting randomization. Quite simply, possibility
//is the "out of" value. For example, Chance(3) is a one out of 3 chance, or 33%
//Currently only works with Integers. While crude, this is a quick way to throw in some randomization
stock bool:Chance(possibility) 
{
	new bool:chancesucceed;
	if (GetRandomInt(1, possibility) == 2) 
	{
		chancesucceed = true;
	}
	else 
	{
		chancesucceed = false;
	}
	return chancesucceed;
}

stock SpawnWitch() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomSurvivor();
	FakeClientCommand(client, "z_spawn witch auto");
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnTank() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomSurvivor();
	FakeClientCommand(client, "z_spawn tank auto");
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnRandomSpecial() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomSurvivor();
	new random = GetRandomInt(1, 3);
	switch (random) 
	{
		case 1: 
		{
			FakeClientCommand(client, "z_spawn smoker auto");
		}
		case 2:
		{
			FakeClientCommand(client, "z_spawn boomer auto");
		}
		case 3: 
		{
			FakeClientCommand(client, "z_spawn hunter auto");
		}
	}
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnHunter() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomClient();
	FakeClientCommand(client, "z_spawn hunter auto");
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnSmoker() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomClient();
	FakeClientCommand(client, "z_spawn smoker auto");
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnBoomer() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomClient();
	FakeClientCommand(client, "z_spawn boomer auto");
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnMob() 
{
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	new client = GetRandomClient();
	FakeClientCommand(client, "z_spawn mob");
	SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);
}

stock SpawnHorde() 
{
	new flags = GetCommandFlags("director_force_panic_event");
	SetCommandFlags("director_force_panic_event", flags & ~FCVAR_CHEAT);
	new client = GetRandomClient();
	FakeClientCommand(client, "director_force_panic_event");
	SetCommandFlags("director_force_panic_event", flags|FCVAR_CHEAT);
}

stock DirectorStart()
{
	new flags = GetCommandFlags("director_start");
	SetCommandFlags("director_start", flags & ~FCVAR_CHEAT);
	ServerCommand("director_start");
	SetCommandFlags("director_start", flags|FCVAR_CHEAT);
}

stock DirectorStop() 
{
	new flags = GetCommandFlags("director_stop");
	SetCommandFlags("director_stop", flags & ~FCVAR_CHEAT);
	ServerCommand("director_stop");
	SetCommandFlags("director_stop", flags|FCVAR_CHEAT);
}

stock CreateTriggerOnce(Float:origin[3], Float:size, String:ontrigger[50])
{
	new ent = CreateEntityByName("trigger_once");
	if (ent != -1)
	{
		DispatchKeyValue(ent, "spawnflags", "3");
		DispatchKeyValue(ent, "OnTrigger", ontrigger);
	}

	DispatchSpawn(ent);
	ActivateEntity(ent);
	
	TeleportEntity(ent, origin, NULL_VECTOR, NULL_VECTOR);
	PrecacheModel("models/props_street/police_barricade2.mdl");
	SetEntityModel(ent, "models/props_street/police_barricade2.mdl");
	new minsize = 0 - size;
	new Float:minbounds[3] = {minsize, minsize, 0.0};
	new Float:maxbounds[3] = {size, size, size};
	SetEntPropVector(ent, Prop_Send, "m_vecMins", minbounds);
	SetEntPropVector(ent, Prop_Send, "m_vecMaxs", maxbounds);
	
	SetEntProp(ent, Prop_Send, "m_nSolidType", 2);
	new enteffects = GetEntProp(ent, Prop_Send, "m_fEffects");
	enteffects |= 32;
	SetEntProp(ent, Prop_Send, "m_fEffects", enteffects);
	GiveClientItem(client, 0);	
}

stock PercentChance(chance)
{
	new rand = GetRandomInt(0, 100);
	if (rand >= chance) return true;
	else return false;
}

stock RestartGame()
{
	SetConVarInt(FindConVar("mp_restartgame"), 1);
}

stock IsTank(client)
{
	decl String:model[40];
	GetClientModel(client, model, 40);
	if (strcmp(model, "models/infected/hulk.mdl", false) == 0) return true;
	else if (strcmp(model, "models/infected/hulk_dlc3.mdl", false) == 0) return true;
	else return false;
}

stock IsBill(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_namvet.mdl", false) == 0) return true;
	else return false;
}

stock IsFrancis(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_biker.mdl", false) == 0) return true;
	else return false;
}

stock IsLouis(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_manager.mdl", false) == 0) return true;
	else return false;
}

stock IsZoey(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0) return true;
	else return false;
}

stock IsHunter(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0) return true;
	else return false;
}

stock IsSmoker(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0) return true;
	else return false;
}

stock IsBoomer(client)
{
	decl String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0) return true;
	else return false;
}

stock EntFire(String:command[128])
{
	new flags = GetCommandFlags("ent_fire");
	SetCommandFlags("ent_fire", flags & ~FCVAR_CHEAT);
	new client = GetRandomSurvivor();
	FakeClientCommand(client, "ent_fire %s", command);
	SetCommandFlags("ent_fire", flags|FCVAR_CHEAT);
}

