/*****************************************
				Mob System
*****************************************/

public Action:MobController(Handle:timer)
{
	if (!leftsafearea) return Plugin_Stop;
	if (finalestarted) return Plugin_Stop;
	if (gamemode != 1) return Plugin_Stop;
	static mobticks = 0;
	mobticks++;
	lastmobtime++;
	if (mobticks >= MOB_INTERVAL) 
	{
		mobticks = 0;
		new mobchance;
		if (intensity >= 80) mobchance = 25;
		else if (intensity >= 70) mobchance = 15;
		else if (intensity >= 60) mobchance = 12;
		else if (intensity >= 50) mobchance = 9;
		else if (intensity >= 40) mobchance = 7;
		else if (intensity >= 30) mobchance = 6;
		else if (intensity >= 20) mobchance = 4;
		else if (intensity >= 10) mobchance = 3;
		if (isfinale) mobchance += 8;
		if (roundtime < 4) mobchance += 2;
		else if (lastmobtime > 190) mobchance -= 2;
		if (mobchance <= 0) mobchance = 1;
		if (GetRandomInt(1, mobchance) == 1 && lastmobtime >= 80 && mobchance <= 6)
		{
			new mobsize = (anger * 3) + GetRandomInt(-3, 3);
			mobsize += lastmobtime / 20;
			if (mobsize < 6)
			{
				SendMobOfSize(mobsize, false);
			}
			else
			{
				SendMobOfSize(mobsize, true);
			}
			lastmobtime = 0;
		}
	}
	return Plugin_Continue;
}

SendMobOfSize(size, bool:sound)
{
	DebugMessage("Mob Sent");
	mobdirection = GetRandomInt(1, 100);
	SetConVarInt(FindConVar("z_spawn_mobs_behind_chance"), mobdirection);
	new oldcommonlimit = commonlimit;
	SetCommonLimit(size);
	if (!sound) MusicManagerOff();
	SpawnMob();
	MusicManagerOn();
	if (gamemode == 1) AddIntensity(12);
	calm = false;
	SetCommonLimit(oldcommonlimit);
}

public Action:ResetMegaMob(Handle:Timer)
{
	SetConVarInt(FindConVar("z_mega_mob_size"), 50);
}

MusicManagerOn()
{
	SetConVarInt(FindConVar("music_manager"), 1);
}

MusicManagerOff()
{
	SetConVarInt(FindConVar("music_manager"), 0);
}
