/**
Toggle or force-open Menu Editor.
tab_name: #none, #Menus, #Quads
*/
function toggleMenuEditor force:false tab_name:#none =
(
	menu_editor_hwnd = undefined
	tab_hwnd = undefined
	tab_title = undefined
	
	for editor_title in #("Menu Editor", "Menu Editor - Developer Mode") do
	(
		if (menu_editor_hwnd == undefined) then
		(
			menu_editor_hwnd = windows.getChildHWND 0 editor_title parent:#max
		)
	)
	
	if (menu_editor_hwnd != undefined and force != true) then
	(
		windows.sendMessage menu_editor_hwnd[1] 0x0010 0 0  -- WM_CLOSE
		menu_editor_hwnd = undefined
	)
	else
	(
		if (menu_editor_hwnd == undefined) then
		(
			actionMan.executeAction 0 "59246"  -- Customize User Interface: Menu Editor
			
			for wait_index = 1 to 20 do
			(
				windows.processPostedMessages()
				
				for editor_title in #("Menu Editor", "Menu Editor - Developer Mode") do
				(
					if (menu_editor_hwnd == undefined) then
					(
						menu_editor_hwnd = windows.getChildHWND 0 editor_title parent:#max
					)
				)
				
				if (menu_editor_hwnd != undefined) then
				(
					exit
				)
			)
		)
		
		tab_title = case tab_name of
		(
			#Menus: "Menus"
			#Quads: "Quads"
			default: undefined
		)
		
		if (menu_editor_hwnd != undefined and tab_title != undefined) then
		(
			tab_hwnd = windows.getChildHWND menu_editor_hwnd[1] tab_title
			
			if (tab_hwnd != undefined) then
			(
				windows.sendMessage tab_hwnd[1] 0x00F5 0 0  -- BM_CLICK
			)
		)
	)
	
	menu_editor_hwnd -- return
)



/** OPEN MENU EDITOR
 */
macroscript	_options_open_menu_editor
category:	"_Options"
buttontext:	"Menu Editor"
tooltip:	"Load default quad menu and menus"
icon:	"across:2"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	on execute do
	(
		toggleMenuEditor force:true tab_name:#Menus
		--toggleMenuEditor force:true tab_name:#Menus
		--toggleMenuEditor force:true tab_name:#Quads
		--toggleMenuEditor()
		--toggleMenuEditor()
	)
)


/** OPEN QUAD MENU EDITOR
 */
macroscript	_options_open_menu_editor_quad
category:	"_Options"
buttontext:	"Quad Editor"
tooltip:	"Load default quad menu and menus"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"

	on execute do
	(
		--toggleMenuEditor force:true tab_name:#Menus
		--toggleMenuEditor force:true tab_name:#Menus
		toggleMenuEditor force:true tab_name:#Quads
		--toggleMenuEditor()
		--toggleMenuEditor()
	)
)


--/**  RESET TO DEFAULT QUADS
-- */
--macroscript	_options_quadmenu_reset
--category:	"_Options"
--buttontext:	"RESET"
--tooltip:	"Load default quad menu and menus"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"
--	on execute do
--	(
--		format "EventFired: %\n" EventFired
--		if queryBox "RESET ALL MENUS AND QUADMENUS ?" title:"RESET MENUS" then
--			(QuadMenuManager_v()).resetMenusAndHotkeys()
--		
--	)
--)


--/**  RESET TO DEFAULT QUADS
-- */
--macroscript	_options_quadmenu_help_hotkeys
--category:	"_Options"
--buttontext:	"HELP"
--tooltip:	"MENU:true"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Menus.mcr"
--	on execute do
--	(
--		clearListener(); 
--		showQuadMenuHotkeys()
--	)
--)
