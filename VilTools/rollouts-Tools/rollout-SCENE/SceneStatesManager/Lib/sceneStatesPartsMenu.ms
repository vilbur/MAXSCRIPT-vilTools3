
/** Create scene states menu
  
  https://help.autodesk.com/view/3DSMAX/2025/ENU/?guid=GUID-AD55B6B0-CACF-4581-AB09-688E0014DB6A#GUID-AD55B6B0-CACF-4581-AB09-688E0014DB6A__IMAGE_045012F838DB47FD9583C2E33C1C93AC
 */
function sceneStatesPartsMenu =
(
	--format "\n"; print ".sceneStatesPartsMenu()"
	macroscripts = #()
	
	scene_state_bit_names = #( #LightProperties, #LightTransforms, #ObjectProperties, #CameraTransforms, #CameraProperties, #LayerProperties, #LayerAssignment, #Materials, #Environment, #AnimLayerProperties )
	
	scene_state_bit_order =
	#(
		#ObjectProperties,
		#LayerProperties,
		#LayerAssignment,
		
		#AnimLayerProperties,
		
		#LightProperties,
		#LightTransforms,
		
		#CameraTransforms,
		#CameraProperties,
		
		#Materials,
		#Environment
	)
		
	category	= "_Scene-States-Parts"
	

	file_path = (getDir #userMacros) + "\\" + category + ".mcr"
	--format "FILE_PATH: %\n" file_path
	--MacroData = MacroData_v macro_name category buttontext:(prefix + state_name) exe:macro_code icon:"MENU:true"
	
	--for i = 1 to scene_state_bit_names.count do
	for scene_state_name in scene_state_bit_order do 
	(
		_bit	= findItem scene_state_bit_names scene_state_name
		
		state_name = scene_state_bit_names[_bit] as string
		--format "state_name: %\n" state_name
		macro_code = "setSceneStateParts "+ _bit as string
		
		tooltip = ( dotNetClass "System.Text.RegularExpressions.Regex").Replace state_name "(?<!^)([A-Z])" " $1"
		--format "title: %\n" title
		
		MacroData = MacroData_v state_name category \
						exe:macro_code \
						tooltip:tooltip icon:"MENU:true" \
						IsChecked: ("SCENE_STATE_BITS != undefined and SCENE_STATE_BITS["+ _bit as string +"]")
		
		append macroscripts MacroData
	)

	
	(MacroscriptGenerator_v()).generateMcrFile (macroscripts) (file_path)
	
	MenuSets 	= Menu_v (category)
	
	MenuSets.clearMenu()
	
	(ScriptFile_Content_v(file_path)).importMacroscriptsToMenus()
	
	MenuSets.addSeparators #( 1, 3, 4, 6, 8 )

	setSceneStateParts(undefined)
)
