/**  SET CUSTOM QUADS
 */
macroscript	_options_install_menus
category:	"_Otions"
buttontext:	"Install Menus"
tooltip:	"Install Menus and Quad menus for VilTools3"
(
	--clearListener()

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\ContentLoader\ContentSubrollouts\ContentRollout\ScriptFile\ScriptFile.ms"

	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\Menus\QuadMenu\Menu\Menu.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\Menus\QuadMenu\QuadMenu.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"


	macros.run "_Otions" "_options_quadmenu_reset"

	/* IMPORT *.mcr files*/
	filein( getFilenamePath(getSourceFileName()) + "/../../../MacroscriptsAllFileIn.ms" ) -- "./../../../MacroscriptsAllFileIn.ms"

	filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/quadMenuConfig.ms" ) -- "./../../../QuadMenu/quadMenuConfig.ms"

	/*  */
   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
	if quadmenu != undefined do menuMan.setViewportRightClickMenu #shiftAndAltAndControlPressed quadmenu

	print "QUAD MENU INSTALLED - Default Quad: Control + SHift + Alt + RMB"

	menuMan.saveMenuFile ((getDir #temp)+"\\vilTools3-Quads.mnux") -- "C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\temp\vilTools3-Quads.mnux
)


/**  RESET TO DEFAULT QUADS
 */
macroscript	_options_quadmenu_reset
category:	"_Otions"
buttontext:	"Reset Menus"
tooltip:	"Load default quad menu and menus"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	--EMPTY_QUAD =  Menu_v("_Empty" ) quad:true

	/* LAOD 3DS MAX DEFAULT .mnux FILE */
	menuMan.loadMenuFile ( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/config-files/QuadMenu-default.mnux" )  -- "./../../../QuadMenu/config-files/QuadMenu-default.mnux"

   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
   if quadmenu != undefined do menuMan.setViewportRightClickMenu #nonePressed quadmenu

   quadmenu = menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]"
   if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlPressed quadmenu


)
