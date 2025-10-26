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
	
	createSceneStatesMenu()
)

--global SCENE_STATE_BITS = BitArray 10
global SCENE_STATE_BITS

/** Set scene state bit
 */
function setSceneStateBit _bit =
(
	format "\n"; print ".setSceneStateBit()"
	format "_bit: %\n" _bit
	ini = Ini_v(getDir #TEMP + "\\ini_files\\SCENE_STATE_BITS.ini" )
	format "INI: %\n" (Ini.getPath())

    
    -- return result_string
	SCENE_STATE_BITS = ini.load "_section" "SCENE_STATE_BITS" default:( BitArray 10 ) 
	
	if _bit != undefined then
	(
		SCENE_STATE_BITS[_bit] = not SCENE_STATE_BITS[_bit]
		
		ini.save "_section" "SCENE_STATE_BITS" SCENE_STATE_BITS
	)
)

/** Create scene states menu
 */
function createSceneStatesMenu =
(
	format "\n"; print ".createSceneStatesMenu()"
	macroscripts = #()
	
	scene_state_bit_names = #( #LightProperties, #LightTransforms, #ObjectProperties, #CameraTransforms, #CameraProperties, #LayerProperties, #LayerAssignment, #Materials, #Environment, #AnimLayerProperties )
	
	category	= "_Scene-States-Parts"
	

	file_path = (getDir #userMacros) + "\\" + category + ".mcr"
	format "FILE_PATH: %\n" file_path
	--MacroData = MacroData_v macro_name category buttontext:(prefix + state_name) exe:macro_code icon:"MENU:true"
	
	for i = 1 to scene_state_bit_names.count do 
	(
		state_name = scene_state_bit_names[i] as string
		format "state_name: %\n" state_name
		macro_code = "setSceneStateBit "+ i as string
		
		tooltip = ( dotNetClass "System.Text.RegularExpressions.Regex").Replace state_name "(?<!^)([A-Z])" " $1"
		--format "title: %\n" title
		MacroData = MacroData_v state_name category exe:macro_code tooltip:tooltip icon:"MENU:true"
		
		MacroData.IsChecked = "SCENE_STATE_BITS != undefined and SCENE_STATE_BITS["+ i as string +"]"
		
		append macroscripts MacroData
	)

	
	(MacroscriptGenerator_v()).generateMcrFile (macroscripts) (file_path)
	
	MenuSets 	= Menu_v (category)
	
	MenuSets.clearMenu()
	
	(ScriptFile_Content_v(file_path)).importMacroscriptsToMenus()

)
