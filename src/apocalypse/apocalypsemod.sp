#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#include <apocalypse>

#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "Apocalypse Mod",
	author = "Lucas Penney",
	description = "Apocalypse Mod Base Plugin",
	version = "0.1.5",
	url = "http://apocalypsemod.com/"
}

new String:mapname[40];

new Handle:apoc_gore;

public OnPluginStart() 
{ 
	L4D1Check();
	GetHandles();
	CvarChanges();

	PrintToServer("Apocalypse Mod Loaded");
	RegConsoleCmd("surv", Command_Surv);
	RegConsoleCmd("survivor", Command_Surv);
	RegConsoleCmd("survivors", Command_Surv);
	RegConsoleCmd("spec", Command_Spec);
	RegConsoleCmd("spectate", Command_Spec);
	RegConsoleCmd("watch", Command_Spec);
	RegConsoleCmd("infected", Command_Infec);
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("infected_hurt", Event_InfectedHurt, EventHookMode_Post);
	HookEvent("infected_hurt", Event_GoreSystemHurt, EventHookMode_Post);
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Post);
	HookEvent("map_transition", Event_MapTransition, EventHookMode_Post);
	HookEvent("player_left_start_area", Event_PlayerLeftStartArea, EventHookMode_Post);
	//Requires consistency off for changes to game scripts
	SetConVarInt(FindConVar("sv_consistency"), 0);

	
	apoc_gore = CreateConVar("apoc_gore", "1", "For those with extreme bloodlust", FCVAR_PLUGIN);
}

/*****************************************
		Console Variable Changes
*****************************************/
new Handle:vs_max_team_switches;
new Handle:z_debug_spawn_set;

new Handle:survivor_allow_crawling;
new Handle:survivor_crawl_speed;

new Handle:z_mob_spawn_min_interval_easy;
new Handle:z_mob_spawn_min_interval_normal;
new Handle:z_mob_spawn_min_interval_hard;
new Handle:z_mob_spawn_min_interval_expert;
new Handle:z_mob_spawn_max_interval_easy;
new Handle:z_mob_spawn_max_interval_normal;
new Handle:z_mob_spawn_max_interval_hard;
new Handle:z_mob_spawn_max_interval_expert;

new Handle:z_witch_relax_rate;
new Handle:z_witch_flashlight_range;
new Handle:z_witch_berserk_range;
new Handle:z_witch_attack_range;
new Handle:z_witch_anger_rate;
new Handle:z_witch_health;

new Handle:z_hear_gunfire_range;
new Handle:z_acquire_far_time;
new Handle:z_acquire_far_range;
new Handle:z_acquire_near_time;
new Handle:z_acquire_near_range;

new Handle:ammo_buckshot_max;
new Handle:ammo_assaultrifle_max;
new Handle:ammo_smg_max;
new Handle:ammo_huntingrifle_max;

new Handle:z_tank_health;
new Handle:tank_attack_range;
new Handle:tank_stuck_time_suicide;

new Handle:z_hunter_health;
new Handle:z_gas_health;
new Handle:z_exploding_health;
new Handle:smoker_tongue_delay;
new Handle:tongue_range;
new Handle:tongue_fly_speed;
new Handle:tongue_victim_max_speed;
new Handle:tongue_hit_delay;
new Handle:tongue_miss_delay;
new Handle:z_exploding_splat_radius;
new Handle:z_vomit_fatigue;
new Handle:z_vomit_interval;

new Handle:z_gib_limbs;
new Handle:z_gib_limb_distance;
new Handle:z_gib_limb_distance_buckshot;

new Handle:z_gun_physics_force;
new Handle:z_gun_force;
new Handle:z_gun_damage;

new Handle:survivor_ff_tolerance;
new Handle:survivor_ff_factor_easy;
new Handle:survivor_ff_factor_normal;
new Handle:survivor_ff_factor_hard;
new Handle:survivor_ff_factor_expert;
new Handle:survivor_incap_cycle_time;
new Handle:survivor_incap_reload_mult;

new Handle:inferno_max_range;
new Handle:inferno_flame_lifetime;
new Handle:inferno_initial_spawn_interval;
new Handle:inferno_child_spawn_max_depth;
new Handle:inferno_max_flames;
new Handle:z_burning_lifetime;
new Handle:pain_pills_health_value;
new Handle:pain_pills_decay_rate;
new Handle:z_gun_swing_interval;
new Handle:z_gun_swing_duration;

new Handle:tank_stuck_failsafe;
new Handle:tank_stuck_time_choose_new_target;
new Handle:tank_stuck_visibility_tolerance_choose_new_target;
new Handle:tank_ground_pound_duration;
new Handle:tank_ground_pound_reveal_distance;
new Handle:tank_stuck_visibility_tolerance_suicide;
new Handle:z_tank_throw_interval;
new Handle:z_tank_damage_slow_max_range;

new Handle:z_minigun_overheat_time;
new Handle:z_minigun_rate_of_fire;
new Handle:z_minigun_fire_think_interval;
new Handle:z_minigun_cooldown_time;
new Handle:z_minigun_damage_rate;

new Handle:sb_separation_range;
new Handle:sb_debug_apoproach_wait_time;
new Handle:sb_separation_danger_min_range;
new Handle:sb_separation_danger_max_range;
new Handle:sb_max_scavenge_separation;
//new Handle:sb_separation_danger_min_range;
new Handle:sb_threat_very_far_range;
new Handle:sb_threat_far_range;
new Handle:sb_threat_medium_range;
new Handle:sb_threat_close_range;
new Handle:sb_threat_very_close_range;
new Handle:sb_flashlight;
new Handle:sb_immobilizedreaction_expert;
new Handle:sb_immobilizedreaction_hard;
new Handle:sb_immobilizedreaction_normal;
new Handle:sb_immobilizedreaction_vs;

