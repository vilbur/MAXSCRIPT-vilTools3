
/** Scene layers
 */
struct SceneLayers_v
(
	/* construct */

	/* properties */
	top_layer_names	= #( #SOURCE, #EDIT, #FINAL ),
	top_layer_names_ext	= #( #HELP, #PRINT, #REFERENCE ),

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
		format "\n"; print "SceneLayers_v.create()"
--this._getTopLayerTitles()
		for layer_name_data in (this._getTopLayerTitles()) do
			--format "layer_name_data: %\n" layer_name_data
			LayersManager.newLayer (layer_name_data.value)
	),

	/** Move to layer
	  *
	  * @param name mode #MOVE|#COPY|#INSTANCE|#REFERENCE
	 */
	function moveToLayerType objs layer_type: mode:#MOVE =
	(
		--format "\n"; print "SceneLayers_v.moveToLayer()"
		layer_type = layer_type as name

		new_layers = #()
		top_layer  = this._getOrCreateTopLayer(layer_type)
		top_layers = this.getTopLayers()

		objs = this._getObjectsArray (objs)


		for obj in objs do
		(
			layers_tree =  this._getLayersTree (obj.layer)

			/* REMOVE TOP LAYER FROM OLD TREE */
			deleteItem layers_tree 1

			layer_names_source = for layer in layers_tree collect layer.name
			--format "LAYER_NAMES_SOURCE: %\n" layer_names_source

			if layer_names_source.count > 0 then
				layer = this._createTargetLayersHierarchy (top_layer) (layer_type) (layer_names_source)
			else
				/* IF OBJECT IS IN "Default" Layer */
				layer = new_layers[1]  = top_layer


			if mode != #MOVE then
				obj = (this._cloneNodes #(obj) mode)[1]


			this._moveNodeToLayer(layer)(obj)(layer_type)

		)

		 this._deleteEmptyLayers()

		--if layer_type == #FINAL then
		----	for i = new_layers.count to 1 by -1 do
		----		new_layers[i].setName ( substituteString new_layers[i].name "-final" "")
		----
		----	--for new_layer in new_layers do
		--	for new_layer in new_layers where matchPattern new_layer.name pattern:("*-final") do
		--		new_layer.setName ( substituteString new_layer.name "-final" "")
	),

	/** Create layer by object
	 */
	function moveToLayerByObject objs =
	(
		format "\n"; print "SceneLayers_v.moveToLayerByObject()"

		/** Get layer key suffix
		 */
		function getLayerKeySuffix obj =
		(
			--format "\n"; print "SceneLayers_v.getLayerKeySuffix()"
			if ( layers_top = LayersManager.getTopLayers obj.layer ) != undefined and (layer_key = this.getTopLayerKey layers_top[1].name) != undefined  then
				delimeter + ( toLower layer_key)
			else
				""
		)

		layers = #()
		format "OBJS: %\n" objs
		objs = this._getObjectsArray objs
		format "OBJS: %\n" objs

		for obj in objs do
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

	/** Ssibility
	  *
	  *
	  * @param Boolean isolate TRUE:HIDE OTHER TOP LAYERS  FALSE: toggle visiblity
	  *
	 */
	function setVisibility isolate:false layer_type: =
	(
		format "\n"; print "SceneLayers_v.setVisibility()"

		top_layer  = this._getOrCreateTopLayer(layer_type)


		if isolate then
			for layer in top_layers = LayersManager.getTopLayers #ALL do
				layer.on = layer == top_layer

		else
			top_layer.on = not top_layer.on

		--top_layers = this.getTopLayers()
		--layers_tree =  this._getLayersTree (obj.layer)
		--
		--this.getTopLayerKey layers_tree[.].name

	),

	private

	/** Create target layers hierarchy
	  *
	  * Return deepest layer in hierarchy
	 */
	function _createTargetLayersHierarchy top_layer layer_type layer_names_source  =
	(
		--format "\n"; print "SceneLayers_v.createTargetLayersHierarchy()"
		layer_key = this.getTopLayerKey top_layer.name

		/* GET TARGET HIERARCHY OF LAYER NAMES */
		layer_names_target = this._getTargetLayerNames(layer_names_source) (layer_type)

		/* CREATE TARGET HIERARCHY OF LAYERS */
		new_layers = LayersManager.createLayersTree(layer_names_target) parent_layer:top_layer

		new_layers[new_layers.count] --return
	),


	/** Move or py obj to layer
	 */
	function _cloneNodes objs mode =
	(
		format "\n"; print "SceneLayers_v._cloneNodes()"

		local new_nodes

		maxOps.CloneNodes objs expandHierarchy:false cloneType:mode newNodes:&new_nodes

		for i = 1 to new_nodes.count do
			new_nodes[i].name = objs[i].name

		new_nodes --return
	),

	/** Move nodes to layers
	 */
	function _moveNodeToLayer layer obj type =
	(
		format "\n"; print "SceneLayers_v._moveNodeToLayer()"


		this._renameObjectBySuffix (obj) (type)

		layer.addNodes #(obj)
	),

	/** Rename object by type
	 */
	function _renameObjectBySuffix obj type_suffix =
	(
		--format "\n"; print "SceneLayers_v.renameObjectBySuffix()"
		obj.name = (this._removeTypeSuffix obj.name)

		if type_suffix != #FINAL then
			obj.name += (delimeter + toLower(type_suffix as string ) )
	),

	/** Get layers tree
	 */
	function _getLayersTree layer =
	(
		--format "\n"; print "SceneLayers_v._getLayersTree()"
		for i = (layers_tree = LayersManager.getLayersTree layer).count to 1 by -1 collect layers_tree[i]
	),

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
	function getTopLayerKey layer_name =
	(
		--format "\n"; print "SceneLayers_v.getTopLayerKey()"
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

			prefix = ""

			for x = 1 to findItem used_layers_reverse (layer_name as name ) do -- too width 200px
				prefix += " "

 			top_layer_titles[ used_layers[i]] =  " " + prefix + dash_line + " "+ toUpper layer_name + " " + dash_line + dash_line + dash_line
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

	/** Rmove layer type suffix
	 */
	function _removeTypeSuffix _string =
	(
		--format "\n"; print "SceneLayers_v._removeTypeSuffix()"
		search_string = this.type_suffix_pattern

		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+search_string+")$") this.IgnoreCase )

		RegExR.Replace _string ""
	),

	/** Get obejcts array
	 */
	function _getObjectsArray objs =
	(
		--format "\n"; print "SceneLayers_v._getObjectsArray()"
		if classOf objs != Array then
			objs = if classOf objs == PathName then objs = objs as Array else #(objs)

		objs --return
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
