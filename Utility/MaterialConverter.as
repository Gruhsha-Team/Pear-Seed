// MaterialConverter.as
void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{
    if (!isServer()) return;

    u16 mats_count = attached.getQuantity();

    // Convert material
    if (this !is null && attached !is null) {
        if (attached.getConfig() == "mat_wood") {
                getRules().add_s32("personalwood_" + this.getPlayer().getUsername(), mats_count);
                attached.server_Die();
        } else if (attached.getConfig() == "mat_stone") {
                getRules().add_s32("personalstone_" + this.getPlayer().getUsername(), mats_count);
                attached.server_Die();
        }
    }
}
