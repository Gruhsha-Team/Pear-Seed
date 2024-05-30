//Explode.as - Explosions

/**
 *
 * used mainly for void Explode ( CBlob@ this, f32 radius, f32 damage )
 *
 * the effect of the explosion can be customised with properties:
 *
 * f32 map_damage_radius        - the radius to damage the map in
 * f32 map_damage_ratio         - the ratio of part-damage to full-damage of the map
 *                                  0.0 is all part-damage, 1.0 is all full-damage
 * bool map_damage_raycast      - whether to damage through terrain, or just the surface blocks;
 *
 * string custom_explosion_sound - the sound played when the explosion happens
 *
 * u8 custom_hitter             - the hitter from Hitters.as to use
 */


#include "Hitters.as";
#include "ShieldCommon.as";
#include "SplashWater.as";

bool isOwnerBlob(CBlob@ this, CBlob@ that)
{
	//easy check
	if (this.getDamageOwnerPlayer() is that.getPlayer())
		return true;

	if (!this.exists("explosive_parent")) { return false; }

	return (that.getNetworkID() == this.get_u16("explosive_parent"));
}

void makeSmallExplosionParticle(Vec2f pos)
{
	if (getRules().get_string("clusterfuck") == "off") return;
	ParticleAnimated("Entities/Effects/Sprites/SmallExplosion" + (XORRandom(3) + 1) + ".png",
	                 pos, Vec2f(0, 0.5f), 0.0f, 1.0f,
	                 3 + XORRandom(3),
	                 -0.1f, true);
}

void makeLargeExplosionParticle(Vec2f pos)
{
	if (getRules().get_string("clusterfuck") == "off") return;
	ParticleAnimated("Entities/Effects/Sprites/Explosion.png",
	                 pos, Vec2f(0, 0.5f), 0.0f, 1.0f,
	                 3 + XORRandom(3),
	                 -0.1f, true);
}

