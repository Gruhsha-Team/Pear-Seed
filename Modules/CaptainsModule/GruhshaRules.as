#include "RulesCore.as"
#include "PickingCommon.as"
#include "ChatCommandManager.as"
#include "ChatCommandCommon.as"
#include "ApprovedTeams.as"

void Reset(CRules@ this)
{
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void onInit(CRules@ this)
{
	Reset(this);
	this.addCommandID("put to spec");
	this.addCommandID("put to blue");
	this.addCommandID("put to red");

	this.addCommandID("create wood gibs");
	DemoteLeaders();
	SyncLeaders();

	if (!isServer()) return;
	ApprovedTeams@ approved_teams = ApprovedTeams();
	if (approved_teams !is null) {
		approved_teams.ClearLists();
		this.set("approved_teams", approved_teams);
		approved_teams.PrintMembers();
	}
}

void onCommand( CRules@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("put to spec") && isServer())
	{
		CPlayer@ caller = getNet().getActiveCommandPlayer();
		if (caller is null) return;

		string username; if (!params.saferead_string(username)) return;
		CPlayer@ doomed = getPlayerByUsername(username);
		if (doomed is null) return;

		RulesCore@ core;
		this.get("core", @core);

		if (core is null) return;

		core.ChangePlayerTeam(doomed, this.getSpectatorTeamNum());
		printf("[CAPTAINS SYSTEM] " + caller.getUsername() + " placed a player " + doomed.getUsername() + " to spectators via pick menu");
		//KickPlayer(doomed);
	} else if(cmd == this.getCommandID("put to blue") && isServer())
	{
		CPlayer@ caller = getNet().getActiveCommandPlayer();
		if (caller is null) return;

		string username; if (!params.saferead_string(username)) return;
		CPlayer@ doomed = getPlayerByUsername(username);
		if (doomed is null) return;

		RulesCore@ core;
		this.get("core", @core);

		if (core is null) return;

		core.ChangePlayerTeam(doomed, 0);
		printf("[CAPTAINS SYSTEM] " + caller.getUsername() + " placed a player " + doomed.getUsername() + " to blue team via pick menu");
		//KickPlayer(doomed);
	} else if(cmd == this.getCommandID("put to red") && isServer())
	{
		CPlayer@ caller = getNet().getActiveCommandPlayer();
		if (caller is null) return;

		string username; if (!params.saferead_string(username)) return;
		CPlayer@ doomed = getPlayerByUsername(username);
		if (doomed is null) return;

		RulesCore@ core;
		this.get("core", @core);

		if (core is null) return;

		core.ChangePlayerTeam(doomed, 1);
		printf("[CAPTAINS SYSTEM] " + caller.getUsername() + " placed a player " + doomed.getUsername() + " to red team via pick menu");
		//KickPlayer(doomed);
	} else if(cmd == this.getCommandID("create wood gibs") && isClient())
	{
		Vec2f spawn_pos; if (!params.saferead_Vec2f(spawn_pos)) return;
		f32 clamped_damage = 5;
		f32 dmg_mod = 9;

		for (int idx = 0; idx < 3; ++idx)
		makeGibParticle("GenericGibs", spawn_pos, Vec2f(-2+XORRandom(4), 0),
		                1, 7-dmg_mod+XORRandom(dmg_mod), Vec2f(8, 8), 2.0f, 0, "", 0);
	}
}

void onNewPlayerJoin(CRules@ this, CPlayer@ player)
{
	if (!isServer()) return;
	RulesCore@ core;
	this.get("core", @core);

	if (core is null) return;

	const u8 SPEC_TEAM = this.getSpectatorTeamNum();
	u8 new_team = 2;

	ApprovedTeams@ approved_teams;
	if (!this.get("approved_teams", @approved_teams)) return;

	new_team = approved_teams.getPlayerTeam(player);

	core.ChangePlayerTeam(player, new_team);
	if (new_team != SPEC_TEAM)
		core.AddPlayerSpawn(player);
	//player.server_setTeamNum(new_team);
	print("team is "+new_team);
	//player.client_ChangeTeam(new_team);
}

void onPlayerRequestTeamChange(CRules@ this, CPlayer@ player, u8 newteam)
{
	if (!getNet().isServer())
		return;

	if (!canChangeTeamByRequest()) {
		server_AddToChat("Идёт набор игроков, вы не можете сами менять свою команду", ConsoleColour::ERROR, player);
		return;
	}

	RulesCore@ core;
	this.get("core", @core);

	if (core is null) return;

	core.ChangePlayerTeam(player, newteam);
}