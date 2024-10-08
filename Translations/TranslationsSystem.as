// TranslationsSystem.as
/*
	Система переводов для Grusha CTF

	Основана на наработках GingerBeard и использует отдельные
	скриптовые файлы для определения слов, описаний и тд.

	Имеющиеся языки:
	Russian
	English
*/

#include "language_en.as"
#include "language_ru.as"

// works by seperating each language by token '\\'
// all translations are only set on startup, therefore changing language mid-game will not update the strings
shared const string Translate(const string&in words)
{
	string[]@ tokens = words.split("\\");
	if (g_locale == "ru" && tokens.length > 1 && !tokens[1].empty()) 	//russian
		return tokens[1];	
		
	return tokens[0];													//english
}

namespace Descriptions
{
	const string

	// Accolades.as
	goldgrushatext		  	    	= Translate(en::d_goldgrushatext+"\\"+ru::d_goldgrushatext),
	bronzetokentext		  	    	= Translate(en::d_bronzetokentext+"\\"+ru::d_bronzetokentext),
	kiwitext		  	    		= Translate(en::d_kiwitext+"\\"+ru::d_kiwitext),
	captaintext		  	    		= Translate(en::d_captaintext+"\\"+ru::d_captaintext),

	// ArcherShop.as
	woodenarrowdesc		  	    	= Translate(en::d_woodenarrowdesc+"\\"+ru::d_woodenarrowdesc),
	stonearrowdesc		  	    	= Translate(en::d_stonearrowdesc+"\\"+ru::d_stonearrowdesc),

	// BindingsCommon.as
	modbindplaceholder		  	    = Translate(en::d_modbindplaceholder+"\\"+ru::d_modbindplaceholder),
	modbindnull		  	    		= Translate(en::d_modbindnull+"\\"+ru::d_modbindnull),

			// Settings
	bmoptlag						= Translate(en::d_bmoptlag+"\\"+ru::d_bmoptlag),
	bmoptvan						= Translate(en::d_bmoptvan+"\\"+ru::d_bmoptvan),
	universalyes		  	  		= Translate(en::d_universalyes+"\\"+ru::d_universalyes),
	universalno		  	  			= Translate(en::d_universalno+"\\"+ru::d_universalno),
	universalon		  	  			= Translate(en::d_universalon+"\\"+ru::d_universalon),
	universaloff		  	  		= Translate(en::d_universaloff+"\\"+ru::d_universaloff),
	universalold		  	  		= Translate(en::d_universalold+"\\"+ru::d_universalold),
	universalnew		  	  		= Translate(en::d_universalnew+"\\"+ru::d_universalnew),

	// PickingCommands.as
	bindingscom		  	       		= Translate(en::d_bindingscom+"\\"+ru::d_bindingscom),

	// Satchel.as
	satcheldesc			  	       	= Translate(en::d_satcheldesc+"\\"+ru::d_satcheldesc),

	// SoundsCommands.as
	togglesoundscomtext				= Translate(en::d_togglesoundscomtext+"\\"+ru::d_togglesoundscomtext),
	togglesoundschattexton			= Translate(en::d_togglesoundschattexton+"\\"+ru::d_togglesoundschattexton),
	togglesoundschattextoff			= Translate(en::d_togglesoundschattextoff+"\\"+ru::d_togglesoundschattextoff),

	// ScoreboardCommon.as
	oldstatstooltip					= Translate(en::d_oldstatstooltip+"\\"+ru::d_oldstatstooltip),

	// ScoreboardRender.as
	currentversiontext				= Translate(en::d_currentversiontext+"\\"+ru::d_currentversiontext),

	// ClassSelectMenu.as
	totaltext						= Translate(en::d_totaltext+"\\"+ru::d_totaltext),

	// Quarters.as
	beertext						= Translate(en::d_beertext+"\\"+ru::d_beertext),
	mealtext						= Translate(en::d_mealtext+"\\"+ru::d_mealtext),
	burgertext						= Translate(en::d_burgertext+"\\"+ru::d_burgertext),
	peartext						= Translate(en::d_peartext+"\\"+ru::d_peartext),
	sleeptext						= Translate(en::d_sleeptext+"\\"+ru::d_sleeptext),

	empty 					= "";
}

namespace Names
{
	const string

