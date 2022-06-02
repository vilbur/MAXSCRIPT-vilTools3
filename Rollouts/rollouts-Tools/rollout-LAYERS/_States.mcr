filein( getFilenamePath(getSourceFileName()) + "/Lib/LayerStates.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/LayerStatesCallback.ms" )


/*------------------------------------------------------------------------------
	GROUPBOX 
------------------------------------------------------------------------------*/

/**  
 */
macroscript	layers_state_group
category:	"_Unreal"
--buttontext:	"[Edit states]" -- BUG - if groupbox is in brackets, the is tried be added twice
buttontext:	"Edit states"
--icon:	"type:Groupbox|id:test_groupbox_x|across:2"
icon:	"type:Groupbox|id:test_groupbox_x|across:2|width:128"
(
)

/*
*/ 
macroscript	layers_state_load
category:	"_Layer"
buttontext:	"Load"
toolTip:	"Load layers state"
icon:	"Groupbox:Edit states"
(
	for i = 1 to sceneStateMgr.GetCount() do
	(
		state = sceneStateMgr.GetSceneState i
		format "state	= % \n" state
		
	)
	
	ROLLOUT_layers.Multilistbox_states.items = sort (for i = 1 to sceneStateMgr.GetCount() collect sceneStateMgr.GetSceneState i)
	--ROLLOUT_layers.Multilistbox_states.items =  (for i = 1 to sceneStateMgr.GetCount() collect sceneStateMgr.GetSceneState i)
	--ROLLOUT_layers.Multilistbox_states.items = sort(for i = 1 to sceneStateMgr.GetCount() collect sceneStateMgr.GetSceneState i)
	--ROLLOUT_layers.Multilistbox_states.items = sort ((LayerStates_v()).getSceneStates())
	--ROLLOUT_layers.Multilistbox_states.items = sort(for item in ((LayerStates_v()).getSceneStates()) collect item)
	
	
)

/*
*/ 
macroscript	layers_state_create
category:	"_Layer"
buttontext:	"Create"
toolTip:	"Create new layers state"
icon:	"Groupbox:Edit states"
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
icon:	"Groupbox:Edit states"
(
	_Multilistbox  = ROLLOUT_layers.Multilistbox_states
	selected_items = _Multilistbox.selection 

	if( selected_items.count > 0 ) then
	(
		selected_state = _Multilistbox.items[(selected_items as array )[1]]
		
		if queryBox ("Update Layer style:\n\n"+selected_state+" ?") beep:false then
			sceneStateMgr.Capture selected_state #{6}
		
	) else
		messageBox "Please select item"
)


/*------------------------------------------------------------------------------
	STATES LIST
--------------------------------------------------------------------------------*/
/*
*/ 
macroscript	layers_state_listbox
category:	"_Layer"
buttontext:	"States"
--toolTip:	""
icon:	"type:Multilistbox|across:2|width:232|offset:[-48,0]"
(
	/*
		CREATE LISTOBX CONTROL
		
		format "EventFired	= % \n" EventFired
		
		on item selected callback
		
	*/
	
)


--
--/* on double click
--*/ 
--macroscript	layers_state_listbox_load_selected
--category:	"_Layer"
--buttontext:	"States"
--toolTip:	"Load selected states"
--icon:	"type:Multilistbox"
--(
--	format "EventFired	= % \n" EventFired
--		
--	_Multilistbox  = ROLLOUT_layers.Multilistbox_states
--
--	enabled_layers = for i = 1 to LayerManager.count collect false
--		
--	/** Load state
--	 */
--	function loadState index =
--	(
--		format "_Multilistbox.items[index]	= % \n" _Multilistbox.items[index]
--		sceneStateMgr.Restore (_Multilistbox.items[index]) #{6}
--	)	
--	
--	/** Is layer on
--	 */
--	function isLayerOn index =
--	(
--		(LayerManager.getLayer index).on
--	)
--	
--	
--
--	for selected_index in ( _Multilistbox.selection as Array ) do
--	(
--		loadState selected_index
--		
--		for i = 1 to LayerManager.count do
--			if( isLayerOn(i-1) ) then
--				enabled_layers[i] = true
--	)
--		
--
--	format "enabled_layers	= % \n" enabled_layers
--	
--	for i = 0 to LayerManager.count-1 do
--		(LayerManager.getLayer i).on = enabled_layers[i+1]
--	
--	
--)
--
--
--
--layerStatesCallback()
