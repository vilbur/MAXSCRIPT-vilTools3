

/**  SET CUSTOM QUADS
 */
macroscript	_options_install_menus
category:	"_Otions"
buttontext:	"Install Menus"
tooltip:	"Install Menus and Quad menus for VilTools3"
(
	clearListener()

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\ContentLoader\ContentSubrollouts\ContentRollout\ScriptFile\ScriptFile.ms"

	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\Menus\QuadMenu\Menu\Menu.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	macros.run "_Otions" "_options_quadmenu_reset"

	/* IMPORT *.mcr files*/
	filein( getFilenamePath(getSourceFileName()) + "/../../../MacroscriptsAllFileIn.ms" ) -- "./../../../MacroscriptsAllFileIn.ms"

	/* SET MENUS */
	quad_menu_files = #(
		"rightClickQuad",	-- "./../../../QuadMenu/rightClickQuad.ms"
		"controlQuad",	-- "./../../../QuadMenu/controlQuad.ms"
		"shiftQuad",	-- "./../../../QuadMenu/shiftQuad.ms"
		"altQuad",	-- "./../../../QuadMenu/altQuad.ms"
		"controlShiftQuad"	-- "./../../../QuadMenu/controlShiftQuad.ms"
	)

	for menu_files in quad_menu_files do
		try(
			file_path = getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/"+menu_files+".ms"

			file_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace file_path "\\"

			filein( file_path )
		)catch(

			format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
			format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
			format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
		)


	/*  */
   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
	if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlAndAltPressed quadmenu

	print "QUAD MENU INSTALLED - Default Quad: Control + Alt + RMB"
)


/**  RESET TO DEFAULT QUADS
 */
macroscript	_options_quadmenu_reset
category:	"_Otions"
buttontext:	"Reset Menus"
tooltip:	"Load default quad menu and menus"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"


	/* LAOD 3DS MAX DEFAULT .mnux FILE */
	menuMan.loadMenuFile ( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/config-files/QuadMenu-default.mnux" )  -- "./../../../QuadMenu/config-files/QuadMenu-default.mnux"

   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
   if quadmenu != undefined do menuMan.setViewportRightClickMenu #nonePressed quadmenu

   quadmenu = menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]"
   if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlPressed quadmenu


)
