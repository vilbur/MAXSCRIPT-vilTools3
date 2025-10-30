filein( getFilenamePath(getSourceFileName()) + "/Lib/processSceneStateCallbackMenu.ms" )	--"./processSceneStateCallbackMenu.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/sceneStatesPartsMenu.ms" )	--"./sceneStatesPartsMenu.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/setSceneStateParts.ms" )	--"./setSceneStateParts.ms"

--global SCENE_STATE_BITS = BitArray 10
global SCENE_STATE_BITS

/** Selection sets manager
  
  https://help.autodesk.com/view/3DSMAX/2025/ENU/?guid=GUID-BF71F54B-B2BB-4E18-899D-BFCF6327336F
  
 */
struct SceneStatesManager_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	--StateMgr = sceneStateMgr,

	scene_states, --Dictionary #STRING key:"state_name" value:index
	
	ini = getDir #TEMP + "\\named-scene-states.ini",

	/* private */
	scene_state_bit_names = #( #LightProperties, #LightTransforms, #ObjectProperties, #CameraTransforms, #CameraProperties, #LayerProperties, #LayerAssignment, #Materials, #Environment, #AnimLayerProperties ),

	menu_callback_help_message = "MANAGE STATE IN QUAD MENU: Press CTRL: Save state | Press SHIFT: Rename state | Press ALT: Delete state",
	/* dependency */
	/* reference */
	/* inhered */
	
	/** FRONT END METHOD
	 */
	function processStateCallback state_name =
	(
		format "\n"; print "SceneStatesManager_v.processState()"
		

		if SCENE_STATE_BITS == undefined then
			setSceneStateParts (undefined) 
		
		--enabled_parts = this.getNamesOfParts(SCENE_STATE_BITS)
		
		state_parts = sceneStateMgr.GetParts state_name

		/* RESAVE STATE on CONTROL pressed */ 
		if keyboard.controlPressed then
		(
			format "state_parts: %\n" state_parts
			format "SCENE_STATE_BITS: %\n" SCENE_STATE_BITS
			
			state_parts_string =  this._arrayToString (this.getNamesOfParts(state_parts))
			
			if queryBox ("SAVE STATE ?\n\nSTATE:\n\t" +state_name+ "\n\nPARTS:\n" + state_parts_string ) title:"SAVE SCENE STATE" then
				this.saveState state_name state_parts
		)
		/* RENAME on SHIFT pressed */ 
		else if keyboard.shiftPressed then
		(
			if (new_name = this._askForStateName default:state_name) != "" then
				this.renameState state_name new_name
		)
		/* DELETE on ALT pressed */ 
		else if keyboard.altPressed then
		(
			if queryBox ("DELETE STATE ?\n\n"+state_name) title:"DELETE SCENE STATE" then
				this.deleteState state_name
		)		
		/* LAOD STATE */ 
		else
			this.loadState state_name state_parts
		
		processSceneStateCallbackMenu()

		format "menu_callback_help_message: %\n" menu_callback_help_message
	),
	
	/** Create state
	 */
	function createState state_bits =
	(
		--format "\n"; print "SceneStatesManager_v.createState()"
		if (state_name = this._askForStateName default:"") != "" then
			this.saveState state_name state_bits
		
		state_name --return
	),

	/** Rename state
	 */
	function renameState state_name new_name =
	(
		format "\n"; print "SceneStatesManager_v.renameState()"
		sceneStateMgr.Rename state_name new_name 
	),
	
	/** Open dialog
	 */
	function openDialog =
	(
		--format "\n"; print "SceneStatesManager_v.openDialog()"
		actionMan.executeAction -1682387772 "4112"  -- Scene State: Scene State Manager Dialog Toggle
	),
	
	/** Save state
	 */
	function saveState state_name state_bits =
	(
		format "\n"; print "SceneStatesManager_v.saveState()"
		--state_bits = this.getSceneStateParts LightProperties:LightProperties LightTransforms:LightTransforms ObjectProperties:ObjectProperties CameraTransforms:CameraTransforms CameraProperties:CameraProperties LayerProperties:LayerProperties LayerAssignment:LayerAssignment Materials:Materials Environment:Environment AnimLayerProperties:AnimLayerProperties OK

		format "state_bits: %\n" state_bits

		if ( index = sceneStateMgr.FindSceneState state_name) == 0 then
			sceneStateMgr.Capture state_name state_bits
	),
	
	/** Load state
	 */
	function loadState state_name load_bits =
	(
		format "\n"; print "SceneStatesManager_v.loadState()"
		--load_bits = this.getSceneStateParts LightProperties:LightProperties LightTransforms:LightTransforms ObjectProperties:ObjectProperties CameraTransforms:CameraTransforms CameraProperties:CameraProperties LayerProperties:LayerProperties LayerAssignment:LayerAssignment Materials:Materials Environment:Environment AnimLayerProperties:AnimLayerProperties OK
		--format "LOAD BITS: %\n" load_bits

		format "INDEX: %\n" (sceneStateMgr.FindSceneState state_name)
		
		if ( index = sceneStateMgr.FindSceneState state_name) > 0 then
		(
			
			--if load_bits.count == 0 then
			saved_bits = sceneStateMgr.GetParts state_name
			
			format "SAVED BITS: %\n" load_bits
			
			--load_bits *= saved_bits
			
			SCENE_STATE_BITS = saved_bits
			
			format "LOAD BITS: %\n" saved_bits
			
			format "\n--------------------- SCENE STATE LOADED PARTS ---------------------\n"
			for load_bit in saved_bits do
				format "LOADED PART: %\n" scene_state_bit_names[load_bit]
			
			
			sceneStateMgr.Restore state_name saved_bits
		)
	),
	
	/** Delete set
	 */
	function deleteState state_name =
	(
		--format "\n"; print "SceneStatesManager_v.deleteState()"
		if ( index = sceneStateMgr.FindSceneState state_name) > 0 then
			sceneStateMgr.Delete state_name
	),
	
	/** Get scene states
	 */
	function getSceneStates =
	(
		--format "\n"; print "SceneStatesManager_v.getSceneStates()"
		--format "sceneStateMgr.GetCount(): %\n" (sceneStateMgr.GetCount())
		scene_states = #()
		
		for i = 1 to sceneStateMgr.GetCount() do
			append scene_states ( sceneStateMgr.GetSceneState i )
			
		scene_states --return
	),
	
	/** Get enabled parts
	 */
	function getNamesOfParts bits =
	(
		--format "\n"; print "SceneStatesManager_v.getNamesOfParts()"
		for _bit in bits collect scene_state_bit_names[_bit]
	),
	
	--/** Get state parts
	-- */
	--function getStateParts state_name =
	--(
	--	--format "\n"; print "SceneStatesManager_v.getStateParts()"
	--	
	--),
	--
	/* 
	  Creates bitArray for sceneStateMgr.Capture
	  Parameters correspond to individual scene elements.
	*/
	
	function getSceneStateParts LightProperties:false LightTransforms:false ObjectProperties:false CameraTransforms:false CameraProperties:false LayerProperties:false LayerAssignment:false Materials:false Environment:false AnimLayerProperties:false = 
	(
		format "\n"; print "SceneStatesManager_v.getSceneStateParts()"
		--bits = bitArray 14
		bits = BitArray ()

		if LightProperties	then bits[1]  = true
		if LightTransforms	then bits[2]  = true
		
		if ObjectProperties	then bits[3]  = true
		
		if CameraTransforms	then bits[4]  = true
		if CameraProperties	then bits[5]  = true
		
		if LayerProperties	then bits[6]  = true
		if LayerAssignment	then bits[7]  = true
		
		if Materials		then bits[8]  = true
		if Environment		then bits[9]  = true
		
		if AnimLayerProperties	then bits[10]  = true
	
		bits -- return
	),

	private
	
	/** Ask for state name
	 */
	function _askForStateName default:"" =
	(
		--format "\n"; print "SceneStatesManager_v._askForStateName default:()"
		dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" default
		dialog.text	= "SELECTION SET NAME"
		modal	= dialog.Showmodal()
		
		--dialog.InstanceName --return
		trimLeft(dialog.InstanceName) --return
	),
	
	/** Add new set
	 */
	function _addNewState objs state_name  =
	(
		--format "\n"; print "SceneStatesManager_v._addNewState()"
		StateMgr.AddNewNamedSelState objs state_name

		this.setSceneStates()
	),
	
	/** Update objects in st
	 */
	function _updateObjectsInState objs state_name replace:false =
	(
		--format "\n"; print "SceneStatesManager_v._updateObjectsInState()"

		if not replace then
		(
			objs_in_set = this.getObjectsInState state_name
			
			objs = makeUniqueArray( objs_in_set + objs )
		)

		StateMgr.ReplaceNamedSelStateByName objs state_name
	),
	
	/** Join array to string
	*/
   function _arrayToString arr delimeter:"\n" = ( _string = ""; for item in arr where item == true do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count)),
		
	--/** Get scene states
	-- */
	--function setSceneStates =
	--(
	--	--format "\n"; print "SceneStatesManager_v.setSceneStates()"
	--	this.scene_states = Dictionary #STRING
	--	
	--	for i = 0 to StateMgr.GetNumNamedSelStates() -1 do
	--		this.scene_states[StateMgr.GetNamedSelStateName i] = i
	--),

	/**
	 */
	on create do
	(
		--this.setSceneStates()
		--format "\n"; print "SceneStatesManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
