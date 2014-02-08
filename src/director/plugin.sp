

public Plugin:myinfo = 
{
	name = "Dynamic Director",
	author = "Luke",
	description = "Apocalypse Mod's Dynamic Director",
	version = "1.6",
	url = "http://apocalypsemod.com/"
}

/*****************************************
			Defines
*****************************************/

#define DEBUG

//Deprecated
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3
#define TEAM_SPECTATE 0

//Deprecated
#define TANKMUSIC1 "music/tank/Tank.wav"
#define TANKMUSIC2 "music/tank/Taank.wav"
#define RABIES1 "music/contagion/L4D_Rabies_01.wav"
#define FINALEMUSIC1 "music/the_end/FinalNail.wav"
#define MOB1 "music/mob/GermX2a.wav"


//Handles
new Handle:DirectorDebug;

new difficulty; //1 easy, 2 normal, 3 advanced, 4 expert
new gamemode; //1 coop, 2 versus, 3 survival
new bool:canpanic = true; //Panic events can only be called once every 90 seconds - this keeps track
new String:mapname[128];

//Director Variables
new anger;
new intensity;
new bool:calm;
new bool:isfinale;
new bool:finalestarted;
new finaleanger;
new finaletanks;
new bool:finaleboss;
new bool:leftsafearea;
new roundtime;
new commonlimit;

//Mob system variables
new mobdirection; //range of 0 - 100 with 0 being front 100 being behind
new lastmobtime; //Seconds since the last mob was sent

#define SPECIAL_INTERVAL 30
#define MOB_INTERVAL 17
#define BOSS_INTERVAL 130
#define SOUND_INTERVAL 5 //Removed in 0.1.0

//Infected variables
new spawnedbosses;
new specials;
new tanks;
new witches;
new commons;
new zhealth;
new zspeed;
new tankhealth;
new witchhealth;

//Survivor Variables
new survivorhealth; //Total real health
new survivortemphealth; //Survivor temp health
new survivorkits; //Total medkits
new survivorpills; //Total pills
new survivorgrenades; //Total throwable items
new survivorlimping; //Total amount of 1 health survivors
new survivorincaps; //How many incapped survivors

//Versus
new bool:vs_billgiven;
new bool:vs_francisgiven;
new bool:vs_louisgiven;
new bool:vs_zoeygiven;

new bool:gunsrandomized;
new bool:transition;
new bool:ingame;

//Survival
new svTime;
new svLastEventTime;
new svAnger;

/*****************************************
			Plugin Start
*****************************************/

public OnPluginStart()
{
	L4D1Check();
	
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	HookEvent("map_transition", Event_MapTransition, EventHookMode_Pre);
	HookEvent("player_use", Event_PlayerUse, EventHookMode_Post);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("player_left_checkpoint", Event_PlayerLeftCheckpoint, EventHookMode_Post);
	CreateTimer(1.3, IntensityTimer, _, TIMER_REPEAT);
	CreateTimer(3.0, CalmTimer, _, TIMER_REPEAT);
	
	//Event Hooks
	HookEvent("friendly_fire", Event_FriendlyFire, EventHookMode_Post);
	HookEvent("infected_death", Event_InfectedDeath, EventHookMode_Post);
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Post);
	HookEvent("infected_hurt", Event_InfectedHurt, EventHookMode_Post);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	HookEvent("witch_killed", Event_WitchKilled, EventHookMode_Post);
	HookEvent("weapon_reload", Event_WeaponReload, EventHookMode_Post);
	HookEvent("tank_killed", Event_TankKilled, EventHookMode_Post);
	
	HookEvent("create_panic_event", Event_PanicEvent, EventHookMode_Post);
	HookEvent("player_left_start_area", Event_PlayerLeftStartArea, EventHookMode_Post);
	HookEvent("player_first_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("finale_start", Event_FinaleStart, EventHookMode_Post);
	HookEvent("player_now_it", Event_PlayerNowIt, EventHookMode_Post);
	HookEvent("player_incapacitated", Event_PlayerIncap, EventHookMode_Post);
	
	//ConVars
	DirectorDebug = CreateConVar("dd_debug", "0", "Print Dynamic Director Debug Messages", FCVAR_PLUGIN);
	RegAdminCmd("director_dump", DumpInfo, ADMFLAG_RESERVATION);

}

DebugMessage(String:message[256])
{
	if(GetConVarBool(DirectorDebug))
	{
		PrintToChatAll("%s", message);
	}
}

/*****************************************
				Commands
*****************************************/

public Action:DumpInfo(client, args)
{
	PrintToConsole(client, "");
	PrintToConsole(client, "Dynamic Director Version 3.00 \"Timothy\"");
	PrintToConsole(client, "");
	PrintToConsole(client, "Status: Loaded");
	PrintToConsole(client, "Difficulty:                %i           Gamemode:        %i", difficulty, gamemode);
	PrintToConsole(client, "Left Safe Area:            %b           Guns Randomized: %b", leftsafearea, gunsrandomized);
	PrintToConsole(client, "In Game:                   %b           Transition:      %b", ingame, transition);
	PrintToConsole(client, "Is Finale:                 %b           Finale Started:  %b", isfinale, finalestarted);
	PrintToConsole(client, "");
	PrintToConsole(client, "Director Variables:");
	PrintToConsole(client, "Anger Level:               %i", anger);
	PrintToConsole(client, "Intensity:                 %i           Calm:            %b", intensity, calm);
	PrintToConsole(client, "Round Time:                %i", roundtime);
	PrintToConsole(client, ""); 
	PrintToConsole(client, "Survivor Variables:");
	PrintToConsole(client, "Survivor Health:           %i", survivorhealth);
	PrintToConsole(client, "Survivor Temp Health:      %i", survivortemphealth);
	PrintToConsole(client, "Survivor Kits:             %i", survivorkits);
	PrintToConsole(client, "Survivor Pills:            %i", survivorpills);
	PrintToConsole(client, "Survivor Grenades:         %i", survivorgrenades);
	PrintToConsole(client, "Survivor Limping:          %i", survivorlimping);
	PrintToConsole(client, "Survivor Incapped:         %i", survivorincaps);
	PrintToConsole(client, "");
	PrintToConsole(client, "Infected Variables:");
	PrintToConsole(client, "Bosses Spawned:            %i           Common Infected: %i", spawnedbosses, commons);
	PrintToConsole(client, "Special Infected:          %i           Common Health:   %i", specials, zhealth);
	PrintToConsole(client, "Tanks:                     %i           Common Speed:    %i", tanks, zspeed);
	PrintToConsole(client, "Witches:                   %i           Common Limit:    %i", witches, commonlimit);
	PrintToConsole(client, "Tank Health:               %i           Witch Health:    %i", tankhealth, witchhealth);
	PrintToConsole(client, "");
	PrintToConsole(client, "Mob System Variables:");
	PrintToConsole(client, "Mob Direction:             %i                              ", mobdirection);
	PrintToConsole(client, "Last Mob Time:             %i                              ", lastmobtime);
	PrintToConsole(client, "");
	PrintToConsole(client, "Survival Time:             %i           Survival LastEventTime: %i", svTime, svLastEventTime);
	PrintToConsole(client, "Survival Anger:            %i ", svAnger);
	
	
	
	return Plugin_Handled;
}



