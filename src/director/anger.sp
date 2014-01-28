/*****************************************
				Anger
*****************************************/

public Action:AngerTimer(Handle:timer)
{
	if (gamemode != 3 && !leftsafearea) return Plugin_Stop;
	GetSurvivorInfo();
	GetActiveInfected();
	CalculateAnger();
	DirectorAdjust(); 
	return Plugin_Continue;
}

CalculateAnger()
{
	new total = 0;
	total += survivorhealth / 9 * 11; //Scale up survivors health! 400 health -> 480 health etc
	total += survivortemphealth / 2; //Temp health is worth half
	total += survivorkits * 100;
	total += survivorpills * 30;
	total += survivorgrenades * 30;
	total -= survivorincaps * 40;
	total -= survivorlimping * 20;
	
	//total -= survivorbw * 30;
	if (total >= 901 && total <= 1000) anger = 10;
	else if (total >= 801 && total <= 900) anger = 9;
	else if (total >= 701 && total <= 800) anger = 8;
	else if (total >= 601 && total <= 700) anger = 7;
	else if (total >= 501 && total <= 600) anger = 6;
	else if (total >= 401 && total <= 500) anger = 5;
	else if (total >= 301 && total <= 400) anger = 4;
	else if (total >= 201 && total <= 300) anger = 3;
	else if (total >= 101 && total <= 200) anger = 2;
	else if (total >= 1 && total <= 100) anger = 1;
	else if (total <= 0) anger = 1;
	else if (total > 100) anger = 10;
	
	if (gamemode == 1) //Anger build up at beginning of round - starts off lower
	{
		if (roundtime <= 3)
		{
			switch (roundtime)
			{
				case 0, 1: anger -= 3;
				case 2: anger -= 2;
				case 3: anger--;
			}
		}
	}
	//Ensure proper anger
	if (anger <= 0) anger = 1;
	else if (anger > 10) anger = 10;
}
 
//This loops through all survivors and gets the information that the DD can use

GetSurvivorInfo()
{
	//Reset variables before the loop, as we're getting new data
	survivorhealth = 0; 
	survivortemphealth = 0;
	survivorkits = 0;
	survivorpills = 0;
	survivorgrenades = 0;
	survivorlimping = 0;
	survivorincaps = 0;
	survivorbw = 0;
	for (new i=1; i<=MaxClients; i++) 
	{ 
		if (IsClientInGame(i)) 
		{
			if ((GetClientTeam(i) == 2) && (IsPlayerAlive(i))) 
			{
				//This is where we start to get the true survivors health values
				//First, Check if they are incapped
				new incapped = GetEntProp(i, Prop_Send, "m_isIncapacitated");
				if (incapped)
				{
					survivorincaps++;
				}
				//Now get "real" health
				survivorhealth += GetEntProp(i, Prop_Data, "m_iHealth");
				if (incapped)
				{
					survivorhealth = 0;
				}
				//Now get temp health
				new Float:ftemphealth = RoundToCeil(GetEntPropFloat(i, Prop_Send, "m_healthBuffer") - ((GetGameTime() - GetEntPropFloat(i, Prop_Send, "m_healthBufferTime")) * GetConVarFloat(FindConVar("pain_pills_decay_rate")))) - 1.0;
				if (FloatCompare(ftemphealth, 0.0) == -1) 
				{
					ftemphealth = 0.0;
				}
				survivortemphealth += RoundToCeil(ftemphealth);
				//survivorbw += GetEntProp(i, Prop_Data, "m_isGoingToDie");
				
				if (survivorhealth == 1)
				{
					if (survivortemphealth < 2)
					{
						survivorlimping++;
					}
				}
				if (IsValidEdict(GetPlayerWeaponSlot(i, 2)))
				{
					//They have a throwable!
					survivorgrenades++;
				}
				if (IsValidEdict(GetPlayerWeaponSlot(i, 3)))
				{
					//They have a medkit!
					survivorkits++;
				}
				if (IsValidEdict(GetPlayerWeaponSlot(i, 4)))
				{
					//They have pills!
					survivorpills++;
				}
			}
		}
	}  
}

GetActiveInfected()
{
	//Reset before going into loop
	tanks = 0;
	witches = 0;
	specials = 0;
	commons = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		if (GetClientTeam(i) != 3)
		{ 
			continue; 
		}
		if (IsTank(i))
		{
			tanks++;
		}
		else
		{
			specials++;
		}
	}
	if (specials < 0) specials = 0;
	new ent = -1;
	while((ent = FindEntityByClassname(ent, "witch")) != -1)  
	{
		witches++;
	}
	ent = -1;
	while((ent = FindEntityByClassname(ent,"infected")) != -1)  
	{
		commons++;
	}
}

DirectorAdjust()
{
	if (gamemode == 1) //coop check
	{
		new newmegamobsize = anger * 6;
		commonlimit = anger * 5;
		if (newmegamobsize < 15) newmegamobsize = 15;
		SetConVarInt(FindConVar("z_mega_mob_size"), newmegamobsize);
		if (!finalestarted)
		{
			if (commonlimit < 15) commonlimit = 15;
			SetCommonLimit(commonlimit);
		}
		tankhealth = anger * 850 / difficulty;
		if (tankhealth <= 800) tankhealth = 800;
		SetTankHealth(tankhealth);
	}
	else if (gamemode == 2)
	{
		SetConVarInt(FindConVar("z_mega_mob_size"), 50);
	}
	else if (gamemode == 3)
	{
		SetConVarInt(FindConVar("z_mega_mob_size"), 50);
	}
}


SetCommonLimit(limit)
{
	commonlimit = limit;
	SetConVarInt(FindConVar("z_common_limit"), limit);
}

SetTankHealth(health)
{
	tankhealth = health;
	SetConVarInt(FindConVar("z_tank_health"), tankhealth);
}
