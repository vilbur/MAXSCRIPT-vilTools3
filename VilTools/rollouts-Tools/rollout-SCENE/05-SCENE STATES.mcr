/*------ DEV IMPORT ------*/
filein( getFilenamePath(getSourceFileName()) + "/SceneStatesManager/SceneStatesManager.ms" )	--"./SceneStatesManager/SceneStatesManager.ms"
/**
  */
macroscript	scene_states_save
category:	"_Scene-States"
buttontext:	"CREATE"
toolTip:	"Create Scene state"
icon:	"id:BTN_save_scene_state|Menu:true|across:3"
(
	--on IsVisible do selection.count > 0

	
	on execute do
	(
		--macros.run "Edit" "namedSelSets"
		--if selection.count > 0 then
		(
			/* ASK FOR NAME OF SET */ 
			dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" ""
			dialog.text	= "SELECTION SET NAME"
			modal	= dialog.Showmodal()
			state_name	= dialog.InstanceName
			
			/* CREATE SELECTION SET */ 
			if (trimLeft(state_name)).count > 0 then
			(
				(SceneStatesManager_v()).saveState state_name SCENE_STATE_BITS
				
				processSceneStateCallbackMenu()
			)
		)
	)
)


/**
  */
macroscript	scene_states_open_dialog
category:	"_Scene-States"
buttontext:	"DIALOG"
toolTip:	"Open Scene states dialog"
icon:	"MENU:true"
(
	on execute do
	(
		actionMan.executeAction -1682387772 "4112"  -- Scene State: Scene State Manager Dialog Toggle
		
		processSceneStateCallbackMenu()

	)
)


global SCENE_STATES_QUADMENU

macroscript	scene_states_create_menu_callbacks
category:	"_Scene-States"
buttontext:	"SCENE STATES QUAD MENU"
toolTip:	"Enable\Disable "
icon:	"control:checkbox|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(

	
	on IsChecked do SCENE_STATES_QUADMENU != undefined

	on execute do
	(
		--format "SCENE_STATES_QUADMENU: %\n" SCENE_STATES_QUADMENU
		if SCENE_STATES_QUADMENU != true or ( EventFired != undefined and EventFired.val ) then
		----if SCENE_STATES_QUADMENU == undefined then
		(
			--CALLBACKMANAGER.start "autoEndResult" --"./../../../CallBacks/modPanelSubObjectLevelChanged/autoEndResult.ms"
			
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

		)

		if EventFired != undefined then 
			SCENE_STATES_QUADMENU = EventFired.val
	)
)