void Explode(CBlob@ this, f32 radius, f32 damage)
{
	Vec2f pos = this.getPosition();
	CMap@ map = this.getMap();

	if (!this.exists("custom_explosion_sound"))
	{
		Sound::Play("Bomb.ogg", this.getPosition());
	}
	else
	{
		Sound::Play(this.get_string("custom_explosion_sound"), this.getPosition());
	}

	if (this.isInInventory())
	{
		CBlob@ doomed = this.getInventoryBlob();
		if (doomed !is null)
		{
			//copy position, explode from centre of carrier
			pos = doomed.getPosition();
			//kill or stun players if we're in their inventory
			if ((doomed.hasTag("player") || doomed.getName() == "crate") && !doomed.hasTag("invincible"))
			{
				if (this.getName() == "bomb") //kill player
				{
					this.server_Hit(doomed, pos, Vec2f(), 100.0f, Hitters::explosion, true);
				}
				else if (this.getName() == "waterbomb") //stun player
				{
					this.server_Hit(doomed, pos, Vec2f(), 0.0f, Hitters::water_stun_force, true);
				}
			}
		}
	}

	//load custom properties
	//map damage
	f32 map_damage_radius = 0.0f;

	if (this.exists("map_damage_radius"))
	{
		map_damage_radius = this.get_f32("map_damage_radius");
	}

	f32 map_damage_ratio = 0.5f;

	if (this.exists("map_damage_ratio"))
	{
		map_damage_ratio = this.get_f32("map_damage_ratio");
	}

	bool map_damage_raycast = true;

	if (this.exists("map_damage_raycast"))
	{
		map_damage_raycast = this.get_bool("map_damage_raycast");
	}

	const bool bomberman = this.hasTag("bomberman_style");

	//actor damage
	u8 hitter = Hitters::explosion;

	if (this.exists("custom_hitter"))
	{
		hitter = this.get_u8("custom_hitter");
	}

	bool should_teamkill = this.exists("explosive_teamkill") && this.get_bool("explosive_teamkill");

	const int r = (radius * (2.0 / 3.0));

	if (hitter == Hitters::water)
	{
		int tilesr = (r / map.tilesize) * 0.5f;
		Splash(this, tilesr, tilesr, 0.0f);
		return;
	}

	//

	makeLargeExplosionParticle(pos);


	if (bomberman)
	{
		BombermanExplosion(this, radius, damage, map_damage_radius, map_damage_ratio, map_damage_raycast, hitter, should_teamkill);

		return; //------------------------------------------------------ END WHEN BOMBERMAN
	}



	if (this.getName() != "keg")
	{
		for (int i = 0; i < radius * 0.16; i++)
		{
			Vec2f partpos = pos + Vec2f(XORRandom(r * 2) - r, XORRandom(r * 2) - r);
			Vec2f endpos = partpos;

			if (map !is null)
			{
				if (!map.rayCastSolid(pos, partpos, endpos))
					makeSmallExplosionParticle(endpos);
			}
		}
	}
	else
	{
		/*const int radius_test = radius * (2.0 / 3.0);

		for (int i = 0; i <= 8; i++)
		{
			Vec2f offset;
			if (i==0) offset = Vec2f(0, radius_test - 4);
			if (i==1) offset = Vec2f(radius_test / 2, radius_test / 2);
			if (i==3) offset = Vec2f(radius_test - 4, 0);
			if (i==4) offset = Vec2f(-radius_test / 2, radius_test / 2);
			if (i==5) offset = Vec2f(0, -(radius_test - 4));
			if (i==6) offset = Vec2f(-radius_test / 2, -radius_test / 2);
			if (i==7) offset = Vec2f(-(radius_test - 4), 0);
			if (i==8) offset = Vec2f(radius_test / 2, -radius_test / 2);

			Vec2f partpos = pos + offset;
			Vec2f endpos = partpos;

			if (map !is null)
			{
				if (!map.rayCastSolid(pos, partpos, endpos))
					makeSmallExplosionParticle(endpos);
			}
		}*/

		// Waffle: Increase keg explosion visuals
		for (int i = 0; i < radius * 0.5; i++)
		{
			Vec2f partpos = pos + Vec2f(XORRandom(r * 2) - r, XORRandom(r * 2) - r);
			Vec2f endpos = partpos;

			if (map !is null)
			{
				if (!map.rayCastSolid(pos, partpos, endpos))
				{
					makeLargeExplosionParticle(endpos);
				}
			}
		}
	}

	if (getNet().isServer())
	{
        Vec2f m_pos = (pos / map.tilesize);
        m_pos.x = Maths::Floor(m_pos.x);
        m_pos.y = Maths::Floor(m_pos.y);
        m_pos = (m_pos * map.tilesize) + Vec2f(map.tilesize / 2, map.tilesize / 2);

		//hit map if we're meant to
		if (map_damage_radius > 0.1f)
		{
			int tile_rad = int(map_damage_radius / map.tilesize) + 1;
			f32 rad_thresh = map_damage_radius * map_damage_ratio;

			//explode outwards
			for (int x_step = 0; x_step <= tile_rad; ++x_step)
			{
				for (int y_step = 0; y_step <= tile_rad; ++y_step)
				{
					Vec2f offset = (Vec2f(x_step, y_step) * map.tilesize);

					for (int i = 0; i < 4; i++)
					{
						if (i == 1)
						{
							if (x_step == 0) { continue; }

							offset.x = -offset.x;
						}

						if (i == 2)
						{
							if (y_step == 0) { continue; }

							offset.y = -offset.y;
						}

						if (i == 3)
						{
							if (x_step == 0) { continue; }

							offset.x = -offset.x;
						}

						f32 dist = offset.Length();

						if (dist < map_damage_radius)
						{
                            Vec2f tpos = m_pos + offset;

                            TileType tile = map.getTile(tpos).type;
                            if (tile == CMap::tile_empty)
                                continue;

							//do we need to raycast?
							bool canHit = !map_damage_raycast || (dist < 0.1f);

							if (!canHit)
							{
								Vec2f v = offset;
								v.Normalize();
								v = v * (dist - map.tilesize);
                                canHit = true;
                                HitInfo@[] hitInfos;
                                if(map.getHitInfosFromRay(m_pos, v.Angle(), v.Length(), this, hitInfos))
                                {
                                    for (int i = 0; i < hitInfos.length; i++)
                                    {
                                        HitInfo@ hi = hitInfos[i];
                                        CBlob@ b = hi.blob;
                                        // m_pos == position ignores blobs that are tiles when the explosion starts in the same tile
                                        if (b !is null && b !is this && b.isCollidable() && b.getShape().isStatic() && m_pos != b.getPosition())
                                        {
                                            /*if (b.isPlatform())
                                            {
                                                // bad but only handle one platform
                                                ShapePlatformDirection@ plat = b.getShape().getPlatformDirection(0);
                                                Vec2f dir = plat.direction;
                                                if (!plat.ignore_rotations)
                                                {
                                                    dir.RotateBy(b.getAngleDegrees());
                                                }

                                                // Does the platform block damage?
                                                if(Maths::Abs(dir.AngleWith(v)) < plat.angleLimit)
                                                {
                                                    canHit = false;
                                                    break;
                                                }
                                                continue;

                                            }*/

                                            canHit = false;
                                            break;
                                        }

                                        if(map.isTileSolid(hi.tile))
                                        {
                                            canHit = false;
                                            break;
                                        }
                                    }

                                }
							}

							if (canHit)
							{
								if (canExplosionDamage(map, tpos, tile))
								{
									if (!map.isTileBedrock(tile))
									{
										if (dist >= rad_thresh ||
										        !canExplosionDestroy(map, tpos, tile))
										{
											map.server_DestroyTile(tpos, 1.0f, this);
										}
										else
										{
											map.server_DestroyTile(tpos, 100.0f, this);
										}
									}
								}
							}
						}
					}
				}
			}

			//end loops
		}

		//hit blobs
		CBlob@[] blobs;
		map.getBlobsInRadius(pos, radius, @blobs);

		for (uint i = 0; i < blobs.length; i++)
		{
			CBlob@ hit_blob = blobs[i];
			if (hit_blob is this)
				continue;

			HitBlob(this, m_pos, hit_blob, radius, damage, hitter, true, should_teamkill);
		}
	}

}

