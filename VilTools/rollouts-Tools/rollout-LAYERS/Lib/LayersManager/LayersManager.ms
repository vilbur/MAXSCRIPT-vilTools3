/** Layers manager
 */
struct LayersManager_v
(
	/* construct */


	/* properties */


	/* dependency */
	/* reference */
	/* inhered */

	/** Show only layers of selected objects
	  *
	  * @return array #(<MixinInterface:LayerProperties>)
	 */
	function isolateLayers _objects =
	(
		layers_of_objects = #()

		if _objects.count > 0 then
		(
			all_layers       = for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i

			layers_of_objects = makeUniqueArray (for obj in _objects collect obj.layer)

			for _layer in all_layers do
				_layer.on = (findItem layers_of_objects _layer > 0)

			active_layer = for layer_of_selected_object in layers_of_objects where layer_of_selected_object.current collect layer_of_selected_object

			if active_layer.count == 0 then
				_objects[1].layer .current  = true
		)

		layers_of_objects --return
	),

	/** Get objects in layers
	 */
	function getObjectsInLayers layers =
	(
		--format "\n"; print "LayersManager_v.getObjectsInLayers()"
		--format "layers	= % \n" layers
		layers_nodes = #()

		for layer in layers do
		(

			layer.nodes &layer_nodes

			layers_nodes += layer_nodes
		)

		layers_nodes --return
	),

	/** Unhide layer
	 */
	function unhideLayer layer_name =
	(
		--format "\n"; print "LayersManager_v.unhideLayer()"
		if ( layer = LayerManager.getLayerFromName layer_name ) != undefined then
		(
			layer.on = true

			for obj in this.getObjectsInLayers #(layer) do
				obj.isHidden = false

		)


	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "LayersManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
