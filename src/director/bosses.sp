/*****************************************
				Boss Infected
*****************************************/

public Action:BossController(Handle:timer)
{
	if (gamemode != 1) return Plugin_Stop;
	if (!leftsafearea) return Plugin_Stop;
	if (finalestarted) return Plugin_Stop;
	static bossticks = 0;
	bossticks++;
	if (bossticks >= BOSS_INTERVAL)
	{
		bossticks = 0;
		new chance;
		new bool:shouldspawn = false;
		new maxbosses;
		if (difficulty == 4) maxbosses = 2;
		else if (difficulty == 3) maxbosses = 3;
		else maxbosses = 4;
		if (anger >= 7)
		{
			chance = 4;
		}
		else if (anger >= 4) 
		{
			chance = 5;
		}
		else if (anger <= 3)
		{
			chance = 6;
		}
		if (GetRandomInt(1, chance) == 1)
		{
			shouldspawn = true;
		}
		//Additional checks where the director shouldn't spawn a boss
		if (spawnedbosses >= maxbosses)
		{
			shouldspawn = false;
		}
		if (finalestarted)
		{
			shouldspawn = false;
		}
		if (isfinale)
		{
			shouldspawn = false;
		}
		if (shouldspawn)
		{ 
			SpawnRandomBoss();
		}
	}
	return Plugin_Continue;
}

SpawnRandomBoss()
{
	new rand = GetRandomInt(1, 5);
	if (rand == 1)
	{
		SpawnTank();
	}
	else if (rand == 2 || rand == 3)
	{
		SpawnWitch();
	}
	else if (rand == 4)
	{
		SetTankHealth(tankhealth / 2);
		SpawnTank();
		SpawnTank();
	}
	else if (rand == 5)
	{
		SpawnWitch();
		SpawnWitch();
	}
	spawnedbosses++;
	DebugMessage("Boss Spawned!");
}
