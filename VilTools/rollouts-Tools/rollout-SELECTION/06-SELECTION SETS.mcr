

/**
  */
macroscript	selection_sets_select
category:	"_Selection-Sets"
buttontext:	"SELECT"
toolTip:	"Select objects in selection sets by current selection"
icon:	"MENU:true|across:3"
(
	
	--function compareArrays arr1 arr2 = with PrintAllElements on ( sort(arr1) ) as string == ( sort(arr2) ) as string
	function compareArrays arr1 arr2 = with PrintAllElements on ( (arr1) ) as string == ( (arr2) ) as string
	
	
	on execute do
	(
		--macros.run "Edit" "namedSelSets"
		_selection = selection as Array
		format "_selection: %\n" _selection
		objs = #()
		
		objs_counts	= Dictionary #INTEGER -- KEY: VALUE:
		
		SelSets = SelectionSetsManager_v()

		sel_sets = SelSets.getSetsByObjects ( _selection )
		
		format "\n\nSELECT OBJECTS OF % SETS\n" sel_sets.keys.count
		
		--selected_set = undefined 
		
		invisible_objs = 10e9
		
		most_visible_set = sel_sets.keys[1]
		
		/* REMOVE CURRENTLY SELECTED SET */ 		
		if ( selected_set = SelSets.getSelectedSet() ) != undefined then
			RemoveDictValue sel_sets selected_set
		
		
		for set_name in sort(sel_sets.keys) do
		(
			objs_in_set_count = sel_sets[set_name].count
			--format "%: %\n" set_name objs_in_set_count
			if objs_counts[objs_in_set_count] == undefined then
				objs_counts[objs_in_set_count] = #()
			
			append objs_counts[objs_in_set_count] set_name
		)
		
		min_count = amin objs_counts.keys
		--format "min_count: %\n" min_count
		
		min_count_set = objs_counts[min_count][1]
		format "SELECT NAMED SET: \"%\"\n" min_count_set
		
		objs = sel_sets[min_count_set]

		
		
		--for set_name in sel_sets.keys do
		--(
		--	format "\n%\n" set_name
		--	format "sel_sets[set_name]: %\n" sel_sets[set_name]
		--	/* GET ONLY VISIBLE OBJECTS */ 
		--	objs_in_set_invisible = for obj in sel_sets[set_name] where obj.isHidden collect obj 
		--	format "objs_in_set_invisible.count: %\n" objs_in_set_invisible.count
		--	
		--	if objs_in_set_invisible.count <= invisible_objs then
		--	(
		--	
		--		if objs_in_set_invisible.count == invisible_objs then
		--		(
		--			selected_set_A = for obj in sel_sets[most_visible_set]	where obj.selected collect obj 
		--			selected_set_B = for obj in sel_sets[set_name]	where obj.selected collect obj 
		--
		--			format "selected_set_A.count: %\n" selected_set_A.count
		--			format "selected_set_B.count: %\n" selected_set_B.count
		--			
		--		)
		--
		--		invisible_objs = objs_in_set_invisible.count
		--	
		--		
		--		most_visible_set = set_name
		--		
		--		objs = SelSets.getObjectsInSet (set_name)
		--	)
		--	
		----	objs += SelSets.getObjectsInSet (set_name)
		--)
		
		
		--format "\nMOST VISIBLE SET: %\n" most_visible_set
		
		if objs.count > 0 then
			select objs
	)
)


/**
  */
macroscript	selection_sets_create
category:	"_Selection-Sets"
buttontext:	"CREATE"
--toolTip:	"Open Selection sets dialog"
icon:	"Menu:true"
(
	on IsVisible do selection.count > 0

	
	on execute do
	(
		--macros.run "Edit" "namedSelSets"
		if selection.count > 0 then
		(
			/* ASK FOR NAME OF SET */ 
			dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" ""
			dialog.text	= "SELECTION SET NAME"
			modal	= dialog.Showmodal()
			set_name	= dialog.InstanceName
			
			/* CREATE SELECTION SET */ 
			if (trimLeft(set_name)).count > 0 then
				(SelectionSetsManager_v()).addObj ( selection as Array ) set_name
			
		)
	)
)

/**
  */
macroscript	selection_sets_delete_all
category:	"_Selection-Sets"
buttontext:	"DELETE"
toolTip:	"DELETE ALL Named Selection Sets From Scene"
icon:	"MENU:true"
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

/**
  */
macroscript	selection_sets_save
category:	"_Selection-Sets"
buttontext:	"SAVE \ LOAD"
toolTip:	"SAVE Selection Sets"
icon:	"MENU:toolTip|across:2"
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
toolTip:	"LOAD Selection Sets"
icon:	"MENU:toolTip"
(
	/** Join array to string
	 */
	function arrayToString arr delimeter = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))
	
	on execute do
	(
		SelSets = SelectionSetsManager_v()
		
		--selection_sets = SelSets.getNamedSelSetDict()
		
		if queryBox ("LOAD SELECTION SETS ?\n\n"+arrayToString SelSets.sel_sets.keys "\n" ) title:"LOAD SETS" then
				
			if doesFileExist ini then
			(
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
macroscript	selection_sets_open_dialog
category:	"_Selection-Sets"
buttontext:	"OPEN SETS"
toolTip:	"Open Selection sets dialog"
icon:	"width:96|height:28|MENU:true"
(
	on execute do
	(
		macros.run "Edit" "namedSelSets"

	)
)




global NAMED_SELECTION_SETS_QUADMENU

macroscript	selection_sets_create_menu_callbacks
category:	"_Selection-Sets"
buttontext:	"SELECTION SETS QUAD MENU"
toolTip:	"Enable\Disable selection sets in quad menu"
icon:	"control:checkbox|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(

	
	on IsChecked do NAMED_SELECTION_SETS_QUADMENU != undefined

	on execute do
	(
		format "NAMED_SELECTION_SETS_QUADMENU: %\n" NAMED_SELECTION_SETS_QUADMENU
		if NAMED_SELECTION_SETS_QUADMENU != true or ( EventFired != undefined and EventFired.val ) then
		----if NAMED_SELECTION_SETS_QUADMENU == undefined then
		(
			--CALLBACKMANAGER.start "autoEndResult" --"./../../../CallBacks/modPanelSubObjectLevelChanged/autoEndResult.ms"
			
			
			
			CALLBACKMANAGER.add "addSelectionSetsToQuadMenu"	#NamedSelSetRenamed
			CALLBACKMANAGER.add "addSelectionSetsToQuadMenu"	#NamedSelSetDeleted
			CALLBACKMANAGER.add "addSelectionSetsToQuadMenu"	#filePostOpen

			CALLBACKMANAGER.start "addSelectionSetsToQuadMenu"

			addSelectionSetsToQuadMenu()
			
		)
		else
		(
			CALLBACKMANAGER.kill "addSelectionSetsToQuadMenu"

			MenuSets 	= Menu_v ("_Selection_Set")
			
			MenuSets.clearMenu()
		)

		if EventFired != undefined then 
			NAMED_SELECTION_SETS_QUADMENU = EventFired.val
	)
)












