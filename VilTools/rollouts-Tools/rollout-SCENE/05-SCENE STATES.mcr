
/**
  */
macroscript	scene_states_save
category:	"_Scene-States"
buttontext:	"SAVE"
--toolTip:	"Open Selection sets dialog"
icon:	"id:BTN_save_scene_state|Menu:true"
(
	on IsVisible do selection.count > 0

	
	on execute do
	(
		--macros.run "Edit" "namedSelSets"
		if selection.count > 0 then
		(
			/* ASK FOR NAME OF SET */ 
			dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" ""
			dialog.text	= "SELECTION SET NAME"
			modal	= dialog.Showmodal()
			set_name	= dialog.InstanceName
			
			/* CREATE SELECTION SET */ 
			if (trimLeft(set_name)).count > 0 then
				(SceneStatesManager_v()).saveState set_name
			
		)
	)
)

/**
  */
macroscript	scene_states_laod
category:	"_Scene-States"
buttontext:	"LOAD"
toolTip:	"LOAD Scene States"
icon:	"id:BTN_load_scene_state|MENU:toolTip"
(
	on execute do
	(
		--SceneStates = SceneStatesManager_v()
		
		--scene_states = loadState.getNamedSelSetDict()
		
		--if queryBox ("LOAD SELECTION SETS ?\n\n"+arrayToString loadState.sel_sets.keys "\n" ) title:"LOAD SETS" then
		--SceneStates.loadState()

	)
)

/**
  */
macroscript	scene_states_delete_all
category:	"_Scene-States"
buttontext:	"DELETE"
toolTip:	"DELETE ALL Named Scene States From Scene"
icon:	"id:BTN_delete_scene_state|MENU:true"
(
	on execute do
	(
		
		--if queryBox ("DELETE SELECTION SETS ?") title:"DELETE SETS" then
		--	(
		--		--nsm = NamedSelectionSetManager
		--		
		--		/* DELETE OLD SETS */ 
		--		--for s = nsm.GetNumNamedSelSets() - 1 to 0 by -1 do 
		--			--nsm.RemoveNamedSelSetByIndex s
		--	)
	)
)





/**
  */
macroscript	scene_states_open_dialog
category:	"_Scene-States"
buttontext:	"Dialog"
toolTip:	"Open Scene states dialog"
icon:	"MENU:true"
(
	on execute do
	(
		actionMan.executeAction -1682387772 "4112"  -- Scene State: Scene State Manager Dialog Toggle
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
		format "SCENE_STATES_QUADMENU: %\n" SCENE_STATES_QUADMENU
		if SCENE_STATES_QUADMENU != true or ( EventFired != undefined and EventFired.val ) then
		----if SCENE_STATES_QUADMENU == undefined then
		(
			--CALLBACKMANAGER.start "autoEndResult" --"./../../../CallBacks/modPanelSubObjectLevelChanged/autoEndResult.ms"
			
			
			
			CALLBACKMANAGER.add "addSceneStatesToQuadMenu"	#NamedSelSetRenamed
			CALLBACKMANAGER.add "addSceneStatesToQuadMenu"	#NamedSelSetDeleted
			CALLBACKMANAGER.add "addSceneStatesToQuadMenu"	#filePostOpen

			CALLBACKMANAGER.start "addSceneStatesToQuadMenu"

			addSceneStatesToQuadMenu()
			
		)
		else
		(
			CALLBACKMANAGER.kill "addSceneStatesToQuadMenu"

			MenuSets 	= Menu_v ("_Selection_Set")
			
			MenuSets.clearMenu()
		)

		if EventFired != undefined then 
			SCENE_STATES_QUADMENU = EventFired.val
	)
)












