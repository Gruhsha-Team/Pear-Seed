// DrillShieldLogic.as
#include "ShieldCommon.as";

const f32 SHIELD_BLOCK_ANGLE = 175.0f;

void onInit(CBlob@ this) {
	addShieldVars(this, SHIELD_BLOCK_ANGLE, 2.0f, 5.0f);
}

void onTick(CBlob@ this) {
	//////////////////////////////////////
	// drill shielding mechanic
	//////////////////////////////////////
	CBlob@ drilla = this.getCarriedBlob();
	if (drilla !is null && drilla.getConfig() == "drill") {
   	 	ShieldVars@ shieldVars = getShieldVars(this);
    	if (shieldVars is null) return;

	    Vec2f pos = this.getPosition();
	    Vec2f vel = this.getVelocity();
	    Vec2f aimpos = this.getAimPos();

        Vec2f vec;
	    const int direction = this.getAimDirection(aimpos);
	    const f32 side = (this.isFacingLeft() ? 1.0f : -1.0f);
	    bool walking = (this.isKeyPressed(key_left) || this.isKeyPressed(key_right));

		if (!drilla.hasTag("no shielding")) {
            setShieldEnabled(this, true);
            setShieldAngle(this, SHIELD_BLOCK_ANGLE);

            int horiz = this.isFacingLeft() ? -1 : 1;

		    if (walking) {
			    if (direction == 0) { //forward
			    	setShieldDirection(this, Vec2f(horiz, 0));
			    } else if (direction == 1) {   //down
			    	setShieldDirection(this, Vec2f(horiz, 3));
			    } else {
			    	setShieldDirection(this, Vec2f(horiz, -3));
			    }
		    } else {
			    if (direction == 0) {   //forward
			    	setShieldDirection(this, Vec2f(horiz, 0));
			    } else if (direction == 1) {   //down
			    	setShieldDirection(this, Vec2f(horiz, 3));
			    } else { //up
				    if (vec.y < -0.97) {
				    	setShieldDirection(this, Vec2f(0, -1));
				    } else {
				    	setShieldDirection(this, Vec2f(horiz, -3));
				    }
			    }
		    }

			if (!drilla.hasTag("no shielding") && drilla.get_f32("shield health") > 0) {
				if (drilla.get_u8("drill heat") > 70 && drilla.get_u8("drill heat") < 150) {
					if (getGameTime() % 30 == 0)
						drilla.sub_f32("shield health", 0.05f);
						drilla.Sync("shield health", true);
				}
			}
        } else {
			setShieldEnabled(this, false);
		}
	} else {
		setShieldEnabled(this, false);
	}
	//////////////////////////////////////
	//////////////////////////////////////
}