void onHitBlob(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData)
{
	if (customData == Hitters::bomb || customData == Hitters::water)
	{
		if (!hitBlob.hasTag("player"))
		{
			//printf("onhitblob " + hitBlob.getName() + ", velocity: " + velocity + " , length: " + velocity.Length() + ", gt: " + getGameTime());
			hitBlob.AddForce(velocity);
		}
	}
}

/**
 * Perform a linear explosion (a-la bomberman if in the cardinal directions)
 */

void LinearExplosion(CBlob@ this, Vec2f _direction, f32 length, const f32 width,
                     const int max_depth, f32 damage, const u8 hitter, CBlob@[]@ blobs = null,
                     bool should_teamkill = false)
{
	Vec2f pos = this.getPosition();
	CMap@ map = this.getMap();

	f32 tilesize = map.tilesize;

	Vec2f direction = _direction;

	direction.Normalize();
	direction *= tilesize;

	const f32 halfwidth = width * 0.5f;

	Vec2f normal = direction;
	normal.RotateBy(90.0f, Vec2f());
	if (normal.y > 0) //so its the same normal for right and left
		normal.RotateBy(180.0f, Vec2f());

	pos += normal * -(halfwidth / tilesize + 1.0f);
    Vec2f m_pos = pos;

	bool isserver = getNet().isServer();

	int steps = int(length / tilesize);
	int width_steps = int(width / tilesize);
	int damagedsteps = 0;
	bool laststep = false;

	for (int step = 0; step <= steps; ++step)
	{
		bool damaged = false;

		Vec2f tpos = pos;
		for (int width_step = 0; width_step < width_steps + 2; width_step++)
		{
			bool justhurt = laststep || (width_step == 0 || width_step == width_steps + 1);
			tpos += normal;

			if (!justhurt && (((step + width_step) % 3 == 0) || XORRandom(3) == 0)) makeSmallExplosionParticle(tpos);

			if (isserver)
			{
				TileType t = map.getTile(tpos).type;
				if (t == CMap::tile_bedrock)
				{
					if (!justhurt && width_step == width_steps / 2 + 1) //central bedrock only
					{
						steps = step;
						damagedsteps = max_depth; //blocked!
						break;
					}
				}
				else if (t != CMap::tile_empty && t != CMap::tile_ground_back)
				{
					if (canExplosionDamage(map, tpos, t))
					{
						if (!justhurt)
							damaged = true;

						justhurt = justhurt || !canExplosionDestroy(map, tpos, t);
						map.server_DestroyTile(tpos, justhurt ? 5.0f : 100.0f, this);
					}
					else
					{
						damaged = true;
					}
				}
			}
		}

		if (damaged)
			damagedsteps++;

		if (damagedsteps >= max_depth)
		{
			if (!laststep)
			{
				laststep = true;
			}
			else
			{
				steps = step;
				break;
			}
		}

		pos += direction;
	}

	if (!isserver) return; //EARLY OUT ---------------------------------------- SERVER ONLY BELOW HERE

	//prevent hitting through walls
	length = steps * tilesize;

	// hit blobs

	pos = this.getPosition();
	direction.Normalize();
	normal.Normalize();

	if (blobs is null)
	{
		Vec2f tolerance(tilesize * 2, tilesize * 2);

		CBlob@[] tempblobs;
		@blobs = tempblobs;
		map.getBlobsInBox(pos - tolerance, pos + (direction * length) + tolerance, @blobs);
	}

	for (uint i = 0; i < blobs.length; i++)
	{
		CBlob@ hit_blob = blobs[i];
		if (hit_blob is this)
			continue;

		float rad = Maths::Max(tilesize, hit_blob.getRadius() * 0.25f);
		Vec2f hit_blob_pos = hit_blob.getPosition();
		Vec2f v = hit_blob_pos - pos;

		//lengthwise overlap
		float p = (v * direction);
		if (p > rad) p -= rad;
		if (p > tilesize) p -= tilesize;

		//widthwise overlap
		float q = Maths::Abs(v * normal) - rad - tilesize;

		if (p > 0.0f && p < length && q < halfwidth)
		{
			HitBlob(this, m_pos, hit_blob, length, damage, hitter, false, should_teamkill);
		}
	}
}