new Handle:intensity_lock;
new Handle:director_no_specials;
new Handle:director_no_bosses;
new Handle:z_hunter_limit;
new Handle:z_gas_limit;
new Handle:z_exploding_limit;
new Handle:z_minion_limit;
new Handle:z_wandering_density;



GetHandles()
{
	vs_max_team_switches = FindConVar("vs_max_team_switches");
	z_debug_spawn_set = FindConVar("z_debug_spawn_set");
	
	survivor_allow_crawling = FindConVar("survivor_allow_crawling");
	survivor_crawl_speed = FindConVar("survivor_crawl_speed");
	z_mob_spawn_min_interval_easy = FindConVar("z_mob_spawn_min_interval_easy");
	z_mob_spawn_min_interval_normal = FindConVar("z_mob_spawn_min_interval_normal");
	z_mob_spawn_min_interval_hard = FindConVar("z_mob_spawn_min_interval_hard");
	z_mob_spawn_min_interval_expert = FindConVar("z_mob_spawn_min_interval_expert");
	z_mob_spawn_max_interval_easy = FindConVar("z_mob_spawn_max_interval_easy");
	z_mob_spawn_max_interval_normal = FindConVar("z_mob_spawn_max_interval_normal");
	z_mob_spawn_max_interval_hard = FindConVar("z_mob_spawn_max_interval_hard");
	z_mob_spawn_max_interval_expert = FindConVar("z_mob_spawn_max_interval_expert");
	
	z_witch_relax_rate = FindConVar("z_witch_relax_rate");
	z_witch_flashlight_range = FindConVar("z_witch_flashlight_range");
	z_witch_berserk_range = FindConVar("z_witch_berserk_range");
	z_witch_attack_range = FindConVar("z_witch_attack_range");
	z_witch_anger_rate = FindConVar("z_witch_anger_rate");
	z_witch_health = FindConVar("z_witch_health");
	
	z_hear_gunfire_range = FindConVar("z_hear_gunfire_range");
	z_acquire_far_time = FindConVar("z_acquire_far_time");
	z_acquire_far_range = FindConVar("z_acquire_far_range");
	z_acquire_near_time = FindConVar("z_acquire_near_time");
	z_acquire_near_range = FindConVar("z_acquire_near_range");
	
	ammo_buckshot_max = FindConVar("ammo_buckshot_max");
	ammo_assaultrifle_max = FindConVar("ammo_assaultrifle_max");
	ammo_smg_max = FindConVar("ammo_smg_max");
	ammo_huntingrifle_max = FindConVar("ammo_huntingrifle_max");
	
	z_tank_health = FindConVar("z_tank_health");
	tank_attack_range = FindConVar("tank_attack_range");
	tank_stuck_time_suicide = FindConVar("tank_stuck_time_suicide");
	
	z_hunter_health = FindConVar("z_hunter_health");
	z_gas_health = FindConVar("z_gas_health");
	z_exploding_health = FindConVar("z_exploding_health");
	smoker_tongue_delay = FindConVar("smoker_tongue_delay");
	tongue_range = FindConVar("tongue_range");
	tongue_fly_speed = FindConVar("tongue_fly_speed");
	tongue_victim_max_speed = FindConVar("tongue_victim_max_speed");
	tongue_hit_delay = FindConVar("tongue_hit_delay");
	tongue_miss_delay = FindConVar("tongue_miss_delay");
	z_exploding_splat_radius = FindConVar("z_exploding_splat_radius");
	z_vomit_fatigue = FindConVar("z_vomit_fatigue");
	z_vomit_interval = FindConVar("z_vomit_interval");
	
	z_gib_limbs = FindConVar("z_gib_limbs");
	z_gib_limb_distance = FindConVar("z_gib_limb_distance");
	z_gib_limb_distance_buckshot = FindConVar("z_gib_limb_distance_buckshot");
	
	z_gun_physics_force = FindConVar("z_gun_physics_force");
	z_gun_force = FindConVar("z_gun_force");
	z_gun_damage = FindConVar("z_gun_damage");
	
	survivor_ff_tolerance = FindConVar("survivor_ff_tolerance");
	survivor_ff_factor_easy = FindConVar("survivor_friendly_fire_factor_easy");
	survivor_ff_factor_normal = FindConVar("survivor_friendly_fire_factor_normal");
	survivor_ff_factor_hard = FindConVar("survivor_friendly_fire_factor_hard");
	survivor_ff_factor_expert = FindConVar("survivor_friendly_fire_factor_expert");
	survivor_incap_cycle_time = FindConVar("survivor_incapacitated_cycle_time");
	survivor_incap_reload_mult = FindConVar("survivor_incapacitated_reload_multiplier");
	
	inferno_max_range = FindConVar("inferno_max_range");
	inferno_flame_lifetime = FindConVar("inferno_flame_lifetime");
	inferno_initial_spawn_interval = FindConVar("inferno_initial_spawn_interval");
	inferno_child_spawn_max_depth = FindConVar("inferno_child_spawn_max_depth");
	inferno_max_flames = FindConVar("inferno_max_flames");
	z_burning_lifetime = FindConVar("z_burning_lifetime");
	pain_pills_health_value = FindConVar("pain_pills_health_value");
	pain_pills_decay_rate = FindConVar("pain_pills_decay_rate");
	z_gun_swing_interval = FindConVar("z_gun_swing_interval");
	z_gun_swing_duration = FindConVar("z_gun_swing_duration");
	
	tank_stuck_failsafe = FindConVar("tank_stuck_failsafe");
	tank_stuck_time_choose_new_target = FindConVar("tank_stuck_time_choose_new_target");
	tank_stuck_visibility_tolerance_choose_new_target = FindConVar("tank_stuck_visibility_tolerance_choose_new_target");
	tank_stuck_time_suicide = FindConVar("tank_stuck_time_suicide");
	tank_ground_pound_duration = FindConVar("tank_ground_pound_duration");
	tank_ground_pound_reveal_distance = FindConVar("tank_ground_pound_reveal_distance");
	tank_stuck_visibility_tolerance_suicide = FindConVar("tank_stuck_visibility_tolerance_suicide");
	z_tank_throw_interval = FindConVar("z_tank_throw_interval");
	z_tank_damage_slow_max_range = FindConVar("z_tank_damage_slow_max_range");
	
	z_minigun_overheat_time = FindConVar("z_minigun_overheat_time");
	z_minigun_rate_of_fire = FindConVar("z_minigun_rate_of_fire");
	z_minigun_fire_think_interval = FindConVar("z_minigun_fire_think_interval");
	z_minigun_cooldown_time = FindConVar("z_minigun_cooldown_time");
	z_minigun_damage_rate = FindConVar("z_minigun_damage_rate");
	
	sb_separation_range = FindConVar("sb_separation_range");
	sb_debug_apoproach_wait_time = FindConVar("sb_debug_apoproach_wait_time");
	sb_separation_danger_min_range = FindConVar("sb_separation_danger_min_range");
	sb_separation_danger_max_range = FindConVar("sb_separation_danger_max_range");
	sb_max_scavenge_separation = FindConVar("sb_max_scavenge_separation");
	sb_separation_danger_min_range = FindConVar("sb_separation_danger_min_range");
	sb_threat_very_far_range = FindConVar("sb_threat_very_far_range");
	sb_threat_far_range = FindConVar("sb_threat_far_range");
	sb_threat_medium_range = FindConVar("sb_threat_medium_range");
	sb_threat_close_range = FindConVar("sb_threat_close_range");
	sb_threat_very_close_range = FindConVar("sb_threat_very_close_range");
	sb_flashlight = FindConVar("sb_flashlight");
	sb_immobilizedreaction_expert = FindConVar("sb_friend_immobilized_reaction_time_expert");
	sb_immobilizedreaction_hard = FindConVar("sb_friend_immobilized_reaction_time_hard");
	sb_immobilizedreaction_normal = FindConVar("sb_friend_immobilized_reaction_time_normal");
	sb_immobilizedreaction_vs = FindConVar("sb_friend_immobilized_reaction_time_vs");
	
	intensity_lock = FindConVar("intensity_lock");
	director_no_specials = FindConVar("director_no_specials");
	director_no_bosses = FindConVar("director_no_bosses");
	z_hunter_limit = FindConVar("z_hunter_limit");
	z_gas_limit = FindConVar("z_gas_limit");
	z_exploding_limit = FindConVar("z_exploding_limit");
	z_minion_limit = FindConVar("z_minion_limit");
	z_wandering_density = FindConVar("z_wandering_density");
}

