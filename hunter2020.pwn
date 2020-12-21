#include a_samp
#undef MAX_PLAYERS
#define MAX_PLAYERS 64

main()
{
	print("Hunter 2020");
}

new Float:startPositions[][] = {
	{1554.8682, 1201.0183, 11.0284},
	{2402.3555, 2530.3452, 22.3689},
	{2684.8489, -1758.7179, 44.7986},
	{1400.8619, -2510.2031, 14.1209},
	{1244.1831, -2042.7524, 60.6428},
	{172.1398, -1844.2178, 4.9680},
	{-2419.9226, -2340.6235, 24.5522},
	{-2352.5190, -1629.3658, 486.2607},
	{-2535.7544, -615.4884, 133.2559},
	{-2135.4238, -238.0773, 35.5678},
	{-1702.5542, -221.6726, 14.8578},
	{-2656.4023, 1310.2074, 7.6345},
	{-2488.4197, 2221.2678, 6.5832},
	{385.9171, 2437.9624, 16.2582},
	{1105.5048, 2602.6001, 13.1117},
	{1067.8004, 2198.3101, 16.9921},
	{1135.1516, 506.3554, 25.8605},
	{1299.7659, 23.4810, 31.1988},
	{-511.9465, -500.3459, 26.4590},
	{-2967.1484, 460.3971, 5.1187},
	{-2475.3171, 802.6829, 35.2412}
};
new Float:finishPositions[][] = {
	{2505.8086, -1696.0623, 13.2662},
	{2642.9194, -2105.8020, 13.5573},
	{1693.3126, -1972.4917, 8.3672},
	{1584.6729, -1705.5682, 5.2607},
	{2231.2844, 172.4122, 26.7192},
	{2558.3894, 72.1076, 25.7649},
	{2351.6851, -655.0423, 127.2292},
	{825.1163, -1102.9286, 24.8061},
	{1019.6462, -1441.4248, 12.8639},
	{1128.6005, -1528.9768, 14.9719},
	{1474.3376, -2255.8472, -3.6175},
	{-2311.3508, -1652.2800, 482.9724},
	{-2679.4983, 1445.0806, 6.2144},
	{-2293.4292, 2232.9487, 4.3008},
	{-1328.1622, 2677.3547, 49.0504},
	{1597.9291, 1171.3228, 13.7084},
	{216.0535, 1865.6229, 12.4715},
	{268.6509, 1883.5313, -31.1664},
	{281.3170, 1989.1921, 17.1807},
	{-790.7051, 2418.4048, 156.3479},
	{2855.2788, 893.6195, 8.8345},
	{2594.1338, 808.6863, 4.7613},
	{2784.7773, -2455.8347, 13.0226},
	{2171.9885, -2253.4568, 12.7276},
	{2095.9224, -1984.8734, 7.2905},
	{2404.7256, -2298.8157, 5.4102},
	{-997.9562, -1006.7675, 93.2885},
	{-1363.8380, -485.0960, 13.5298},
	{-1672.3065, 69.4370, -11.5601}
};

enum
{
	teamHunter,
	teamDriver
}
new team[MAX_PLAYERS];

new hunterCount;
new driverCount;
new startIndex;
new finishIndex;

new Text:TextdrawPlayerDistance;

enum
{
	gameStatePlaying,
	gameStateCountdown,
	gameStateEnding,
	gameStateWaitingForPlayers
}
new gameState;

public OnGameModeInit()
{
	SetGameModeText("Hunter 2020");

	gameState = gameStateWaitingForPlayers;
	
	TextdrawPlayerDistance = TextDrawCreate(631.000000, 220.000000, "New Textdraw");
	TextDrawAlignment(TextdrawPlayerDistance, 3);
	TextDrawBackgroundColor(TextdrawPlayerDistance, 255);
	TextDrawFont(TextdrawPlayerDistance, 1);
	TextDrawLetterSize(TextdrawPlayerDistance, 0.390000, 1.000000);
	TextDrawColor(TextdrawPlayerDistance, -1);
	TextDrawSetOutline(TextdrawPlayerDistance, 0);
	TextDrawSetProportional(TextdrawPlayerDistance, 1);
	TextDrawSetShadow(TextdrawPlayerDistance, 1);
	TextDrawSetSelectable(TextdrawPlayerDistance, 0);
	TextDrawShowForAll(TextdrawPlayerDistance);

	SetTimer("UpdateDistanceText", 500, true);
}

