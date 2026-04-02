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
    validParts_bits,
    tempDir,

    /* 
        Saves scene states into INI files
    */
    function save =
    (
 		format "\n"; print "SceneStateSaver_v.save()"
        makeDir tempDir

        local tempBackupState = "___TEMP_ACTIVE_SCENE_BACKUP___"
        sceneStateMgr.Capture tempBackupState #{1..10}

        local statesToProcess = this._collectStatesToProcess()

        for sp in statesToProcess do
        (
            local state_name = sp[1]
            local parts_to_save = sp[2]
            local ini_file = tempDir + state_name + ".ini"

            if doesFileExist ini_file then deleteFile ini_file

            sceneStateMgr.Restore state_name parts_to_save

            for part in parts_to_save do
            (
                local part_name = sceneStateMgr.MapIndexToPart part
                this._savePart part_name ini_file
            )

            format "iniFile: %\n" ini_file
            --DOSCommand ("\"" + ini_file + "\"")
        )

        sceneStateMgr.Restore tempBackupState #{1..10}

        sceneStateMgr.Delete tempBackupState
		
        FORMAT "SUCCESS: Saved % scene states to %\n" statesToProcess.count tempDir
    ),
	

	private
	

    /* 
        Collect states that contain valid parts
    */
    function _collectStatesToProcess =
    (
        local result = #()
        local statesCount = sceneStateMgr.GetCount()

        for i = 1 to statesCount do
        (
            local state_name = sceneStateMgr.GetSceneState i

            if state_name != "___TEMP_ACTIVE_SCENE_BACKUP___" then
            (
                local parts = sceneStateMgr.GetParts state_name
                local matching_parts = #{}

                for p in parts where validParts_bits[p] do
                (
                    matching_parts[p] = true
                )

                if not matching_parts.isEmpty then
                (
                    append result #(state_name, matching_parts)
                )
            )
        )

        result -- return
    ),

    /* 
        Dispatch processing of scene state part
    */
    function _savePart part_name ini_file =
    (
		/* E.G.: "Object Properties" >>> "_saveObjectProperties" */ 
		method = "_save" + ( substituteString part_name " " "") 
		
		/* EXECUTE METHOD */ 
		if hasProperty this method then
			case part_name of
			(
				"Light Properties":	this._saveLightProperties	ini_file
				"Light Transforms":	this._saveLightTransforms	ini_file
				"Object Properties":	this._saveObjectProperties	ini_file
				"Camera Transforms":	this._saveCameraTransforms	ini_file
				"Camera Properties":	this._saveCameraProperties	ini_file
				"Layer Properties":	this._saveLayerProperties	ini_file
				"Layer Assignment":	this._saveLayerAssignment	ini_file
				"Materials":	this._saveMaterials	ini_file
				"Environment":	this._saveEnvironment	ini_file
				"Anim Layer Properties":	this._saveAnimLayerProperties	ini_file
			)
		else
			format "\nUNKNOW METHOD SceneStateSaver_v.%()\n" ( method )
    ),
	
	
    /* 
        Process Object Properties part
    */
    function _saveObjectProperties ini_file =
    (
        for obj in objects do
			this._saveProperties ini_file "Object Properties" obj.name isHidden:obj.isHidden isFrozen:obj.isFrozen renderable:obj.renderable
    ),

    /* 
        Process Layer Properties part
    */
    function _saveLayerProperties ini_file =
    (
        for i = 0 to LayerManager.count - 1 where ( layer = LayerManager.getLayer i ) != undefined do
			this._saveProperties ini_file "Layer Properties" layer.name isHidden:(not layer.on) isFrozen:layer.isFrozen renderable:layer.renderable
    ),

	/** Save properties
	 */
	function _saveProperties ini_file state_name key isHidden: isFrozen: renderable: =
	(
		--format "\n"; print "SceneStateSaver_v._saveProperties()"
		
		data = Dictionary #( #isHidden, isHidden ) #( #isFrozen, isFrozen ) #( #renderable, renderable )
		
        setINISetting ini_file state_name key ( data as string )
	),

    /* 
        Process Layer Assignment part
    */
    function _saveLayerAssignment ini_file =
    (
        for i = 0 to LayerManager.count - 1 do
        (
			layer_nodes = #()
			
            layer = LayerManager.getLayer i
			
            layer.nodes &layer_nodes

            setINISetting ini_file "Layer Assignment" layer.name ( layer_nodes as Array )
        )
    ),


    on create do
    (
    )
)

