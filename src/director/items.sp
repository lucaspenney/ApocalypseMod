/*****************************************
			Random Gun Spawns
*****************************************/

public Action:StartRandomizing(Handle:timer)
{
	if (gunsrandomized) return Plugin_Handled;
	for (new client=1; client<=MaxClients; client++)
	{
		if (IsClientConnected(client))
		{
			if (IsClientInGame(client) && !IsFakeClient(client))
			{
				if (!IsClientObserver(client) && !IsClientTimingOut(client))
				{
					if (transition)
					{
						if (ingame)
						{
							//RandomizeGuns();
							return Plugin_Stop;
						}
					}
					else
					{
						//RandomizeGuns();
						return Plugin_Stop;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
/*
Removed for now...
RandomizeGuns()
{
	if (gamemode == 2 || gamemode == 3) return;
	if (gunsrandomized) return;
	gunsrandomized = true;
	DebugMessage("Gun Spawns Randomized");
	new EntCount = GetEntityCount();
	new j,i;
	new String:EdictName[128];
	new Float:angles[3];
	new Float:origin[3];
	for (i = 0; i <= EntCount; i++)
	{
		if (IsValidEntity(i))
		{
			GetEdictClassname(i, EdictName, sizeof(EdictName));
			if (StrContains(EdictName, "prop_dynamic", false) != -1)
			{
				new String:model[128];
				GetEntPropString(i, Prop_Data, "m_ModelName", model, sizeof(model));
				if (StrEqual(model, "models/error.mdl", true) && strlen(model) < 19)
				{
						GetEntPropVector(i, Prop_Send, "m_vecOrigin", origin);
						GetEntPropVector(i, Prop_Send, "m_angRotation", angles);
						AcceptEntityInput(i, "Kill");
						new random = GetRandomInt(1, (GetRandomInt(5, 6)));
						new newweapon;
						switch(random)
						{
						case 1: newweapon = CreateEntityByName("weapon_pumpshotgun_spawn");
						case 2: newweapon = CreateEntityByName("weapon_autoshotgun_spawn");
						case 3: newweapon = CreateEntityByName("weapon_smg_spawn");
						case 4: newweapon = CreateEntityByName("weapon_hunting_rifle_spawn");
						case 5: newweapon = CreateEntityByName("weapon_rifle_spawn");
						}
						if (newweapon != -1)
						{
							DispatchKeyValue(newweapon, "disableshadows", "0");
							DispatchKeyValue(newweapon, "count", "7");
							DispatchKeyValue(newweapon, "solid", "6");
							DispatchKeyValue(newweapon, "spawnflags", "0");
							DispatchKeyValueVector(newweapon, "origin", origin);
							DispatchKeyValueVector(newweapon, "angles", angles);
							//origin[2] += 0.1;
							DispatchSpawn(newweapon);
							TeleportEntity(newweapon, origin, angles, NULL_VECTOR);
						}
				}
			}
		}
	}
	leftsafearea = false;
}
*/

RemoveGuns()
{
	if (gamemode != 1) return;
	DebugMessage("Guns Removed from map");
	new EntCount = GetEntityCount();
	new j,i;
	new String:EdictName[128];
	new String:WeaponName[128];
	new weapon;
	
	for (j = 1; j <= MaxClients; j++)
	{
		if (IsClientInGame(j) && GetClientTeam(j)==2 && !IsFakeClient(j))
		{
			weapon = GetEntPropEnt(j, Prop_Send, "m_hActiveWeapon");  
			if (IsValidEdict(weapon))
			{
				GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
			}
			for (i = 0; i <= EntCount; i++)
			{
				if (IsValidEntity(i))
				{
					GetEdictClassname(i, EdictName, sizeof(EdictName));
					if (StrContains(EdictName, "weapon_rifle", false) != -1 || StrContains(EdictName, "weapon_smg", false) != -1 || StrContains(EdictName, "weapon_pumpshotgun", false) != -1 || StrContains(EdictName, "weapon_hunting_rifle", false) != -1 || StrContains(EdictName, "weapon_autoshotgun", false) != -1)
					{
						if (!StrEqual(WeaponName, EdictName))
						{
							AcceptEntityInput(i, "Kill");
						}
					}
				}
			}
		}
	}
}
