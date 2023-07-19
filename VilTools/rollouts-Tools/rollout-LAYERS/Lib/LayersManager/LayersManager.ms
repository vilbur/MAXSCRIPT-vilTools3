/** Wrapper for remote layers manager UI
 */
struct LayersManager_v
(
	/* construct */


	/* properties */


	/* dependency */
	/* reference */
	/* inhered */


	/** Get selected layers
	 */
	function getSelectedLayers =
	(
		--format "\n"; print "LayersManager_v.getSelectedLayers()"
		 for obj in (SceneExplorerManager.GetActiveExplorer()).SelectedItems() where superClassOf obj == Base_Layer collect obj --return
	),

	/** Get layers by objects
	 */
	function getLayersByObjects _objects =
	(
		--format "\n"; print "LayersManager_v.getLayersByObjects()"
		makeUniqueArray (for obj in _objects collect obj.layer) --return
	),

	/** Get all layers
	 */
	function getAllLayers =
	(
		--format "\n"; print "LayersManager_v.getAllLayers()"
		 for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i --return
	),

	/** Visible
	 */
	function visible layers =
	(
		format "\n"; print "LayersManager_v.visible()"
		--format "layers = % \n" layers
		--format "state  = % \n" state
		--format "\n"

		layers_in_hierarchy = this.getLayersInHierarchy(layers)

		top_layers = this._getTopLayers()

		this.loopHierarchy(top_layers)(layers_in_hierarchy)

	),

	/** Loop hierarchy
	 */
	function loopHierarchy layers layers_in_hierarchy =
	(
		--format "\n"; print "LayersManager_v.loopHierarchy()"

		for _layer in layers  do
			if findItem layers_in_hierarchy _layer > 0 then
			(
				child_layers = for i = 1 to _layer.getNumChildren() collect _layer.getChild(i)

				for child_layer in child_layers do

				this.loopHierarchy(child_layers)(layers_in_hierarchy)
			)
			else
				_layer.on = false
	),


	/** Get layers in hierarchy
	  *
	  *
	  *
	 */
	function getLayersInHierarchy layers =
	(
		--format "\n"; print "LayersManager_v.getLayersInHierarchy()"
		layers_in_tree = layers

		for curent_layer in layers do
			while curent_layer.getParent() != undefined do
				appendIfUnique layers_in_tree (curent_layer = curent_layer.getParent())

		layers_in_tree --return
	),


	private


	/** Get top layers
	 */
	function _getTopLayers =
	(
		--format "\n"; print "LayersManager_v.getTopLayers()"

		for _layer in this.getAllLayers() where _layer.getParent() == undefined collect _layer
	),


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
				_objects[1].layer.current  = true
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
