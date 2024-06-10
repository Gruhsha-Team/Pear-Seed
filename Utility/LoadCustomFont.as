void onInit(CRules@ this)
{
	onRestart(this);

	if (!GUI::isFontLoaded("Balkara_Condensed"))
	{
		string Balkara = CFileMatcher("Balkara_Condensed.ttf").getFirst();
		GUI::LoadFont("Balkara_Condensed", Balkara, 20, true);
	}

	if (!GUI::isFontLoaded("SourceHanSansCN-Bold"))
	{
		string SourceSans = CFileMatcher("SourceHanSansCN-Bold.ttf").getFirst();
		GUI::LoadFont("SourceHanSansCN-Bold", SourceSans, 34, true);
	}
}

void onRestart(CRules@ this)
{
	if (isClient())
	{
        if (!GUI::isFontLoaded("Balkara_Condensed"))
        {
            string Balkara = CFileMatcher("Balkara_Condensed.ttf").getFirst();
            GUI::LoadFont("Balkara_Condensed", Balkara, 20, true);
        }

        if (!GUI::isFontLoaded("SourceHanSansCN-Bold"))
        {
            string SourceSans = CFileMatcher("SourceHanSansCN-Bold.ttf").getFirst();
            GUI::LoadFont("SourceHanSansCN-Bold", SourceSans, 34, true);
        }
	}
}
