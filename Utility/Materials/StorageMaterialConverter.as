// StorageMaterialConverter.as

s32 convert_time_inventory = 10;

///////////////////////////////////////////////
// Converter heart
void onTick(CBlob@ this)
{
    if (!isServer()) return;

    CInventory@ inv = this.getInventory();
    CPlayer@ player = null;

    CPlayer@[] builders_blue;
    CPlayer@[] builders_red;

    // calculating amount of players in classes
    for (u32 i = 0; i < getPlayersCount(); i++) {
        CPlayer@ p = getPlayer(i);
		if (p is null) continue;

        if (getPlayer(i).getBlob() is null) continue;

        if (getPlayer(i).getBlob().getName() == "builder") {
            if (getPlayer(i).getTeamNum() == 0) builders_blue.push_back(p);
            else if (getPlayer(i).getTeamNum() == 1) builders_red.push_back(p);
        }
    }

    // Convert material, if storage have it in inventory
    if (this !is null && inv !is null) {
    	for (int i = 0; i < inv.getItemsCount(); i++) {
            CBlob@ item = inv.getItem(i);
            const string name = item.getName();

            const int stone_count = inv.getCount("mat_stone");
            const int wood_count = inv.getCount("mat_wood");

            // DEBUG
            /*if (name == "mat_stone") {
                printf("Stone amount in inventory is " + stone_count);
            } else if (name == "mat_wood") {
                printf("Wood amount in inventory is " + wood_count);
            }*/

            if (name == "mat_stone" && getGameTime() > convert_time_inventory * getTicksASecond() + item.get_s32("storage pickup time")) {
                if (this.getTeamNum() == 0 && builders_blue.length > 0) { // BLUE TEAM
                    for (int i = 0; i < builders_blue.length; ++i) {
                        CPlayer@ p = builders_blue[i];
                        if (p is null) continue;

                        getRules().add_s32("personalstone_" + p.getUsername(), stone_count / builders_blue.length);
                        getRules().Sync("personalstone_" + p.getUsername(), true);
                        //inv.server_RemoveItems("mat_stone", stone_count); // dont working with onRemoveFromInventory hook???

                        this.server_PutOutInventory(item);
                        item.server_Die();
                    }

                    this.SendCommand(this.getCommandID("play convert sound"));
                } else if (this.getTeamNum() == 1 && builders_red.length > 0) { // RED TEAM
                    for (int i = 0; i < builders_red.length; ++i) {
                        CPlayer@ p = builders_red[i];
                        if (p is null) continue;

                        getRules().add_s32("personalstone_" + p.getUsername(), stone_count / builders_red.length);
                        getRules().Sync("personalstone_" + p.getUsername(), true);
                        //inv.server_RemoveItems("mat_stone", stone_count); // dont working with onRemoveFromInventory hook???

                        this.server_PutOutInventory(item);
                        item.server_Die();
                    }

                    this.SendCommand(this.getCommandID("play convert sound"));
                }
            } else if (name == "mat_wood" && getGameTime() > convert_time_inventory * getTicksASecond() + item.get_s32("storage pickup time")) {
                if (this.getTeamNum() == 0 && builders_blue.length > 0) { // BLUE TEAM
                    for (int i = 0; i < builders_blue.length; ++i) {
                        CPlayer@ p = builders_blue[i];
                        if (p is null) continue;

                        getRules().add_s32("personalwood_" + this.getPlayer().getUsername(), wood_count / builders_blue.length);
                        getRules().Sync("personalwood_" + this.getPlayer().getUsername(), true);
                        //inv.server_RemoveItems("mat_wood", wood_count); // dont working with onRemoveFromInventory hook???

                        this.server_PutOutInventory(item);
                        item.server_Die();
                    }

                this.SendCommand(this.getCommandID("play convert sound"));
                } else if (this.getTeamNum() == 1 && builders_red.length > 0) { // RED TEAM
                    for (int i = 0; i < builders_red.length; ++i) {
                        CPlayer@ p = builders_red[i];
                        if (p is null) continue;

                        getRules().add_s32("personalwood_" + this.getPlayer().getUsername(), wood_count / builders_red.length);
                        getRules().Sync("personalwood_" + this.getPlayer().getUsername(), true);
                        //inv.server_RemoveItems("mat_wood", wood_count); // dont working with onRemoveFromInventory hook???

                        this.server_PutOutInventory(item);
                        item.server_Die();
                    }

                this.SendCommand(this.getCommandID("play convert sound"));
                }
            }
        }
    }
}
///////////////////////////////////////////////
///////////////////////////////////////////////

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
    if (cmd == this.getCommandID("play convert sound") && isClient()) {
        this.getSprite().PlaySound("/mat_converted.ogg");
    }
}

// Set pickup timer
void onAddToInventory(CBlob@ this, CBlob@ blob)
{
    if (!isServer()) return;

    if (this !is null && blob !is null) {
        if (blob.getConfig() == "mat_stone") {
            blob.set_s32("storage pickup time", getGameTime());
            blob.Sync("storage pickup time", true);

            //printf("Stone pickup time is " + blob.get_s32("pickup time"));
        } else if (blob.getConfig() == "mat_wood") {
            blob.set_s32("storage pickup time", getGameTime());
            blob.Sync("storage pickup time", true);

            //printf("Wood pickup time is " + blob.get_s32("pickup time"));
        }
    }
}
