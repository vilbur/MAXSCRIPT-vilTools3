
/** Add selection sets to quad menu
 */
function addSelectionSetsToQuadMenu =
(
	format "\n"; print ".addSelectionSetsToQuadMenu()"
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
		
		
)