/*****************************************
				Panic Events
*****************************************/

public Action:Event_PanicEvent(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (gamemode == 1 && canpanic) CoopPanicEvent();
	if (!canpanic)
	{
		DebugMessage("Panic event called while variable canpanic=false !");
	}
	if (canpanic)
	{
		canpanic = false;
		DebugMessage("Panic Event sent successfully");
		CreateTimer(90.0, PanicResetTimer);
	}
	if (gamemode == 3) 
	{
		SurvivalStart();
		
	}
}

public Action:PanicResetTimer(Handle:Timer)
{
	canpanic = true;
	DebugMessage("Panic Event now ready");
}

CoopPanicEvent()
{
	if (anger > 6 && intensity < 20 && Chance(2))
	{
		SetTankHealth(tankhealth / 2);
		SpawnTank();
	}
	else if (GetRandomInt(1, 8) == 1)
	{
		SetTankHealth(tankhealth / 3);
		SpawnTank();
		SpawnTank();
	}
}