

/**  SET CUSTOM QUADS
 */
macroscript	_options_install_menus
category:	"_Otions"
buttontext:	"Install Menus"
tooltip:	"Install Menus and Quad menus for VilTools3"
(
	clearListener()

	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	macros.run "_Otions" "_options_quadmenu_reset"

	filein( getFilenamePath(getSourceFileName()) + "/../../../MacroscriptsAllFileIn.ms" ) -- "./../../../MacroscriptsAllFileIn.ms"

	/* SET MENUS */
	filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/rightClickQuad.ms" ) -- "./../../../QuadMenu/rightClickQuad.ms"
	--
	filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/controlQuad.ms" ) -- "./../../../QuadMenu/controlQuad.ms"
	--
	filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/shiftQuad.ms" ) -- "./../../../QuadMenu/shiftQuad.ms"
	--
	filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/altQuad.ms" ) -- "./../../../QuadMenu/altQuad.ms"
	--
	filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/controlShiftQuad.ms" ) -- "./../../../QuadMenu/controlShiftQuad.ms"

	/*  */
   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
	if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlAndAltPressed quadmenu

)


/**  RESET TO DEFAULT QUADS
 */
macroscript	_options_quadmenu_reset
category:	"_Otions"
buttontext:	"Reset Menus"
tooltip:	"Load default quad menu and menus"
(
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	/* LAOD 3DS MAX DEFAULT .mnux FILE */
	menuMan.loadMenuFile ( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/config-files/QuadMenu-default.mnux" )  -- "./../../../QuadMenu/config-files/QuadMenu-default.mnux"

   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
   if quadmenu != undefined do menuMan.setViewportRightClickMenu #nonePressed quadmenu

   quadmenu = menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]"
   if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlPressed quadmenu


)