CvarChanges()
{
	SetConVarInt(vs_max_team_switches, 10);
	SetConVarInt(z_debug_spawn_set, 3);

	SetConVarInt(survivor_allow_crawling, 1);
	SetConVarInt(survivor_crawl_speed, 25);
	SetConVarInt(z_mob_spawn_min_interval_easy, 9999999998);
	SetConVarInt(z_mob_spawn_min_interval_normal, 9999999998);
	SetConVarInt(z_mob_spawn_min_interval_hard, 9999999998);
	SetConVarInt(z_mob_spawn_min_interval_expert, 9999999998);
	SetConVarInt(z_mob_spawn_max_interval_easy, 9999999999);
	SetConVarInt(z_mob_spawn_max_interval_normal, 9999999999);
	SetConVarInt(z_mob_spawn_max_interval_hard, 9999999999);
	SetConVarInt(z_mob_spawn_max_interval_expert, 9999999999);
	
	SetConVarFloat(z_witch_relax_rate, 0.12);
	SetConVarInt(z_witch_flashlight_range, 900);
	SetConVarInt(z_witch_berserk_range, 325);
	SetConVarInt(z_witch_attack_range, 40);
	SetConVarFloat(z_witch_anger_rate, 0.21);
	SetConVarInt(z_witch_health, 2000);
	
	SetConVarInt(z_hear_gunfire_range, 800);
	SetConVarFloat(z_acquire_far_time, 3.0);
	SetConVarInt(z_acquire_far_range, 2500);
	SetConVarFloat(z_acquire_near_time, 1.0);
	SetConVarInt(z_acquire_near_range, 700);
	
	SetConVarInt(ammo_buckshot_max, 56);
	SetConVarInt(ammo_assaultrifle_max, 200);
	SetConVarInt(ammo_smg_max, 600);
	SetConVarInt(ammo_huntingrifle_max, 120);
	
	SetConVarInt(z_tank_health, 2000);
	SetConVarInt(tank_attack_range, 125);
	SetConVarInt(tank_stuck_time_suicide, 50);
	
	//Special Infected Settings
	SetConVarInt(z_hunter_health, 250);
	SetConVarInt(z_gas_health, 250);
	SetConVarInt(z_exploding_health, 50);
	SetConVarFloat(smoker_tongue_delay, 0.5);
	SetConVarInt(tongue_range, 900);
	SetConVarInt(tongue_fly_speed, 1500);
	SetConVarInt(tongue_hit_delay, 10);
	SetConVarInt(tongue_miss_delay, 6);
	SetConVarInt(tongue_victim_max_speed, 225);
	SetConVarInt(z_exploding_splat_radius, 225);
	SetConVarInt(z_vomit_fatigue, 1000);
	SetConVarInt(z_vomit_interval, 15);
	
	//Gore settings
	SetConVarInt(z_gib_limbs, 1);
	SetConVarInt(z_gib_limb_distance, 2500);
	SetConVarInt(z_gib_limb_distance_buckshot, 1400);
	
	//Physics changes
	SetConVarInt(z_gun_physics_force, 1);
	SetConVarInt(z_gun_force, 1);
	SetConVarInt(z_gun_damage, 1);
	
	//Survivor Settings
	SetConVarInt(survivor_ff_tolerance, 0);
	SetConVarFloat(survivor_ff_factor_easy, 0.3);
	SetConVarFloat(survivor_ff_factor_normal, 0.6);
	SetConVarFloat(survivor_ff_factor_hard, 0.9);
	SetConVarFloat(survivor_ff_factor_expert, 1.3);
	SetConVarFloat(survivor_incap_cycle_time, 0.21);
	SetConVarFloat(survivor_incap_reload_mult, 1.0);
	
	SetConVarInt(inferno_max_range, 750);
	SetConVarInt(inferno_flame_lifetime, 15);
	SetConVarFloat(inferno_initial_spawn_interval, 0.4);
	SetConVarInt(inferno_child_spawn_max_depth, 20);
	SetConVarInt(inferno_max_flames, 50);
	SetConVarInt(z_burning_lifetime, 999);
	SetConVarInt(pain_pills_health_value, 80);
	SetConVarFloat(pain_pills_decay_rate, 0.5);
	SetConVarFloat(z_gun_swing_interval, 0.7);
	SetConVarFloat(z_gun_swing_duration, 0.2);
	

	
	//Tank settings
	SetConVarInt(tank_stuck_failsafe, 0);
	SetConVarInt(tank_stuck_time_choose_new_target, 0);
	SetConVarInt(tank_stuck_visibility_tolerance_choose_new_target, 1);
	SetConVarInt(tank_stuck_time_suicide, 99999);
	SetConVarInt(tank_ground_pound_duration, 0);
	SetConVarInt(tank_ground_pound_reveal_distance, 9999);
	SetConVarInt(tank_stuck_visibility_tolerance_suicide, 9999);
	SetConVarInt(z_tank_throw_interval, 3);
	SetConVarInt(z_tank_damage_slow_max_range, 1);

	
	//Minigun changes
	SetConVarFloat(z_minigun_overheat_time, 100.0);
	SetConVarInt(z_minigun_rate_of_fire, 2500);
	SetConVarFloat(z_minigun_fire_think_interval, 0.05);
	SetConVarFloat(z_minigun_cooldown_time, 0.1);
	SetConVarInt(z_minigun_damage_rate, 75000);
	



	
	//Bot changes
	SetConVarInt(sb_separation_range, 25);
	SetConVarInt(sb_debug_apoproach_wait_time, 2);
	SetConVarInt(sb_separation_danger_min_range, 150);
	SetConVarInt(sb_separation_danger_max_range, 300);
	SetConVarInt(sb_max_scavenge_separation, 75);
	SetConVarInt(sb_separation_danger_min_range, 250);
	SetConVarInt(sb_threat_very_far_range, 2000);
	SetConVarInt(sb_threat_far_range, 900);
	SetConVarInt(sb_threat_medium_range, 400);
	SetConVarInt(sb_threat_close_range, 200);
	SetConVarInt(sb_threat_very_close_range, 100);
	SetConVarFloat(sb_immobilizedreaction_expert, 0.0);
	SetConVarFloat(sb_immobilizedreaction_hard, 0.1);
	SetConVarFloat(sb_immobilizedreaction_normal, 0.3);
	SetConVarFloat(sb_immobilizedreaction_vs, 0.0);
	SetConVarInt(sb_flashlight, 1);
	
	//Music director changes
	SetConVarInt(FindConVar("music_calm_min_interval"), 3);
	SetConVarFloat(FindConVar("music_dynamic_ambient_out_min"), 0.3);
	SetConVarInt(FindConVar("music_large_area_reveal_repeat_threshold"), 3);
	SetConVarInt(FindConVar("music_large_area_reveal_threshold"), 300000);
	SetConVarInt(FindConVar("music_dynamic_mob_size"), 18);

	 
	//Versus specific overrides
	GameMode = FindConVar("mp_gamemode");	
	decl String:sGameMode[32];
	GetConVarString(GameMode, sGameMode, sizeof(sGameMode));
	
	if (StrEqual(sGameMode, "versus", false))
	{
		cvar = FindConVar("z_tank_health");
		SetConVarInt(cvar, 2000);
		cvar = FindConVar("versus_tank_chance");
		SetConVarFloat(cvar, 1.0);
		cvar = FindConVar("versus_tank_chance_intro");
		SetConVarFloat(cvar, 0.0);  
		cvar = FindConVar("versus_tank_chance_finale");
		SetConVarFloat(cvar, 0.0);
		SetConVarFloat(FindConVar("versus_witch_chance_intro"), 1.0);
		SetConVarFloat(FindConVar("versus_witch_chance_finale"), 1.0);
		cvar = FindConVar("director_vs_convert_pills");
		SetConVarFloat(cvar, 0.0);	
		cvar = FindConVar("versus_tank_bonus_health");
		SetConVarFloat(cvar, 1.0);			
		cvar = FindConVar("z_frustration_lifetime");
		SetConVarInt(cvar, 999);
		cvar = FindConVar("z_ghost_speed");
		SetConVarInt(cvar, 750);
		cvar = FindConVar("vs_score_pp_health");
		SetConVarFloat(cvar, 0.25);
		cvar = FindConVar("vs_score_pp_healthbuffer");
		SetConVarFloat(cvar, 0.1);
		SetConVarInt(FindConVar("vs_max_team_switches"), 30);
		SetConVarInt(FindConVar("vs_tank_damage"), 20);
		SetConVarInt(FindConVar("z_ghost_delay_min"), 24);
		SetConVarInt(FindConVar("z_ghost_delay_max"), 25);
		SetConVarFloat(intensity_lock, 0.1);
		SetConVarInt(director_no_specials, 0);
		SetConVarInt(director_no_bosses, 0);
		SetConVarInt(z_hunter_limit, 6);
		SetConVarInt(z_gas_limit, 6);
		SetConVarInt(z_exploding_limit, 6);
		SetConVarFloat(FindConVar("director_vs_convert_pills"), 0.0);
	}
	if (StrEqual(sGameMode, "coop", false))
	{
		SetConVarFloat(intensity_lock, 0.1);
		SetConVarInt(director_no_specials, 1);
		SetConVarInt(director_no_bosses, 1);
		SetConVarInt(z_hunter_limit, 6);
		SetConVarInt(z_gas_limit, 6);
		SetConVarInt(z_exploding_limit, 6);
		SetConVarInt(z_minion_limit, 10);
		SetConVarFloat(z_wandering_density, 0.03);
	}
	if (StrEqual(sGameMode, "survival", false))
	{
		//Old Survival mechanic changes
		/*
		SetConVarInt(FindConVar("holdout_max_boomers"), 2);
		SetConVarInt(FindConVar("holdout_max_smokers"), 2);
		SetConVarInt(FindConVar("holdout_max_hunters"), 2);
		SetConVarInt(FindConVar("holdout_max_specials"), 5);
		SetConVarInt(FindConVar("holdout_hunter_limit_increase"), 0);
		SetConVarInt(FindConVar("holdout_smoker_limit_increase"), 0);
		SetConVarInt(FindConVar("z_tank_health"), 2000);
		SetConVarInt(FindConVar("holdout_special_spawn_interval_decay"), 1);
		SetConVarInt(FindConVar("holdout_special_spawn_interval"), 20);
		SetConVarInt(FindConVar("holdout_tank_double_spawn_delay"), 3);
		cvar = FindConVar("director_no_specials");
		SetConVarInt(cvar, 0);
		*/
		//Dynamic Survival changes
		SetConVarInt(FindConVar("holdout_max_boomers"), 0);
		SetConVarInt(FindConVar("holdout_max_smokers"), 0);
		SetConVarInt(FindConVar("holdout_max_hunters"), 0);
		SetConVarInt(FindConVar("holdout_max_specials"), 9);
		SetConVarInt(FindConVar("holdout_hunter_limit_increase"), 0);
		SetConVarInt(FindConVar("holdout_smoker_limit_increase"), 0);
		SetConVarInt(FindConVar("holdout_boomer_limit_increase"), 0);
		SetConVarInt(FindConVar("z_tank_health"), 2000);
		SetConVarInt(FindConVar("holdout_tank_stage_interval"), 9999999);
		SetConVarInt(FindConVar("holdout_tank_stage_interval_decay"), 0);
		SetConVarInt(FindConVar("holdout_lull_time_max"), 9999999);
		SetConVarInt(FindConVar("holdout_lull_time"), 99999998);
		SetConVarInt(FindConVar("holdout_special_spawn_interval_decay"), 0);
		SetConVarInt(FindConVar("holdout_special_spawn_interval"), 99999999);
		SetConVarInt(FindConVar("holdout_tank_double_spawn_delay"), 0);
		SetConVarInt(FindConVar("holdout_horde_stage_interval"), 9999999);
		SetConVarInt(FindConVar("holdout_horde_stage_interval_decay"), 0);
		cvar = FindConVar("director_no_specials");
		SetConVarInt(cvar, 1);
		cvar = FindConVar("director_no_bosses");
		SetConVarInt(cvar, 1);
	}
	SetCommandFlags("weapon_reparse_server",GetCommandFlags("weapon_reparse_server")^FCVAR_CHEAT);
	ServerCommand("weapon_reparse_server"); 
}

