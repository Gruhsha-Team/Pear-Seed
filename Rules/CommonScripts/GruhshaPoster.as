#define CLIENT_ONLY

bool showtut = true;
bool copied = false;

void onTick(CRules@ this)
{
	if (!showtut) return;

	CControls@ controls = getControls();

	float screen_size_y = getDriver().getScreenHeight();
    u8 res_scale = screen_size_y / 720;
    f32 resolution_scale = f32(res_scale);

    Vec2f middle(getDriver().getScreenWidth() / 2.0f, getDriver().getScreenHeight() / 2.0f);

    if (getDriver().getScreenWidth() < 1280 && getDriver().getScreenHeight() < 720) showtut = false;

    Vec2f cursor_pos = controls.getMouseScreenPos();

    Vec2f tl_x = middle + Vec2f(resolution_scale * 367, resolution_scale * -253);
    Vec2f br_x = tl_x + Vec2f(resolution_scale * 31, resolution_scale * 31);

    Vec2f tl_b = middle + Vec2f(-resolution_scale * 398, resolution_scale * 203);
    Vec2f br_b = middle + Vec2f(resolution_scale * 398, resolution_scale * 252);

   	//GUI::DrawPane(tl_x, br_x);

    if (cursor_pos.x >= tl_x.x && cursor_pos.x <= br_x.x &&
    	cursor_pos.y >= tl_x.y && cursor_pos.y <= br_x.y)
    {
    	if (controls.isKeyJustReleased(KEY_LBUTTON))
    	{
    		showtut = false;
    	}
    }

    /*if (cursor_pos.x >= tl_b.x && cursor_pos.x <= br_b.x &&
    	cursor_pos.y >= tl_b.y && cursor_pos.y <= br_b.y)
    {
    	if (controls.isKeyJustReleased(KEY_LBUTTON))
    	{
    		CopyToClipboard("https://discord.gg/sBJaTJPGYg");
    		copied = true;
    	}
    }*/

    if (controls.isKeyJustPressed(KEY_KEY_X))
	{
		showtut = false;
	}

    if (controls.isKeyJustPressed(KEY_LBUTTON))
    {
        showtut = false;
    }
}

void onRender(CRules@ this)
{
	if (!showtut) return;

	float screen_size_y = getDriver().getScreenHeight();
    u8 res_scale = screen_size_y / 720;
    f32 resolution_scale = f32(res_scale);
    
    Vec2f middle(getDriver().getScreenWidth() / 2.0f, getDriver().getScreenHeight() / 2.0f);

	const string tutorial_image = "GruhshaPoster.png";

	if(showtut)
	{
		if (resolution_scale >= 2)
			GUI::DrawIcon(tutorial_image, Vec2f(middle.x - 800, middle.y - 510), 0.5f);
		else 
			GUI::DrawIcon(tutorial_image, Vec2f(middle.x - 400, middle.y - 255), 0.25f);
	}

	CControls@ controls = getControls();
	Vec2f cursor_pos = controls.getMouseScreenPos();

    Vec2f tl_x = middle + Vec2f(resolution_scale * 367, resolution_scale * -253);
    Vec2f br_x = tl_x + Vec2f(resolution_scale * 31, resolution_scale * 31);

    Vec2f tl_b = middle + Vec2f(-resolution_scale * 398, resolution_scale * 203);
    Vec2f br_b = middle + Vec2f(resolution_scale * 398, resolution_scale * 252);

    if (copied)
    {
    	GUI::SetFont("big score font");
    	Vec2f text_center = middle + Vec2f(0, resolution_scale * 270);
    	GUI::DrawTextCentered("Link copied!", text_center, color_white);
    }
}
