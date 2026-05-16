// DefenceShieldUtility.as

// change sprite for the shield, if shield attached to some player
f32 getSnappedAngle(CBlob@ holder, f32 angle_step = 45)
{
	if (holder is null) return 0;
	f32 shield_angle = getShieldAngle(holder);
	f32 snapped_angle = Maths::Floor((shield_angle + holder.getAngleDegrees()) / angle_step + 0.5f) * angle_step;
	return snapped_angle;
}

f32 getShieldAngle(CBlob@ this)
{
	const bool flip = this.isFacingLeft();
	const f32 flip_factor = flip ? -1: 1;
	const u16 angle_flip_factor = flip ? 180 : 0;
	
	Vec2f pos = this.getPosition();
 	Vec2f aimvector = this.getAimPos() - pos;
	f32 angle = aimvector.Angle();// + this.getAngleDegrees();
	//return angle_flip_factor-angle;
    return constrainAngle(angle_flip_factor - (angle + flip_factor));
}

f32 constrainAngle(f32 x)
{
	x = (x + 180) % 360;
	if (x < 0) x += 360;
	return x - 180;
}
