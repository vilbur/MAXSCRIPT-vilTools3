
--format "\n*********************************\n\n sceneStatesPartsMenu() \n\n*********************************\n\n"

--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\ContentLoader\ContentSubrollouts\ContentRollout\ScriptFile\ScriptFile.ms"

/** Create scene states menu
  
  https://help.autodesk.com/view/3DSMAX/2025/ENU/?guid=GUID-AD55B6B0-CACF-4581-AB09-688E0014DB6A#GUID-AD55B6B0-CACF-4581-AB09-688E0014DB6A__IMAGE_045012F838DB47FD9583C2E33C1C93AC
 */
function sceneStatesPartsMenu =
(
	--format "\n"; print ".sceneStatesPartsMenu()"
	
	macroscripts = #()
	
	
	--scene_state_bit_names = for i = 1 to sceneStateMgr.PartsCount() collect sceneStateMgr.MapIndexToPart i -- get #("Light Properties", "Light Transforms", "Object Properties", "Camera Transforms", "Camera Properties", "Layer Properties", "Layer Assignment", "Materials", "Environment", "Anim Layer Properties")
	/*
		Default order	
		 #("Light Properties", "Light Transforms", "Object Properties", "Camera Transforms", "Camera Properties", "Layer Properties", "Layer Assignment", "Materials", "Environment", "Anim Layer Properties")
	*/ 
	
	scene_state_bit_order =
	#(
		"Object Properties",
		"Layer Properties",
		"Layer Assignment",
		
		"Anim Layer Properties",
		
		"Light Properties",
		"Light Transforms",
		
		"Camera Transforms",
		"Camera Properties",
		
		"Materials",
		"Environment"
	)
		
		
	category	= "_Scene-States-Parts"
	

	file_path = (getDir #userMacros) + "\\" + category + ".mcr"
	
	--if menuMan.findMenu category != undefined then
		--return true
 

	for state_name in scene_state_bit_order do 
	(
		--_bit	= findItem scene_state_bit_names state_name
		_bit = sceneStateMgr.MapPartToIndex state_name
		
		--state_name = scene_state_bit_names[_bit] as string
		--format "state_name: %\n" state_name
		--macro_code = "setSceneStateParts "+ _bit as string
		macro_code = "SCENE_STATE_BITS["+ _bit as string + "]"
		
		tooltip = ( dotNetClass "System.Text.RegularExpressions.Regex").Replace state_name "(?<!^)([A-Z])" " $1"
		--format "title: %\n" title
		
		MacroData = MacroData_v state_name category \
						exe:macro_code \
						tooltip:tooltip icon:"MENU:true" \
						IsChecked: ("SCENE_STATE_BITS != undefined and SCENE_STATE_BITS["+ _bit as string +"]")
		
		append macroscripts MacroData
	)

	if ScriptFile_Content_v != undefined and Menu_v != undefined then 
	(
		
		(MacroscriptGenerator_v()).generateMcrFile (macroscripts) (file_path)
		
		MenuSetParts 	= Menu_v (category)
		
		MenuSetParts.clearMenu()
		
		(ScriptFile_Content_v(file_path)).importMacroscriptsToMenus()
		
		MenuSetParts.addSeparators #( 1, 3, 4, 6, 8 )
	
		--setSceneStateParts(undefined)
	)
	else
	(
		format "ScriptFile_Content_v: %\n" ScriptFile_Content_v
		format "Menu_v: %\n" Menu_v
		
	)
	
)
