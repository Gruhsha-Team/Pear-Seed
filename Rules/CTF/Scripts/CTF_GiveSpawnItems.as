// spawn resources

#include "RulesCore.as";
#include "CTF_Structs.as";
#include "CTF_Common.as"; // resupply stuff

bool SetMaterials(CBlob@ blob,  const string &in name, const int quantity, bool drop = false)
{
	CInventory@ inv = blob.getInventory();

	//avoid over-stacking arrows
	if (name == "mat_arrows")
	{
		inv.server_RemoveItems(name, quantity);
	}

	CBlob@ mat = server_CreateBlobNoInit(name);

	if (mat !is null)
	{
		mat.Tag('custom quantity');
		mat.Init();

		mat.server_SetQuantity(quantity);

		if (drop || not blob.server_PutInInventory(mat))
		{
			mat.setPosition(blob.getPosition());
		}
	}

	return true;
}

//when the player is set, give materials if possible
void onSetPlayer(CRules@ this, CBlob@ blob, CPlayer@ player)
{
	if (!isServer()) return;

	if (blob is null) return;
	if (player is null) return;

	doGiveSpawnMats(this, player, blob);
}

//when player dies, unset archer flag so he can get arrows if he really sucks :)
//give a guy a break :)
void onPlayerDie(CRules@ this, CPlayer@ victim, CPlayer@ attacker, u8 customData)
{
	if (victim !is null)
	{
		SetCTFTimer(this, victim, 0, "archer");
	}
}

void doGiveMats(CRules@ this) {
	s32 gametime = getGameTime();

	s32 next_resuply = gametime + materials_wait * getTicksASecond();
	this.set_s32("nextresuply", next_resuply);
	this.Sync("nextresuply", true);

	int wood_amount = matchtime_wood_amount;
	int stone_amount = matchtime_stone_amount;

	if (gametime > lower_mats_timer * getTicksASecond())
	{
		wood_amount = lower_wood;
		stone_amount = lower_stone;
	}

	for(int team = 0; team < 2; team++) {
		if (this.get_s32("teamwood" + team) < 3000) {
			this.add_s32("teamwood" + team, wood_amount);
			this.Sync("teamwood" + team, true);
		}
		if (this.get_s32("teamstone" + team) < 2000) {
			this.add_s32("teamstone" + team, stone_amount);
			this.Sync("teamstone" + team, true);
		}
	}

	for (int i = 0; i < getPlayerCount(); i++) {
		CPlayer@ player = getPlayer(i);
		if (player is null) continue;
		SetCTFTimer(this, player, next_resuply, "builder");
	}
}

//takes into account and sets the limiting timer
//prevents dying over and over, and allows getting more mats throughout the game
void doGiveSpawnMats(CRules@ this, CPlayer@ p, CBlob@ b)
{
	s32 gametime = getGameTime();
	string name = b.getName();

	if (name == "archer")
	{
		if (gametime > getCTFTimer(this, p, "archer"))
		{
			CInventory@ inv = b.getInventory();
			if (inv.isInInventory("mat_arrows", 30))
			{
				return; // don't give arrows if they have 30 already
			}
			else if (SetMaterials(b, "mat_arrows", 30))
			{
				SetCTFTimer(this, p, gametime + (this.isWarmup() ? materials_wait_warmup : materials_wait)*getTicksASecond(), "archer");
			}
		}
	}
}

void Reset(CRules@ this)
{
	//restart everyone's timers
	for (uint i = 0; i < getPlayersCount(); ++i)
	{
		SetCTFTimer(this, getPlayer(i), 0, "builder");
		SetCTFTimer(this, getPlayer(i), 0, "archer");
	}
	if (!isServer()) return;

	this.set_s32("teamwood" + 0, 0);
	this.Sync("teamwood" + 0, true);
	this.set_s32("teamstone" + 0, 0);
	this.Sync("teamstone" + 0, true);
	//this.set_s32("teamgold" + 0, 0);
	//this.Sync("teamgold" + 0, true);

	this.set_s32("teamwood" + 1, 0);
	this.Sync("teamwood" + 1, true);
	this.set_s32("teamstone" + 1, 0);
	this.Sync("teamstone" + 1, true);
	//this.set_s32("teamgold" + 1, 0);
	//this.Sync("teamgold" + 1, true);

	this.set_s32("nextresuply", 0);
	this.Sync("nextresuply", true);
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void onInit(CRules@ this)
{
	Reset(this);
}

void onTick(CRules@ this)
{
	if (!isServer())
		return;

	s32 gametime = getGameTime();

	if (this.getCurrentState() == WARMUP) {
		if (getGameTime() == 60) {
			this.set_s32("teamwood" + 0, 6000);
			this.Sync("teamwood" + 0, true);
			this.set_s32("teamwood" + 1, 6000);
			this.Sync("teamwood" + 1, true);

			this.set_s32("teamstone" + 0, 4500);
			this.Sync("teamstone" + 0, true);
			this.set_s32("teamstone" + 1, 4500);
			this.Sync("teamstone" + 1, true);
		}

		u32 pog = 30 * 179;

		if (getGameTime() == pog) {
			this.set_s32("teamwood" + 0, 1000);
			this.Sync("teamwood" + 0, true);
			this.set_s32("teamwood" + 1, 1000);
			this.Sync("teamwood" + 1, true);

			this.set_s32("teamstone" + 0, 400);
			this.Sync("teamstone" + 0, true);
			this.set_s32("teamstone" + 1, 400);
			this.Sync("teamstone" + 1, true);
		}
	} else {
		CBlob@[] spots;
		getBlobsByName(base_name(),   @spots);
		getBlobsByName("outpost",	@spots);
		getBlobsByName("warboat",	 @spots);
		//getBlobsByName("buildershop", @spots);
		getBlobsByName("archershop",  @spots);
		// getBlobsByName("knightshop",  @spots);
		for (uint step = 0; step < spots.length; ++step) {
			CBlob@ spot = spots[step];
			if (spot is null) continue;

			CBlob@[] overlapping;
			if (!spot.getOverlapping(overlapping)) continue;

			string name = spot.getName();
			bool isShop = (name.find("shop") != -1);

			for (uint o_step = 0; o_step < overlapping.length; ++o_step) {
				CBlob@ overlapped = overlapping[o_step];
				if (overlapped is null) continue;

				if (!overlapped.hasTag("player")) continue;
				CPlayer@ p = overlapped.getPlayer();
				if (p is null) continue;

				CBlob@ player_blob = p.getBlob();
				if (player_blob is null) continue;

				u8 team = player_blob.getTeamNum();

				string class_name = overlapped.getName();

				if (isShop && name.find(class_name) == -1) continue; // NOTE: builder doesn't get wood+stone at archershop, archer doesn't get arrows at buildershop

				doGiveSpawnMats(this, p, overlapped);
			}
		}

		// automatic resupplies for builders
		if(gametime >= this.get_s32("nextresuply")) {
			doGiveMats(this);
		}
	}
}

// Reset timer in case player who joins has an outdated timer
void onNewPlayerJoin(CRules@ this, CPlayer@ player)
{
	s32 next_add_time = getGameTime() + (this.isWarmup() ? materials_wait_warmup : materials_wait) * getTicksASecond();

	if (this.getCurrentState() == WARMUP)
		SetCTFTimer(this, player, 0, "builder");
	else
		SetCTFTimer(this, player, this.get_s32("nextresuply"), "builder");
	if (next_add_time < getCTFTimer(this, player, "builder") || next_add_time < getCTFTimer(this, player, "archer"))
	{
		SetCTFTimer(this, player, getGameTime(), "archer");
	}
}
