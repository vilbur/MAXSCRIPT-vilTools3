
/** Scene layers
 */
struct SceneLayers_v
(
	/* construct */


	/* properties */
	top_layer_names	= #( #SOURCE, #EDIT, #FINAL ),
	top_layer_names_ext	= #( #HELP, #SUPPORTS, #REFERENCE ),

	prefix = "——————",
	diameter = "-",

	--suffix_pattern = this.arrayToString( top_layer_names + top_layer_names_ext ) "|",
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

	/**
	 */
	function _getTopLayerTitles =
	(
		format "\n"; print "SceneLayers_v.create()"

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

		top_layer_titles --return

	),


	/** Move to layer
	 */
	function moveToLayer obj name_key =
	(
		format "\n"; print "SceneLayers_v.moveToLayer()"

		name_key = name_key as name

		top_layer = this._getOrCreateTopLayer(name_key)

		layers_tree =  this._getLayersTree (obj.layer)

		last_layer = copy top_layer

		layer_names_source = for layer in layers_tree collect layer.name

		--for layer_name_source in layer_names_source do
			--format "layer_name_source: %\n" layer_name_source

		if layer_names_source[1] != "0" then
		(
			layer_key = this.getTopLayerKey top_layer.name
			--format "LAYER_KEY: %\n" layer_key

			layer_names_target = this._getSourceLayerNames(layer_names_source) ( toLower (name_key as string ))

			/* DEV */
			--for layer_name_target in layer_names_target do
				--format "layer_name_target: %\n" layer_name_target

			new_layers = LayersManager.createLayersTree(layer_names_target) parent_layer:top_layer

			new_layers[new_layers.count].addNode obj
		)
		else
			/* IF OBJECT IS IN "Default" Layer */
			top_layer.addNode obj

			macros.run "Scene Explorer" "SERemoveEmptyLayers"

	),

	/** Get layers tree
	 */
	function _getLayersTree layer =
	(
		--format "\n"; print "SceneLayers_v._getLayersTree()"
		for i = (layers_tree = LayersManager.getLayersTree layer).count to 1 by -1 collect layers_tree[i]


	),

	/** Create layer by object
	 */
	function moveToLayerByObject obj =
	(
		format "\n"; print "SceneLayers_v.moveToLayerByObject()"

		/** Get layer key suffix
		 */
		function getLayerKeySuffix obj =
		(
			format "\n"; print "SceneLayers_v.getLayerKeySuffix()"

			if ( layers_top = LayersManager.getTopLayers obj.layer ) != undefined and (layer_key = this.getTopLayerKey layers_top[1].name) != undefined  then
				diameter + ( toLower layer_key)
			else
				""
		)

		local obj_layer

		obj_name_stripped = this._regExReplace obj.name "[_-]*\d+$" ""

		if not matchPattern obj.layer.name pattern:( obj_name_stripped + "*") then
		(
			obj_layer = LayersManager.newLayer (obj_name_stripped + getLayerKeySuffix(obj) ) parent:obj.layer

			obj_layer.addNode obj
		)

		obj.layer --return
	),


	/** Find top layer
	 */
	function findTopLayer pattern =
	(
		--format "\n"; print "SceneLayers_v.findTopLayer()"
		--
		--top_layers = LayersManager.findLayer (pattern) search_only_top_layers:true
		----format "top_layers: %\n" top_layers
		--
		----found_layers = for layer in top_layers where matchPattern layer.name pattern:("*"+pattern+"*") collect layer
		--
		--found_layers[1] --return
	),

	/**
	 */
	function getTopLayerKey layer_name =
	(
		format "\n"; print "SceneLayers_v.getTopLayerKey()"
		format "\n"
		--RegEx.matches _string pattern ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		matches = this.RegEx.matches layer_name ("[^A-Z]*("+this.suffix_pattern+")[^A-Z]*") this.IgnoreCase
		--format "matches: %\n" matches.item[1].groups
		result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return


		if result.count > 0 then
			result[1][2] --return
	),

	/** Join array to string
	 */
	function arrayToString arr delimeter = ( local _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count)),

	private

	/** Get or create top layer
	 */
	function _getOrCreateTopLayer name_key =
	(
		--format "\n"; print "SceneLayers_v._getOrCreateTopLayer()"
		if ( top_layer = LayersManager.findLayer (name_key) search_only_top_layers:true ) == undefined then
			top_layer = LayersManager.newLayer ((this._getTopLayerTitles())[name_key])

		top_layer --return
	),

	/** Create top layer
	 */
	function _createTopLayer =
	(
		--format "\n"; print "SceneLayers_v._createTopLayer()"


	),

	/** Get source layer names
	 */
	function _getSourceLayerNames layer_names _replace =
	(
		--format "\n"; print "SceneLayers_v.getSourceLayerNames()"
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" ("[-_]*("+this.suffix_pattern+")$") this.IgnoreCase )

		for layer_name in layer_names collect
			 (RegExR.Replace layer_name "" ) + (diameter + _replace )
	),

	/** Reg ex replace
	 */
	function _regExReplace _string _search _replace =
	(
		RegExR = ( dotNetObject "System.Text.RegularExpressions.Regex" _search this.IgnoreCase )

		RegExR.Replace _string _replace
	),




	/**
	 */
	on create do
	(
		--format "\n"; print "SceneLayers.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		suffix_pattern = this.arrayToString( top_layer_names + top_layer_names_ext ) "|"

	)

)