	// ArcherShop.as
	woodenarrow		  	      	 	= Translate(en::n_woodenarrow+"\\"+ru::n_woodenarrow),
	stonearrow		  	      	 	= Translate(en::n_stonearrow+"\\"+ru::n_stonearrow),
	bombarrow		  	      	 	= Translate(en::n_bombarrow+"\\"+ru::n_bombarrow),

	// BindingsCommon.as
		// Buttons
	modbindemote		  	    		= Translate(en::n_modbindemote+"\\"+ru::n_modbindemote),
	modbindsmenu		  	      	 	= Translate(en::n_modbindsmenu+"\\"+ru::n_modbindsmenu),
	emotemenu		  	      	 		= Translate(en::n_emotemenu+"\\"+ru::n_emotemenu),
	blocksmenu		  	      	 		= Translate(en::n_blocksmenu+"\\"+ru::n_blocksmenu),
	actionsmenu		  	      	 		= Translate(en::n_actionsmenu+"\\"+ru::n_actionsmenu),
	archernmb		  	      	 		= Translate(en::n_archernmb+"\\"+ru::n_archernmb),
	buildernmb		  	      	 		= Translate(en::n_buildernmb+"\\"+ru::n_buildernmb),
	knightnmb		  	      	 		= Translate(en::n_knightnmb+"\\"+ru::n_knightnmb),
	quartersnmb		  	      	 		= Translate(en::n_quartersnmb+"\\"+ru::n_quartersnmb),
	vehiclenmb		  	      	 		= Translate(en::n_vehiclenmb+"\\"+ru::n_vehiclenmb),
	boatnmb		  	      	 			= Translate(en::n_boatnmb+"\\"+ru::n_boatnmb),
	settingsmenu		  	      	 	= Translate(en::n_settingsmenu+"\\"+ru::n_settingsmenu),
	vsettingsmenu		  	      	 	= Translate(en::n_vsettingsmenu+"\\"+ru::n_vsettingsmenu),
	tagwheel		  	       			= Translate(en::n_tagwheel+"\\"+ru::n_tagwheel),
	emotewheelvanilla		  	       	= Translate(en::n_emotewheelvanilla+"\\"+ru::n_emotewheelvanilla),
	emotewheelsecond		  	       	= Translate(en::n_emotewheelsecond+"\\"+ru::n_emotewheelsecond),

		// Blocks
	stonebl		  	      	 			= Translate(en::n_stonebl+"\\"+ru::n_stonebl),
	stoneback		  	      	 		= Translate(en::n_stoneback+"\\"+ru::n_stoneback),
	stonedoor		  	      	 		= Translate(en::n_stonedoor+"\\"+ru::n_stonedoor),
	woodbl		  	      	 			= Translate(en::n_woodbl+"\\"+ru::n_woodbl),
	woodback		  	      		 	= Translate(en::n_woodback+"\\"+ru::n_woodback),
	wooddoor		  	      		 	= Translate(en::n_wooddoor+"\\"+ru::n_wooddoor),
	platformt		  	     	 	 	= Translate(en::n_platformt+"\\"+ru::n_platformt),
	ladder		  	      	 			= Translate(en::n_ladder+"\\"+ru::n_ladder),
	platform		  	     	 	 	= Translate(en::n_platform+"\\"+ru::n_platform),
	shop		  	      	 			= Translate(en::n_shop+"\\"+ru::n_shop),
	spikes		  	      			 	= Translate(en::n_spikes+"\\"+ru::n_spikes),

		// Actions
	drillcommand		  	      		= Translate(en::n_drillcommand+"\\"+ru::n_drillcommand),
	cancelarrowschargingcommand			= Translate(en::n_cancelarrowschargingcommand+"\\"+ru::n_cancelarrowschargingcommand),
	markbuildercommand					= Translate(en::n_markbuildercommand+"\\"+ru::n_markbuildercommand),
	activateorthrowbomb					= Translate(en::n_activateorthrowbomb+"\\"+ru::n_activateorthrowbomb),

		// NoMenuBuying Binds
			// Knight Shop
	bombnmb								= Translate(en::n_bombnmb+"\\"+ru::n_bombnmb),
	waterbombnmb						= Translate(en::n_waterbombnmb+"\\"+ru::n_waterbombnmb),
	minenmb								= Translate(en::n_minenmb+"\\"+ru::n_minenmb),
	kegnmb								= Translate(en::n_kegnmb+"\\"+ru::n_kegnmb),
	drillnmb							= Translate(en::n_drillnmb+"\\"+ru::n_drillnmb),
	satchelnmb							= Translate(en::n_satchelnmb+"\\"+ru::n_satchelnmb),

