

/**
  */
macroscript	selection_sets_open_dialog
category:	"_Selection-Sets"
buttontext:	"OPEN SETS"
toolTip:	"Open Selection sets dialog"
icon:	"across:4|width:96|height:28"
(
	on execute do
	(
		macros.run "Edit" "namedSelSets"

	)
)

/**
  */
macroscript	selection_sets_open_dialog
category:	"_Selection-Sets"
buttontext:	"SELECT"
toolTip:	"Select objects in selection sets by current selection"
--icon:	"across:4|width:96|height:28"
(
	on execute do
	(
		--macros.run "Edit" "namedSelSets"
		objs = #()
		
		SelSets = SelectionSetsManager_v()

		sel_sets = SelSets.getSetsByObjects ( selection as Array )
		
		for set_name in sel_sets.keys do
			objs += SelSets.getObjectsInSet (set_name)
		
		if objs.count > 0 then
			select objs
	)
)

/**
  */
macroscript	selection_sets_save
category:	"_Selection-Sets"
buttontext:	"SAVE \ LOAD"
toolTip:	"SAVE Named Selection Sets"
icon:	""
(
	on execute do
	(
		SelSets = SelectionSetsManager_v()

		selection_exists = selection.count > 0
		
		by_selection = if selection_exists then "OF SELECTED" else "OF ALL"
		
		if queryBox ("SAVE SELECTION SETS\n\n " +by_selection+ " OBJECTS ?") title:"SAVE SETS" then
			 SelSets.saveToIni only_selected:selection_exists
	)
)


/**
  */
macroscript	selection_sets_laod
category:	"_Selection-Sets"
buttontext:	"SAVE \ LOAD"
toolTip:	"LOAD Named Selection Sets"
icon:	""
(
	/** Join array to string
	 */
	function arrayToString arr delimeter = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))
	
	on execute do
	(
		SelSets = SelectionSetsManager_v()
		
		selection_sets = getNamedSelSetDict()
		
		if queryBox ("LOAD SELECTION SETS ?\n\n"+arrayToString selection_sets.keys "\n" ) title:"LOAD SETS" then
				
			if doesFileExist ini then
			(
				
				
				format "selection_sets: %\n" selection_sets
				/* DELETE OLD SETS */ 
				if queryBox ("DELETE OLD SELECTION SETS ?") title:"DELETE SETS" then
					SelSets.deleteSets()
				
				SelSets.loadFromIni()

			)
			else
				messageBox "Ini file does not exists.\n\nNamed Selection Sets\n\nMust be saved before" title:"LOAD SETS" 

	)
)


/**
  */
macroscript	selection_sets_delete_all
category:	"_Selection-Sets"
buttontext:	"DELETE"
toolTip:	"DELETE ALL Named Selection Sets From Scene"
icon:	""
(
	on execute do
	(
		
		if queryBox ("DELETE SELECTION SETS ?") title:"DELETE SETS" then
			(
				nsm = NamedSelectionSetManager
				
				/* DELETE OLD SETS */ 
				for s = nsm.GetNumNamedSelSets() - 1 to 0 by -1 do 
					nsm.RemoveNamedSelSetByIndex s
			)
	)
)