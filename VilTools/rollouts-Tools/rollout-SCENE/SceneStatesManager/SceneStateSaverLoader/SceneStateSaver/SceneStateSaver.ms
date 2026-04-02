/*
	write maxscript struct to save \ load scene states
	
	
	fuction save does fllowing:
		1) loop all scene states
		2) test if state has one of these parts: "Object Properties"|"Layer Properties"|"Layer Assignment"
		3) if true then continue and create temp folder for ini files
		4) for each of scene states create ini file named as scene state
		5) loop scene parts where each part name is section in ini file
		
		
		in case of: "Object Properties"
			iterate objects in scene and save object name as key and dictionary of each object Properties
			
			
		in case of: "Layer Properties"
			iterate layers in scene and save layer name as key and dictionary of each layer Properties
			
			
		in case of: "Layer Assignment"
			iterate layers in scene and save layer name as key and array of objects which belongs to layer
			
			
	fuction load inverts process. Read ini file and create or update scene set accordning to data from ini file
	
	
	ALL SCENE STATE PARTS:
		#("Light Properties", "Light Transforms", "Object Properties", "Camera Transforms", "Camera Properties", "Layer Properties", "Layer Assignment", "Materials", "Environment", "Anim Layer Properties")
	
*/

struct SceneStateSaver_v
(
    valid_parts,
	
    temp_dir,

	state_name, -- currently processed state
	
	active_state_backup = "___TEMP_ACTIVE_SCENE_BACKUP___",
	
    /* 
        Saves scene states into INI files
    */
    function save =
    (
 		format "\n"; print "SceneStateSaver_v.save()"
		
		removeDir temp_dir
		
        makeDir temp_dir

		/* SAVE ACTIVE STATE */ 
        sceneStateMgr.Capture active_state_backup #{1..10}
		

		/* SAVE STATES */ 
        states_to_process = this._collectStatesToProcess()

        for state_data in states_to_process do
			this._processState state_data[1] state_data[2]

			
		/* RESTORE ACTIVE STATE */ 
        sceneStateMgr.Restore active_state_backup #{1..10}

        sceneStateMgr.Delete active_state_backup
		
		
        FORMAT "SUCCESS: Saved % scene states to %\n" states_to_process.count temp_dir
    ),
	

	private
	
	/** Process state
	 */
	function _processState state_name parts_to_save  =
	(
		--format "\n"; print "to._processState()"
		this.state_name = state_name
		
		/* ACTIVATE STATE */ 
		sceneStateMgr.Restore state_name parts_to_save

		/* SAVE EACH PART */ 
		for part in parts_to_save do
			this._savePart (sceneStateMgr.MapIndexToPart part)

			
		format "ini_file: %\n" (this._getIniPath())
		--DOSCommand ("\"" + ini_file + "\"")
	
	),	

    /* 
        Dispatch processing of scene state part
    */
    function _savePart part_name =
    (
		/* E.G.: "Object Properties" >>> "_saveObjectProperties" */ 
		method = "_save" + ( substituteString part_name " " "") 
		
		/* EXECUTE METHOD */ 
		if hasProperty this method then
			case part_name of
			(
				"Light Properties":	this._saveLightProperties()
				"Light Transforms":	this._saveLightTransforms()
				"Object Properties":	this._saveObjectProperties()
				"Camera Transforms":	this._saveCameraTransforms()
				"Camera Properties":	this._saveCameraProperties()
				"Layer Properties":	this._saveLayerProperties()
				"Layer Assignment":	this._saveLayerAssignment()
				"Materials":	this._saveMaterials()
				"Environment":	this._saveEnvironment()
				"Anim Layer Properties":	this._saveAnimLayerProperties()
			)
		else
			FORMAT "\nUNKNOW METHOD SceneStateSaver_v.%()\n" ( method )
    ),
	
	
    /* 
        Process Object Properties part
    */
    function _saveObjectProperties =
    (
        for obj in objects do
			this._saveProperties "Object Properties" obj.name isHidden:obj.isHidden isFrozen:obj.isFrozen renderable:obj.renderable
    ),

    /* 
        Process Layer Properties part
    */
    function _saveLayerProperties =
    (
        for i = 0 to LayerManager.count - 1 where ( layer = LayerManager.getLayer i ) != undefined do
			this._saveProperties "Layer Properties" layer.name isHidden:(not layer.on) isFrozen:layer.isFrozen renderable:layer.renderable
    ),

	/** Save properties
	 */
	function _saveProperties part_name key isHidden: isFrozen: renderable: =
	(
		--format "\n"; print "SceneStateSaver_v._saveProperties()"
		data = Dictionary #( #isHidden, isHidden ) #( #isFrozen, isFrozen ) #( #renderable, renderable )
		
		this.saveToIni part_name key data
	),
	
    /* 
        Process Layer Assignment part
    */
    function _saveLayerAssignment =
    (
		state_name = state_name
		
        for i = 0 to LayerManager.count - 1 do
        (
			objs_in_layer = #()
			
            layer = LayerManager.getLayer i
			
            layer.nodes &objs_in_layer

			node_names = for obj_in_layer in objs_in_layer collect obj_in_layer.name
			
			this.saveToIni "Layer Assignment" layer.name node_names
        )
    ),

    /* Collect states that contain valid parts
		
		@return matrix of states data E.G.: #( state_name, matching_parts ) >>> #( "Foo-State", #{1..3} )
    */
    function _collectStatesToProcess =
    (
        result = #()
        statesCount = sceneStateMgr.GetCount()

        for i = 1 to statesCount where ( state_name = sceneStateMgr.GetSceneState i ) != active_state_backup do
        (
			matching_parts = #{}
			
			parts = sceneStateMgr.GetParts state_name

			/* GET PARTS */ 
			for p in parts where valid_parts[p] do
				matching_parts[p] = true

			/* GET RESULT */ 
			if not matching_parts.isEmpty then
				append result #( state_name, matching_parts )
        )

        result -- return
    ),

	/** Save to ini
	 */
	function saveToIni part_name key val =
	(
		--format "\n"; print "to.saveToIni()"
        setINISetting (this._getIniPath()) part_name ( key as string ) ( val as string )
	),
	
	/** Get ini path
	 */
	function _getIniPath =
	(
		--format "\n"; print "to.getIniPath()"
		temp_dir + this.state_name + ".ini" --return
	),
	

    on create do
    (
    )
)

