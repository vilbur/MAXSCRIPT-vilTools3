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


struct SceneStateTransfer
(
    -- Define the target properties and temporary folder path
    tempDir = (getDir #temp) + "\\SceneStates_INI\\",
    validParts = #("Object Properties", "Layer Properties", "Layer Assignment"),
    
	validParts_bits = ( for validPart in validParts collect sceneStateMgr.MapPartToIndex validPart ) as BitArray,
    -- Helper to format booleans for the INI file
    fn formatBool b = ( if b then "true" else "false" ),
    
    -- 1) Save function
    fn save = (
        -- 3) Create temp folder for INI files
        makeDir tempDir
        
        -- Cache the current scene state so we don't permanently alter the user's active viewport during the loop
        local tempBackupState = "___TEMP_ACTIVE_SCENE_BACKUP___"
		
		
        --sceneStateMgr.Capture tempBackupState validParts
        sceneStateMgr.Capture tempBackupState #{1..10}
        
        local statesCount = sceneStateMgr.GetCount()
        local statesToProcess = #()
        
        -- 1) Loop all scene states
        for i = 1 to statesCount do
		(
            local stateName = sceneStateMgr.GetSceneState i
			
            -- Ignore our temporary backup state
            if stateName != tempBackupState do (
                local parts = sceneStateMgr.GetParts stateName
                local matchingParts = #{}
				
				
                -- 2) Test if state has one of the target parts
                for p in parts where validParts_bits[p] do
					matchingParts[p] = true
                
                -- If true, add to our processing queue
                if not matchingParts.isEmpty do append statesToProcess #(stateName, matchingParts)
            )
        )
        -- 4) For each of scene states create INI file
        for sp in statesToProcess do (
            local stateName = sp[1]
            local partsToProcess = sp[2]
            local iniFile = tempDir + stateName + ".ini"
            
            -- Ensure a clean slate for the INI file
            if doesFileExist iniFile do deleteFile iniFile
            
            -- We MUST restore the state to the scene to read the property values
            sceneStateMgr.Restore stateName partsToProcess
            
            -- 5) Loop scene parts (sections in INI file)
            for part in partsToProcess do (
                
				part_name = sceneStateMgr.MapIndexToPart part
				
                -- Object Properties
                if part_name == "Object Properties" then (
                    for obj in objects do (
                        local propStr = "isHidden:" + (formatBool obj.isHidden) + ",isFrozen:" + (formatBool obj.isFrozen) + ",renderable:" + (formatBool obj.renderable)
                        setINISetting iniFile part_name obj.name propStr
                    )
                )
                -- Layer Properties
                else if part_name == "Layer Properties" then (
                    for i = 0 to LayerManager.count-1 do (
                        local layer = LayerManager.getLayer i
                        -- layer.on is visibility (true = visible). We invert it to match 'isHidden' logic.
                        local propStr = "isHidden:" + (formatBool (not layer.on)) + ",isFrozen:" + (formatBool layer.isFrozen) + ",renderable:" + (formatBool layer.renderable)
                        setINISetting iniFile part_name layer.name propStr
                    )
                )
                -- Layer Assignment
                else if part_name == "Layer Assignment" then (
                    for i = 0 to LayerManager.count-1 do (
                        local layer = LayerManager.getLayer i
                        layer.nodes &layerNodes
                        
                        local nameStr = ""
                        if layerNodes != undefined and layerNodes.count > 0 do (
                            for n = 1 to layerNodes.count do (
                                nameStr += layerNodes[n].name
                                if n < layerNodes.count do nameStr += ","
                            )
                        )
                        setINISetting iniFile part_name layer.name nameStr
                    )
                )
				
            )
			
			format "iniFile: %\n" iniFile
			--DOSCommand ("\""+iniFile+"\"")
			DOSCommand ("\""+iniFile+"\"")
        )
        
        -- Restore the original active scene and delete the temporary backup
        sceneStateMgr.Restore tempBackupState #{1..10}
        sceneStateMgr.Delete tempBackupState
        
        format "SUCCESS: Saved % scene states to %\n" statesToProcess.count tempDir
    ),
    
    -- Load function (Inverts process)
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
    )
)

clearListener(); print("Cleared in: "+getSourceFileName())

-- USAGE:
mySceneStates = SceneStateTransfer()
mySceneStates.save()
-- mySceneStates.load()