			// Builder Shop
	drillbnmb							= Translate(en::n_drillbnmb+"\\"+ru::n_drillbnmb),
	spongebnmb							= Translate(en::n_spongebnmb+"\\"+ru::n_spongebnmb),
	bucketwnmb							= Translate(en::n_bucketwnmb+"\\"+ru::n_bucketwnmb),
	bouldernmb							= Translate(en::n_bouldernmb+"\\"+ru::n_bouldernmb),
	lanternnmb							= Translate(en::n_lanternnmb+"\\"+ru::n_lanternnmb),
	bucketnnmb							= Translate(en::n_bucketnnmb+"\\"+ru::n_bucketnnmb),
	trampolinenmb						= Translate(en::n_trampolinenmb+"\\"+ru::n_trampolinenmb),
	sawnmb								= Translate(en::n_sawnmb+"\\"+ru::n_sawnmb),
	cratewoodnmb						= Translate(en::n_cratewoodnmb+"\\"+ru::n_cratewoodnmb),
	cratecoinsnmb						= Translate(en::n_cratecoinsnmb+"\\"+ru::n_cratecoinsnmb),

			// Archer Shop
	arrowsnmb							= Translate(en::n_arrowsnmb+"\\"+ru::n_arrowsnmb),
	waterarrowsnmb						= Translate(en::n_waterarrowsnmb+"\\"+ru::n_waterarrowsnmb),
	firearrowsnmb						= Translate(en::n_firearrowsnmb+"\\"+ru::n_firearrowsnmb),
	bombarrowsnmb						= Translate(en::n_bombarrowsnmb+"\\"+ru::n_bombarrowsnmb),
	blockarrowsnmb						= Translate(en::n_blockarrowsnmb+"\\"+ru::n_blockarrowsnmb),
	stoneblockarrowsnmb					= Translate(en::n_stoneblockarrowsnmb+"\\"+ru::n_stoneblockarrowsnmb),

			// Quarters
	beernmb								 = Translate(en::n_beernmb+"\\"+ru::n_beernmb),
	mealnmb								 = Translate(en::n_mealnmb+"\\"+ru::n_mealnmb),
	eggnmb								 = Translate(en::n_eggnmb+"\\"+ru::n_eggnmb),
	burgernmb							 = Translate(en::n_burgernmb+"\\"+ru::n_burgernmb),
	pearnmb								 = Translate(en::n_pearnmb+"\\"+ru::n_pearnmb),
	sleepnmb							 = Translate(en::n_sleepnmb+"\\"+ru::n_sleepnmb),

			// Vehicle Shop
	catapultnmb								 = Translate(en::n_catapultnmb+"\\"+ru::n_catapultnmb),
	ballistanmb								 = Translate(en::n_ballistanmb+"\\"+ru::n_ballistanmb),
	outpostnmb								 = Translate(en::n_outpostnmb+"\\"+ru::n_outpostnmb),
	boltsnmb								 = Translate(en::n_boltsnmb+"\\"+ru::n_boltsnmb),
	shellsnmb								 = Translate(en::n_shellsnmb+"\\"+ru::n_shellsnmb),

			// Boat Shop
	dinghynmb							 = Translate(en::n_dinghynmb+"\\"+ru::n_dinghynmb),
	longboatnmb							 = Translate(en::n_longboatnmb+"\\"+ru::n_longboatnmb),
	warboatnmb							 = Translate(en::n_warboatnmb+"\\"+ru::n_warboatnmb),

