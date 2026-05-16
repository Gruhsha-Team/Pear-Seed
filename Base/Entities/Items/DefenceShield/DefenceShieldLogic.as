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
	if (drilla !is null && drilla.getConfig() == "defenceshield") {
   	 	ShieldVars@ shieldVars = getShieldVars(this);
    	if (shieldVars is null) return;

	    Vec2f pos = this.getPosition();
	    Vec2f vel = this.getVelocity();
	    Vec2f aimpos = this.getAimPos();

        Vec2f vec;
	    const int direction = this.getAimDirection(aimpos);
	    const f32 side = (this.isFacingLeft() ? 1.0f : -1.0f);
	    bool walking = (this.isKeyPressed(key_left) || this.isKeyPressed(key_right));

		if (this.isKeyPressed(key_action2)) {
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

			    this.Tag("prevent crouch");
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

			// shield up = collideable
			if (direction == -1) {
				if (!this.hasTag("shieldplatform")) {
					this.getShape().checkCollisionsAgain = true;
					this.Tag("shieldplatform");
				}
			} else {
				if (this.hasTag("shieldplatform")) {
					this.getShape().checkCollisionsAgain = true;
					this.Untag("shieldplatform");
				}
			}

			/*if (getGameTime() % 60 == 0){
				printf("|-------------------------|");
				printf("horiz is " + horiz);
				printf("Side is " + side);
				printf("Direction is " + direction);
			}*/
        } else {
			setShieldEnabled(this, false);
		}
	} else {
		setShieldEnabled(this, false);
	}
	//////////////////////////////////////
	//////////////////////////////////////
}
