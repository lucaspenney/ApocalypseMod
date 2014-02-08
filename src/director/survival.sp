/*****************************************
			Survival
*****************************************/  


new svRandSeed;
new bool:svStarted;


SurvivalReset()
{
	svTime = 0;
	svLastEventTime = 0;
	svStarted = false;
}

SurvivalStart()
{
	//Survival cvar changes take place in apocalypsemod.sp
	svStarted = true;
	CreateTimer(1.0, AngerTimer, _, TIMER_REPEAT);
	CreateTimer(1.0, SurvivalTimer, _, TIMER_REPEAT);
	svRandSeed = GetRandomInt(-2, 2);
	
	SetCommonLimit(30);
	SpawnMob();SpawnMob();SpawnMob();
	SpawnMob();SpawnMob();SpawnMob();
	SetCommonLimit(4);
	DebugMessage("Survival Start");
}



public Action:SurvivalTimer(Handle:timer)
{
	if (!svStarted) return Plugin_Stop;
	SurvivalAnger();
	svTime++;
	new svTimeSinceEvent = svTime - svLastEventTime;
	if ((svTime - 15) > svLastEventTime) //seconds passed since the last event
	{
		//Time to start thinking about sending more
		//TODO: Send new event if a) Low intensity b) Lots of time since last event c) Account higher anger
		new bool:sendevent = false;
		if (svTime/60 <= 4)
		{
			if (intensity < 25) sendevent = true;
			if (svTimeSinceEvent > 35) sendevent = true;
			
		}
		else if (svTime/60 >= 5 && svTime/60 <=8)
		{
			if (intensity < 45) sendevent = true;
			if (intensity > 80) sendevent = false;
			if (svTimeSinceEvent > 30) sendevent = true;
		}
		else if (svTime/60 >= 9)
		{
			if (svTimeSinceEvent > 25) sendevent = true;
			if (intensity < 50) sendevent = true;
		}
		if (sendevent) //Basic qualification checks before considering another event
		{
			SurvivalEvent();
		}
	}
	return Plugin_Continue;
}

SurvivalAnger()
{
	svAnger = anger;
	
	//The anger changes based on the survivors current time
	//How it changes is based on svRandSeed - meaning that it could be anywhere from -2 to +2 different
	
	if (svTime/60 <= 1)
	{
		svAnger -= 3;
	}
	else if (svTime/60 <= 2)
	{
		svAnger -= 2;
	}
	else if (svTime/60 == 5+svRandSeed)
	{
		svAnger++;
	}
	else if (svTime/60 == 6+svRandSeed || svTime/60 == 7+svRandSeed)
	{
		svAnger += 2;
	}
	else if (svTime/60 == 8+svRandSeed || svTime/60 == 9+svRandSeed)
	{
		svAnger += 3;
	}
	else if (svTime/60 >= 10+svRandSeed)
	{
		svAnger += GetRandomInt(3,5);
	}
	else if (svTime/60 >= 13+svRandSeed)
	{
		svAnger += GetRandomInt(4,8);
	}
}


SurvivalEvent()
{
	svLastEventTime = svTime;
	SetCommonLimit(4);
	//At this point, svAnger is anywhere around -5 to 20. Instead of accounting for all cases
	//the event will be decided based on the anger more algorithmically
	
	//First, get anger to 1 if it's below
	if (svAnger <= 1)
	{
		svAnger = 1;
		if (GetRandomInt(0, 1) == 1)
		{
			//Rest event
			CreateTimer(1.0, SurvivalRest);
			DebugMessage("Survival Event - Rest");
		}
	}
	if (svAnger == 2)
	{
		if (GetRandomInt(0, 2) == 1)
		{
			//Rest
			CreateTimer(1.0, SurvivalRest);
			DebugMessage("Survival Event - Rest2");
		}
	}
	
	new svTankChance = GetRandomInt(-1, svAnger);
	new svSpecialChance = GetRandomInt(0, svAnger); //Specials get a little boost as they are less severe
	new svMobChance = GetRandomInt(0, svAnger);
	
	new bool:tank = false;
	new bool:special = false;
	new bool:mob = false;

	//More double events when into the game, and only 75% of the time
	if (svTime/60 > GetRandomInt(2,4) && GetRandomInt(1, 3) > 1)
	{
		if (svTankChance > svSpecialChance && svTankChance > svMobChance)
		{
			tank = true;
			if (svSpecialChance > svMobChance) special = true;
			else mob = true;
		}
		else if (svSpecialChance > svTankChance && svSpecialChance > svMobChance)
		{
			special = true;
			if (svTankChance > svMobChance) tank = true;
			else mob = true;
		}
		else if (svMobChance > svSpecialChance && svMobChance > svTankChance)
		{
			mob = true;
			if (svTankChance > svSpecialChance) tank = true;
			else special = true;
		}
	}
	else
	{
		if (svTankChance > svSpecialChance && svTankChance > svMobChance)
		{
			tank = true;
		}
		else if (svSpecialChance > svTankChance && svSpecialChance > svMobChance)
		{
			special = true;
		}
		else if (svMobChance > svSpecialChance && svMobChance > svTankChance)
		{
			mob = true;
		}
	}
	
	if (!mob && !special && !tank)
	{
		new rands = GetRandomInt(1, 3);
		if (rands == 1) mob = true;
		else if (rands == 2) special = true;
		else if (rands == 3) tank = true;
	}
	
	
	//We've now decided what we're going to do for the event (tanks, special, mobs) - Now do it
	//The severity should be based off anger
	//These are not elseifs as it's possible more than one will apply
	if (mob)
	{
		DebugMessage("Survival Event - Mob");
		new svMobSize = svAnger * 4;
		if (svMobSize < 8) svMobSize = 8;
		else if (svMobSize > 40) svMobSize = 40;
		SetCommonLimit(svMobSize);
		SpawnMob(); SpawnMob(); SpawnMob();
		SpawnMob(); SpawnMob(); SpawnMob();
		SpawnMob(); SpawnMob(); SpawnMob();
	}
	if (special)
	{
		DebugMessage("Survival Event - Special");
		new tospawn = svAnger / 3;
		if (tospawn <= 0 ) tospawn = 1;
		while (tospawn > 0)
		{
			new rands = GetRandomInt(1,3);
			if (rands == 1) SpawnHunter();
			else if (rands == 2) SpawnSmoker();
			else if (rands == 3) SpawnBoomer();
			tospawn--;
		}
	}
	if (tank)
	{
		new svTankHealth = svAnger * 200;
		if (svAnger > GetRandomInt(7, 11))
		{
			svTankHealth = svTankHealth / 3;
			SetTankHealth(svTankHealth);
			SpawnTank();
			SpawnTank();
			SpawnTank();
			DebugMessage("Survival Event - 3 Tanks");
		}
		else if (GetRandomInt(1, 5) == 4)
		{
			svTankHealth = svTankHealth / 5;
			SetTankHealth(svTankHealth);
			SpawnTank();
			SpawnTank();
			SpawnTank();
			SpawnTank();
			DebugMessage("Survival event - 4 tanks.");
		}
		else 
		{
			SetTankHealth(svTankHealth);
			SpawnTank();
			DebugMessage("Survival Event - Tank");
		}
	}
	
}


public Action:SurvivalRest(Handle:timer)
{
	SetCommonLimit(4);
}
