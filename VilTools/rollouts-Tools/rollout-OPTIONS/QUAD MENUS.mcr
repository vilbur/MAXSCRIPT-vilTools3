filein( getFilenamePath(getSourceFileName()) + "/../../../../MAXSCRIPT-UI-framework/Lib/Menus/QuadMenuManager/QuadMenuManager.ms" )	--"./../../../../MAXSCRIPT-UI-framework/Lib/Menus/QuadMenuManager/QuadMenuManager.ms"

/**  SET CUSTOM QUADS
 */
macroscript	_options_install_menus
category:	"_Options"
buttontext:	"INSTALL Menus"
tooltip:	"Install Menus and Quad menus for VilTools3"
icon:	"MENU:true"
(

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		--format "Macro:EventFired:	% \n" EventFired
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-OPTIONS\QUAD MENUS.mcr"
		current_dir = getFilenamePath(getSourceFileName())
	
		/* IMPORT *.mcr files*/
		(QuadMenuManager_v()).createMenusFromMacroscriptFiles ( current_dir + "/../" ) blacklist:#( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )
		
		
		format "\n\n"; print "========================= SETUP MENUS ========================="
	
		/* SETUP QUAD MENUS */ 
		(QuadMenuManager_v()).setupMenus( current_dir + "/../../../QuadMenus" ) --"./../../../QuadMenus"

	)
)


/**  RESET TO DEFAULT QUADS
 */
macroscript	_options_quadmenu_reset
category:	"_Options"
buttontext:	"RESET Menus"
tooltip:	"Load default quad menu and menus"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	if queryBox "RESET ALL MENUS AND QUADMENUS ?" title:"RESET MENUS" then
		(QuadMenuManager_v()).resetMenusAndHotkeys()
)
