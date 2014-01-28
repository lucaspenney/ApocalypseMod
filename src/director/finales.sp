/*****************************************
Dynamic Finales
*****************************************/

CoopFinale()
{
	finalestarted = true;
	decl String:map[128];
	GetCurrentMap(map, 128);
	if (StrContains(map, "_river_") != -1) return; //No dynamic finales on The Sacrifice
	CreateTimer(5.0, CoopFinaleBegin);
	SetCommonLimit(20);
	//All these mob spawns are to ensure a constant horde state while the commonlimit varies
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
	SpawnMob(); SpawnMob();
}

public Action:CoopFinaleBegin(Handle:timer)
{
	if (anger >= 7) finaleanger = GetRandomInt(2, 4);
	else if (anger <= 4) finaleanger = GetRandomInt(1, 3);
	else finaleanger = GetRandomInt(2,3);
	EntFire("trigger_finale DisableEscapeSequence");
	SetCommonLimit(20);
	SpawnMob();
	CreateTimer(15.0, FinaleActionTimer, _, TIMER_REPEAT);
}

public Action:FinaleActionTimer(Handle:timer)
{
	if (!finalestarted) return Plugin_Stop;
	SpawnMob();
	SpawnMob();
	SpawnMob();
	if (tanks == 0)
	{
		if (finaleanger >= 1)
		{
			if (GetRandomInt(1, 3) == 1 && !finaleboss)
			{
				DebugMessage("Transitioning into Finale Boss Stage");
				CreateTimer(5.0, FinaleSpawnBoss, _, TIMER_REPEAT);
				finaleboss = true;
			}
		}
		else
		{
			EntFire("trigger_finale EnableEscapeSequence");
			EntFire("trigger_finale FinaleEscapeStarted");
			DebugMessage("Finale Escape Started");
			CreateTimer(4.0, FinaleEscape);
			return Plugin_Stop;
		}
	}
	return Plugin_Continue;
}

public Action:FinaleSpawnBoss(Handle:timer)
{
	SetCommonLimit(1);
	SpawnMob();
	if (commons <= 6 && tanks == 0)
	{
		new rand = GetRandomInt(1, 5);
		finaleanger--;
		switch (rand)
		{
		case 1:
			{
				SetCommonLimit(1);
				SpawnTank();
				finaletanks = 1;
				DebugMessage("Dynamic Finale: Tank");
			}
		case 2:
			{
				SetTankHealth(tankhealth / 3);
				SpawnTank();
				SpawnTank();
				finaletanks = 2;
				DebugMessage("Dynamic Finale: 2 Tanks");
			}
		case 3:
			{
				SpawnTank();
				SetTankHealth(tankhealth / 5);
				SpawnTank();
				SpawnTank();
				finaletanks = 3;
				SpawnMob();
				DebugMessage("Dynamic Finale: Strong tank and 2 weak tank");
			}
		case 4:
			{
				SetTankHealth(tankhealth / 4);
				SpawnTank();
				SpawnTank();
				SpawnTank();
				finaletanks = 3;
				DebugMessage("Dynamic Finale: 3 Tanks");
			}
		case 5: 
			{
				finaleanger++;
				DebugMessage("Dynamic Finale: Rest");
				CreateTimer(5.0, FinaleTankDeath);
			}
		}
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:FinaleTankDeath(Handle:timer)
{
	if (finalestarted) finaletanks--;
	if (finaletanks <= 0)
	{
		SetCommonLimit(20);
		SpawnMob();
		SpawnMob();
		SpawnMob();
		SpawnMob();
		DebugMessage("Finale Tank Stage Complete");
		finaleboss = false;
	}
}

public Action:FinaleEscape(Handle:timer)
{
	if (!finalestarted) return;
	EmitSoundToAll(FINALEMUSIC1);
	finaleboss = true;
	SetTankHealth(tankhealth / 4);
	new tankstospawn = GetRandomInt(1, 3);
	SetCommonLimit(20);
	SpawnMob();
	SpawnMob();
	while (tankstospawn > 0)
	{
		SpawnTank();
		tankstospawn--;
	}
}