void BombermanExplosion(CBlob@ this, f32 radius, f32 damage, f32 map_damage_radius,
                        f32 map_damage_ratio, bool map_damage_raycast, const u8 hitter,
                        const bool should_teamkill = false)
{
	Vec2f pos = this.getPosition();
	CMap@ map = this.getMap();
	const f32 interval = map.tilesize;

	const int steps = 4; //HACK - todo property

	f32 ray_width = 16.0f;
	if (this.exists("map_bomberman_width"))
	{
		ray_width = this.get_f32("map_bomberman_width");
	}

	//get blobs
	CBlob@[] blobs;
	map.getBlobsInRadius(pos, radius, @blobs);

	//up
	LinearExplosion(this, Vec2f(0, -1), radius, ray_width, steps, damage, hitter, blobs, should_teamkill);
	//down
	LinearExplosion(this, Vec2f(0, 1), radius, ray_width, steps, damage, hitter, blobs, should_teamkill);
	//left and right
	LinearExplosion(this, Vec2f(-1, 0), radius, ray_width, steps, damage, hitter, blobs, should_teamkill);
	LinearExplosion(this, Vec2f(1, 0), radius, ray_width, steps, damage, hitter, blobs, should_teamkill);

}

bool canExplosionDamage(CMap@ map, Vec2f tpos, TileType t)
{
	CBlob@[] blist;

	bool hasValidFrontBlob = false;
	bool isBackwall = (t == CMap::tile_castle_back || t == CMap::tile_castle_back_moss || t == CMap::tile_wood_back);

	if (map.getBlobsAtPosition(tpos, blist))
	{
		for (int i=0; i<blist.length; ++i)
		{
			string name = blist[i].getName();
			hasValidFrontBlob = (name == "wooden_door" || name == "stone_door" || name == "trap_block" || name == "wooden_platform" || name == "bridge");

			if (hasValidFrontBlob) break;
		}
	}
	//return (t != 29 && t != 30 && t != 31 && t != CMap::tile_ground && t != CMap::tile_stone_d0);
	return (t != 29 && t != 30 && t != 31 && t != CMap::tile_ground && t != CMap::tile_stone_d0 && !(hasValidFrontBlob && isBackwall));
}

bool canExplosionDestroy(CMap@ map, Vec2f tpos, TileType t)
{
	return !(map.isTileGroundStuff(t));
}

