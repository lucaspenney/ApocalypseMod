#include <sourcemod>
#include <sdktools>
#include <apocalypse>

public Plugin:myinfo = 
{
	name = "Custom Items",
	author = "Luke",
	description = "Apocalypse Mod Custom Items",	
	version = "1.0",
	url = "http://apocalypsemod.com/",
}

public OnPluginStart() 
{
	HookEvent("player_use", Event_PlayerUse, EventHookMode_Post);
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundStart, EventHookMode_Post);
	HookEvent("map_transition", Event_RoundStart, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	RegConsoleCmd("use_customitem_6", ButtonPressed);
	RegConsoleCmd("customitemmenu", ForceMenu);
}


public OnMapStart()
{
	decl Particle;
	
	//Initialize:
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{

		//Properties:
		DispatchKeyValue(Particle, "effect_name", "flare_burning");
		
		//Spawn:
		DispatchSpawn(Particle);
		ActivateEntity(Particle);
		AcceptEntityInput(Particle, "start");
		
		//Delete:
		CreateTimer(0.3, DeleteParticle, Particle, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:DeleteParticle(Handle:Timer, any:Particle)
{
	if(IsValidEntity(Particle))
	{
		decl String:Classname[64];
		GetEdictClassname(Particle, Classname, sizeof(Classname));
		if(StrEqual(Classname, "info_particle_system", false))
		{
			RemoveEdict(Particle);
		}
	}
}

public Action:DeleteEntity(Handle:Timer, any:ent)
{
	AcceptEntityInput(ent, "kill");
}


//**********************************
//       Client Item System
//**********************************

//How this will work:

//Menu lets them choose an item.
//
// 
//Each survivor gets their own variable (tied to the model)
new bill;
new francis;
new louis;
new zoey;
new billchosen;
new francischosen;
new louischosen;
new zoeychosen;

new bool:billdeploy;
new bool:francisdeploy;
new bool:louisdeploy;
new bool:zoeydeploy;

new clientitem[MAXPLAYERS+1] [2]; //Stores ent id's for the clients items, used for keeping track of them in game

// Item ID List
//
//-1. Error
// 0. Nothing
// 1. Flares x1
// 2. Flares x2
// 2. Flares x3
// 4. Ammo Box
// 5. Trip Mine




public OnClientPutInServer(client)
{
	ClientCommand(client, "bind 6 \"use_customitem_6; slot6\"");
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	bill = 0;
	francis = 0;
	louis = 0;
	zoey = 0;
	billchosen = 0;
	francischosen = 0;
	louischosen = 0;
	zoeychosen = 0;
}

public Action:Event_PlayerUse(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new i = GetClientOfUserId(userid);
	new String:model[50];
	GetClientModel(i, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_namvet.mdl", false) == 0)
	{
		if (!billchosen)
		{
			Bill(i);
			billchosen = true;
		}
	}
	else if (strcmp(model, "models/survivors/survivor_biker.mdl", false) == 0)
	{
		if(!francischosen)
		{
			Francis(i);
			francischosen = true;
		}
	}
	else if (strcmp(model, "models/survivors/survivor_manager.mdl", false) == 0)
	{
		if (!louischosen)
		{
			Louis(i);
			louischosen = true;
		}
	}
	else if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0)
	{
		if (!zoeychosen)
		{
			Zoey(i);
			zoeychosen = true;
		}
	}
}

Bill(client)
{
	new Handle:menu = CreateMenu(MenuHandler);
	SetMenuTitle(menu, "Choose your safehouse item:");
	AddMenuItem(menu, "flares", "Military Flares");
	AddMenuItem(menu, "ammo", "Ammo Pack");
	AddMenuItem(menu, "lantern", "Lantern");
	AddMenuItem(menu, "bomb", "Battery Trip Mine");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, client, 30)
}

Francis(client)
{
	new Handle:menu = CreateMenu(MenuHandler);
	SetMenuTitle(menu, "Choose your safehouse item:");
	AddMenuItem(menu, "flares", "Military Flares");
	AddMenuItem(menu, "ammo", "Ammo Pack");
	AddMenuItem(menu, "lantern", "Lantern");
	AddMenuItem(menu, "bomb", "Battery Trip Mine");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, client, 30)
}

Louis(client)
{
	new Handle:menu = CreateMenu(MenuHandler);
	SetMenuTitle(menu, "Choose your safehouse item:");
	AddMenuItem(menu, "flares", "Military Flares");
	AddMenuItem(menu, "ammo", "Ammo Pack");
	AddMenuItem(menu, "lantern", "Lantern"); 
	AddMenuItem(menu, "bomb", "Battery Trip Mine");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, client, 30)
}