public OnPlayerConnect(playerid)
{
	TogglePlayerSpectating(playerid, 1);
	if(gameState == gameStatePlaying)
	{
		TextDrawShowForAll(TextdrawPlayerDistance);
		
		team[playerid] = teamHunter;
		hunterCount++;
		
		TriggerSpawn(playerid, startPositions[startIndex][0], startPositions[startIndex][1], startPositions[startIndex][2], 0);
	}
	else if(gameState == gameStateWaitingForPlayers)
	{
		TriggerNextRount();
	}
	
}

public OnPlayerDisconnect(playerid, reason)
{
	if(gameState == gameStatePlaying || gameState == gameStateCountdown)
	{
		if(team[playerid] == teamHunter)
		{
			hunterCount--;
		}
		else if(team[playerid] == teamDriver)
		{
			driverCount--;
		}

		HandlePlayerLoss();
	}
}

HandlePlayerLoss()
{
	if(driverCount <= 0)
	{
		EndRound(teamHunter);
	}
	else if(hunterCount <= 0)
	{
		EndRound(teamDriver);
	}
}

Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    x1 -= x2, y1 -= y2, z1 -= z2;
    return floatsqroot((x1 * x1) + (y1 * y1) + (z1 * z1));
}

TriggerSpawn(playerid, Float:x, Float:y, Float:z, Float:a)
{
	TogglePlayerSpectating(playerid, 1);
	SetSpawnInfo(playerid, 0, 0, x, y, z, a, 0, 0, 0, 0, 0, 0);
	SetTimerEx("Spawn", 300, false, "d", playerid);
}

forward Spawn(playerid);
public Spawn(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	SetCameraBehindPlayer(playerid);
}

public OnPlayerSpawn(playerid)
{
	if(gameState == gameStateCountdown)
	{
		SetPlayerCameraPos(playerid, finishPositions[finishIndex][0],finishPositions[finishIndex][1],finishPositions[finishIndex][2]+200);
		SetPlayerCameraLookAt(playerid, finishPositions[finishIndex][0],finishPositions[finishIndex][1],finishPositions[finishIndex][2]);
	}
	else
	{
		DisablePlayerCheckpoint(playerid);

		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		new vehicleModel;
		if(team[playerid] == teamHunter)
		{
			vehicleModel = 425;
		}
		else
		{
			vehicleModel = 560;
			SetPlayerCheckpoint(playerid, finishPositions[finishIndex][0],finishPositions[finishIndex][1],finishPositions[finishIndex][2], 3);
		}

		new name[25];
		GetPlayerName(playerid, name, 25);

		new vehicle = CreateVehicle(vehicleModel, pos[0], pos[1], pos[2], 0, random(256), random(256), -1);
		SetVehicleNumberPlate(vehicle, name);
		PutPlayerInVehicle(playerid, vehicle, 0);
	}
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new Float:pos[4];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);
	
	if(gameState == gameStatePlaying)
	{
	    if(team[playerid] == teamDriver)
	    {
	        driverCount--;
	        hunterCount++;
	    	team[playerid] = teamHunter;
	    }

	    SendDeathMessage(killerid, playerid, reason);

		new Float:zAddition = team[playerid] == teamHunter ? 100 : 0;
		TriggerSpawn(playerid, pos[0], pos[1], pos[2]+10, pos[3] + zAddition);

		HandlePlayerLoss();
	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER && gameState == gameStatePlaying)
	{
	    SetPlayerHealth(playerid, 0);
	}
	
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
	EndRound(teamDriver);
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

