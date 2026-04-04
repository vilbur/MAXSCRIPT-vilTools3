/*------ DEV IMPORT ------*/
filein( getFilenamePath(getSourceFileName()) + "/SceneStatesManager/SceneStatesManager.ms" )	--"./SceneStatesManager/SceneStatesManager.ms"
/**
  */
macroscript	scene_states_save
category:	"_Scene-States"
buttontext:	"CREATE"
toolTip:	"Create Scene state"
icon:	"id:BTN_save_scene_state|Menu:CREATE state|across:4|width:96"
(
	--on IsVisible do selection.count > 0
	on execute do
	(
		/* CREATE SELECTION SET */ 
		if ( state_name = (SceneStatesManager_v()).createState(SCENE_STATE_BITS) ) != "" then
			processSceneStateCallbackMenu()
	)
)


/**
  */
macroscript	scene_states_open_dialog
category:	"_Scene-States"
buttontext:	"DIALOG"
toolTip:	"Open Scene states dialog"
icon:	"MENU:DIALOG open"
(
	on execute do
	(
		actionMan.executeAction -1682387772 "4112"  -- Scene State: Scene State Manager Dialog Toggle
		
		processSceneStateCallbackMenu()
	)
)

/**
  */
macroscript	scene_states_export
category:	"_Scene-States-IO"
buttontext:	"EXPORT"
toolTip:	"Export scene states from scene"
icon:	"MENU:E X P O R T states"
(
	on execute do
		(SceneStateSaveLoader_v()).save()
)

/**
  */
macroscript	scene_states_import
category:	"_Scene-States-IO"
buttontext:	"IMPORT"
toolTip:	"Import scene states from scene"
icon:	"MENU:I M P O R T states"
(
	on execute do
		(SceneStateSaveLoader_v()).load()
)

/*
*/ 
macroscript	scene_states_create_menu_callbacks
category:	"_Scene-States"
buttontext:	"SCENE STATES QUAD MENU ✅"
toolTip:	"Enable\Disable "
icon:	"control:checkbox|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(
	on IsChecked do SCENE_STATE_BITS != undefined

	on execute do
	(
		if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
		(
			
			format "\nSCENE_STATES_CREATE_MENU_CALLBACKS - CREATE\n"
			
			CALLBACKMANAGER.add "processSceneStateCallbackMenu" #filePostOpen
			--CALLBACKMANAGER.add "processSceneStateCallbackMenu" #systemPostReset

			CALLBACKMANAGER.start "processSceneStateCallbackMenu"

			processSceneStateCallbackMenu()
			
			sceneStatesPartsMenu()
		)
		else
		(
			format "\nSCENE_STATES_CREATE_MENU_CALLBACKS - KILL\n"
			
			CALLBACKMANAGER.kill "processSceneStateCallbackMenu"

			(Menu_v ("_Scene-States-Parts")).clearMenu()
			
			(Menu_v ("_Scene-State-Callback")).clearMenu()
			
			SCENE_STATE_BITS = #{}
		)
	)
)












