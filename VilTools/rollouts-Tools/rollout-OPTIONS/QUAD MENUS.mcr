
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
		format "Macro:EventFired:	% \n" EventFired

		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-OPTIONS\QUAD MENUS.mcr"

		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\ContentLoader\ContentSubrollouts\ContentRollout\ScriptFile\ScriptFile.ms"

		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\Menus\QuadMenu\Menu\Menu.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\Menus\QuadMenu\QuadMenu.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

		filein( getFilenamePath(getSourceFileName()) + "/../../../generateMacroscripts.ms" )	-- "./../../../generateMacroscripts.ms"

		--macros.run "_Options" "_options_quadmenu_reset"

		/* IMPORT *.mcr files*/
		filein( getFilenamePath(getSourceFileName()) + "/../../../MacroscriptsAllFileIn.ms" ) -- "./../../../MacroscriptsAllFileIn.ms"

		filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/installQuads.ms" ) -- "./../../../QuadMenu/installQuads.ms"
		--filein( getFilenamePath(getSourceFileName()) + "/../../../QuadMenuOld/quadMenuConfig.ms" ) -- "./../../../QuadMenu/quadMenuConfig.ms"

		/* SET DEFAULT QUADMENU  TO CTRL+SHIFT+AL+RMB */
	   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
		if quadmenu != undefined do menuMan.setViewportRightClickMenu #shiftAndAltAndControlPressed quadmenu


		menuMan.saveMenuFile ((getDir #ui)+"\\MaxStartUI.mnux") -- "C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\en-US\UI\MaxStartUI.mnux"


		/* OPEN HOTKEY EDITOR - for refresh quad menu keyboard shortcuts */
		actionMan.executeAction 0 "59245"  -- Customize User Interface: Hotkey Editor

		/* CLOSE HOTKEY EDITOR */
		if (hotkey_dialog = (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "Hotkey Editor" collect hwnd)[1]) != undefined then
			UIAccessor.CloseDialog hotkey_dialog

		format "\n\nQUAD MENU INSTALLED - Default Quad: Control + SHift + Alt + RMB"

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

	--EMPTY_QUAD =  Menu_v("_Empty" ) quad:true

	if queryBox "REST ALL MENUS AND QUADMENUS ?" title:"RESET MENUS" then
	(
		/* LAOD 3DS MAX DEFAULT .mnux FILE */
		menuMan.loadMenuFile ( getFilenamePath(getSourceFileName()) + "/../../../QuadMenu/config-files/QuadMenu-default.mnux" )  -- "./../../../QuadMenu/config-files/QuadMenu-default.mnux"

	   quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
	   if quadmenu != undefined do menuMan.setViewportRightClickMenu #nonePressed quadmenu

	   quadmenu = menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]"
	   if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlPressed quadmenu
	)
)
