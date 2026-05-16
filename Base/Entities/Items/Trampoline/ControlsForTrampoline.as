// press action1 to click buttons
void HandleButtonClickKey(CBlob@ this, AttachmentPoint@ point = null)
{
	if (getHUD().hasButtons())
	{
		if (point !is null)
		{
			if ((point.isKeyJustPressed(key_action1)) && !point.isKeyPressed(key_pickup))
			{
				ButtonOrMenuClick(this, this.getAimPos(), false, true);
				this.set_bool("release click", false);
			}
		}
		else
		{
			if ((this.isKeyJustPressed(key_action1)) && !this.isKeyPressed(key_pickup))
			{
				ButtonOrMenuClick(this, this.getAimPos(), false, true);
				this.set_bool("release click", false);
			}
		}
	}
}

bool ClickGridMenu(CBlob@ this, int button)
{
	CGridMenu @gmenu;
	CGridButton @gbutton;

	if (this.ClickGridMenu(button, gmenu, gbutton))   // button gets pressed here - thing get picked up
	{
		if (gmenu !is null)
		{
			// if (gmenu.getName() == this.getInventory().getMenuName() && gmenu.getOwner() !is null)
			{
				if (gbutton is null)    // carrying something, put it in
				{
					client_PutInHeld(this);
				}
				else // take something
				{
					// handled by button cmd   // hardcoded still :/
				}
			}
			return true;
		}
	}

	return false;
}

void ButtonOrMenuClick(CBlob@ this, Vec2f pos, bool clear, bool doClosestClick)
{
	if (!ClickGridMenu(this, 0))
		if (this.ClickInteractButton())
		{
			clear = false;
		}
		else if (doClosestClick)
		{
			if (this.ClickClosestInteractButton(pos, this.getRadius() * 1.0f))
			{
				this.ClearButtons();
				clear = false;
			}
		}

	if (clear)
	{
		this.ClearButtons();
		this.ClearMenus();
	}
}