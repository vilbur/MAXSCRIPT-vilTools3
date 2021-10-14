filein( getFilenamePath(getSourceFileName()) + "/Lib/LayerStates.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/LayerStatesCallback.ms" )




/*
*/ 
macroscript	layers_state_load
category:	"_Layer"
buttontext:	"Load"
toolTip:	"Load layers state"
(
	ROLLOUT_layers.Multilistbox_states.items = (LayerStates_v()).getSceneStates()
)

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
	items_all      = ROLLOUT_layers.Multilistbox_states.items  
	selected_items = ROLLOUT_layers.Multilistbox_states.selection 

	if( selected_items.count > 0 ) then
	(
		selected_state = items_all[(selected_items as array )[1]]
		
		if queryBox ("Update Layer style "+selected_state+" ?") beep:false then
			sceneStateMgr.Capture selected_state #{6}
		
	) else
		messageBox "Please select item"
)


/*
*/ 
macroscript	layers_state_listbox
category:	"_Layer"
buttontext:	"States"
--toolTip:	""
icon:	"type:Multilistbox|columns:14"
(
	format "EventFired	= % \n" EventFired
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
icon:	"type:Multilistbox"
(
	format "EventFired	= % \n" EventFired

	items_all      = ROLLOUT_layers.Multilistbox_states.items  
	selected_items = ROLLOUT_layers.Multilistbox_states.selection 
	selected_state = items_all[(selected_items as array )[1]]

	sceneStateMgr.Restore selected_state #{6}
)



layerStatesCallback()