public Action:Command_Surv(client, args)
{
	ClientCommand(client, "spectate");
	ClientCommand(client, "jointeam 2");
}

public Action:Command_Spec(client, args)
{
	ClientCommand(client, "spectate");
}

public Action:Command_Infec(client, args)
{
	ClientCommand(client, "spectate");
	ClientCommand(client, "jointeam 3");
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	GetCurrentMap(mapname, sizeof(mapname));
	CvarChanges();
}

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	GetCurrentMap(mapname, sizeof(mapname));
	CvarChanges();
}

public Action:Event_MapTransition(Handle:event, const String:name[], bool:dontBroadcast)
{
	CvarChanges();
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (GetClientTeam(GetClientOfUserId(GetEventInt(event, "userid"))) == 2)
	{
		CvarChanges();
		CreateTimer(2.0, CvarChangeTimer);
	}
}

public Action:CvarChangeTimer(Handle:timer)
{
	CvarChanges();
}

public Action:Event_PlayerLeftStartArea(Handle:event, const String:name[], bool:dontBroadcast)
{
	CvarChanges();
}

public OnMapStart() {
	GetCurrentMap(mapname, sizeof(mapname));
	CvarChanges();
	Precache();
}

public OnMapEnd()
{
	CvarChanges();
}

public Action:Event_InfectedHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	//This makes melee do no damage, by giving the health back immediately.
	new zombieid = GetEventInt(event, "entityid");
	new amount = GetEventInt(event, "amount");
	new type = GetEventInt(event, "type");
	if (type == 128) {
		new health=GetEntProp(zombieid, Prop_Data, "m_iHealth"); //Get the value of m_iHealth
		SetEntProp(zombieid, Prop_Data, "m_iHealth", (health + amount)); //give health back
	} 
	//Witches take serious damage from explosions
	if (type == 64) 
	{
		decl String:model[40];
		GetEntPropString(zombieid, Prop_Data, "m_ModelName", model, 39);
		if (!strcmp(model, "models/infected/witch.mdl", false))
		{
			new oldhealth = GetEntProp(zombieid, Prop_Data, "m_iHealth");
			SetEntProp(zombieid, Prop_Data, "m_iHealth", (oldhealth - 1000));	
		}
	}
}