Zoey(client)
{
	new Handle:menu = CreateMenu(MenuHandler);
	SetMenuTitle(menu, "Choose your safehouse item:");
	AddMenuItem(menu, "flares", "Military Flares");
	AddMenuItem(menu, "ammo", "Ammo Pack");
	AddMenuItem(menu, "lantern", "Lantern"); 
	AddMenuItem(menu, "bomb", "Battery Trip Mine");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, client, 30)
}



public MenuHandler(Handle:menu, MenuAction:action, param1, param2)
{
	/* If an option was selected, tell the client about the item. */
	if (action == MenuAction_Select)
	{
		new String:name[40];
		GetClientName(param1, name, 40);
		if (param2 == 0)
		{
			GiveClientItem(param1, 3);
			PrintToChatAll("%s has chosen Military Flares", name);
		}
		if (param2 == 1)
		{
			GiveClientItem(param1, 4);
			PrintToChatAll("%s has chosen Ammo Pack", name);
		}
		if (param2 == 2)
		{
			GiveClientItem(param1, 5);
			PrintToChatAll("%s has chosen a Lantern", name);
		}
		if (param2 == 3)
		{
			GiveClientItem(param1, 7);
			PrintToChatAll("%s has chosen a Battery Trip Mine", name);
		}
		PrintHintText(param1, "Press your \"6\" key twice to use your custom item");
	}
	else if (action == MenuAction_Cancel)
	{
		GiveRandomItem(param1);
	}
	else if (action == MenuAction_End)
	{
		CreateTimer(10.0, GiveMenu, param1);
	} 
}

public Action:GiveMenu(Handle:timer, any:client)
{
	if (client > 0)
	{
		if (IsClientInGame(client))
		{
			ClientCommand(client, "customitemmenu");
		}
	}
}

public GiveRandomItem(client)
{
	new rand = GetRandomInt(3,6)
	GiveClientItem(client, rand);
	new String:name[40];
	GetClientName(client, name, sizeof(name));
	switch (rand)
	{
		case 3: PrintToChatAll("%s was given Military Flares because they did not chose an item", name);
		case 4: PrintToChatAll("%s was given Ammo Pack because they did not chose an item", name);
		case 5: PrintToChatAll("%s was given a Lantern because they did not chose an item", name);
		case 6: PrintToChatAll("%s was given a Battery Trip Mine because they did not choose an item", name);
	}
}


public Action:ForceMenu(client, args) 
{
	new item = GetClientItem(client);
	new String:model[50];
	GetClientModel(client, model, sizeof(model));
	new chosen;
	if (strcmp(model, "models/survivors/survivor_namvet.mdl", false) == 0)
	{
		if (billchosen)
		{
			billchosen = true;
		}
	}
	else if (strcmp(model, "models/survivors/survivor_biker.mdl", false) == 0)
	{
		if(francischosen)
		{
			francischosen = true;
		}
	}
	else if (strcmp(model, "models/survivors/survivor_manager.mdl", false) == 0)
	{
		if (louischosen)
		{
			louischosen = true;
		}
	}
	else if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0)
	{
		if (zoeychosen)
		{
			zoeychosen = true;
		}
	}
	if (item == 0)
	{
		new Handle:forcemenu = CreateMenu(MenuHandler);
		SetMenuTitle(forcemenu, "Choose your safehouse item:");
		AddMenuItem(forcemenu, "flares", "Military Flares");
		AddMenuItem(forcemenu, "ammo", "Ammo Pack");
		AddMenuItem(forcemenu, "lantern", "Lantern");
		AddMenuItem(forcemenu, "bomb", "Battery Trip Mine");
		SetMenuExitButton(forcemenu, false);
		DisplayMenu(forcemenu, client, 30);
	}
	return Plugin_Handled;
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{

}