bool HitBlob(CBlob@ this, Vec2f mapPos, CBlob@ hit_blob, f32 radius, f32 damage, const u8 hitter,
             const bool bother_raycasting = true, const bool should_teamkill = false)
{
    // Waffle: Protect drivers
    if (hitter != Hitters::water && hit_blob.hasTag("vehicle protection"))
    {
        return false;
    }

	Vec2f pos = this.getPosition();
	CMap@ map = this.getMap();
	Vec2f hit_blob_pos = hit_blob.getPosition();
	Vec2f wall_hit;
	Vec2f hitvec = hit_blob_pos - pos;

	if (bother_raycasting && this.getName() != "keg") // have we already checked the rays?
	{
		// no wall in front

		if (map.rayCastSolidNoBlobs(pos, hit_blob_pos, wall_hit)) { return false; }

		// no blobs in front

		HitInfo@[] hitInfos;
		if (map.getHitInfosFromRay(pos, -hitvec.getAngle(), hitvec.getLength(), this, @hitInfos))
		{
			for (uint i = 0; i < hitInfos.length; i++)
			{
				HitInfo@ hi = hitInfos[i];

				if (hi.blob !is null) // blob
				{
                    // mapPos == position ignores blobs that are tiles when the explosion starts in the same tile
					if (hi.blob is this || hi.blob is hit_blob || !hi.blob.isCollidable() || mapPos == hi.blob.getPosition())
					{
						continue;
					}

                    CBlob@ b = hi.blob;
                    if (b.isPlatform())
                    {
                        ShapePlatformDirection@ plat = b.getShape().getPlatformDirection(0);
                        Vec2f dir = plat.direction;
                        if (!plat.ignore_rotations)
                        {
                            dir.RotateBy(b.getAngleDegrees());
                        }

                        // Does the platform block damage
                        Vec2f hitvec_dir = -hitvec;
                        if (hit_blob.isPlatform())
                        {
                            hitvec_dir = hitvec;
                        }

                        if(Maths::Abs(dir.AngleWith(hitvec_dir)) < plat.angleLimit)
                        {
                            return false;
                        }
                        continue;
                    }

					// only shield and heavy things block explosions
					if (hi.blob.hasTag("heavy weight") ||
					        hi.blob.getMass() > 500 || hi.blob.getShape().isStatic() ||
					        (hi.blob.hasTag("shielded") && blockAttack(hi.blob, hitvec, 0.0f)))
					{
						return false;
					}
				}
			}
		}
	}

	f32 scale;
	Vec2f bombforce = getBombForce2(this, radius, hit_blob_pos, pos, hit_blob.getMass(), scale);
	f32 dam = damage * scale;

	bombforce = getBombForce3(this, radius, hit_blob_pos, pos, hit_blob.getMass(), scale);

	//printf("Force1: " + bombforce);

	//explosion particle
	makeSmallExplosionParticle(hit_blob_pos);

	//printf("Hello, hitting blob: " + hit_blob.getHealth() + ", " + dam);

	bool easy_bombjump = false;

	if (!easy_bombjump)
	{
			this.server_Hit(hit_blob, hit_blob_pos,
	                bombforce, dam,
	                hitter, hitter == Hitters::water || //hit with water
	                isOwnerBlob(this, hit_blob) ||	//allow selfkill with bombs
	                should_teamkill || hit_blob.hasTag("dead") || //hit all corpses ("dead" tag)
					hit_blob.hasTag("explosion always teamkill") || // check for override with tag
					(this.isInInventory() && this.getInventoryBlob() is hit_blob) //is the inventory container
	               );
	}

	if (hit_blob.getHealth() <= 0)
	{
		map.server_DestroyTile(hit_blob_pos, 100.0f, this);
	}

	return true;

	if (hit_blob.getCarriedBlob() !is null)
	{
		if (hit_blob.getCarriedBlob() is this)
		{
			ShieldVars@ vars = getShieldVars(hit_blob);

			if (vars !is null)
			{
				if (vars.enabled)
				{
					Vec2f offsetg = hit_blob.getAimPos() - hit_blob.getPosition();
					//offsetg.RotateByDegrees(180);
					offsetg.Normalize();

					Vec2f new_pos = hit_blob.getPosition() + (offsetg * 2);
					f32 scale2;
					Vec2f bombforce2 = getBombForce2(this, radius, hit_blob_pos, new_pos, hit_blob.getMass(), scale2);

					/*printf("mouse pos: " + hit_blob.getAimPos());
					printf("Pos: " + hit_blob.getPosition());
					printf("Bombpos: " + new_pos);
					printf("Force2: " + bombforce2);*/

					easy_bombjump = true;

					/*if (isServer())
					{

					}*/
					this.set_u16("TESTGE", hit_blob.getNetworkID());
					this.Sync("TESTGE", true);
					//this.Sync

					this.server_Hit(hit_blob, new_pos,
	                bombforce2, dam,
	                hitter, hitter == Hitters::water || //hit with water
	                isOwnerBlob(this, hit_blob) ||	//allow selfkill with bombs
	                should_teamkill || hit_blob.hasTag("dead") || //hit all corpses ("dead" tag)
					hit_blob.hasTag("explosion always teamkill") // check for override with tag
	               );

					/*Vec2f vel = hit_blob.getVelocity();
					hit_blob.setVelocity(Vec2f(0.0f, Maths::Min(0.0f, vel.y)));

					Vec2f new_bombforce = Vec2f(0.0f, ((bombforce.y > 0) ? 0.7f : -1.3f));

					new_bombforce.Normalize();
					new_bombforce *= 2.0f * Maths::Sqrt(dam) * hit_blob.getMass();
					new_bombforce.y -= 2;

					if (!hit_blob.isOnGround() && !hit_blob.isOnLadder())
					{
						if (hit_blob.isFacingLeft() && vel.x > 0)
						{
							new_bombforce.x += 50;
							new_bombforce.y -= 80;
						}
						else if (!hit_blob.isFacingLeft() && vel.x < 0)
						{
							new_bombforce.x -= 50;
							new_bombforce.y -= 80;
						}
					}
					else if (hit_blob.isFacingLeft() && vel.x > 0)
					{
						new_bombforce.x += 5;
					}
					else if (!hit_blob.isFacingLeft() && vel.x < 0)
					{
						new_bombforce.x -= 5;
					}

					hit_blob.AddForce(new_bombforce);
					hit_blob.Tag("dont stop til ground");*/
				}
			}

			/*//zero direction = bypass shield
			if (direction.LengthSquared() < 0.001f) return false;

			//shield isn't blocking/strong enough
			f32 angle = Maths::Abs(vars.direction.AngleWith(direction));
			f32 angle_difference = 180.0f - angle;*/
		}
	}
}