public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	//Tank
	if (IsTank(client))
	{
		ExtinguishEntity(client);
		new type = GetEventInt(event, "type");
		if (type == 64)
		{
			new event_damage = GetEventInt(event, "dmg_health");
			new damage = event_damage * 35;
			if (damage < 500) damage = 500;
			damage += 150;
			new oldhealth = GetEntProp(client, Prop_Data, "m_iHealth");
			SetEntProp(client, Prop_Data, "m_iHealth", (oldhealth - damage));
		}
		new hitgroup = GetEventInt(event, "hitgroup");
		if (hitgroup != 1)
		{
			new event_damage = GetEventInt(event, "dmg_health");
			new damage = event_damage / 10 * 9;
			new oldhealth = GetEntProp(client, Prop_Data, "m_iHealth");
			SetEntProp(client, Prop_Data, "m_iHealth", (oldhealth + damage));
		}
	}
	//Players being hit by tank
	new String:Weapon[256];	  
	GetEventString(event, "weapon", Weapon, 256);
	if ((StrEqual(Weapon, "tank_claw") && GetClientTeam(client) == 2))
	{
		new damagedone = GetEventInt(event, "dmg_health");
		new healthleft = GetEventInt(event, "health");
		new giveback;
		if ((GetEntProp(client, Prop_Send, "m_isIncapacitated") != 0)) //Is incapped
		{
			if (healthleft > 70)
			{
				if (damagedone >= 50) giveback = damagedone - 50;
			}
		}
		else //Not incapped
		{
			if (damagedone > 30) giveback = damagedone - 30;
			SetEntProp(client, Prop_Send, "m_isIncapacitated", 0);
		}
		giveback += healthleft;
		SetEntProp(client, Prop_Data, "m_iHealth", giveback);
	}
	return Plugin_Continue;
} 


