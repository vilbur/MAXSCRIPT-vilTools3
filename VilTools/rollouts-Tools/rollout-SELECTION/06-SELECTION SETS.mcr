/*------ DEV IMPORT ------*/
filein( getFilenamePath(getSourceFileName()) + "/Lib/SelectionSetsManager/SelectionSetsManager.ms" )	--"./Lib/SelectionSetsManager/SelectionSetsManager.ms"



/**
  */
macroscript	selection_sets_create
category:	"_Selection-Sets"
buttontext:	"CREATE"
--toolTip:	"Open Selection sets dialog"
icon:	"across:4|width:92|height:32|Menu:CREATE set"
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
macroscript	selection_sets_add
category:	"_Selection-Sets"
buttontext:	"ADD"
toolTip:	"Add selection to set"
icon:	"MENU:ADD TO sets"
(
	on execute do
	(
		(SelectionSetsManager_v()).chooseSetRollout "AddTo"
	)
)

/**
  */
macroscript	selection_sets_remove
category:	"_Selection-Sets"
buttontext:	"REMOVE"
toolTip:	"REMOVE "
icon:	"MENU:REMOVE selection"
(
	on execute do
	(
		(SelectionSetsManager_v()).chooseSetRollout "Remove"
	)
)
/**
  */
macroscript	selection_sets_delete
category:	"_Selection-Sets"
buttontext:	"DELETE"
toolTip:	"DELETE ALL Named Selection Sets From Scene"
icon:	"MENU:DELETE sets"
(
	on execute do
	(
		SelSets = SelectionSetsManager_v()

		--if ( selected_set = SelSets.getSelectedSet() ) != undefined then
		--(
		--	format "selected_set: %\n" selected_set
		--	
		--	selected_index = #{SelSets.sel_sets[selected_set]}
		--	
		--)
		SelSets.chooseSetRollout "Delete" selected_sets:(SelSets.getSelectedSet())
	)
)

/**
  */
macroscript	selection_sets_select
category:	"_Selection-Sets"
buttontext:	"SELECT"
toolTip:	"Select objects in selection sets by current selection"
icon:	"across:3"
(
	
	--function compareArrays arr1 arr2 = with PrintAllElements on ( sort(arr1) ) as string == ( sort(arr2) ) as string
	function compareArrays arr1 arr2 = with PrintAllElements on ( (arr1) ) as string == ( (arr2) ) as string
	
	
	on execute do
	(
		--macros.run "Edit" "namedSelSets"
		--_selection = selection as Array
		--format "_selection: %\n" _selection
		objs = #()
		
		objs_counts	= Dictionary #INTEGER -- KEY:objects count VALUE:set_name
		
		SelSets = SelectionSetsManager_v()

		sel_sets = SelSets.getSetsByObjects ( selection as Array )
		
		format "\n\nSELECT OBJECTS OF % SETS\n" sel_sets.keys.count
		
		
		invisible_objs = 10e9
		
		--most_visible_set = sel_sets.keys[1]
		
		/* REMOVE CURRENTLY SELECTED SET */ 		
		if ( selected_set = SelSets.getSelectedSet() ) != undefined then
			RemoveDictValue sel_sets selected_set
		format "SELECTED_SET: %\n" selected_set
		format "\n------------------------------------------\n"
		
		for set_name in sort(sel_sets.keys) do
		(
			--format "SET_NAME: %\n" set_name
			format "\n"
			objs_in_set_count = selectionSets[set_name].count
			
			format "%: %\n" set_name objs_in_set_count
			
			if objs_counts[objs_in_set_count] == undefined then
				objs_counts[objs_in_set_count] = #()
			
			append objs_counts[objs_in_set_count] set_name
		)
		
		min_count = amin objs_counts.keys
		format "\n"
		format "objs_counts: %\n" objs_counts
		format "min_count: %\n" min_count
		
		min_count_set = objs_counts[min_count][1]
		--format "SELECT NAMED SET: \"%\"\n" min_count_set
		format "SELECT SET: %\n" min_count_set
		objs = SelSets.getObjectsInSet min_count_set
		format "objs: %\n" objs
		if objs.count > 0 then
			select objs
	)
)

/**
  */
macroscript	selection_sets_save
category:	"_Selection-Sets"
buttontext:	"SAVE \ LOAD"
toolTip:	"SAVE Selection set"
icon:	"MENU:SAVE set"
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
toolTip:	"LOAD Selection sets"
icon:	"MENU:LOAD set"
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
buttontext:	"DIALOG"
toolTip:	"Open Selection sets dialog"
icon:	"MENU:true"
(
	on execute do
	(
		hwnd = (for child in ( windows.getChildrenHWND 0 parent:#max ) where child[5] == "Named Selection Sets" collect child[1])[1]
		
		/* CLOSE DIALOG by sending WM_CLOSE */
		if hwnd != undefined then
			windows.sendMessage hwnd 0x0010 0 0
		/* OPEN DIALOG */ 
		else
			macros.run "Edit" "namedSelSets"
	)
)

global NAMED_SELECTION_SETS_QUADMENU = undefined

macroscript	selection_sets_create_menu_callbacks
category:	"_Selection-Sets"
buttontext:	"SELECTION SETS QUAD MENU ✅"
toolTip:	"Enable\Disable selection sets in quad menu"
icon:	"control:checkbox|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(
	--on IsChecked do NAMED_SELECTION_SETS_QUADMENU != undefined

	on execute do
	(
		format "\n------------------------------------------------------------------------------------\n"
		format "NAMED_SELECTION_SETS_QUADMENU: %\n" NAMED_SELECTION_SETS_QUADMENU
		format "EventFired: %\n" (EventFired != undefined and EventFired.val)
		format "TEST: %\n" (NAMED_SELECTION_SETS_QUADMENU == undefined or ( EventFired != undefined and EventFired.val ) )
		
		if NAMED_SELECTION_SETS_QUADMENU == undefined or ( EventFired != undefined and EventFired.val ) then
		(
			CALLBACKMANAGER.add "addSelectionSetsToQuadMenu" #NamedSelSetRenamed
			CALLBACKMANAGER.add "addSelectionSetsToQuadMenu" #NamedSelSetDeleted
			CALLBACKMANAGER.add "addSelectionSetsToQuadMenu" #filePostOpen
			
			CALLBACKMANAGER.add "setSelectionSetActive" #selectionSetChanged
			CALLBACKMANAGER.add "setSelectionSetActive" #filePostOpen
			
			CALLBACKMANAGER.add "clearSelectionSetMenu" #preSystemShutdown 


			CALLBACKMANAGER.start "addSelectionSetsToQuadMenu"
			CALLBACKMANAGER.start "setSelectionSetActive"
 
			setSelectionSetActive()
			
			addSelectionSetsToQuadMenu()
			
		)
		else
		(

			CALLBACKMANAGER.kill "addSelectionSetsToQuadMenu"
			CALLBACKMANAGER.kill "setSelectionSetActive"
			
			MenuSets = Menu_v ("_Selection_Set")
			
			MenuSets.clearMenu()
			
			NAMED_SELECTION_SETS_QUADMENU = undefined
			
			
		)
		format "NAMED_SELECTION_SETS_QUADMENU: %\n" NAMED_SELECTION_SETS_QUADMENU

	)
)







