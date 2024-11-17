
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

	/** Move to layer
	  *
	  * @param name mode #MOVE|#COPY|#INSTANCE|#REFERENCE
	 */
	function moveToLayerType _objects layer_type: mode:#MOVE =
	(
		--format "\n"; print "SceneLayers_v.moveToLayer()"
		layer_type = layer_type as name


		for obj in (_objects = this._getSourceObjects (_objects)) do
		(
			if mode != #MOVE then
			(
				new_node = this._cloneNode (obj) (mode)

				setUserPropBuffer new_node ""

				this._renameObjectByTopLayer (obj)

				obj = new_node
			)

			this._moveNodeToLayer(obj)(layer_type)

			append new_nodes_all obj
		)

		 this._deleteEmptyLayers()

		 select new_nodes_all

		--if layer_type == #FINAL then
		----	for i = new_layers.count to 1 by -1 do
		----		new_layers[i].setName ( substituteString new_layers[i].name "-final" "")
		----
		----	--for new_layer in new_layers do
		--	for new_layer in new_layers where matchPattern new_layer.name pattern:("*-final") do
		--		new_layer.setName ( substituteString new_layer.name "-final" "")
	),

	/** Rename object by top layer
	 */
	function _renameObjectByTopLayer obj =
	(
		--format "\n"; print "SceneLayers_v.renameObjectByTopLayer()"
		top_layer_source = (LayersManager.getTopLayers(obj.layer))[1]

		layer_type = this.getTopLayerSuffix (top_layer_source.name)

		obj.name = this._getNameByLayerSuffix (obj) (layer_type as name )
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
			if ( layers_top = LayersManager.getTopLayers obj.layer ) != undefined and (layer_key = this.getTopLayerSuffix layers_top[1].name) != undefined  then
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

	/** Select layer type
	 */
	function selectLayerType _objects layer_type: select_more:false =
	(
		--format "\n"; print "SceneLayers_v.selectLayerType()"
		layer_type = layer_type as name

		function isLayerWithoutSuffix layer_type = findItem this.layers_without_suffix layer_type > 0

		new_selection = #()

		for obj in this._getSourceObjects (_objects) do
		(
			if isLayerWithoutSuffix(layer_type) then
				 target_obj = getNodebyName (this._removeTypeSuffix obj.name)

			if target_obj == undefined then
				 target_obj = getNodebyName (this._getNameByLayerSuffix obj (layer_type as string ))

			format "obj: %\n" obj
			format "target_obj: %\n" target_obj

			if target_obj != undefined then
				append new_selection target_obj
		)

		if new_selection.count > 0 then
			(if select_more then selectmore else select) new_selection
	),

	/*
	  *
	  * @param Boolean isolate TRUE:HIDE OTHER TOP LAYERS  FALSE: toggle visiblity
	  *
	 */
	function setVisibility isolate:false layer_type: =
	(
		format "\n"; print "SceneLayers_v.setVisibility()"
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

	/** Clone nodes and remove default number suffix of new copy
	  *
	  * Children of object are copied too
	 */
	function _cloneNode obj mode =
	(
		--format "\n"; print "SceneLayers_v._cloneNode()"

		maxOps.CloneNodes #(obj) expandHierarchy:true cloneType:mode newNodes:&new_nodes

		new_node = new_nodes[1]

		new_node.name = obj.name

		new_node --return
	),

	/** Move nodes to layers
	 */
	function _moveNodeToLayer obj layer_type =
	(
		--format "\n"; print "SceneLayers_v._moveNodeToLayer()"
		/** Get layers tree
		 */
		layer = this._createTargetLayersHierarchy(obj) (layer_type)

		this._renameObjBySuffix (obj) (layer_type)

		layer.addNodes obj
	),

	/** Rename object by type
	 *
	 * return string E.G.: ""
	 */
	function _getNameByLayerSuffix obj layer_type =
	(
		--format "\n"; print "SceneLayers_v._getNameByLayerSuffix()"
		obj_name = this._removeTypeSuffix obj.name

		if findItem layers_without_suffix layer_type == 0 then
			obj_name += (delimeter + toLower(layer_type as string ) )

		obj_name --return
	),

	/** Rename object by type
	 *
	 * return string E.G.: ""
	 */
	function _renameObjBySuffix obj layer_type =
	(
		--format "\n"; print "SceneLayers_v._getNameByLayerSuffix()"
		obj_name = this._removeTypeSuffix obj.name

		if (getNodeByName obj_name all:true).count > 1 then -- do not rename if only one (current) object of given name exists in scene
			obj_name = this. _getNameByLayerSuffix obj layer_type

		obj.name = obj_name
	),

	/** Create target layers hierarchy
	  *
	  * Return deepest layer in hierarchy
	 */
	function _createTargetLayersHierarchy obj layer_type  =
	(
		--format "\n"; print "SceneLayers_v.createTargetLayersHierarchy()"
		fn getLayersTree layer = for i = (layers_tree = LayersManager.getLayersTree layer).count to 1 by -1 collect layers_tree[i]

		new_layers = #()

		--layers_source = for layer in getLayersTree (obj.layer) collect layer
		layer_names_source = for layer in getLayersTree (obj.layer) collect layer.name

		top_layer_source = LayerManager.getLayerFromName (layer_names_source[1])
		--format "TOP_LAYER_SOURCE: %\n" top_layer_source

		deleteItem layer_names_source 1 -- remove  top layer

		top_layer_target = this._getOrCreateTopLayer (layer_type)
		--format "TOP_LAYER_TARGET: %\n" top_layer_target
		--format "top_layer_source == top_layer_target: %\n" (top_layer_source == top_layer_target)
        if top_layer_source == top_layer_target then
			format "Target layer is same as source LAYER TYPE:% LAYER: %\n" layer_type top_layer_source.name


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
		--format "\n"; print "SceneLayers_v.findTopLayer()"
		all_top_layers = LayersManager.getTopLayers #ALL

		top_layers_titles = this._getTopLayerTitles flat:true

		for layer in all_top_layers where findItem top_layers_titles layer.name  > 0 collect layer
	),

	/**
	 */
	function getTopLayerSuffix layer_name =
	(
		--format "\n"; print "SceneLayers_v.getTopLayerSuffix()"
		matches = this.RegEx.matches layer_name ("[^A-Z]*("+this.type_suffix_pattern+")[^A-Z]*") this.IgnoreCase
		--format "matches: %\n" matches.item[1].groups
		result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return

		if result.count > 0 then
			result[1][2] --return
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


	/** R replace
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
		--format "\n"; print "SceneLayers_v._getSourceObjects()"
		if classOf _objects != Array then
			_objects = if classOf _objects == PathName then _objects = _objects as Array else #(_objects)

		/* REMOVE CHILDREN FROM SELECTION - avoid mutliple duplicates when function maxOps.CloneNodes() whith expandHierarchy:TRUE is used */
		if mode != #MOVE then
		(
			/* GET OBJECTS WITH CHILDREN */
			parents = for obj in _objects where obj.children.count > 0 collect obj

			children = this._getGroupMembers (parents)

			/* REMOVE CHILDREN FROM OBJECTS */
			for child in children where (index = findItem _objects child ) > 0 do
				deleteItem _objects index
		)

		_objects --return
	),

	/** Get group members of closed group
	 */
	function _getGroupMembers groups =
	(
		if classOf groups != Array  then
			groups = #(groups)

		mapped function getAllChildren node &group_members = (if isValidNode node and isKindOf group_members Array do join group_members node.children)

		group_members = #()

		getAllChildren groups &group_members

		group_members --return
	),
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