new Handle:WelcomeTimers[MAXPLAYERS+1];
 
public OnClientPutInServer(client)
{
	WelcomeTimers[client] = CreateTimer(18.0, WelcomePlayer, client);
	ClientCommand(client, "cl_glow_survivor_r 0");
	ClientCommand(client, "cl_glow_survivor_g 0");
	ClientCommand(client, "cl_glow_survivor_b 0");
	ClientCommand(client, "cl_glow_survivor_hurt_r 0");
	ClientCommand(client, "cl_glow_survivor_hurt_g 0");
	ClientCommand(client, "cl_glow_survivor_hurt_b 0");
	ClientCommand(client, "cl_glow_survivor_vomit_r 0");
	ClientCommand(client, "cl_glow_survivor_vomit_g 0");
	ClientCommand(client, "cl_glow_survivor_vomit_b 0");
	ClientCommand(client, "cl_glow_item_r 0");
	ClientCommand(client, "cl_glow_item_b 0");
	ClientCommand(client, "cl_glow_item_g 0");
	ClientCommand(client, "cl_glow_item_far_r 0");
	ClientCommand(client, "cl_glow_item_far_b 0");
	ClientCommand(client, "cl_glow_item_far_g 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_r 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_b 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_g 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_colorblind_r 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_colorblind_b 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_colorblind_g 0");
	ClientCommand(client, "cl_glow_ability_r 0");
	ClientCommand(client, "cl_glow_ability_g 0");
	ClientCommand(client, "cl_glow_ability_b 0");
	ClientCommand(client, "cl_glow_ability_colorblind_r 0");
	ClientCommand(client, "cl_glow_ability_colorblind_g 0");
	ClientCommand(client, "cl_glow_ability_colorblind_b 0");
}

