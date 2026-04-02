/** 
  *	
  *	
  *	
  */
struct SceneStateLoader_v
(
    validParts_bits,
    tempDir,
	
    /* 
        Load scene states from INI files
    */
    function load =
    (
		/* ini file == preset state */ 
        ini_files = this._collectIniFiles()

		format "ini_files: %\n" ini_files
		
        for ini_file in ini_files do
        (
			bits_to_load = #{}
			
			parts_to_load =  getINISetting ini_file

			/* State name is filename */ 
            state_name = getFilenameFile ini_file

			
			/* LAOD EACH PART */ 
			for part_name in parts_to_load where ( bit_of_part = sceneStateMgr.MapPartToIndex part_name ) > 0 do 
                if validParts_bits[bit_of_part] then
                (
					/* REMEBER WHICH PART IS LAODED */ 
					bits_to_load[bit_of_part] = true
					
					/* LOAD PART */ 
					this._loadPart part_name ini_file
                )
			
			/* SAVE STATE */
			if not bits_to_load.isEmpty then
				sceneStateMgr.Capture state_name bits_to_load
        )

        --FORMAT "SUCCESS: Loaded % scene states from %\n" ini_files.count tempDir
    ),
    /* 
        Dispatch LOAD part
    */
    function _loadPart part_name ini_file =
    (
		/* E.G.: "Object Properties" >>> "_loadObjectProperties" */ 
		method = "_load" + ( substituteString part_name " " "") 
		--format "TEST: %\n" ( hasProperty this method )
		
		/* EXECUTE METHOD */ 
		if hasProperty this method then
			case part_name of
			(
				"Light Properties":	this._loadLightProperties	ini_file
				"Light Transforms":	this._loadLightTransforms	ini_file
				"Object Properties":	this._loadObjectProperties	ini_file
				"Camera Transforms":	this._loadCameraTransforms	ini_file
				"Camera Properties":	this._loadCameraProperties	ini_file
				"Layer Properties":	this._loadLayerProperties	ini_file
				"Layer Assignment":	this._loadLayerAssignment	ini_file
				"Materials":	this._loadMaterials	ini_file
				"Environment":	this._loadEnvironment	ini_file
				"Anim Layer Properties":	this._loadAnimLayerProperties	ini_file
			)
		else
			format "\nUNKNOW METHOD SceneStateLoader_v.%()\n" ( method )
    ),

    /* 
        Apply Object Properties LOAD
    */
    function _loadObjectProperties ini_file =
    (
 		format "\n"; print "SceneStateLoader_v._loadObjectProperties()"
		
        for obj in objects do
			this._loadProperties obj "Object Properties"
    ),

    /* 
        Apply Layer Properties LOAD
    */
    function _loadLayerProperties ini_file =
    (
        for i = 0 to LayerManager.count - 1 do
			this._loadProperties ( LayerManager.getLayer i ) "Layer Properties"
    ),

	/** Load properties
	 */
	function _loadProperties _node state_name =
	(
		--format "\n"; print "SceneStateLoader_v._loadProperties()"
		if ( ini_val = getINISetting ini_file state_name _node.name ) != undefined then
		(
			values = execute ini_val 
			
			for prop in values.keys do format "prop: % 	value: %\n" prop values[prop]
			
			for prop in values.keys do
				setProperty _node prop values[prop]
		)
	),
	
    /* 
        Apply Layer Assignment LOAD
    */
    function _loadLayerAssignment ini_file =
    (
        for i = 0 to LayerManager.count - 1 do
        (
            layer = LayerManager.getLayer i
			
			if ( ini_val = getINISetting ini_file "Layer Assignment" layer.name ) != undefined then
			(
				objects_in_layer = execute ini_val 
				
				if objects_in_layer.count > 0 then
					layer.addnodes objects_in_layer
			)
        )
    ),

    /* 
        Collect ini files from temp directory
    */
    function _collectIniFiles =
    (
        result = #()
        files = getFiles (tempDir + "*.ini")

        for f in files do
        (
            append result f
        )

        result -- return
    ),



    on create do
    (
    )
)