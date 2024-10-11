/** Call submenu
  *
 */
function openLayerRcMenu layer_index =
(
	--format "\n"; print "openVertexColorSubmenu()"
	--format "method: %\n" method
	format "EventFired: %\n" EventFired
	--if not keyboard.altPressed then
	(

		/* FIRST ITEM */
		--item_title = case method of
		--(
		--	--#SET:	"Set &Color"
		--	#SELECT:	"&Select By Selection"
		--	#HIDE:	"&Hide By Selection"
		--	#UNHIDE:	"&Unide By Selection"
		--	#ISOLATE:	"&Isolate By Selection"
		--layer_index
		--)
		--
		--
		--category = "_Epoly-Vertex-Color"
		--
		--macro_name = "epoly_vertex_color_" + method as string  + (if method == #SET then "_by_last_color" else "_by_selection")
		--
		--/* ITEMS BY COLOR */
		--call_method_by_vertex_color = "callMethodByVertexColor #"+ method as string + " " --"./../callMethodByVertexColor/callMethodByVertexColor.ms"
		--
		--/* DEFINE MAIN MENU */
		Menu = RcMenu_v name:"LayerRcMenu"
		--
		LayerToggleCallbacks = "(LayerToggleCallbacks_v(" + layer_index as string + "))"

		--if method != #SET then
		--	Menu.item item_title	( "macros.run" + "\"" + category + "\"" + "\"" + macro_name + "\""	) -- macros.run "_Epoly-Vertex-Color" "color_set_by_selection"
		--
		Menu.item "&Show Layer wirecolor (Ctrl+RMB)"	( LayerToggleCallbacks + ".toggleDisplayAsLayer HIERARCHY:keyboard.shiftPressed" 	)
		Menu.item "&Wirecolor to children layers"	( LayerToggleCallbacks + ".propagateWirecolorToChildrenLayers()" 	)
		--Menu.item "&BLUE"	( call_method_by_vertex_color + " " + COLOR_NAMES[#BLUE] as string	)
		--Menu.item "&ORANGE"	( call_method_by_vertex_color + "orange"	)
		--Menu.item "&YELLOW"	( call_method_by_vertex_color + "yellow"	)
		--Menu.item "&PINK"	( call_method_by_vertex_color + " " + COLOR_NAMES[#PINK] as string	)
		--Menu.item "&MAGENTA"	( call_method_by_vertex_color + " " + COLOR_NAMES[#MAGENTA] as string	)
		--Menu.item "&WHITE"	( call_method_by_vertex_color + "white"	)


		popUpMenu (Menu.create())


	)
	--else /* IF CONTROL KEY PRESSED */
	--	::LayerToggleCallbacks_v.toggleDisplayAsLayer (index)

)