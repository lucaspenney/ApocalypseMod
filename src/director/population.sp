/*****************************************
			Infected Population
*****************************************/

//Create dynamic common infected based on anger
public OnEntityCreated(entity, const String:classname[])
{
	if (StrEqual(classname, "infected"))
	{
		if (gamemode == 1)
		{
			zspeed = GetRandomInt(230, 270);
			if (anger == 10)
			{
				zhealth = GetRandomInt(150, 200);
			}
			else if (anger == 9 || anger == 8)
			{
				zhealth = GetRandomInt(100,150);
			}
			else if (anger == 7 || anger == 6 || anger == 5)
			{
				zhealth = GetRandomInt(75,100);
			}
			else if (anger == 4 || anger == 3)
			{
				zhealth = GetRandomInt(50, 75);
			}
			else if (anger == 1 || anger == 2)
			{
				zhealth = GetRandomInt(1, 50);
			}
			zhealth -= intensity;
			if (zhealth <= 0) zhealth = GetRandomInt(1, 5);
			SetConVarInt(FindConVar("z_health"), zhealth);
			SetConVarInt(FindConVar("z_speed"), zspeed);
		}
		//Versus mode
		if (gamemode == 2)
		{
			SetConVarInt(FindConVar("z_health"), 30);
			SetConVarInt(FindConVar("z_speed"), 250);
		}
		//Survival mode
		else if (gamemode == 3)
		{
			SetConVarInt(FindConVar("z_health"), 50);
			SetConVarInt(FindConVar("z_speed"), 250);
		}
	}
}