		// Settings
	buildmode		  	      			 = Translate(en::n_buildmode+"\\"+ru::n_buildmode),
	blockbar		  	      			 = Translate(en::n_blockbar+"\\"+ru::n_blockbar),
	dsewnmb								 = Translate(en::n_dsewnmb+"\\"+ru::n_dsewnmb),
	shownomenubuyingpan					 = Translate(en::n_shownomenubuyingpan+"\\"+ru::n_shownomenubuyingpan),
	nomenubuyingset						 = Translate(en::n_nomenubuyingset+"\\"+ru::n_nomenubuyingset),
	nomenubuyingboldarset				 = Translate(en::n_nomenubuyingboldarset+"\\"+ru::n_nomenubuyingboldarset),
	camerasw		  	      			 = Translate(en::n_camerasw+"\\"+ru::n_camerasw),
	bodytilt		  	      			 = Translate(en::n_bodytilt+"\\"+ru::n_bodytilt),
	headrotating		  	      		 = Translate(en::n_headrotating+"\\"+ru::n_headrotating),
	clusterfuck	  	      				 = Translate(en::n_clusterfuck+"\\"+ru::n_clusterfuck),
	clusterfuck_blood	  	      		 = Translate(en::n_clusterfuck_blood+"\\"+ru::n_clusterfuck_blood),
	clusterfuck_smoke	  	      		 = Translate(en::n_clusterfuck_smoke+"\\"+ru::n_clusterfuck_smoke),
	grapplewhilecharging	  	      	 = Translate(en::n_grapplewhilecharging+"\\"+ru::n_grapplewhilecharging),
	annoyingnature		 	 	      	 = Translate(en::n_annoyingnature+"\\"+ru::n_annoyingnature),
	annoyingvoicelines		 	 	     = Translate(en::n_annoyingvoicelines+"\\"+ru::n_annoyingvoicelines),
	annoyingtags		 	 	      	 = Translate(en::n_annoyingtags+"\\"+ru::n_annoyingtags),
	customdpsounds		 	 	      	 = Translate(en::n_customdpsounds+"\\"+ru::n_customdpsounds),
	switchclasschanginginshop			 = Translate(en::n_switchclasschanginginshop+"\\"+ru::n_switchclasschanginginshop),
	drillknight							 = Translate(en::n_drillknight+"\\"+ru::n_drillknight),
	drillbuilder			 			 = Translate(en::n_drillbuilder+"\\"+ru::n_drillbuilder),
	drillarcher							 = Translate(en::n_drillarcher+"\\"+ru::n_drillarcher),
	bombbuilder							 = Translate(en::n_bombbuilder+"\\"+ru::n_bombbuilder),
	bombarcher							 = Translate(en::n_bombarcher+"\\"+ru::n_bombarcher),
	cyclewithitem						 = Translate(en::n_cyclewithitem+"\\"+ru::n_cyclewithitem),
	visualitempick						 = Translate(en::n_visualitempick+"\\"+ru::n_visualitempick),
	pickupsystem						 = Translate(en::n_pickupsystem+"\\"+ru::n_pickupsystem),

		// Other
	pressdelete		  	       			= Translate(en::n_pressdelete+"\\"+ru::n_pressdelete),

	// Food.as
	burgerinv		  	       			= Translate(en::n_burgerinv+"\\"+ru::n_burgerinv),

	// KIWI_Playercard.as
	medalsn		  	       				= Translate(en::n_medalsn+"\\"+ru::n_medalsn),
	partipin		  	       			= Translate(en::n_partipin+"\\"+ru::n_partipin),
	clanbadgetext		  	       		= Translate(en::n_clanbadgetext+"\\"+ru::n_clanbadgetext),

	// ScoreboardCommon.as
	modsettingsbutton	  	       		= Translate(en::n_modsettingsbutton+"\\"+ru::n_modsettingsbutton),
	damagedealtsc	  	       			= Translate(en::n_damagedealtsc+"\\"+ru::n_damagedealtsc),
	killsperminute	  	       			= Translate(en::n_killsperminute+"\\"+ru::n_killsperminute),

	// ScoreboardRender.as
	matssection	  	   		    		= Translate(en::n_matssection+"\\"+ru::n_matssection),

	// Quarters.as
	beeritem		  	       			= Translate(en::n_beeritem+"\\"+ru::n_beeritem),
	mealitem		  	       			= Translate(en::n_mealitem+"\\"+ru::n_mealitem),
	eggitem		  	       				= Translate(en::n_eggitem+"\\"+ru::n_eggitem),
	burgeritem		  	       			= Translate(en::n_burgeritem+"\\"+ru::n_burgeritem),
	pearitem		  	       			= Translate(en::n_pearitem+"\\"+ru::n_pearitem),
	sleepaction		  	       			= Translate(en::n_sleepaction+"\\"+ru::n_sleepaction),

	empty					= "";
}