public OnClientDisconnect(client)
{
	if (WelcomeTimers[client] != INVALID_HANDLE)
	{
		KillTimer(WelcomeTimers[client]);
		WelcomeTimers[client] = INVALID_HANDLE;
	}
	ClientCommand(client, "cl_glow_survivor_r 0.3");
	ClientCommand(client, "cl_glow_survivor_g 0.4");
	ClientCommand(client, "cl_glow_survivor_b 1.0");
	ClientCommand(client, "cl_glow_survivor_hurt_r 0.4");
	ClientCommand(client, "cl_glow_survivor_hurt_g 1.0");
	ClientCommand(client, "cl_glow_survivor_hurt_b 0");
	ClientCommand(client, "cl_glow_survivor_vomit_r 1.0");
	ClientCommand(client, "cl_glow_survivor_vomit_g 0.4");
	ClientCommand(client, "cl_glow_survivor_vomit_b 0");
	ClientCommand(client, "cl_glow_item_r 0.7");
	ClientCommand(client, "cl_glow_item_b 1.0");
	ClientCommand(client, "cl_glow_item_g 0.7");
	ClientCommand(client, "cl_glow_item_far_r 0.3");
	ClientCommand(client, "cl_glow_item_far_b 1.0");
	ClientCommand(client, "cl_glow_item_far_g 0.4");
	ClientCommand(client, "cl_glow_thirdstrike_item_r 1.0");
	ClientCommand(client, "cl_glow_thirdstrike_item_b 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_g 0");
	ClientCommand(client, "cl_glow_thirdstrike_item_colorblind_r 1.0");
	ClientCommand(client, "cl_glow_thirdstrike_item_colorblind_b 1.0");
	ClientCommand(client, "cl_glow_thirdstrike_item_colorblind_g 0.3");
	ClientCommand(client, "cl_glow_ability_r 1.0");
	ClientCommand(client, "cl_glow_ability_g 0");
	ClientCommand(client, "cl_glow_ability_b 0");
	ClientCommand(client, "cl_glow_ability_colorblind_r 0.3");
	ClientCommand(client, "cl_glow_ability_colorblind_g 1.0");
	ClientCommand(client, "cl_glow_ability_colorblind_b 1.0");
}

public Action:WelcomePlayer(Handle:timer, any:client)
{
	decl String:name[128];
	GetClientName(client, name, sizeof(name));
	PrintToChat(client, "\x04Welcome, %s!", name);
	PrintToChat(client, "\x04You are playing on an Apocalypse Mod server!");
	PrintToChat(client, "\x04Visit ApocalypseMod.com for more information.");
	WelcomeTimers[client] = INVALID_HANDLE;
}


//Gore system

Precache()
{
	ForcePrecache("blood_impact_infected_01");
	ForcePrecache("blood_impact_tank_01_cheap");
	ForcePrecache("blood_impact_survivor_01");
	ForcePrecache("blood_impact_infected_01_shotgun");
	ForcePrecache("blood_impact_tank_02");
	ForcePrecache("blood_impact_headshot_01b");
	ForcePrecache("blood_impact_headshot_01c");
	ForcePrecache("blood_impact_arterial_spray_cheap");
}


public Action:Event_GoreSystemHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	decl ent, attacker, hitgroup;	
	ent = GetEventInt(event, "entityid");
	attacker = GetEventInt(event, "attacker");
	new client = GetClientOfUserId(attacker);
	hitgroup = GetEventInt(event, "hitgroup");
	new bool:headshot;
	if (hitgroup == 1) headshot = true;
	else headshot = false;
	new body = GetEntProp(ent, Prop_Send, "m_nBody");
	if(ent != 0)
	{
		new random = GetRandomInt(1, 8);
		switch (random) 
		{
		case 1: CreateBlood(ent, "blood_impact_infected_01", headshot);
		case 2: CreateBlood(ent, "blood_impact_tank_01_cheap", headshot);
		case 3: CreateBlood(ent, "blood_impact_survivor_01", headshot);
		case 4: CreateBlood(ent, "blood_impact_infected_01_shotgun", headshot);
		case 5: CreateBlood(ent, "blood_impact_tank_02", headshot);
		case 6: CreateBlood(ent, "blood_impact_headshot_01b", headshot);
		case 7: CreateBlood(ent, "blood_impact_headshot_01c", headshot);
		case 8: CreateBlood(ent, "blood_impact_arterial_spray_cheap", headshot);
		}
		if (GetConVarBool(apoc_gore))
		{
			if (hitgroup == 1) // 1 for head
			{
				new chance;
				new String:weapon[32];
				if (client < 1) client = 1;
				if (client > 8) client = 1;
				GetClientWeapon(client, weapon, 32);
				if (StrEqual(weapon, "weapon_smg"))
				{
					chance = 2;
				}
				else if (StrEqual(weapon, "weapon_pistol"))
				{
					chance = 2;
				}
				else chance = 15;
				new rand = GetRandomInt(1, chance);
				if (rand == 1)
				{
					//Zombies running around without heads!
					if (body >= 0 && body <= 3) SetEntProp(ent, Prop_Send, "m_nBody", 4);
					else if (body >= 5 && body <= 8) SetEntProp(ent, Prop_Send, "m_nBody", 9);
					else if (body >= 30 && body <= 34) SetEntProp(ent, Prop_Send, "m_nBody", 35);
					else if (body >= 36 && body <= 38) SetEntProp(ent, Prop_Send, "m_nBody", 39);
				}
			}
			else if (hitgroup == 2)
			{
				if (GetRandomInt(1, 15) == 1)
				{
					if (body >= 0 && body <= 3) SetEntProp(ent, Prop_Send, "m_nBody", 4);
					else if (body >= 5 && body <= 8) SetEntProp(ent, Prop_Send, "m_nBody", 9);
					else if (body >= 30 && body <= 34) SetEntProp(ent, Prop_Send, "m_nBody", 35);
					else if (body >= 36 && body <= 38) SetEntProp(ent, Prop_Send, "m_nBody", 39);
				}
			}
			else if (hitgroup == 3)
			{
				if (GetRandomInt(1, 4) == 1)
				{
					if (body >= 0 && body <= 3) 
					{
						SetEntProp(ent, Prop_Send, "m_nBody", (body + 15));
						SetEntProp(ent, Prop_Send, "m_gibbedLimbs", (body + 15));
					}
					else if (body >= 5 && body <= 8) 
					{
						SetEntProp(ent, Prop_Send, "m_nBody", (body + 15));
						SetEntProp(ent, Prop_Send, "m_gibbedLimbs", (body + 15));
					}
					else if (body >= 30 && body <= 34)
					{
						//Female zombies don't seem to work the same
						//I never could understand females...
					}
				}
			} 
			else if (hitgroup == 4)
			{
				new chance;
				new String:weapon[32];
				if (client < 1) client = 1;
				if (client > 8) client = 1;
				GetClientWeapon(client, weapon, 32);
				if (StrEqual(weapon, "weapon_smg"))
				{
					chance = 3;
				}
				else if (StrEqual(weapon, "weapon_pistol"))
				{
					chance = 3;
				}
				else chance = 15;
				if (GetRandomInt(1, chance) == 1)
				{
					if (body >= 0 && body <= 3) SetEntProp(ent, Prop_Send, "m_nBody", (body + 40));
					else if (body >= 5 && body <= 8) SetEntProp(ent, Prop_Send, "m_nBody", (body + 40));
					SetEntProp(ent, Prop_Send, "m_gibbedLimbs", (body + 40));
					SetEntProp(ent, Prop_Data, "m_iHealth", 9);
				}
			}
		}
	}
}

		//Hitgroups
		//1 = head
		//2 = arms
		//3 = torso
		//4 = lower body
		//Gibs
		// 1 = left arm
		// 2 = right arm
		// 3 = both arms
		// 4 = left leg
		// 5 = left arm and left leg	if (GetConVarBool(apoc_gore))
		// 6 = right arm left leg
		// 7 = both arms and left leg
		// 8 = right leg
		// 9 = left arm right leg
		// 10 = right arm right leg
		// 11 = both arms right leg
		// 12 = both legs
		// 13 = left arm 
		// 14 = right arm + head
		// 15 = all limbs except head
		/// 16 = NO GIB OR FALL
		// 17 = left arm
		// 18 = right arm
		// 19 = both arms
		// 29 = falls both legs and left arm
		// 37 = falls left arm and leg
		//Body
		//1,2,3 = no gib
		//9 = head
		//10 = right arm or nothing
		//11 =
		//12 = nothing
		//13 = 
		//14 = head and right arm
		//17 = left arm
		//18 = left arm
		//19 = head and random arm
		//20 = right leg/left arm/nothing
		//25 = nothing
		//34 = random
		//44 = head + random leg (right)
		//SetEntProp(ent, Prop_Send, "m_gibbedLimbs", 16);
		//SetEntProp(ent, Prop_Send, "m_nBody", 23);

