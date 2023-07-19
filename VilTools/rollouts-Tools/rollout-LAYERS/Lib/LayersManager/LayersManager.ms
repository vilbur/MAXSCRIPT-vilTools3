/** Wrapper for remote layers manager UI
 */
struct LayersManager_v
(
	/* construct */


	/* properties */
	ExplorerManager = SceneExplorerManager.GetActiveExplorer(),

	/* dependency */
	/* reference */
	/* inhered */


	/** Get selected layers
	 */
	function getSelectedLayers =
	(
		--format "\n"; print "LayersManager_v.getSelectedLayers()"
		 for obj in ExplorerManager.SelectedItems() where superClassOf obj == Base_Layer collect obj --return
	),

	/** Get layers by name
	 */
	function getLayers pattern =
	(
		--format "\n"; print "LayersManager_v.getSelectedLayers()"
		 --for obj in ExplorerManager.SelectedItems() where superClassOf obj == Base_Layer collect obj --return
		for layer in this.getAllLayers()where matchPattern layer.name pattern:pattern collect layer -- return

	),

	/** Set given layers visible
	  * Works with nested layers too
	  *
	  * @return array of layers
	 */
	function setVisibleTree layers =
	(
		--format "\n"; print "LayersManager_v.setVisible()"
		layers_not_in_hieararchy = #()

		layers_in_hierarchy = this.getLayersInHierarchy(layers)

		this._getLayersNotInHierarchy(this._getTopLayers())(layers_in_hierarchy)(layers_not_in_hieararchy)

		this.setVisibility (layers_in_hierarchy)     (true)
		this.setVisibility (layers_not_in_hieararchy)(false)

		layers_in_hierarchy --return
	),

	/** Set visibility
	 */
	function setVisibility layers state =
	(
		format "\n"; print "LayersManager_v.setVisibility()"
		format "state = % \n" state
		for layer in layers  do
			layer.on = state
	),

	/** Select visibily of obejcts in given layers
	  *
	 */
	function setObjectsVisibility layers state =
	(
		--format "\n"; print "LayersManager_v.setObjectsVisibility()"
		objects_in_layers = this.getObjectsInLayers (layers)

		for obj in objects_in_layers do
			obj.isHidden = not state
	),

	/** Expand layers by obejcts
	  *
	  * Achived by workaround with auto expansion
	  *
	 */
	function expandLayersByObejcts _objects =
	(
		--format "\n"; print "LayersManager_v.expandLayersByObejcts()"
		auto_expand_state = ExplorerManager.AutoExpand

		this.CollapseAll()

		ExplorerManager.AutoExpand = true

		select _objects

		 ExplorerManager.AutoExpand = auto_expand_state
	),

	/** Collapse all Layers
	 */
	function collapseAll =
	(
		--format "\n"; print "LayersManager_v.collapseAll()"
		ExplorerManager.collapseAll()
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


	/** Get layers in hierarchy
	 *
	 * @return array of parent layers
	 */
	function getLayersInHierarchy layers =
	(
		--format "\n"; print "LayersManager_v.getLayersInHierarchy()"
		layers_in_tree = deepCopy  layers

		for curent_layer in layers do
			while curent_layer.getParent() != undefined do
				appendIfUnique layers_in_tree (curent_layer = curent_layer.getParent())

		layers_in_tree --return
	),

	/** Test if any of given layers is current active, if not ativeate first
	 */
	function setCurrent layers =
	(
		--format "\n"; print "LayersManager_v.setCurrent()"
		if (for layer in layers where layer.current == true collect layer).count == 0 then
			layers[1].current  = true
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


	private


	/** Get top layers
	 */
	function _getTopLayers =
	(
		--format "\n"; print "LayersManager_v.getTopLayers()"

		for layer in this.getAllLayers() where layer.getParent() == undefined collect layer
	),

	/** Get layers which are not in hierarchy of given layers
	  * 		retun only top most layers of tree
	  *
	  * @param #(<MixinInterface:LayerProperties>)	layers	hierarchy of thes layers will not be iterated
	  * @param array	layers_in_hierarchy	hierarchy of layers of 1st parameter
	  * @param array	layers_not_in_hieararchy	returned
	  *
	  * @return array
	  *
	  *		E.G.: IF _getLayersNotInHierarchy #("SUB NESTED C1")
	  *
	  *				RETURN #("TOP LAYER A","TOP LAYER B", "SUB C2")
	  *
	  *	EXAMPLE OF LAYERS TREE:
	  *		TOP LAYER A
	  *
	  *		TOP LAYER B
	  *			SUB B1
	  *
	  *		TOP LAYER C
	  *			SUB C1
	  *				SUB NESTED C1
	  *			SUB C2
	  *				SUB NESTED C2
	  *
	 */
	function _getLayersNotInHierarchy layers layers_in_hierarchy &layers_not_in_hieararchy =
	(
		--format "\n"; print "LayersManager_v.loopHierarchy()"

		for layer in layers  do
			if findItem layers_in_hierarchy layer > 0 then
			(
				child_layers = for i = 1 to layer.getNumChildren() collect layer.getChild(i)

				for child_layer in child_layers do

				this._getLayersNotInHierarchy(child_layers)(layers_in_hierarchy)(layers_not_in_hieararchy)
			)
			else
				appendIfUnique layers_not_in_hieararchy layer
				--layer.on = false
		layers_not_in_hieararchy --return
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

			for layer in all_layers do
				layer.on = (findItem layers_of_objects layer > 0)

			active_layer = for layer_of_selected_object in layers_of_objects where layer_of_selected_object.current collect layer_of_selected_object

			if active_layer.count == 0 then
				_objects[1].layer.current  = true
		)

		layers_of_objects --return
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
