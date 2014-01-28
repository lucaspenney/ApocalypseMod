/*****************************************
				Versus Mode
*****************************************/

VersusPlayerUse(client)
{
	if (IsBill(client))
	{
		if (!vs_billgiven) 
		{
			vs_billgiven = true;
			new flags = GetCommandFlags("give");
			SetCommandFlags("give", flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, "give first_aid_kit");
			FakeClientCommand(client, "give pain_pills");
			SetCommandFlags("give", flags|FCVAR_CHEAT);
		}
	}	
	else if (IsFrancis(client))
	{
		if (!vs_francisgiven) 
		{
			vs_francisgiven = true;
			new flags = GetCommandFlags("give");
			SetCommandFlags("give", flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, "give first_aid_kit");
			FakeClientCommand(client, "give pain_pills");
			SetCommandFlags("give", flags|FCVAR_CHEAT);
		}
	}
	else if (IsLouis(client))
	{
		if (!vs_louisgiven)
		{
			vs_louisgiven = true;
			new flags = GetCommandFlags("give");
			SetCommandFlags("give", flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, "give first_aid_kit");
			FakeClientCommand(client, "give pain_pills");
			SetCommandFlags("give", flags|FCVAR_CHEAT);
		}
	}
	else if (IsZoey(client))
	{
		if (!vs_zoeygiven)
		{
			vs_zoeygiven = true;
			new flags = GetCommandFlags("give");
			SetCommandFlags("give", flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, "give first_aid_kit");
			FakeClientCommand(client, "give pain_pills");
			SetCommandFlags("give", flags|FCVAR_CHEAT);		
		}
	}
}

VersusRemoveItems()
{
	SetConVarFloat(FindConVar("z_wandering_density"), 0.0);
	new ent = -1;
	while((ent = FindEntityByClassname(ent,"weapon_first_aid_kit_spawn")) != -1)  
	{
		AcceptEntityInput(ent, "Kill");
	}
	ent = -1;
	while((ent = FindEntityByClassname(ent,"weapon_pain_pills_spawn")) != -1)  
	{
		AcceptEntityInput(ent, "Kill");
	}
}