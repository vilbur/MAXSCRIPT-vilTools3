
/** Scene layers
 */
struct SceneLayers_v
(
	/* construct */


	/* properties */
	top_layer_names	= #( #SOURCE, #EDIT, #FINAL ),
	top_layer_names_ext	= #( #HELP, #SUPPORTS, #REFERENCE ),

	prefix = "——————",


	/* dependency */
	LayersManager = LayersManager_v(),


	/* reference */
	/* inhered */
	/** Create
	 */
	function createTopLayers =
	(
		format "\n"; print "SceneLayers_v.create()"

		used_layers = top_layer_names + top_layer_names_ext

		longes_title = amax (for layer_name in used_layers collect (layer_name as string ).count)

		used_layers_reverse = for i = used_layers.count to 1 by -1 collect used_layers[i]

		for i = used_layers.count to 1 by -1 do
		(
			layer_name = used_layers[i] as string

			suffix = ""

			for x = 1 to findItem used_layers_reverse (layer_name as name ) do -- too width 200px
				suffix += " "

			editLayer = LayersManager.newLayer( " " + suffix + prefix + " "+ toUpper layer_name + " " + prefix+ prefix+ prefix )
		)

	),

	/** Move to layer
	 */
	function moveToLayer obj pattern =
	(
		format "\n"; print "SceneLayers_v.moveToLayer()"

		top_layer = LayersManager.findLayer (pattern) search_only_top_layers:true

		layers_tree = LayersManager.getLayersTree obj.layer

		last_layer = copy top_layer

		--for layer in layers_tree do
		--format "layer.name: %\n" layer.name

		layer_names_source = for layer in layers_tree collect layer.name

		layer_names_target = for layer_name in layer_names_source  collect layer_name + "-"+ ( toLower pattern )

		format "layer_names_source: %\n" layer_names_source

        layer_names_target[layer_names_target.count] = top_layer.name

		--deleteItem layer_names_source 1

        for i = layer_names_target.count to 1 by -1 do
		(
			format "LAYER %: %\n" i layer_names_target[i]

			layers_by_name = LayersManager.getLayerByName(layer_names_target[i])

			layer = if layers_by_name.count == 0 then
						LayersManager.newLayer layer_names_target[i] parent:last_layer
					else
						layers_by_name[1]

			format "layer: %\n" layer


			if i == 1 then
				layer.addNode obj


			last_layer = layer
		)


	),

	/** Create layer by object
	 */
	function moveToLayerByObject obj =
	(
		format "\n"; print "SceneLayers_v.moveToLayerByObject()"

		local obj_layer

		if not matchPattern obj.layer.name pattern:( obj.name + "*") then
		(
			obj_layer = LayersManager.newLayer obj.name parent:obj.layer

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


	private


	/**
	 */
	on create do
	(
		--format "\n"; print "SceneLayers.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