Vec2f getBombForce2(CBlob@ this, f32 radius, Vec2f hit_blob_pos, Vec2f pos, f32 hit_blob_mass, f32 &out scale)
{
	Vec2f offset = hit_blob_pos - pos;
	f32 distance = offset.Length();
	//set the scale (2 step)

	//printf("GETBOMBFORCE offset " + offset);

	scale = (distance > (radius * 0.7)) ? 0.5f : 1.0f;
	//the force, copy across
	Vec2f bombforce = offset;
	bombforce.Normalize();
	bombforce *= 2.0f;
	bombforce.y -= 0.2f; // push up for greater cinematic effect
	/*if (bombforce.x <= 0) bombforce.x = -2;
	if (bombforce.x > 0) bombforce.x = 2;*/
	//bombforce.x = _round(bombforce.x);
	//printf("g " + bombforce.x);
	//bombforce.y = _round(bombforce.y);
	bombforce /= 2.0f;
	bombforce *= hit_blob_mass * (3.0f) * scale;

	//printf("GETBOMBFORCE bombforce: " + bombforce);
	return bombforce;
}

Vec2f getBombForce3(CBlob@ this, f32 radius, Vec2f hit_blob_pos, Vec2f pos, f32 hit_blob_mass, f32 &out scale)
{
	Vec2f offset = hit_blob_pos - pos;
	f32 distance = offset.Length();
	//set the scale (2 step)

	//printf("GETBOMBFORCE offset " + offset);

	scale = 1.0f;
	//the force, copy across
	Vec2f bombforce = offset;
	bombforce.Normalize();
	bombforce *= 2.0f;
	bombforce.y -= 0.2f; // push up for greater cinematic effect
	/*if (bombforce.x <= 0) bombforce.x = -2;
	if (bombforce.x > 0) bombforce.x = 2;*/
	//bombforce.x = _round(bombforce.x);
	//printf("g " + bombforce.x);
	//bombforce.y = _round(bombforce.y);
	bombforce /= 2.0f;
	bombforce *= hit_blob_mass * (3.0f) * scale;

	//printf("GETBOMBFORCE bombforce: " + bombforce);
	return bombforce;
}

float _round(float x)
{
    return Maths::Floor(x + 0.5);
}