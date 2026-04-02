/** 
  *	
  *	
  *	
  */
struct SceneStateLoader_v
(
    valid_parts,
	
    temp_dir,
	
	state_name, -- currently processed state

    /* 
        Load scene states from INI files
    */
    function load =
    (
 		format "\n"; print "SceneStateLoader_v._loadObjectProperties()"
		
		/* ini file == preset state */ 
        ini_files = this._collectIniFiles()

		--format "ini_files: %\n" ini_files
		
        for ini_file in ini_files do
        (
			format "\n=========================================================================================================\n"
			
			bits_to_load = #{}
			
			parts_to_load =  getINISetting ini_file

			/* State name is filename */ 
            this.state_name = getFilenameFile ini_file

			format "STATE_NAME: %\n" state_name
			
			/* LAOD EACH PART */ 
			for part_name in parts_to_load where ( bit_of_part = sceneStateMgr.MapPartToIndex part_name ) > 0 do 
                if valid_parts[bit_of_part] then
                (
					/* REMEBER WHICH PART IS LAODED */ 
					bits_to_load[bit_of_part] = true
					
					/* LOAD PART */ 
					this._loadPart part_name
                )
			
			/* SAVE STATE */
			if not bits_to_load.isEmpty then
				sceneStateMgr.Capture state_name bits_to_load
        )

        --FORMAT "SUCCESS: Loaded % scene states from %\n" ini_files.count temp_dir
    ),
	
    /* 
        Dispatch LOAD part
    */
    function _loadPart part_name =
    (
 		format "\n"; print ("SceneStateLoader_v._loadPart(\""+part_name+"\")")
		/* E.G.: "Object Properties" >>> "_loadObjectProperties" */ 
		method = "_load" + ( substituteString part_name " " "") 
		--format "TEST: %\n" ( hasProperty this method )
		
		/* EXECUTE METHOD */ 
		if hasProperty this method then
			case part_name of
			(
				"Light Properties":	this._loadLightProperties()
				"Light Transforms":	this._loadLightTransforms()
				"Object Properties":	this._loadObjectProperties()
				"Camera Transforms":	this._loadCameraTransforms()
				"Camera Properties":	this._loadCameraProperties()
				"Layer Properties":	this._loadLayerProperties()
				"Layer Assignment":	this._loadLayerAssignment()
				"Materials":	this._loadMaterials()
				"Environment":	this._loadEnvironment()
				"Anim Layer Properties":	this._loadAnimLayerProperties()
			)
		else
			FORMAT "\nUNKNOW METHOD SceneStateLoader_v.%()\n" ( method )
    ),

    /* 
        Apply Object Properties LOAD
    */
    function _loadObjectProperties =
    (
 		--format "\n"; print "SceneStateLoader_v._loadObjectProperties()"
		
        for obj in objects do
			this._loadProperties obj "Object Properties"
    ),

    /* 
        Apply Layer Properties LOAD
    */
    function _loadLayerProperties =
    (
		--format "\n"; print "SceneStateLoader_v._loadLayerProperties()"
        for i = 0 to LayerManager.count - 1 do
			this._loadProperties ( LayerManager.getLayer i ) "Layer Properties"
    ),

	/** Load properties
	 */
	function _loadProperties _node part_name =
	(
		--format "\n"; print "SceneStateLoader_v._loadProperties()"
		if ( ini_val = this._loadIni part_name _node.name ) != undefined then
			if ( values = execute ini_val ).keys.count > 0 then
				/* LOOP EACH PROP */ 
				for prop in values.keys do
					/* SET PROPERT TO NODE */ 
					setProperty _node prop values[prop]
	),
	
    /* 
        Apply Layer Assignment LOAD
    */
    function _loadLayerAssignment =
    (
		--format "\n"; print "SceneStateLoader_v._loadLayerAssignment()"
        for i = 0 to LayerManager.count - 1 do
        (
            layer = LayerManager.getLayer i
			
			if ( ini_val = this._loadIni "Layer Assignment" layer.name ) != undefined then
			(
				format "ini_val: %\n" ini_val
				--object_names_in_layer = execute ini_val
				
				--objects_in_layer	= for obj_name in object_names_in_layer where (obj = getNodeByName obj_name ) != undefined collect obj
				--
				--if objects_in_layer.count > 0 then
				--	layer.addnodes objects_in_layer
			)
        )
    ),

    /* 
        Collect ini files from temp directory
    */
    function _collectIniFiles =
    (
        result = #()
        files = getFiles (temp_dir + "*.ini")

        for f in files do
            append result f

        result -- return
    ),
	
	/** Load to ini
	 */
	function _loadIni part_name key =
	(
		--format "\n"; print "to._loadIni()"
		if ( ini_val = getINISetting (this._getIniPath()) part_name key ) != "" then
			ini_val --return
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