CreateBlood(Ent, String:ParticleName[], bool:headshot)
{

	//Declare:
	decl Particle;
	decl String:tName[64];

	//Initialize:
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{

		//Declare:
		decl Float:Position[3], Float:Angles[3];

		//Initialize:
		Angles[0] = GetRandomFloat(0.0, 360.0);
		Angles[1] = GetRandomFloat(-15.0, 15.0);
		Angles[2] = GetRandomFloat(-15.0, 15.0);

		//Origin:
        GetEntPropVector(Ent, Prop_Send, "m_vecOrigin", Position);

		//Lower:
		Position[2] += GetRandomFloat(10.0, 30.0);
		if (headshot) Position[2] += 23.0;

		//Randomize:
		if (headshot)
		{
			Position[0] += GetRandomFloat(-8.0, 8.0);
			Position[1] += GetRandomFloat(-8.0, 8.0);
		}
		else
		{
			Position[0] += GetRandomFloat(-13.0, 13.0);
			Position[1] += GetRandomFloat(-13.0, 13.0);
		}

		//Send:
        TeleportEntity(Particle, Position, Angles, NULL_VECTOR);

		//Target Name:
		Format(tName, sizeof(tName), "Entity%d", Ent);
		DispatchKeyValue(Ent, "targetname", tName);
		GetEntPropString(Ent, Prop_Data, "m_iName", tName, sizeof(tName));

		//Properties:
		DispatchKeyValue(Particle, "targetname", "L4DParticle");
		DispatchKeyValue(Particle, "parentname", tName);
		DispatchKeyValue(Particle, "effect_name", ParticleName);

		//Spawn:
		DispatchSpawn(Particle);
	
		//Parent:		
		SetVariantString(tName);
		AcceptEntityInput(Particle, "SetParent", Particle, Particle);
		ActivateEntity(Particle);
		AcceptEntityInput(Particle, "start");

		//Delete:
		if (!headshot)
		{
			if (GetRandomInt(1, 5) == 1)
			{
				CreateTimer(2.5, DeleteParticle, Particle);
			}
			else
			{
				CreateTimer(1.2, DeleteParticle, Particle);
			}
		}
		else
		{
			if (GetRandomInt(1, 4) == 1)
			{
				CreateTimer(2.5, DeleteParticle, Particle);
			}
			else
			{
				CreateTimer(7.0, DeleteParticle, Particle);
			}
		}
	}
}

public Action:DeleteParticle(Handle:Timer, any:Particle)
{
	if(IsValidEntity(Particle))
	{
		decl String:Classname[64];
		GetEdictClassname(Particle, Classname, sizeof(Classname));
		if(StrEqual(Classname, "info_particle_system", false))
		{
			RemoveEdict(Particle);
		}
	}
}

ForcePrecache(String:ParticleName[])
{
	decl Particle;
	
	//Initialize: 
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{

		//Properties:
		DispatchKeyValue(Particle, "effect_name", ParticleName);
		
		//Spawn:
		DispatchSpawn(Particle);
		ActivateEntity(Particle);
		AcceptEntityInput(Particle, "start");
		
		//Delete:
		CreateTimer(0.3, DeleteParticle, Particle, TIMER_FLAG_NO_MAPCHANGE);
	}
}