EndRound(winnerTeam)
{
	gameState = gameStateEnding;

	new teamName[16];
	if(winnerTeam == teamDriver)
	{
		teamName = "drivers";
	}
	else if(winnerTeam == teamHunter)
	{
		teamName = "hunters";
	}

	new txt[54];
	format(txt, 54, "%s win!", teamName);
    GameTextForAll(txt, 2980, 5);
    
	TextDrawHideForAll(TextdrawPlayerDistance);

	SetTimer("TriggerNextRount", 3000, false);
}

forward TriggerNextRount();
public TriggerNextRount()
{
	if(gameState == gameStateCountdown)
	{
	    return;
	}

	SetupTeams();
	SetupPositions();
	if(hunterCount > 0 && driverCount > 0)
	{	
		gameState = gameStateCountdown;
		GameTextForAll("starting next round", 1980, 5);
		SetTimerEx("StartRoundCountdown", 2000, false, "d", 3);
		
		for(new i = 0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && team[i] == teamDriver)
			{
				ShowFinish(i);
			}
		}
	}
	else
	{
		gameState = gameStateWaitingForPlayers;
		GameTextForAll("Waiting for players...", 980, 5);
	}
}

ShowFinish(playerid)
{
	TriggerSpawn(playerid, finishPositions[finishIndex][0],finishPositions[finishIndex][1],finishPositions[finishIndex][2], 0);
}

forward StartRoundCountdown(counter);
public StartRoundCountdown(counter)
{
	if(counter > 0)
	{
		new text[2];
		valstr(text, counter);
		GameTextForAll(text, 980, 5);
		SetTimerEx("StartRoundCountdown", 1000, false, "d", counter-1);
	}
	else
	{
		StartGame();
	}
}

StartGame()
{
	gameState = gameStatePlaying;

	DestroyAllVehicles();

	for(new i = 0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
		{
		    new zAddition = team[i] == teamHunter ? 500 : 0;
			TriggerSpawn(i, startPositions[startIndex][0], startPositions[startIndex][1], startPositions[startIndex][2]+zAddition, 0);
		}
	}

	TextDrawShowForAll(TextdrawPlayerDistance);
}

SetupTeams()
{
	new count = 0;

	new hunter = GetRandomPlayerId();
	team[hunter] = teamHunter;

	for(new i = 0; i<MAX_PLAYERS;i++)
	{
		if(i != hunter && IsPlayerConnected(i))
		{
			team[i] = teamDriver;
			count++;
		}
	}

	hunterCount = 1;
	driverCount = count;
}

SetupPositions()
{
	startIndex = random(sizeof(startPositions));
	do
	{
	    finishIndex = random(sizeof(finishPositions));
	}
	while(GetDistanceBetweenPoints(finishPositions[finishIndex][0],finishPositions[finishIndex][1],finishPositions[finishIndex][2], startPositions[startIndex][0],startPositions[startIndex][1],startPositions[startIndex][2]) < 1500);
}

GetRandomPlayerId()
{
	new id;
	do
	{
	    id = random(MAX_PLAYERS);
	}
	while(!IsPlayerConnected(id));

	return id;
}

public OnVehicleDeath(vehicleid)
{
	DestroyVehicle(vehicleid);
}

DestroyAllVehicles()
{
	for(new i = 0;i<MAX_VEHICLES;i++)
	{
		DestroyVehicle(i);
	}
}

forward UpdateDistanceText();
public UpdateDistanceText()
{
	new string[128];
	for(new i; i<MAX_PLAYERS;i++)
	{
	    if(team[i] == teamDriver && IsPlayerConnected(i))
	    {
			new Float:x, Float:y, Float:z;
	        if(IsPlayerInAnyVehicle(i)) GetVehiclePos(GetPlayerVehicleID(i), x, y, z);
			else GetPlayerPos(i, x, y, z);
	        new add[128];
	        new name[24];
			GetPlayerName(i, name, 24);
			format(add, 128, "%s: %.2fm ~n~", name, GetDistanceBetweenPoints(x, y, z, finishPositions[finishIndex][0],finishPositions[finishIndex][1],finishPositions[finishIndex][2]));
			strcat(string, add);
	    }
	}
	TextDrawSetString(TextdrawPlayerDistance, string);
	return 1;
}
