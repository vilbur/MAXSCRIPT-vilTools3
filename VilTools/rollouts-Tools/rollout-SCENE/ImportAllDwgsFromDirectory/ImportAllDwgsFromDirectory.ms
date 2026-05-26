/*
    Description:
    Mass DWG importer with layer parenting and persistent scale settings.
*/

struct massDWGImporter_v
(
    ini_file = (getDir #userScripts + "\\mass-dwg-importer.ini"),
    import_unit = "millimeters",
    import_scale = 1.0,
    selected_directory = undefined,


    /*
        Description:
        Check if ini has key.
    */

    function HasDictValue ini_path section_key =
    (
        local result = false

        if (doesFileExist ini_path) then
        (
            local value = getINISetting ini_path section_key "value"

            if (value != "") then
            (
                result = true
            )
        )

        result -- return
    ),


    /*
        Description:
        Convert unit string to scale multiplier.
    */

    function GetUnitScale unit_name =
    (
        case unit_name of
        (
            "millimeters":
            (
                1.0
            )

            "centimeters":
            (
                10.0
            )

            "meters":
            (
                1000.0
            )

            "kilometers":
            (
                1000000.0
            )

            default:
            (
                1.0
            )
        )
    ),


    /*
        Description:
        Return current max unit string.
    */

    function GetCurrentMaxUnit =
    (
        case units.MetricType of
        (
            #millimeters:
            (
                "millimeters"
            )

            #centimeters:
            (
                "centimeters"
            )

            #meters:
            (
                "meters"
            )

            #kilometers:
            (
                "kilometers"
            )

            default:
            (
                "unknown"
            )
        )
    ),


    /*
        Description:
        Ensure scene uses millimeters.
    */

    function EnsureMillimeterUnits =
    (
        local is_ok = true

        if (units.SystemType != #metric) then
        (
            is_ok = false
        )

        if (units.MetricType != #millimeters) then
        (
            is_ok = false
        )

        if (not is_ok) then
        (
            local result = queryBox
            (
                "3ds Max units are not millimeters.\n\nSwitch to millimeters?"
            )

            if result then
            (
                units.SystemType = #metric
                units.MetricType = #millimeters
                units.SystemScale = 1.0
            )
            else
            (
                false -- return
            )
        )

        true -- return
    ),


    /*
        Description:
        Ask user for directory if needed.
    */

    function GetImportDirectory =
    (
        local import_dir = undefined

        if (maxFilePath != "") then
        (
            local dwg_files = getFiles (maxFilePath + "*.dwg")

            if (dwg_files.count > 0) then
            (
                import_dir = maxFilePath
            )
        )

        if (import_dir == undefined) then
        (
            import_dir = getSavePath caption:"Select DWG Directory"  initialDir:(getDir #import)
            
        )

        import_dir -- return
    ),


    /*
        Description:
        Save folder scale settings.
    */

    function SaveFolderScale folder_path unit_name =
    (
        if (folder_path == undefined) then
        (
            false -- return
        )

        if (unit_name == undefined) then
        (
            unit_name = "millimeters"
        )

        setINISetting ini_file folder_path "value" unit_name

        true -- return
    ),


    /*
        Description:
        Load folder scale settings.
    */

    function LoadFolderScale folder_path =
    (
        local value = getINISetting ini_file folder_path "value"

        value -- return
    ),


    /*
        Description:
        Ask user for import units.
    */

    function AskImportUnits folder_path =
    (

        rollout unit_rollout "DWG Import Units"
        (
			local selected_unit = "millimeters"
            listbox lb_units "" items:#("millimeters", "centimeters", "meters", "kilometers") height:4
            button btn_ok "OK" width:120

            on unit_rollout open do
            (
                lb_units.selection = 1
            )

            on btn_ok pressed do
            (
                if (lb_units.selection > 0) then
                (
                    selected_unit = lb_units.items[lb_units.selection]
                )

                destroyDialog unit_rollout
				
				
				
            )
        )

        createDialog unit_rollout width:220 height:160 modal:true

        if (selected_unit == undefined) then
        (
            selected_unit = "millimeters"
        )

        SaveFolderScale folder_path selected_unit

        selected_unit -- return
    ),


    /*
        Description:
        Resolve import scale settings.
    */

    function ResolveImportScale reset_scale_settings:false =
    (
        local saved_unit = ""

        if (not reset_scale_settings) then
        (
            saved_unit = LoadFolderScale selected_directory
        )

        if (saved_unit == "") then
        (
            local ask_result = queryBox  "Do you want to define DWG import scale?"
            

            if ask_result then
            (
                saved_unit = AskImportUnits selected_directory
            )
            else
            (
                saved_unit = "millimeters"
            )
        )

        import_unit = saved_unit
        import_scale = GetUnitScale saved_unit
    ),


    /*
        Description:
        Create parent layer.
    */

    function CreateParentLayer layer_name =
    (
        local parent_layer = LayerManager.getLayerFromName layer_name

        if (parent_layer == undefined) then
        (
            parent_layer = LayerManager.newLayerFromName layer_name
        )

        parent_layer -- return
    ),


    /*
        Description:
        Return current layer snapshot.
    */

    function GetCurrentLayers =
    (
        local layers = #()

        for i = 0 to (LayerManager.count - 1) do
        (
            append layers (LayerManager.getLayer i)
        )

        layers -- return
    ),


    /*
        Description:
        Return new imported layers.
    */

    function GetNewLayers old_layers =
    (
        local new_layers = #()

        for i = 0 to (LayerManager.count - 1) do
        (
            local layer_ref = LayerManager.getLayer i

            if (findItem old_layers layer_ref == 0) then
            (
                append new_layers layer_ref
            )
        )

        new_layers -- return
    ),


    /*
        Description:
        Parent imported layers.
    */

    function ParentImportedLayers parent_layer imported_layers =
    (
        for layer_ref in imported_layers do
        (
            try
            (
                if (layer_ref.name != "0") then
                (
                    layer_ref.setParent parent_layer
                )
            )
            catch()
        )
    ),


    /*
        Description:
        Scale imported nodes.
    */

    function ScaleImportedNodes nodes_array scale_value =
    (
        if (scale_value == 1.0) then
        (
            true -- return
        )

        for obj in nodes_array do
        (
            try
            (
                obj.scale *= [scale_value, scale_value, scale_value]
            )
            catch()
        )
    ),


    /*
        Description:
        Import single DWG file.
    */

    function ImportDwgFile dwg_file =
    (
        local file_name = getFilenameFile dwg_file

        local old_layers = GetCurrentLayers()

        local old_nodes = objects as array

        importFile dwg_file #noPrompt using:DWGIMP

        local new_nodes = #()

        for obj in objects do
        (
            if (findItem old_nodes obj == 0) then
            (
                append new_nodes obj
            )
        )

        ScaleImportedNodes new_nodes import_scale

        local parent_layer = CreateParentLayer file_name

        local new_layers = GetNewLayers old_layers

        ParentImportedLayers parent_layer new_layers

        for obj in new_nodes do
        (
            parent_layer.addNode obj
        )
    ),


    /*
        Description:
        Import all DWG files from folder.
    */

    function ImportAllDwgs reset_scale_settings:false =
    (
        --if (not EnsureMillimeterUnits()) then
        --(
        --    false -- return
        --)

        selected_directory = GetImportDirectory()

        if (selected_directory == undefined) then
        (
            messageBox "No folder selected."
            false -- return
        )

        local dwg_files = getFiles (selected_directory + "\\*.dwg")

        if (dwg_files.count == 0) then
        (
            messageBox "No DWG files found."
            false -- return
        )

        ResolveImportScale reset_scale_settings:reset_scale_settings

        disableSceneRedraw()

        for dwg_file in dwg_files do
        (
            ImportDwgFile dwg_file
        )

        enableSceneRedraw()

        completeRedraw()

        local message_text = ""
        
        message_text += "Imported DWG files: "
        message_text += (dwg_files.count as string)
        message_text += "\n\nImport scale source: "
        message_text += import_unit
        message_text += "\nImport scale multiplier: "
        message_text += (import_scale as string)
        message_text += "\nCurrent 3ds Max units: "
        message_text += GetCurrentMaxUnit()
        

        messageBox message_text

        true -- return
    ),


    on create do
    (
    )
)



