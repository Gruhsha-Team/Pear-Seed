// MaterialConverter.as
void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{
    if (!isServer()) return;

    u16 mats_count = attached.getQuantity();
    printf("time " + getGameTime());

    // Set timer in blob
    if (this !is null && attached !is null) {
        if (attached.getConfig() == "mat_wood") {
            attached.set_u32("convertimer", getGameTime() + (5 * getTicksASecond()));
            attached.Sync("convertimer", true);

            //printf("converting in " + attached.get_u32("convertimer"));
        } else if (attached.getConfig() == "mat_stone") {
            attached.set_u32("convertimer", getGameTime() + (5 * getTicksASecond()));
            attached.Sync("convertimer", true);

            //printf("converting in " + attached.get_u32("convertimer"));
        }
    }

    // Convert material
    if (this !is null && attached !is null) {
        if (attached.getConfig() == "mat_wood" /*&& getGameTime() >= attached.get_u32("convertimer")*/) {
                getRules().add_s32("personalwood_" + this.getPlayer().getUsername(), mats_count);
                attached.server_Die();
        } else if (attached.getConfig() == "mat_stone" /*&& getGameTime() >= attached.get_u32("convertimer")*/) {
                getRules().add_s32("personalstone_" + this.getPlayer().getUsername(), mats_count);
                attached.server_Die();
        }
    }
}

/*void onTick(CInventory@ this)
{

}*/