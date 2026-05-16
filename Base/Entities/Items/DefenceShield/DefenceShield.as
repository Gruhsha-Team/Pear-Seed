// DefenceShield.as

#include "ShieldCommon.as";
#include "KnightCommon.as";
#include "KnockedCommon.as";
#include "Hitters.as";
#include "GruhshaHitters.as";

void onInit(CBlob@ this) {
	// special variables for correct sprite set
	this.set_string("shield owner", "none");
	this.set_u8("shield type", 0);
}

void onTick(CBlob@ this) {
	AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
	if (point is null) return;

	CBlob@ holder = point.getOccupied();
	if (holder is null) return;

	// kill the shield
	if (this.getHealth() <= 0) {
		this.server_Die();
		//setKnocked(holder, 40, true);
	}
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint) {
	u8 type = this.get_u8("shield type");
	string owner = this.get_string("shield owner");

	this.setInventoryName(owner + "'s Shield");
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint) {
	u8 type = this.get_u8("shield type");
	CSprite@ sprite = this.getSprite();
	if (sprite is null) return;
	
	sprite.SetAnimation("default");

	if (this !is null && detached !is null) {
		CPlayer@ pl = detached.getPlayer();
		if (pl is null) return;

		sprite.SetRelativeZ(10.0f);
		sprite.getAnimation("default").SetFrameIndex(type);
	}

	setShieldEnabled(detached, false);
}
