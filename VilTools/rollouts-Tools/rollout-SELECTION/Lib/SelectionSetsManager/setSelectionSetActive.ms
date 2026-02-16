
		
/** Set selection set seleted
 */
function setSelectionSetActive =
(
	format "\n"; print ".setSelectionSetActive()"
	
	SelSets = SelectionSetsManager_v()
	
	selected_sets = SelSets.getSetsByObjects ( selection as Array )
	
	global NAMED_SELECTION_SETS_QUADMENU = (for set_name in selected_sets.keys collect selected_sets[set_name] + 1 ) as BitArray
	format "NAMED_SELECTION_SETS_QUADMENU: %\n" NAMED_SELECTION_SETS_QUADMENU
	
	menu_callback_help_message = "MANAGE STATE IN QUAD MENU: Press CTRL: Save state | Press SHIFT: Rename state | Press ALT: Delete state"
	
	format "\n%" menu_callback_help_message

)

/** Set selection set seleted
 */
function clearSelectionSetMenu =
(
	--messageBox "Yupiii" title:"Title"  beep:false
	(Menu_v ("_Selection_Set")).clearMenu()
)	