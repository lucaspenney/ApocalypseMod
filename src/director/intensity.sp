/*****************************************
				Intensity
*****************************************/

public Action:IntensityTimer(Handle:timer)
{
	if (intensity <= 0) return;
	else if (intensity < 0) intensity = 0;
	else if (intensity >= 100) intensity = 99;
	else if (calm) 
	{
		if (intensity > 12) SubtractIntensity(GetRandomInt(3,4));
		else if (intensity > 70) SubtractIntensity(GetRandomInt(4, 5));
		else intensity--;
	}
	else intensity--;
}

public Action:CalmTimer(Handle:timer)
{
	static oldintensity = 0;
	if (intensity > 10)
	{
		if (intensity <= oldintensity) calm = true;
		else calm = false;
		oldintensity = intensity;
	}
}

AddIntensity(amount)
{
	if (amount > 50) amount = 50;
	if (amount < 0) amount = 0;
	intensity = intensity + amount;
}

SubtractIntensity(amount)
{
	if (amount < 0) amount = 0;
	if ((intensity - amount) < 0) amount = 0;
	intensity = intensity - amount;
} 
