/** Call submenu
  *
 */
function openLayerRcMenu layer_index =
(
	--format "\n"; print "openVertexColorSubmenu()"

	/* DEFINE MAIN MENU */
	Menu = RcMenu_v name:"LayerRcMenu"

	LayerToggleCallbacks = "(LayerToggleCallbacks_v(" + layer_index as string + "))"

	Menu.item "&Show Layer wirecolor (Ctrl+RMB)"	( LayerToggleCallbacks + ".toggleDisplayAsLayer HIERARCHY:keyboard.shiftPressed"	)
	Menu.item "&Wirecolor to children layers"	( LayerToggleCallbacks + ".passWirecolorToChildrenLayers()" 	)
	Menu.item "&Lock Wirecolor display"	( LayerToggleCallbacks + ".wirecolorLockToggle()" 	)

	popUpMenu (Menu.create())

)