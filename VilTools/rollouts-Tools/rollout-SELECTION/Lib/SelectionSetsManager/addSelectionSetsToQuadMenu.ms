
/** Add selection sets to quad menu
 */
function addSelectionSetsToQuadMenu =
(
	format "\n"; print ".addSelectionSetsToQuadMenu()"

	macroscripts = #()
	
	quad_name	= "_SelectionSets"
	category	= "_Selection_Set"
	
	file_path = (getDir #userMacros) + "\\" + category + ".mcr"

	rx = "System.Text.RegularExpressions.Regex"
	
	
	SelSets = SelectionSetsManager_v()
	
	if SelSets.sel_sets.count == 0 then
		return false
	
	/* GET MENU OF NAMED SELECTION SET */ 
	MenuSets 	= Menu_v (category)
	
	MenuSets.clearMenu()
	
	counter = 0
	
	/* CREATE EACH MACROSCRIPT */ 
	for set_name in SelSets.sel_sets.keys do
	--for set_name in SelSets.sel_sets.keys do
	(
		--format "set_name: %\n" set_name
		counter += 1
	
		sanitized_set_name = ( dotNetObject rx "[^0-9A-Za-z]" ).Replace ( toLower(set_name) ) "_"
		sanitized_set_name = ( dotNetObject rx "[_]+" ).Replace sanitized_set_name "_"
		
		macro_name	= "selection_sets_use_set_" + sanitized_set_name
		
		prefix = if counter < 10 then "&" + counter as string + " - " else ""
		
		macro_code = "\n\t\tselect ( ( SelectionSetsManager_v() ).getObjectsInSet \""+set_name+"\" )"
		
		MacroData = MacroData_v macro_name category buttontext:(prefix + set_name) exe:macro_code icon:"MENU:true"
		
		append macroscripts MacroData
	)
	
	/* WRITE TO MCR FILE */ 
	(MacroscriptGenerator_v()).generateMcrFile (macroscripts) (file_path)
	
	/* PARSE MCR FILE TO MENU */ 
	(ScriptFile_Content_v(file_path)).importMacroscriptsToMenus()
	
	
	/* GET QUAD */ 
	SelSetsQuadMenu 	= QuadMenu_v( quad_name )
	--format "SelSetsQuadMenu: %\n" SelSetsQuadMenu
	
	
	/* ADD SETS TO QUAD */
	SelSetsQuadMenu.Quads[1].addMenu( category )	
)
	
		
		