/*------ DEV IMPORT ------*/
filein( getFilenamePath(getSourceFileName()) + "/SceneStatesManager/SceneStatesManager.ms" )	--"./SceneStatesManager/SceneStatesManager.ms"
/**
  */
macroscript	scene_states_save
category:	"_Scene-States"
buttontext:	"CREATE"
toolTip:	"Create Scene state"
icon:	"id:BTN_save_scene_state|Menu:CREATE state|across:3"
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


--global SCENE_STATE_BITS

macroscript	scene_states_create_menu_callbacks
category:	"_Scene-States"
buttontext:	"SCENE STATES QUAD MENU ✅"
toolTip:	"Enable\Disable "
icon:	"control:checkbox|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(
	on IsChecked do SCENE_STATE_BITS != undefined

	on execute do
	(
		
		if SCENE_STATE_BITS == undefined or ( EventFired != undefined and EventFired.val ) then
		(
			
			CALLBACKMANAGER.add "processSceneStateCallbackMenu"	#NamedSelSetRenamed
			CALLBACKMANAGER.add "processSceneStateCallbackMenu"	#NamedSelSetDeleted
			CALLBACKMANAGER.add "processSceneStateCallbackMenu"	#filePostOpen

			CALLBACKMANAGER.start "processSceneStateCallbackMenu"

			processSceneStateCallbackMenu()
			
			sceneStatesPartsMenu()
			
			/* UPDATE PARTS MENU */ 
			setSceneStateParts undefined 
		)
		else
		(
			CALLBACKMANAGER.kill "processSceneStateCallbackMenu"

			(Menu_v ("_Scene-States-Parts")).clearMenu()
			
			(Menu_v ("_Scene-State-Callback")).clearMenu()
			
			SCENE_STATE_BITS = undefined
		)

		--if EventFired != undefined then 
			--SCENE_STATE_BITS = EventFired.val
	)
)












