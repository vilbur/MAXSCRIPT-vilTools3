

filein( getFilenamePath(getSourceFileName()) + "/Lib/addSceneStatesToQuadMenu.ms" )	--"./addSceneStatesToQuadMenu.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/createSceneStatesPartsMenu.ms" )	--"./createSceneStatesPartsMenu.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/setSceneStateBit.ms" )	--"./setSceneStateBit.ms"

--global SCENE_STATE_BITS = BitArray 10
global SCENE_STATE_BITS

/** Selection sets manager
  
  https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-6CC6500C-FD5C-4646-A880-BC34E852CA2B
  
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

	/* dependency */
	/* reference */
	/* inhered */
	
	/** Process state
	 */
	function processStateCallback state_name =
	(
		format "\n"; print "SceneStatesManager_v.processState()"
		if SCENE_STATE_BITS == undefined then
			setSceneStateBit (undefined) 
		
		
		if keyboard.controlPressed then
			this.saveState state_name SCENE_STATE_BITS
		
		else
			this.loadState state_name SCENE_STATE_BITS
		 
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
		--state_bits = this.getSceneStateBits LightProperties:LightProperties LightTransforms:LightTransforms ObjectProperties:ObjectProperties CameraTransforms:CameraTransforms CameraProperties:CameraProperties LayerProperties:LayerProperties LayerAssignment:LayerAssignment Materials:Materials Environment:Environment AnimLayerProperties:AnimLayerProperties OK

		format "state_bits: %\n" state_bits

		if ( index = sceneStateMgr.FindSceneState state_name) == 0 then
			sceneStateMgr.Capture state_name state_bits
	),
	
	/** Load state
	 */
	function loadState state_name load_bits =
	(
		format "\n"; print "SceneStatesManager_v.loadState()"
		--load_bits = this.getSceneStateBits LightProperties:LightProperties LightTransforms:LightTransforms ObjectProperties:ObjectProperties CameraTransforms:CameraTransforms CameraProperties:CameraProperties LayerProperties:LayerProperties LayerAssignment:LayerAssignment Materials:Materials Environment:Environment AnimLayerProperties:AnimLayerProperties OK
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
		format "\n"; print "SceneStatesManager_v.getSceneStates()"
		format "sceneStateMgr.GetCount(): %\n" (sceneStateMgr.GetCount())
		scene_states = #()
		
		for i = 1 to sceneStateMgr.GetCount() do
			append scene_states ( sceneStateMgr.GetSceneState i )
			
		scene_states --return
	),
	
	/* 
	  Creates bitArray for sceneStateMgr.Capture
	  Parameters correspond to individual scene elements.
	*/
	
	function getSceneStateBits LightProperties:false LightTransforms:false ObjectProperties:false CameraTransforms:false CameraProperties:false LayerProperties:false LayerAssignment:false Materials:false Environment:false AnimLayerProperties:false = 
	(
		format "\n"; print "SceneStatesManager_v.getSceneStateBits()"
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

	
	/** Add new set
	 */
	function addNewState objs state_name  =
	(
		--format "\n"; print "SceneStatesManager_v.addNewState()"
		StateMgr.AddNewNamedSelState objs state_name

		this.setSceneStates()
	),
	
	/** Update objects in st
	 */
	function updateObjectsInState objs state_name replace:false =
	(
		--format "\n"; print "SceneStatesManager_v.updateObjectsInState()"

		if not replace then
		(
			objs_in_set = this.getObjectsInState state_name
			
			objs = makeUniqueArray( objs_in_set + objs )
		)

		StateMgr.ReplaceNamedSelStateByName objs state_name
	),
	
	
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
