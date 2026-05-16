// DefenceShieldRender.as
#include "DefenceShieldUtility.as";

// FIXME: epic hack for customized shield textures
void onTick(CSprite@ this) {
	CBlob@ blob = this.getBlob();
	if (blob is null) return;
	
	AttachmentPoint@ point = blob.getAttachments().getAttachmentPointByName("PICKUP");
	if (point is null) return;

	CBlob@ holder = point.getOccupied();
	if (holder is null) return;
	
	CPlayer@ pl = holder.getPlayer();
	if (pl is null) return;

	// set correct owner and use
	if (!blob.hasTag("OWNER SET")) {
		if (pl.getUsername() == "TerminalHash") {
			blob.set_u8("shield type", 1);
			blob.set_string("shield owner", pl.getUsername());
		} else if (pl.getUsername() == "karolloPL") {
			blob.set_u8("shield type", 2);
			blob.set_string("shield owner", pl.getUsername());
		} else if (pl.getUsername() == "plmoknijbuhvygcmarmo") {
			blob.set_u8("shield type", 3);
			blob.set_string("shield owner", pl.getUsername());
		} else if (pl.getUsername() == "tigorsun") {
			blob.set_u8("shield type", 4);
			blob.set_string("shield owner", pl.getUsername());
		} else if (pl.getUsername() == "cosm_akylka") {
			blob.set_u8("shield type", 5);
			blob.set_string("shield owner", pl.getUsername());
		}

		blob.Tag("OWNER SET");
	}

	u8 type = blob.get_u8("shield type");

	const bool FLIP = holder.isFacingLeft();
	const f32 FLIP_FACTOR = FLIP ? -1: 1;
	const u16 ANGLE_FLIP_FACTOR = FLIP ? 180 : 0;

	Vec2f aimpos = holder.getAimPos();
	const int direction = holder.getAimDirection(aimpos);

	f32 shield_dist = 4;
	f32 shield_y_factor = 0;
	f32 shield_y_offset = 2;
	f32 shield_x_offset = 0;
	f32 snapped_angle = getSnappedAngle(holder) - holder.getAngleDegrees();
	this.ResetTransform();
	this.ScaleBy(1.0f, 1.0f);

	if (!holder.hasTag("shielded")) {
		this.SetRelativeZ(-70.0f);
		this.SetAnimation("backside");

		this.getAnimation("backside").SetFrameIndex(type);

		shield_dist = 1;
	} else {
		this.SetRelativeZ(10.0f);
		this.SetAnimation("default");

		this.getAnimation("default").SetFrameIndex(type);

		if (direction == -1 && (snapped_angle != 45 && snapped_angle != -45)) {
			shield_y_offset = -4;	
		}

		if (direction == 1 && (snapped_angle != 45 && snapped_angle != -45)) {
			shield_x_offset = 5;	
		}

		this.RotateBy(snapped_angle, Vec2f(shield_dist * FLIP_FACTOR, shield_y_factor));

		/*if (getGameTime() % 60 == 0){
			printf("|-------------------------|");
			printf("getSnappedAngle is " + getSnappedAngle(holder));
			printf("getShieldAngle is " + getShieldAngle(holder));
			printf("Shield angle is " + snapped_angle);
		}*/
	}

	Vec2f sitting_offset = Vec2f(1,-4);
	Vec2f sitting_rotoff = Vec2f(2 * sitting_offset.x, sitting_offset.y);
	
	this.SetOffset(Vec2f(-shield_dist + shield_x_offset, 2 + blob.getVelocity().y) + (holder.hasTag("shielded") ? sitting_offset.RotateBy(-snapped_angle * FLIP_FACTOR, Vec2f()) : Vec2f()) + (holder.hasTag("shielded") ? Vec2f(0, shield_y_offset) : Vec2f()));
}
