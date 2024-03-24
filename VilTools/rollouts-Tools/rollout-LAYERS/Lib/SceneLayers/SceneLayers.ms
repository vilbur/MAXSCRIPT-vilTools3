
/** Scene layers
 */
struct SceneLayers_v
(
	/* construct */

	/* properties */
	top_layer_names	= #( #SOURCE, #EDIT, #FINAL ),
	top_layer_names_ext	= #( #HELP, #PRINT, #REFERENCE ),

	prefix = "——————",
	delimeter = "-",

	--suffix_pattern = this._arrayToString( top_layer_names + top_layer_names_ext ) "|",
	suffix_pattern,

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
	function moveToLayer objs layer_type: mode:#MOVE =
	(
		--format "\n"; print "SceneLayers_v.moveToLayer()"
		layer_type = layer_type as name

		new_layers = #()
		top_layer  = this._getOrCreateTopLayer(layer_type)
		top_layers = this.getTopLayers()

		objs = this._getObejctsArray (objs)

		for obj in objs do
		(
			layers_tree =  this._getLayersTree (obj.layer)
			--format "top_layers: %\n" top_layers
			--format "layers_tree[1].name: %\n" layers_tree[1].name
			/* REMOVE TOP LAYER FROM OLD TREE */
			--if layers_tree[1].name == "0" or findItem top_layers layers_tree[1] > 0 then
				deleteItem layers_tree 1

			layer_names_source = for layer in layers_tree collect layer.name
			--format "LAYER_NAMES_SOURCE: %\n" layer_names_source
			if layer_names_source.count > 0 then
			(
				layer_key = this.getTopLayerKey top_layer.name
				--format "LAYER_KEY: %\n" layer_key

				layer_names_target = this._getSourceLayerNames(layer_names_source) ( toLower (layer_type as string ))

				/* DEV */
				--for layer_name_target in layer_names_target do
					--format "layer_name_target: %\n" layer_name_target

				new_layers = LayersManager.createLayersTree(layer_names_target) parent_layer:top_layer

				layer = new_layers[new_layers.count]
			)
			else
				/* IF OBJECT IS IN "Default" Layer */
				new_layers[1]  = layer = top_layer

			this._moveOrCopyObjToLayer layer_type #(obj) layer mode

		)

		 this._deleteEmptyLayers()

		if layer_type == #FINAL then
		--	for i = new_layers.count to 1 by -1 do
		--		new_layers[i].setName ( substituteString new_layers[i].name "-final" "")
		--
		--	--for new_layer in new_layers do
			for new_layer in new_layers where matchPattern new_layer.name pattern:("*-final") do
				new_layer.setName ( substituteString new_layer.name "-final" "")
	),

	/** Create layer by object
	 */
	function moveToLayerByObject objs =
	(
		--format "\n"; print "SceneLayers_v.moveToLayerByObject()"

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

		objs = this._getObejctsArray objs

		for obj in objs do
		(
			local obj_layer

			obj_name_stripped = this._removeLayerTypeSuffix obj.name

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

	/** Set visibility
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


	/** Move or py obj to layer
	 */
	function _moveOrCopyObjToLayer layer_type objs layer mode =
	(
		format "\n"; print "SceneLayers_v._moveOrCopyObjToLayer()"

		local new_nodes

		nodes_to_add = objs

		if mode != #MOVE then
		(
			maxOps.CloneNodes objs expandHierarchy:false cloneType:mode newNodes:&new_nodes

			for i = 1 to new_nodes.count do
				new_nodes[i].name = objs[i].name

			nodes_to_add = new_nodes
		)

		--nodes_to_add = if new_nodes != undefined then new_nodes else objs

		layer.addNodes nodes_to_add

		if mode != #MOVE then
			for obj_new in nodes_to_add do
			(
				format "obj_new: %\n" obj_new
				obj_name_new = this._removeLayerTypeSuffix obj_new.name

				if layer_type != #FINAL then
					obj_name_new += delimeter + toLower (layer_type as string )

				--if obj_name_new == obj_new.name then 


				obj_new.name = obj_name_new
			)


		nodes_to_add --return
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
		matches = this.RegEx.matches layer_name ("[^A-Z]*("+this.suffix_pattern+")[^A-Z]*") this.IgnoreCase
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

	/**
	 */
	function _getTopLayerTitles flat:false =
	(
		--format "\n"; print "SceneLayers_v.create()"
		top_layer_titles = Dictionary()

		used_layers = top_layer_names + top_layer_names_ext

		longes_title = amax (for layer_name in used_layers collect (layer_name as string ).count)

		used_layers_reverse = for i = used_layers.count to 1 by -1 collect used_layers[i]

		for i = used_layers.count to 1 by -1 do
		(
			layer_name = used_layers[i] as string

			suffix = ""

			for x = 1 to findItem used_layers_reverse (layer_name as name ) do -- too width 200px
				suffix += " "

			top_layer_titles[ used_layers[i]] =  " " + suffix + prefix + " "+ toUpper layer_name + " " + prefix+ prefix+ prefix
		)


		if flat then
			top_layer_titles = for data in top_layer_titles collect data.value

		top_layer_titles --return

	),

	/** Get source layer names
	 */
	function _getSourceLayerNames layer_names _replace =
	(
		--format "\n"; print "SceneLayers_v.getSourceLayerNames()"
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+this.suffix_pattern+")$") this.IgnoreCase )

		for layer_name in layer_names collect
			 (this._removeLayerTypeSuffix layer_name) + (delimeter + _replace )
	),

	/** Reg ex replace
	 */
	function _regExReplace _string _search _replace =
	(
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" _search this.IgnoreCase )

		RegExR.Replace _string _replace
	),

	/** Rmove layer type suffix
	 */
	function _removeLayerTypeSuffix _string =
	(
		--format "\n"; print "SceneLayers_v._removeLayerTypeSuffix()"
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+this.suffix_pattern+")$") this.IgnoreCase )

		RegExR.Replace _string ""
	),

	/** Get obejcts array
	 */
	function _getObejctsArray objs =
	(
		--format "\n"; print "SceneLayers_v._getObejctsArray()"
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
		suffix_pattern = this._arrayToString( top_layer_names + top_layer_names_ext ) "|"

	)

)