public Action:ButtonPressed(client, args) 
{
	if (IsLouis(client))
	{
		if (louisdeploy)
		{
			UseItem(client);
			louisdeploy = false;
		}
		else
		{
			louisdeploy = true;
			CreateTimer(2.0, DeployTimer, client);
		}
	}
	if (IsZoey(client))
	{
		if (zoeydeploy)
		{
			UseItem(client);
			zoeydeploy = false;
		}
		else
		{
			zoeydeploy = true;
			CreateTimer(2.0, DeployTimer, client);
		}
	}
	if (IsBill(client))
	{
		if (billdeploy)
		{
			UseItem(client);
			billdeploy = false;
		}
		else
		{
			billdeploy = true;
			CreateTimer(2.0, DeployTimer, client);
		}
	}
	if (IsFrancis(client))
	{
		if (francisdeploy)
		{
			UseItem(client);
			francisdeploy = false;
		}
		else
		{
			francisdeploy = true;
			CreateTimer(2.0, DeployTimer, client);
		}
	}
	return Plugin_Handled;
}

public Action:DeployTimer(Handle:timer, any:client)
{
	if (IsLouis(client))
	{
		louisdeploy = false;
	}
	else if (IsZoey(client))
	{
		zoeydeploy = false;
	}
	else if (IsFrancis(client))
	{
		francisdeploy = false;
	}
	else if (IsBill(client))
	{
		billdeploy = false;
	}
}


public GiveClientItem(client, item)
{
	new String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_namvet.mdl", false) == 0)
	{
		bill = item;
		billchosen = true;
	}
	else if (strcmp(model, "models/survivors/survivor_biker.mdl", false) == 0)
	{
		francis = item;
		francischosen = true;
	}
	else if (strcmp(model, "models/survivors/survivor_manager.mdl", false) == 0)
	{
		louis = item;
		louischosen = true;
	}
	else if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0)
	{
		zoey = item;
		zoeychosen = true;
	}
}

public UseItem(client)
{
	new item = GetClientItem(client);
	if (GetClientTeam(client) == 2)
	{
		if (IsPlayerAlive(client))
		{
			if ((GetEntProp(client, Prop_Send, "m_isIncapacitated") != 0)) return; //Must be standing to use items
			switch (item)
			{
			case 1:
				{
					SpawnFlare(client, 1);
				}
			case 2:
				{
					SpawnFlare(client, 2);
				}
			case 3:
				{
					SpawnFlare(client, 3);
				}
			case 4:
				{
					SpawnAmmo(client);
				}
			case 5:
				{
					SpawnLantern(client);
				}
			case 6:
				{
					SpawnExplosive(client, 1);
				}
			case 7:
				{
					SpawnExplosive(client, 2);
				}
			}
		}
	}
}

public GetClientItem(client)
{
	new itemid;
	new String:model[50];
	GetClientModel(client, model, sizeof(model));
	if (strcmp(model, "models/survivors/survivor_namvet.mdl", false) == 0)
	{
		itemid = bill;
	}
	else if (strcmp(model, "models/survivors/survivor_biker.mdl", false) == 0)
	{
		itemid = francis;
	}
	else if (strcmp(model, "models/survivors/survivor_manager.mdl", false) == 0)
	{
		itemid = louis;
	}
	else if (strcmp(model, "models/survivors/survivor_teenangst.mdl", false) == 0)
	{
		itemid = zoey;
	}
	else
	{
		itemid = 0;
	}
	return itemid;
}

