
/**  SET CUSTOM QUADS
 */
macroscript	_options_install_menus
category:	"_Options"
buttontext:	"INSTALL"
tooltip:	"Install Menus and Quad menus for VilTools3"
icon:	"ACROSS:3|height:28"
(

	on execute do
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		--format "Macro:EventFired:	% \n" EventFired
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-OPTIONS\QUAD MENUS.mcr"
		
		if queryBox ("INSTALL QUAD MENUS ?") then
		(
			current_dir = getFilenamePath(getSourceFileName())
		
			QuadMenuManager = QuadMenuManager_v() --"./../../../../MAXSCRIPT-UI-framework/Lib/Menus/QuadMenuManager/QuadMenuManager.ms"
		
			/* IMPORT *.mcr files*/
			QuadMenuManager.createMenusFromMacroscriptFiles ( current_dir + "/../" ) blacklist:#( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )
			
			
			format "\n\n"; print "========================= SETUP MENUS ========================="
		
			/* SETUP QUAD MENUS */ 
			QuadMenuManager.setupMenus( current_dir + "/../../../QuadMenus" ) --"./../../../QuadMenus"
		)
	)
)


/**  RESET TO DEFAULT QUADS
 */
macroscript	_options_quadmenu_reset
category:	"_Options"
buttontext:	"RESET"
tooltip:	"Load default quad menu and menus"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"
	on execute do
	(
		format "EventFired: %\n" EventFired
		if queryBox "RESET ALL MENUS AND QUADMENUS ?" title:"RESET MENUS" then
			(QuadMenuManager_v()).resetMenusAndHotkeys()
		
	)
)


/**  RESET TO DEFAULT QUADS
 */
macroscript	_options_quadmenu_help_hotkeys
category:	"_Options"
buttontext:	"HELP"
tooltip:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"
	on execute do
	(
		showQuadMenuHotkeys()
	)
)
