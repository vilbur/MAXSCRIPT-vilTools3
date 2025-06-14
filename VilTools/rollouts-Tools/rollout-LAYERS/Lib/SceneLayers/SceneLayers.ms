
/** Scene layers

  TODO:

	REMNAME THIS STRUCT TO LayerTypesManager_v


 */
struct SceneLayers_v
(
	/* construct */

	/* properties */
	top_layer_names	= #( #SOURCE, #EDIT, #FINAL ),
	top_layer_names_ext	= #( #HELP, #PRINT, #REFERENCE ),

	--layers_without_suffix	= #( #FINAL, #PRINT ), -- objects name is not suffixed in these layer types
	layers_without_suffix	= #( #FINAL ), -- objects name is not suffixed in these layer types

	new_nodes_all = #(),

	dash_line = "——————",
	delimeter = "-",

	--type_suffix_pattern = this._arrayToString( top_layer_names + top_layer_names_ext ) "|",
	type_suffix_pattern,

	/* dependency */
	LayersManager = LayersManager_v(),

	RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" ),
	IgnoreCase	= ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase,


	/* reference */
	/* inhered */
	/** Create
	 */
	function createTopLayers =
	(
		--format "\n"; print "SceneLayers_v.create()"
		for layer_name_data in (this._getTopLayerTitles()) do
			LayersManager.newLayer (layer_name_data.value)
	),

	
	/** Move to
	 */
	function moveTo layer_type _objects =
	(
		--format "\n"; print "TO.moveTo()"

		if _objects != undefined then
		(
			for obj in (_objects = this._getSourceObjects (_objects)) do
			(
				this._moveNodeToLayer(obj)(layer_type)
				
				--this.renameObjectsAndChildren obj layer_type
				this._renameObject obj layer_type
				
				if obj.children.count > 0 then
					for child in this.getAllChildren obj do
						this._renameObject child layer_type
			)
			
			select _objects
			
			_objects --return 
		)
		else
			#() -- return fallback
	),

	/** Copy to
	 */
	function copyTo layer_type _objects =
	(
		--format "\n"; print "TO.copyTo()"
		select ( this._copyTo layer_type _objects mode:#COPY )
	),
	
	/** Instance to
	 */
	function instanceTo layer_type _objects =
	(
		--format "\n"; print "TO.instanceTo()"
		select ( this._copyTo layer_type _objects mode:#INSTANCE )
	),
	
	/** Reference to
	 */
	function referenceTo layer_type _objects =
	(
		--format "\n"; print "TO.referenceTo()"
		select ( this._copyTo layer_type _objects mode:#REFERENCE )
	),
	

	/** Create layer by object
	 */
	function createLayerByObject _objects =
	(
		--format "\n"; print "SceneLayers_v.createLayerByObject()"

		/** Get layer key suffix
		 */
		function getLayerKeySuffix obj =
		(
			--format "\n"; print "SceneLayers_v.getLayerKeySuffix()"
			if ( layers_top = LayersManager.getTopLayers obj.layer ) != undefined and (layer_key = this.getTopLayerSuffix layers_top[1]) != undefined  then
				delimeter + ( toLower layer_key)
			else
				""
		)

		layers = #()
		--format "OBJS: %\n" _objects
		_objects = this._getSourceObjects (_objects)
		--format "OBJS: %\n" _objects

		for obj in _objects do
		(
			local obj_layer

			obj_name_stripped = this._removeTypeSuffix obj.name

			obj_name_stripped = this._regExReplace obj_name_stripped "[_-]*\d+$" ""

			if not matchPattern obj.layer.name pattern:( obj_name_stripped + "*") then
			(
				obj_layer = LayersManager.newLayer (obj_name_stripped + getLayerKeySuffix(obj) ) parent:obj.layer

				obj_layer.addNode obj

				appendIfUnique layers obj_layer
			)
		)

		layers --return
	),

	/** SELECT BY LAYER TYPE
	 */
	function selectIn layer_type _objects select_more:false =
	(
		--format "\n"; print "SceneLayers_v.selectIn()"
		--format "_objects: %\n" _objects
		/* 
		Merges two arrays of nodes and removes duplicates
		Returns a new array containing unique nodes from both inputs
		*/
		
		function mergeNodeArraysUnique array_a array_b =
		(
			merged = array_a as array
		
			for node in array_b where not (findItem merged node > 0) do
				append merged node
		
			merged -- return
		)
		/* 
		Removes all items from source_array that are found in remove_array
		Returns a new array with remaining items
		*/
		
		function removeArrayItems source_array remove_array =
		(
			result = #()
		
			for item in source_array where not (findItem remove_array item > 0) do
				append result item
		
			result -- return
		)
		layer_type = layer_type as name
		
		LayersManager = LayersManager_v()


		function isLayerWithoutSuffix layer_type = findItem this.layers_without_suffix layer_type > 0

		objs_found = #()
		objs_not_found = #()

		--for obj in this._getSourceObjects (_objects) do
		for obj in _objects do
		(
			
			target_obj = getNodebyName (this._getNameByLayerSuffix obj (layer_type as string ))
			
			--format "----------------\n"
			--format "target_obj: %\n" target_obj
			
			if target_obj == undefined then
				if (target_obj_without_suffix = getNodebyName (this._removeTypeSuffix obj.name)) != undefined and obj != target_obj_without_suffix then
				(
					top_layer_name = this.getTopLayerSuffix target_obj_without_suffix.layer
					
					target_obj = target_obj_without_suffix
				)
				
			if target_obj == undefined then
				append objs_not_found obj
			else
				append objs_found target_obj
			
		)
		--format "LAYERS: %\n" (LayersManager.getLayersByObjects _objects)
--		
		--format "OBJS_FOUND: %\n" objs_found
		--format "NOT_FOUND:  %\n" objs_not_found
--		
		if objs_found.count > 0 then
		(
			found_and_not_found = mergeNodeArraysUnique objs_found objs_not_found
			--format "found_and_not_found: %\n" found_and_not_found
			LayersManager.setVisibility (LayersManager.getLayersByObjects (_objects)) false
			LayersManager.setVisibility (LayersManager.getLayersByObjects found_and_not_found ) true
			
			(if select_more then selectmore else select) found_and_not_found 
			
			for obj in objs_not_found do
                 (format "TYPE %	NOT FOUND FOR OBJECT:	%\n" layer_type obj.name)
		)
		else
			messageBox ("NOT ANY OBJECT FOUND IN LAYER:\n\n" + toUpper ( this.getTopLayerTitle layer_type ))  title:"NOT FOUND"  beep:false
	),

	/* SET VISIBILITY
	  *
	  * @param Boolean isolate TRUE:HIDE OTHER TOP LAYERS  FALSE: toggle visiblity
	  *
	 */
	function setVisibility isolate:false layer_type: =
	(
		-- format "\n"; print "SceneLayers_v.setVisibility()"
		layer_type = layer_type as name

		top_layer  = this._getOrCreateTopLayer(layer_type)


		if isolate then
			for layer in top_layers = LayersManager.getTopLayers #ALL do
				layer.on = layer == top_layer

		else
			top_layer.on = not top_layer.on

		--top_layers = this.getTopLayers()
		--layers_tree =  this._getLayersTree (obj.layer)
		--
		--this.getTopLayerSuffix layers_tree[.].name

	),

	
	private
	
	
	
	/** Move to layer of type
	  *
	  * @param name mode #COPY|#INSTANCE|#REFERENCE
	 */
	function _copyTo layer_type _objects mode: =
	(
		-- format "\n"; print "SceneLayers_v._copyTo()"
		-- format "mode: %\n" mode
		
		if _objects != undefined then
		(
			layer_type = layer_type as name
					
			for obj in (_objects = this._getSourceObjects (_objects)) do
			(
				source_name = obj.name
				
				_nodes = this._cloneNode (obj) (mode)
				--format "_NODES: %\n" _nodes
	
				actual_node_list = _nodes[1]
				new_nodes       = _nodes[2]
				
				/* RENAME COPIES AS SOURCE OBJECTS */ 
				for i = 1 to new_nodes.count do
				(
					new_node = new_nodes[i]
					
					new_node.name = actual_node_list[i].name
					
					/* CLEAR USER PROPS ON NE NODE */ 
					setUserPropBuffer new_node ""
	
					/* MOVE COPY TO LAYER */
					this._moveNodeToLayer(new_node)(layer_type)
					
					this._renameObject new_node layer_type
				)
				
				--obj = new_nodes[1]
				
				--append new_nodes_all obj
				join new_nodes_all new_nodes
			)
	
			 this._deleteEmptyLayers()
			 
			 new_nodes_all --return
		)
		else
			#() --return fallback
	),
	
	/** Rename object
	 */
	function _renameObject obj layer_type =
	(
		--format "\n"; print "SceneLayers_v._renameObject()"
		layer_has_suffix = findItem layers_without_suffix (layer_type as name ) == 0
		
		obj.name = this._removeTypeSuffix obj.name

		same_name_objs = this._getObjectsByName obj.name 
		--format "same_name_objs.count: %\n" same_name_objs.count
		if same_name_objs.count > 1 then
		(
			if layer_has_suffix then
				for i = 1 to same_name_objs.count - 1 do 
					this._renameObjectByTopLayer same_name_objs[i]
			
			else
				for i = 1 to same_name_objs.count where same_name_objs[i] != obj do 
					this._renameObjectByTopLayer same_name_objs[i]
			
		)
	),
	
	/** Get objects by name
	 */
	function _getObjectsByName obj_name =
	(
		--format "\n"; print "TO._getObjectsByName()"
		 getNodeByName obj_name all:true
	),
	
	/** Rename object by top layer
	 */
	function _renameObjectByTopLayer obj force: =
	(
		  -- format "\n"; print "SceneLayers_v._renameObjectByTopLayer()"
		 -- format "obj.name: %\n" obj.name
		top_layer_source = (LayersManager.getTopLayers(obj.layer))[1]
		-- format "top_layer_source: %\n" top_layer_source.name
		layer_type = this.getTopLayerSuffix (top_layer_source)
		  -- format "LAYER_TYPE: %\n" layer_type
		--layer_has_suffix = findItem layers_without_suffix (layer_type as name ) > 0

		--if layer_type != undefined and layer_has_suffix then -- undefined if "Default" layer
			--obj.name = this._getNameByLayerSuffix (obj) (layer_type as name ) force:force
			
		--if layer_type != undefined and layer_has_suffix then -- undefined if "Default" layer
		if layer_type != undefined then -- undefined if "Default" layer
			this._renameObjBySuffix obj layer_type
	),

	/** Clone nodes and remove default number suffix of new copy
	  *
	  * Children of object are copied too
	 */
	function _cloneNode obj mode =
	(
		--format "\n"; print "SceneLayers_v._cloneNode()"

		maxOps.CloneNodes #(obj) expandHierarchy:true cloneType:mode newNodes:&new_nodes actualNodeList:&actual_node_list
		--maxOps.CloneNodes #(obj) expandHierarchy:true cloneType:mode newNodes:&new_nodes

		#( actual_node_list, new_nodes ) --return
	),

	/** Move nodes to layers
	 */
	function _moveNodeToLayer obj layer_type =
	(
		-- format "\n---------------------------------------------\n"
		-- format "\n"; print "SceneLayers_v._moveNodeToLayer()"
		
		/** Get layers tree
		 */
		layer = this._createTargetLayersHierarchy(obj) (layer_type)
		-- format "layer: %\n" layer

		layer.addNodes obj

		if obj.children.count > 0 then
			for child in this.getAllChildren obj do 
				this._moveNodeToLayer child layer_type
	),

	/** Get group members of closed group
	 */
	function getAllChildren groups =
	(
		if classOf groups != Array  then
			groups = #(groups)

		group_members = #()

		this._getAllChildren groups &group_members

		group_members --return

    ),

    mapped function _getAllChildren _node &group_members = ( join group_members _node.children;	if _node.children.count > 0 then this._getAllChildren _node.children &group_members ),

	/** Rename object by type
	 *
	 * return string E.G.: ""
	 */
	function _renameObjBySuffix obj layer_type =
	(
		--format "\n"; print "SceneLayers_v._renameObjBySuffix()"
		basename = this._removeTypeSuffix obj.name

		obj.name = basename + this._getSuffixByLayerType layer_type
	),
	
	/** Get suffix by layer type
	 */
	function _getSuffixByLayerType layer_type =
	(
		--format "\n"; print "TO._getSuffixByLayerType()"
		(delimeter + toLower(layer_type as string ) ) --return
	),
	
	/** Rename object by type
	 *
	 * return string E.G.: ""
	 */
	function _getNameByLayerSuffix obj layer_type force: =
	(
		 -- format "\n"; print "SceneLayers_v._getNameByLayerSuffix()"
		 -- format "layer_type: %\n" layer_type
		basename = this._removeTypeSuffix obj.name

		basename + this._getSuffixByLayerType layer_type --return
	),

	/** Create target layers hierarchy
	  *
	  * Return deepest layer in hierarchy
	 */
	function _createTargetLayersHierarchy obj layer_type  =
	(
		-- format "\n"; print "SceneLayers_v.createTargetLayersHierarchy()"
		fn getLayersTree layer = for i = (layers_tree = LayersManager.getLayersTree layer).count to 1 by -1 collect layers_tree[i]

		new_layers = #()

		--layers_source = for layer in getLayersTree (obj.layer) collect layer
		layer_names_source = for layer in getLayersTree (obj.layer) collect layer.name
		-- format "layer_names_source: %\n" layer_names_source

		top_layer_source = LayerManager.getLayerFromName (layer_names_source[1])
		-- format "TOP_LAYER_SOURCE: %\n" top_layer_source

		deleteItem layer_names_source 1 -- remove  top layer

		top_layer_target = this._getOrCreateTopLayer (layer_type)
		-- format "TOP_LAYER_TARGET: %\n" top_layer_target
		--format "top_layer_source == top_layer_target: %\n" (top_layer_source == top_layer_target)
        if top_layer_source == top_layer_target then
			  (format "Target layer is same as source LAYER TYPE:% LAYER: %\n" layer_type top_layer_source.name)


		if layer_names_source.count > 0 then
		(
			/* GET TARGET HIERARCHY OF LAYER NAMES */
			layer_names_target = this._getTargetLayerNames(layer_names_source) (layer_type)

			/* CREATE TARGET HIERARCHY OF LAYERS */
			new_layers = LayersManager.createLayersTree(layer_names_target) parent_layer:top_layer_target

			new_layers[new_layers.count] --return
		)
		else -- if object is in default layer
			top_layer_target --return
	),

	--/** Get layers tree
	-- */
	--function getLayersTree layer =
	--(
	--	--format "\n"; print "SceneLayers_v._getLayersTree()"
	--	for i = (layers_tree = LayersManager.getLayersTree layer).count to 1 by -1 collect layers_tree[i]
	--),

	/** Find top layer
	 */
	function getTopLayers =
	(
		format "\n"; print "SceneLayers_v.findTopLayer()"
		all_top_layers = LayersManager.getTopLayers #ALL
		--format "all_top_layers: %\n" all_top_layers

		top_layers_titles = this._getTopLayerTitles flat:true
		
		for layer in all_top_layers where findItem top_layers_titles layer.name  > 0 collect layer
	),

	/**
	 */
	function getTopLayerSuffix layer =
	(
		-- format "\n"; print "SceneLayers_v.getTopLayerSuffix()"
		-- format "layer: %\n" layer
		top_layer = LayersManager.getTopLayer(layer)
		-- format "top_layer: %\n" top_layer
		layer_name = top_layer.name
		-- format "layer_name: %\n" layer_name
		
		
		-- format "type_suffix_pattern: %\n" this.type_suffix_pattern
		matches = this.RegEx.matches layer_name ("[^A-Z]*("+this.type_suffix_pattern+")[^A-Z]*") this.IgnoreCase
		--format "matches: %\n" matches.item[1].groups
		result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		-- format "result: %\n" result

		if result.count > 0 then
			result[1][2] --return
	),
	
	/** Get top layer title
	 */
	function getTopLayerTitle layer_type =
	(
		format "\n"; print "SceneLayers_v.getTopLayerTitle()"
		top_layers_titles = this._getTopLayerTitles flat:true
		format "top_layers_titles: %\n" top_layers_titles

		top_layers_title = for top_layers_title in top_layers_titles where matchPattern top_layers_title pattern:("*"+ layer_type as string +"*") collect top_layers_title

		top_layers_title[1] --return
	),
	
	/** Join array to string
	 */
	function _arrayToString arr delimeter = ( local _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count)),

	/** Get or create top layer
	 */
	function _getOrCreateTopLayer layer_type =
	(
		--format "\n"; print "SceneLayers_v._getOrCreateTopLayer()"
		if ( top_layer = LayersManager.findLayer (layer_type) search_only_top_layers:true ) == undefined then
			top_layer = LayersManager.newLayer ((this._getTopLayerTitles())[layer_type])

		top_layer --return
	),

	/** get title string of top layer
	  *		Name is prefixed with whitespace to keep logical order by alpabet
	  *
	  * @return string E.G.:  "       —————— SOURCE ——————————————————"
	 */
	function _getTopLayerTitles flat:false =
	(
		--format "\n"; print "SceneLayers_v.create()"
		top_layer_titles = Dictionary()

		used_layers = top_layer_names + top_layer_names_ext

		--longest_title = amax (for layer_name in used_layers collect (layer_name as string ).count)

		used_layers_reverse = for i = used_layers.count to 1 by -1 collect used_layers[i]

		for i = used_layers.count to 1 by -1 do
		(
			layer_name = used_layers[i] as string

			whitespace = ""

			for x = 1 to findItem used_layers_reverse (layer_name as name ) do -- too width 200px
				whitespace += " "

 			top_layer_titles[ used_layers[i]] =  " " + whitespace + dash_line + " "+ toUpper layer_name + " " + dash_line
		)


		if flat then
			top_layer_titles = for data in top_layer_titles collect data.value

		top_layer_titles --return

	),
	
	/** Get source layer names
	 */
	function _getTargetLayerNames layer_names type_suffix =
	(
		--format "\n"; print "SceneLayers_v.getSourceLayerNames()"
		--format "type_suffix: %\n" type_suffix
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+this.type_suffix_pattern+")$") this.IgnoreCase )

		for layer_name in layer_names collect
		(
			layer_name = this._removeTypeSuffix (layer_name)

			if type_suffix != #FINAL then
				layer_name += (delimeter + toLower(type_suffix as string ) )

			layer_name --return
		)
	),


	/** Replace
	 */
	function _regExReplace _string _search _replace =
	(
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" _search this.IgnoreCase )

		RegExR.Replace _string _replace
	),

	/** Remove layer type suffix
	 */
	function _removeTypeSuffix source_name =
	(
		--format "\n"; print "SceneLayers_v._removeTypeSuffix()"
		search_string = this.type_suffix_pattern

		--RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+search_string+")$") this.IgnoreCase )
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+search_string+"[\d]*)$") this.IgnoreCase )

		RegExR.Replace source_name ""
	),

	/** Rmove layer type suffix
	 */
	function _removeNumberSuffix _string =
	(
		--format "\n"; print "SceneLayers_v._removeNumberSuffix()"
		--RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+search_string+")$") this.IgnoreCase )
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("\d+$") this.IgnoreCase )

		RegExR.Replace _string ""
	),

	/** Remove children from objects if array contains both, parents and its children
	  *
	  * @return Array
	 */
	function _getSourceObjects _objects =
	(
		 -- format "\n"; print "SceneLayers_v._getSourceObjects()"
		 -- format "_objects: %\n" _objects
		if classOf _objects != Array then
			_objects = if classOf _objects == PathName then _objects = _objects as Array else #(_objects)

		/* REMOVE CHILDREN FROM SELECTION - avoid mutliple duplicates when function maxOps.CloneNodes() whith expandHierarchy:TRUE is used */
		if mode != #MOVE then
		(
			/* GET OBJECTS WITH CHILDREN */
			parents = for obj in _objects where obj.children.count > 0 collect obj

			children = this.getAllChildren (parents)

			/* REMOVE CHILDREN FROM OBJECTS */
			for child in children where (index = findItem _objects child ) > 0 do
				deleteItem _objects index
		)

		 -- format "_OBJECTS: %\n" _objects
		_objects --return
	),

	--/** Get group members of closed group
	-- */
	--function getAllChildren groups =
	--(
	--	if classOf groups != Array  then
	--		groups = #(groups)
	--
	--	mapped function _getAllChildren node &group_members = (if isValidNode node and isKindOf group_members Array do join group_members node.children)
	--
	--	group_members = #()
	--
	--	_getAllChildren groups &group_members
	--
	--	group_members --return
	--),
	/**
	*
	*/
	function _deleteEmptyLayers =
	(
		local counter = 0

		for id = LayerManager.count - 1 to 1 by -1 do
		(
			local layer = LayerManager.getLayer id

			local contains_nodes = LayerManager.doesLayerHierarchyContainNodes layer.name

			if not contains_nodes then
			(
				local deleted = LayerManager.deleteLayerByName layer.name

				if deleted then counter += 1
			)
		)

		return counter
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "SceneLayers.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		type_suffix_pattern = this._arrayToString( top_layer_names + top_layer_names_ext ) "|"
	)

)
