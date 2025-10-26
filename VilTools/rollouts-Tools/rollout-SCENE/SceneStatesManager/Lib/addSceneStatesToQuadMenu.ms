--filein( getFilenamePath(getSourceFileName()) + "/../../../../../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms" )	--"./../../../../../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms"
/** Add scene states to quad menu
 */
function addSceneStatesToQuadMenu =
(
	format "\n"; print ".addSceneStatesToQuadMenu()"
	macroscripts = #()
	
	quad_name	= "_SelectionSets"
	category	= "_Scene-State"
	
	file_path = (getDir #userMacros) + "\\" + category + ".mcr"

	rx = "System.Text.RegularExpressions.Regex"
	
	
	SceneStates = SceneStatesManager_v()
	
	scene_states = SceneStates.getSceneStates()
	format "scene_states: %\n" scene_states
	if scene_statescount == 0 then
		return false
	
	/* GET MENU OF NAMED SELECTION SET */ 
	MenuSets 	= Menu_v (category)
	
	MenuSets.clearMenu()
	
	counter = 0
	
	--/* CREATE EACH MACROSCRIPT */ 
	for state_name in scene_states do
	(
		format "state_name: %\n" state_name
		counter += 1
	
		sanitized_set_name = ( dotNetObject rx "[^0-9A-Za-z]" ).Replace ( toLower(state_name) ) "_"
		sanitized_set_name = ( dotNetObject rx "[_]+" ).Replace sanitized_set_name "_"
		
		macro_name	= "selection_sets_use_set_" + sanitized_set_name
		
		--prefix = if counter < 10 then "&" + counter as string + " - " else ""
		prefix = ""
		
		macro_code = "\n\t\t( SceneStatesManager_v() ).loadState \""+state_name+"\""
		--macro_code = "\n\t\tmessageBox \""+state_name+"\""
		
		MacroData = MacroData_v macro_name category buttontext:(prefix + state_name) exe:macro_code icon:"MENU:true"
		
		append macroscripts MacroData
	)
	
	format "FILE_PATH: %\n" file_path
	/* WRITE TO MCR FILE */ 
	(MacroscriptGenerator_v()).generateMcrFile (macroscripts) (file_path)
	
	/* PARSE MCR FILE TO MENU */ 
	(ScriptFile_Content_v(file_path)).importMacroscriptsToMenus()
	
	
	/* GET QUAD */ 
	SelSetsQuadMenu 	= QuadMenu_v( quad_name )
	--format "SelSetsQuadMenu: %\n" SelSetsQuadMenu
	
	
	/* ADD SETS TO QUAD */
	SelSetsQuadMenu.Quads[4].addMenu( category )
	
	createSceneStatesPartsMenu()
)