public SpawnFlare(client, amount)
{
	new Float:origin[3];
	GetClientAbsOrigin(client, origin); 
	//Spawn the prop
	new flareprop = CreateEntityByName("prop_dynamic");
	PrecacheModel("models/props_lighting/light_flares.mdl");
	if (flareprop == -1)
	{
		return;
	}
	DispatchKeyValue(flareprop, "model", "models/props_lighting/light_flares.mdl");
	DispatchKeyValue(flareprop, "targetname", "lightprop");
	DispatchKeyValue(flareprop, "fadescale", "0");
	DispatchKeyValue(flareprop, "solid", "0");
	DispatchKeyValue(flareprop, "disableshadows", "1");
	DispatchSpawn(flareprop);
	TeleportEntity(flareprop, origin, NULL_VECTOR, NULL_VECTOR);
	//Sound
	//Glow
	new lightglow = CreateEntityByName("env_lightglow");
	if (lightglow == -1)
	{
		return;
	}
	origin[2] = origin[2] + 3;
	DispatchKeyValue(lightglow, "MaxDist", "1");
	DispatchKeyValue(lightglow, "MinDist", "1");
	DispatchKeyValue(lightglow, "OuterMaxDist", "750");
	DispatchKeyValue(lightglow, "targetname", "lightglow");
	DispatchKeyValue(lightglow, "HorizontalGlowSize", "10");
	DispatchKeyValue(lightglow, "VerticalGlowSize", "10");
	DispatchKeyValue(lightglow, "rendercolor", "255 20 20");
	DispatchSpawn(lightglow);
	TeleportEntity(lightglow, origin, NULL_VECTOR, NULL_VECTOR);
	CreateTimer(90.0, DeleteEntity, lightglow);
	//Light
	origin[2] = origin[2] + 27;
	new light = CreateEntityByName("light_dynamic");
	if (light == -1)
	{
		return;
	}
	DispatchKeyValue(light, "targetname", "light");
	DispatchKeyValue(light, "_light", "255 10 10");
	DispatchKeyValue(light, "distance", "175");
	DispatchKeyValue(light, "spotlight_radius", "0");
	DispatchKeyValue(light, "origin", "0 0 0");
	DispatchKeyValue(light, "brightness", "6");
	DispatchKeyValue(light, "style", "0");
	DispatchKeyValue(light, "spawnflags", "0");
	DispatchKeyValue(light, "parent", "lightprop");

	DispatchSpawn(light);
	TeleportEntity(light, origin, NULL_VECTOR, NULL_VECTOR);
	CreateTimer(90.0, DeleteEntity, light);
	//Smoke
	decl Particle;

	//Initialize:
	origin[2] = origin[2] - 27;
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{
		//Send:
        TeleportEntity(Particle, origin, NULL_VECTOR, NULL_VECTOR);
		//Properties:
		DispatchKeyValue(Particle, "targetname", "L4DParticle");
		DispatchKeyValue(Particle, "effect_name", "flare_burning");

		//Spawn:
		DispatchSpawn(Particle);
		ActivateEntity(Particle);
		AcceptEntityInput(Particle, "start");
		CreateTimer(90.0, DeleteEntity, Particle);
	}
	amount = amount - 1;
	if (amount == 0)
	{
		GiveClientItem(client, 0);
	}
	else
	{
		GiveClientItem(client, amount);
	}
}

public SpawnAmmo(client)
{
	new Float:origin[3];
	GetClientAbsOrigin(client, origin); 
	origin[2] = origin[2] - 2;
	//Spawn the prop
	new ammo = CreateEntityByName("weapon_ammo_spawn");
	PrecacheModel("models/props_unique/spawn_apartment/coffeeammo.mdl");
	if (ammo == -1)
	{
		return;
	}
	DispatchKeyValue(ammo, "model", "models/props_unique/spawn_apartment/coffeeammo.mdl");
	DispatchKeyValue(ammo, "targetname", "ammopile");
	DispatchKeyValue(ammo, "count", "3");
	DispatchKeyValue(ammo, "solid", "0");
	DispatchKeyValue(ammo, "disableshadows", "1");
	DispatchSpawn(ammo);
	//Move origin down a bit
	
	TeleportEntity(ammo, origin, NULL_VECTOR, NULL_VECTOR);
	GiveClientItem(client, 0);
	ClientCommand(client, "vocalize playerspotammo");
}

public SpawnLantern(client)
{
	new Float:origin[3];
	GetClientAbsOrigin(client, origin); 
	new flareprop = CreateEntityByName("prop_dynamic");
	if (flareprop == -1)
	{
		return;
	}
	DispatchKeyValue(flareprop, "model", "models/props_unique/spawn_apartment/lantern.mdl");
	DispatchKeyValue(flareprop, "targetname", "lightprop");
	DispatchKeyValue(flareprop, "fadescale", "0");
	DispatchKeyValue(flareprop, "solid", "0");
	DispatchSpawn(flareprop);
	TeleportEntity(flareprop, origin, NULL_VECTOR, NULL_VECTOR);
	//Glow
	new lightglow = CreateEntityByName("env_lightglow");
	if (lightglow == -1)
	{
		return;
	}
	origin[2] = origin[2] + 3;
	DispatchKeyValue(lightglow, "MaxDist", "1");
	DispatchKeyValue(lightglow, "MinDist", "1");
	DispatchKeyValue(lightglow, "OuterMaxDist", "750");
	DispatchKeyValue(lightglow, "targetname", "lightglow2");
	DispatchKeyValue(lightglow, "HorizontalGlowSize", "20");
	DispatchKeyValue(lightglow, "VerticalGlowSize", "20");
	DispatchKeyValue(lightglow, "rendercolor", "150 150 255");
	DispatchSpawn(lightglow);
	TeleportEntity(lightglow, origin, NULL_VECTOR, NULL_VECTOR);
	//Light
	origin[2] = origin[2] + 30;
	new light = CreateEntityByName("light_dynamic");
	if (light == -1)
	{
		return;
	}
	DispatchKeyValue(light, "targetname", "light");
	DispatchKeyValue(light, "_light", "150 150 255");
	DispatchKeyValue(light, "distance", "225");
	DispatchKeyValue(light, "spotlight_radius", "0");
	DispatchKeyValue(light, "origin", "0 0 0");
	DispatchKeyValue(light, "brightness", "5");
	DispatchKeyValue(light, "style", "0");
	DispatchKeyValue(light, "spawnflags", "0");
	DispatchKeyValue(light, "parent", "lightprop");

	DispatchSpawn(light);
	TeleportEntity(light, origin, NULL_VECTOR, NULL_VECTOR);
	GiveClientItem(client, 0);
}

