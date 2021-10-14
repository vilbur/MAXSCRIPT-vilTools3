filein( getFilenamePath(getSourceFileName()) + "/Lib/LayerStates.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/LayerStatesCallback.ms" )


--/*
--*/ 
--macroscript	layers_state_load
--category:	"_Layer"
--buttontext:	"Load"
--toolTip:	"Load layers state"
--(
--	ROLLOUT_layers.LISTBOX_states.items = (LayerStates_v()).getSceneStates()
--)


/*
*/ 
macroscript	layers_state_create
category:	"_Layer"
buttontext:	"Create"
toolTip:	"Create new layers state"
(
	rollout state_name_rollout "Set state name"
	(
		local current_layer = (LayerManager.current).name
		
		edittext edittext_state_name text:current_layer
		
		on edittext_state_name entered entered_text do 
		(
			if( entered_text != "" ) then 
				sceneStateMgr.Capture entered_text #{6}
			
			loadLayerStates()
			
			destroyDialog state_name_rollout
		)	
	)
	
	CreateDialog state_name_rollout width:256
		
	setFocus state_name_rollout.edittext_state_name

)

/*
*/ 
macroscript	layers_state_update
category:	"_Layer"
buttontext:	"Update"
toolTip:	"Update layers state"
(
	selected_state = ROLLOUT_layers.LISTBOX_states.selected
	
	if queryBox ("Update Layer style "+selected_state+" ?") beep:false then
		sceneStateMgr.Capture selected_state #{6}
)


/*
*/ 
macroscript	layers_state_listbox
category:	"_Layer"
buttontext:	"States"
--toolTip:	""
icon:	"type:Listbox|columns:14"
(
	--format "EventFired	= % \n" EventFired
	/*
		CREATE LISTOBX CONTROL
	*/ 
)
/*
*/ 
macroscript	layers_state_listbox_load_selected
category:	"_Layer"
buttontext:	"States"
toolTip:	"Load selected state"
icon:	"type:Listbox"
(
	selected_state = ROLLOUT_layers.LISTBOX_states.selected
	
	sceneStateMgr.Restore selected_state #{6}
)


layerStatesCallback()
