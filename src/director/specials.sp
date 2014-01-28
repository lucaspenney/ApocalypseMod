/*****************************************
			Special Infected
*****************************************/

public Action:SpecialTimer(Handle:timer)
{
	if (!leftsafearea) return Plugin_Stop;
	if (gamemode != 1) return Plugin_Stop;
	static specialticks = 0;
	specialticks++;
	if (specialticks >= SPECIAL_INTERVAL)
	{
		specialticks = 0;
		new rand = GetRandomInt(1, 3);
		if (rand == 2) 
		{
			new newspecials;
			if (anger == 10) newspecials = 4;
			else if (anger > 7) newspecials = 3;
			else if (anger >= 4) newspecials = 2;
			else if (anger <= 3) newspecials = 1;
			else if (anger == 1) newspecials = 0;
			if (intensity > 60) newspecials--;
			new allowedspecials = 4;
			allowedspecials -= specials;
			if (newspecials > allowedspecials)
			{
				newspecials = allowedspecials;
			}
			while(newspecials != 0)
			{
				rand = GetRandomInt(1, 3);
				switch (rand)
				{
					case 1: 
					{
						SpawnHunter(); 
						DebugMessage("Director: Spawned Hunter");
					}
					case 2: 
					{
						SpawnSmoker();
						DebugMessage("Director: Spawned Smoker");
					}
					case 3: 
					{
						SpawnBoomer();
						DebugMessage("Director: Spawned Boomer");
					}
				}
				newspecials--;
			}
		}
	}
	return Plugin_Continue;
}