public SpawnExplosive(client, amount)
{
	new Float:origin[3];
	GetClientAbsOrigin(client, origin); 
	new String:name[32];
	GetClientName(client, name, sizeof(name));
	//Spawn the prop
	new bombprop = CreateEntityByName("prop_dynamic");
	PrecacheModel("models/props_lighting/light_battery_rigged_01.mdl");
	if (bombprop == -1)
	{
		return;
	}
	DispatchKeyValue(bombprop, "model", "models/props_lighting/light_battery_rigged_01.mdl");
	DispatchKeyValue(bombprop, "targetname", name);
	DispatchKeyValue(bombprop, "fadescale", "0");
	DispatchKeyValue(bombprop, "solid", "0");
	DispatchKeyValue(bombprop, "disableshadows", "1");
	DispatchSpawn(bombprop);
	TeleportEntity(bombprop, origin, NULL_VECTOR, NULL_VECTOR);
	
	new bomb = CreateEntityByName("prop_physics");
	PrecacheModel("models/props_junk/propanecanister001a.mdl");
	if (bomb == -1)
	{
		return;
	}
	DispatchKeyValue(bomb, "model", "models/props_junk/propanecanister001a.mdl");
	DispatchKeyValue(bomb, "targetname", name);
	DispatchKeyValue(bomb, "fadescale", "0");
	DispatchKeyValue(bomb, "disableshadows", "1");
	DispatchKeyValue(bomb, "rendermode", "10");
	DispatchKeyValue(bomb, "spawnflags", "1805");
	DispatchKeyValue(bomb, "minhealthdmg", "900");
	DispatchSpawn(bomb);
	TeleportEntity(bomb, origin, NULL_VECTOR, NULL_VECTOR);
	//Spawn the trigger_once that triggers the explosion
	new entindex = CreateEntityByName("trigger_once");
	if (entindex != -1)
	{
		DispatchKeyValue(entindex, "spawnflags", "3");
		DispatchKeyValue(entindex, "filtername", "infected_only_filter");
		new String:buffer[128];
		Format(buffer, sizeof(buffer), "%s,Break,,0,-1", name);
		new String:buffer2[128];
		Format(buffer2, sizeof(buffer2), "%s,Kill,,1,-1", name);
		DispatchKeyValue(entindex, "OnTrigger", buffer);
		DispatchKeyValue(entindex, "OnTrigger", buffer2);
	}

	DispatchSpawn(entindex);
	ActivateEntity(entindex);
	
	TeleportEntity(entindex, origin, NULL_VECTOR, NULL_VECTOR);
	PrecacheModel("models/props_street/police_barricade2.mdl");
	SetEntityModel(entindex, "models/props_street/police_barricade2.mdl");
	
	new Float:minbounds[3] = {-60.0, -60.0, 0.0};
	new Float:maxbounds[3] = {60.0, 60.0, 120.0};
	SetEntPropVector(entindex, Prop_Send, "m_vecMins", minbounds);
	SetEntPropVector(entindex, Prop_Send, "m_vecMaxs", maxbounds);
	
	SetEntProp(entindex, Prop_Send, "m_nSolidType", 2);
	new enteffects = GetEntProp(entindex, Prop_Send, "m_fEffects");
	enteffects |= 32;
	SetEntProp(entindex, Prop_Send, "m_fEffects", enteffects);
	amount = amount - 1;
	if (amount == 0)
	{
		GiveClientItem(client, 0);
	}
	else
	{
		GiveClientItem(client, 6);
	}
}