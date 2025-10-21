

/**
  */
macroscript	selection_sets_open_dialog
category:	"_Selection-Sets"
buttontext:	"OPEN SETS"
toolTip:	"Open Selection sets dialog"
icon:	"across:4|width:96|height:28|MENU:true"
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
icon:	"MENU:true"
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
icon:	"MENU:true"
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
icon:	"MENU:true"
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
macroscript	selection_sets_set_menu
category:	"_Selection-Sets"
buttontext:	"SET MENU"
--toolTip:	"DELETE ALL Named Selection Sets From Scene"
--icon:	"MENU:true"
(
	/*
	Function to generate and save a macroscript file
	Creates file in user macros directory
	*/
	function generateMacroScript category macro_name buttontext script_body file_path =
	(
		macro_text = ""
		macro_text += "\nmacroscript	"	+ macro_name
		macro_text += "\ncategory:	\""	+ category + "\""
		macro_text += "\nbuttontext:	\""	+ buttontext + "\""
		macro_text += "\nicon:	\"MENU:true\""
		
		macro_text += "\n(\n"
		macro_text += "	" + script_body + "\n"
		macro_text += ")\n"
		
		macro_text -- return
	)
	
	/** Write to mcr file
	 */
	function writeToMcrFile file_content file_path =
	(
		--format "\n"; print ".writeToMcrFile()"
		if doesFileExist file_path then
			deleteFile file_path
			
		file_stream = createFile file_path

		format "%" file_content to:file_stream

		close file_stream
		
		format "\nMacroScripts created in:\n%\n"  file_path
	)
	
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		
		quad_name	= "_SelectionSets"
		mcr_category	= "_Selection_Set"
		
		file_path = (getDir #userMacros) + "\\" + mcr_category + ".mcr"
		
		file_content = ""

		rx = "System.Text.RegularExpressions.Regex"
		
		
		--SelSets = SelectionSetsManager_v()
		
		/* GET MENU OF NAMED SELECTION SET */ 
		MenuSets 	= Menu_v (mcr_category)
		
		MenuSets.clearMenu()
		
		counter = 0
		
		/* CREATE EACH MACROSCRIPT */ 
		for set_name in (SelectionSetsManager_v()).sel_sets.keys do
		--for set_name in SelSets.sel_sets.keys do
		(
			format "set_name: %\n" set_name
			counter += 1
		
			sanitized_set_name = ( dotNetObject rx "[^0-9A-Za-z]" ).Replace ( toLower(set_name) ) "_"
			sanitized_set_name = ( dotNetObject rx "[_]+" ).Replace sanitized_set_name "_"
			
			macro_name	= "selection_sets_use_set_" + sanitized_set_name
			
			prefix = if counter < 10 then "&" + counter as string + " - " else ""
			
			macro_code = "\n\t\tselect ( ( SelectionSetsManager_v() ).getObjectsInSet \""+set_name+"\" )"
			
			file_content += "\n" + generateMacroScript (mcr_category) (macro_name) (prefix + set_name)  macro_code file_path
		)
		
		/* WRITE TO MCR FILE */ 
		writeToMcrFile (file_content) (file_path)
		
		/* PARSE MCR FILE TO MENU */ 
		(ScriptFile_Content_v(file_path)).importMacroscriptsToMenus()
		
		
		/* GET QUAD */ 
		SelSetsQuadMenu 	= QuadMenu_v( quad_name )
		format "SelSetsQuadMenu: %\n" SelSetsQuadMenu
		
		/* QUADS SETUP */ 
		SelSetsQuadMenu.Quads[1].addMenu( mcr_category )	
		SelSetsQuadMenu.Quads[2].addMenu( "_Selection-Sets" )	flat:true
		
		--ShellLaunch file_path ""
		
		ShellLaunch "notepad.exe" ("\"" + file_path + "\"")

	)
)
















