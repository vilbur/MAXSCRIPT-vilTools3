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
*/

struct SceneStateTransfer_v
(
    tempDir = (getDir #temp + "\\SceneStates\\"),
    validParts_bits,

    /* 
        Saves scene states into INI files
    */
    function save =
    (
        makeDir tempDir

        local tempBackupState = "___TEMP_ACTIVE_SCENE_BACKUP___"
        sceneStateMgr.Capture tempBackupState #{1..10}

        local statesToProcess = this._collectStatesToProcess()

        for sp in statesToProcess do
        (
            local state_name = sp[1]
            local parts_to_process = sp[2]
            local ini_file = tempDir + state_name + ".ini"

            if doesFileExist ini_file then deleteFile ini_file

            sceneStateMgr.Restore state_name parts_to_process

            for part in parts_to_process do
            (
                local part_name = sceneStateMgr.MapIndexToPart part
                this._processPart part_name ini_file
            )

            format "iniFile: %\n" ini_file
            DOSCommand ("\"" + ini_file + "\"")
        )

        sceneStateMgr.Restore tempBackupState #{1..10}
        sceneStateMgr.Delete tempBackupState

        format "SUCCESS: Saved % scene states to %\n" statesToProcess.count tempDir
    ),
	
	
    fn load = (
        local iniFiles = getFiles (tempDir + "*.ini")
        
        for iniFile in iniFiles do (
            local stateName = getFileNameFile iniFile
            local sectionsInFile = getINISetting iniFile
            local capturedParts = #()
            
            for part in sectionsInFile do (
                append capturedParts part
                local keys = getINISetting iniFile part
                
                -- Reconstruct Object Properties
                if part == "Object Properties" then (
                    for k in keys do (
                        local obj = getNodeByName k
                        if obj != undefined do (
                            local propStr = getINISetting iniFile part k
                            local tokens = filterString propStr ","
                            for t in tokens do (
                                local kv = filterString t ":"
                                if kv.count == 2 do (
                                    if kv[1] == "isHidden" do obj.isHidden = (kv[2] == "true")
                                    if kv[1] == "isFrozen" do obj.isFrozen = (kv[2] == "true")
                                    if kv[1] == "renderable" do obj.renderable = (kv[2] == "true")
                                )
                            )
                        )
                    )
                )
                -- Reconstruct Layer Properties
                else if part == "Layer Properties" then (
                    for k in keys do (
                        local layer = LayerManager.getLayerFromName k
                        if layer != undefined do (
                            local propStr = getINISetting iniFile part k
                            local tokens = filterString propStr ","
                            for t in tokens do (
                                local kv = filterString t ":"
                                if kv.count == 2 do (
                                    if kv[1] == "isHidden" do layer.on = (kv[2] == "false") -- Invert back
                                    if kv[1] == "isFrozen" do layer.isFrozen = (kv[2] == "true")
                                    if kv[1] == "renderable" do layer.renderable = (kv[2] == "true")
                                )
                            )
                        )
                    )
                )
                -- Reconstruct Layer Assignment
                else if part == "Layer Assignment" then (
                    for k in keys do (
                        local layer = LayerManager.getLayerFromName k
                        if layer == undefined do layer = LayerManager.newLayerFromName k
                        
                        local propStr = getINISetting iniFile part k
                        if propStr != "" do (
                            local objNames = filterString propStr ","
                            for objName in objNames do (
                                local obj = getNodeByName objName
                                if obj != undefined do layer.addNode obj
                            )
                        )
                    )
                )
            )
            
            -- Create or update the Scene State according to the reconstructed scene
            if capturedParts.count > 0 do (
                sceneStateMgr.Capture stateName capturedParts
            )
        )
        
        format "SUCCESS: Loaded % scene states from %\n" iniFiles.count tempDir
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
    function _processPart part_name ini_file =
    (
        if part_name == "Object Properties" then this._processObjectProperties ini_file
        else if part_name == "Layer Properties" then this._processLayerProperties ini_file
        else if part_name == "Layer Assignment" then this._processLayerAssignment ini_file
    ),
    /* 
        Process Object Properties part
    */
    function _processObjectProperties ini_file =
    (
        for obj in objects do
			this._saveProperties ini_file "Object Properties" obj.name isHidden:obj.isHidden isFrozen:obj.isFrozen renderable:obj.renderable
    ),

    /* 
        Process Layer Properties part
    */
    function _processLayerProperties ini_file =
    (
        for i = 0 to LayerManager.count - 1 where ( layer = LayerManager.getLayer i ) != undefined do
			this._saveProperties ini_file "Layer Properties" layer.name isHidden:(not layer.on) isFrozen:layer.isFrozen renderable:layer.renderable
    ),

	/** Save properties
	 */
	function _saveProperties ini_file state_name key isHidden: isFrozen: renderable: =
	(
		format "\n"; print "SceneStateTransfer_v._saveProperties()"
		
		data = Dictionary #( #isHidden, isHidden ) #( #isFrozen, isFrozen ) #( #renderable, renderable )
		
        setINISetting ini_file state_name key ( data as string )
	),

    /* 
        Process Layer Assignment part
    */
    function _processLayerAssignment ini_file =
    (
        for i = 0 to LayerManager.count - 1 do
        (
            local layer = LayerManager.getLayer i
            layer.nodes &layer_nodes

            local name_str = ""

            if layer_nodes != undefined and layer_nodes.count > 0 then
            (
                for n = 1 to layer_nodes.count do
                (
                    name_str += layer_nodes[n].name
                    if n < layer_nodes.count then name_str += ","
                )
            )

            setINISetting ini_file "Layer Assignment" layer.name name_str
        )
    ),

    /* 
        Initialize valid parts bitarray
    */
    function _initValidParts =
    (
        validParts_bits = #{}
        validParts_bits[sceneStateMgr.MapPartToIndex "Object Properties"] = true
        validParts_bits[sceneStateMgr.MapPartToIndex "Layer Properties"] = true
        validParts_bits[sceneStateMgr.MapPartToIndex "Layer Assignment"] = true
    ),

	
    on create do
    (
        _initValidParts()
    )
)


clearListener(); print("Cleared in: "+getSourceFileName())

-- USAGE:
mySceneStates = SceneStateTransfer_v()
mySceneStates.save()
-- mySceneStates.load()