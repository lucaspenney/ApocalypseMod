/*****************************************
		Dynamic Post Processing
*****************************************/

public Action:PostProcessTimer(Handle:timer)
{
	if (!leftsafearea) return Plugin_Stop;
	
	//Decide the new values using current intensity
	new Float:fintensity = float(intensity);
	new Float:newlocalcontrast;
	new Float:newlocalcontrastedge;
	new Float:newblurstrength;
	//Postprocess in map must have localcontrast -0.055 and localcontrastedge -0.031, these will take place before dynamic post processing kicks in (leave saferoom)
	//This prevents a little weird jump in postprocessing change when the survivors leave the safehouse
	if (FloatCompare(fintensity, 2.0) == -1) fintensity = 2.0;
	if (FloatCompare(fintensity, 5.0) == -1) //Low intensity has a negative contrast
	{
		fintensity = 15 - fintensity;
		fintensity = 0 - fintensity;
		newlocalcontrast = fintensity / 180;
		newlocalcontrastedge = fintensity / 320;
	}
	else
	{
		fintensity -= 20;
		if (fintensity >= 80) fintensity = 80.0;
		newlocalcontrast = fintensity / 70.0;
		newlocalcontrastedge = fintensity / 90.0;
	}
	newblurstrength = fintensity / 150;
	
	//Fire it to the postprocess controller
	new flags = GetCommandFlags("ent_fire");
	SetCommandFlags("ent_fire", flags & ~FCVAR_CHEAT);
	new client = GetRandomSurvivor();
	//Send new values
	FakeClientCommand(client, "ent_fire postprocess_controller SetLocalContrastStrength %.2f", newlocalcontrast);
	//Local Contrast Edge
	FakeClientCommand(client, "ent_fire postprocess_controller SetLocalContrastEdgeStrength %.2f", newlocalcontrastedge);
	//Blur Strength
	FakeClientCommand(client, "ent_fire postprocess_controller SetVignetteBlurStrength %.2f", newblurstrength);
	SetCommandFlags("ent_fire", flags|FCVAR_CHEAT);
	return Plugin_Continue; 
}	
