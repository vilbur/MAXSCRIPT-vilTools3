/** 
  *	
  *	
  *	
  */
struct SceneStateTransfer_v
(
    tempDir = (getDir #temp + "\\SceneStates\\"),
    validParts_bits,
	
	
    /* 
        Load scene states from INI files
    */
    function load =
    (
        local iniFiles = collectIniFiles()

        for ini_file in iniFiles do
        (
            local state_name = getFilenameFile ini_file

            if sceneStateMgr.GetSceneStateIndex state_name == 0 then
            (
                sceneStateMgr.Capture state_name #{}
            )

            for part_index in validParts_bits do
            (
                if validParts_bits[part_index] then
                (
                    local part_name = sceneStateMgr.MapIndexToPart part_index
                    applyPart part_name ini_file
                )
            )
        )

        format "SUCCESS: Loaded % scene states from %\n" iniFiles.count tempDir
    ),

    /* 
        Initialize valid parts bitarray
    */
    function initValidParts =
    (
        validParts_bits = #{}
        validParts_bits[sceneStateMgr.MapPartToIndex "Object Properties"] = true
        validParts_bits[sceneStateMgr.MapPartToIndex "Layer Properties"] = true
        validParts_bits[sceneStateMgr.MapPartToIndex "Layer Assignment"] = true
    ),

    /* 
        Format boolean to string
    */
    function formatBool val =
    (
        if val then "1" else "0" -- return
    ),

    /* 
        Parse string boolean
    */
    function parseBool str =
    (
        if str == "1" then true else false -- return
    ),

    /* 
        Collect ini files from temp directory
    */
    function collectIniFiles =
    (
        local result = #()
        local files = getFiles (tempDir + "*.ini")

        for f in files do
        (
            append result f
        )

        result -- return
    ),

    /* 
        Apply Object Properties LOAD
    */
    function applyObjectProperties ini_file =
    (
        for obj in objects do
        (
            local val = getINISetting ini_file "Object Properties" obj.name
            if val != undefined then
            (
                local data = filterString val ","
                for d in data do
                (
                    local pair = filterString d ":"
                    if pair.count == 2 then
                    (
                        if pair[1] == "isHidden" then obj.isHidden = parseBool pair[2]
                        else if pair[1] == "isFrozen" then obj.isFrozen = parseBool pair[2]
                        else if pair[1] == "renderable" then obj.renderable = parseBool pair[2]
                    )
                )
            )
        )
    ),

    /* 
        Apply Layer Properties LOAD
    */
    function applyLayerProperties ini_file =
    (
        for i = 0 to LayerManager.count - 1 do
        (
            local layer = LayerManager.getLayer i
            local val = getINISetting ini_file "Layer Properties" layer.name

            if val != undefined then
            (
                local data = filterString val ","
                for d in data do
                (
                    local pair = filterString d ":"
                    if pair.count == 2 then
                    (
                        if pair[1] == "isHidden" then layer.on = not parseBool pair[2]
                        else if pair[1] == "isFrozen" then layer.isFrozen = parseBool pair[2]
                        else if pair[1] == "renderable" then layer.renderable = parseBool pair[2]
                    )
                )
            )
        )
    ),

    /* 
        Apply Layer Assignment LOAD
    */
    function applyLayerAssignment ini_file =
    (
        for i = 0 to LayerManager.count - 1 do
        (
            local layer = LayerManager.getLayer i
            local val = getINISetting ini_file "Layer Assignment" layer.name

            if val != undefined and val != "" then
            (
                local names = filterString val ","

                for n in names do
                (
                    local obj = getNodeByName n
                    if obj != undefined then
                    (
                        layer.addNode obj
                    )
                )
            )
        )
    ),

    /* 
        Dispatch LOAD part
    */
    function applyPart part_name ini_file =
    (
        if part_name == "Object Properties" then applyObjectProperties ini_file
        else if part_name == "Layer Properties" then applyLayerProperties ini_file
        else if part_name == "Layer Assignment" then applyLayerAssignment ini_file
    ),


    on create do
    (
        initValidParts()
    )
)