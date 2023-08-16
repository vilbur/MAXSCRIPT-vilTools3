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

	/*------------------------------------------------------------------------------
		GET LAYERS
	--------------------------------------------------------------------------------*/

	/** Get layers
	  *  1) By slection in layer manager
	  *  2) By current obejcts selection if nothing is selected in layer manager
	  *  3) Get current layer if nothing is selected
	  *
	  * Return array of layers
	 */
	function getLayers =
	(
		--format "\n"; print "LayersManager_v.getLayers()"
		if (selected_layers = this.getSelectLayersOrBySelection()).count == 0 then
			selected_layers = #(this.getCurrent())

		selected_layers --return
	),

	/** Get select layers
	  *  1) By slection in layer manager
	  *  2) By current obejcts selection if nothing is selected in layer manager
	 */
	function getSelectLayersOrBySelection =
	(
		--format "\n"; print "LayersManager_v.getSelectLayersOrBySelection()"
		selected_layers = this.getSelectedLayers()

		if selected_layers.count == 0 then
			selected_layers = this.getLayersByObjects( selection )

		--for layer in selected_layers do
			--format "Selected: % \n" layer.name


		selected_layers --return
	),

	/** Get selected layers
	 */
	function getSelectedLayers =
	(
		--format "\n"; print "LayersManager_v.getSelectedLayers()"
		 for obj in ExplorerManager.SelectedItems() where superClassOf obj == Base_Layer collect obj --return
	),


	/** Get layers by name
	 */
	function getLayersByName pattern =
	(
		--format "\n"; print "LayersManager_v.getSelectedLayers()"
		 --for obj in ExplorerManager.SelectedItems() where superClassOf obj == Base_Layer collect obj --return
		for layer in this.getAllLayers()where matchPattern layer.name pattern:pattern collect layer -- return
	),

	/** Get prefixes of given layers
	  * Default Layaer is excluded
	  *
	  * Test if layer name starts with:
	  * 		1) Something other then letter A-Z
	  * 		2) Split by dash|underscore|whitespace
	  *
	  * Examples:
	  *		"-layerName"	>>> "-"
	  *		"1-layerName"	>>> "1"
	  *		"Prefix_layerName"	>>> "_"
	  *		"Prefix layerName"	>>> " "
	  *
	  * @return array of prefixes
	 */
	function getLayersPrefixes layers =
	(

		function getPrefix layer_name =
		(
			--format "\n"; print "getLayersByPrefix.ms.getPrefix()"
			RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

			layer_name = trimLeft layer_name

			matches = RegEx.matches layer_name "^([^A-Za-z]+).*"

			if matches.count > 0 then
				prefix = matches.item[0].groups.item[1].value

			else if (string_split = filterString layer_name "-_ ").count > 0 then
				prefix = string_split[1]

		)

		prefixes = makeUniqueArray (for layer in layers where (prefix = getPrefix (layer.name)) != undefined collect prefix )

		if ( index = findItem prefixes "0" ) > 0 then
			deleteItem prefixes sn

		prefixes --return
	),



	/** Get all layers
	 */
	function getAllLayers =
	(
		--format "\n"; print "LayersManager_v.getAllLayers()"
		 for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i --return
	),

	/** Test if any of given layers is current active, if not ativeate first
	 */
	function getCurrent =
	(
		--format "\n"; print "LayersManager_v.setCurrent()"
		for layer in this.getAllLayers() where layer.current == true do return layer
	),

	/** Get top layers
	  *
	  * @return array of layers
	 */
	function getTopLayers layers =
	(
		--format "\n"; print "LayersManager_v.getAllTopLayers()"

		for layer in this.getLayersInHierarchy(layers) where layer.getParent() == undefined collect layer
	),

	/** Get children
	  *
	  */
	function getChildren layer =
	(
		--format "\n"; print "LayersManager_v.getChildren()"
		layer	= this._getLayer (layer)

		for i = 1 to layer.getNumChildren() collect layer.getChild i
	),

	/** Get all layers in hierarchy in path to nested layers
	 *
	 * @return array of parent layers
	 */
	function getLayersInHierarchy layers =
	(
		--format "\n"; print "LayersManager_v.getLayersInHierarchy()"
		if classOf layers != Array then layers = #(layers)

		layers_in_tree = deepCopy  layers

		for curent_layer in layers do
			while curent_layer.getParent() != undefined do
				appendIfUnique layers_in_tree (curent_layer = curent_layer.getParent())

		layers_in_tree --return
	),

	/** Get layers by objects
	 */
	function getLayersByObjects _objects =
	(
		--format "\n"; print "LayersManager_v.getLayersByObjects()"
		makeUniqueArray (for obj in _objects collect obj.layer) --return
	),

	/** Get layers not in hierarchy
	  *
	  */
	function getLayersNotInHierarchy all_top_layers layers_in_hierarchy =
	(
		format "\n"; print "DEPRECATED: LayersManager_v.getLayersNotInHierarchy()"
		--layers_not_in_hieararchy = #()
		--
		--this._getLayersNotInHierarchy(all_top_layers)(layers_in_hierarchy)(layers_not_in_hieararchy)
		--
		--layers_not_in_hieararchy --return
	),

	/** Get objects in layers
	 */
	function getObjectsInLayers layers =
	(
		--format "\n"; print "LayersManager_v.getObjectsInLayers()"
		if classOf layers != Array then layers = #(layers)

		layers_nodes = #()

		for layer in layers do
		(
			layer.nodes &layer_nodes
			--layer_nodes = refs.dependents layer

			layers_nodes += layer_nodes
		)

		layers_nodes --return
	),

	/*------------------------------------------------------------------------------
		MANAGE LAYERS
	--------------------------------------------------------------------------------*/

	/** Open layer manager
	 */
	function openLayerManager =
	(
		--format "\n"; print "LayersManager_v.openLayerManager()"
		LayerManager.editLayerByName ""
	),

	/** Create layer
	  *
	  * @param string|<MixinInterface:LayerProperties> parent
	  */
	function newLayer layer_name parent: =
	(
		--format "\n"; print "LayersManager_v.createLayer()"
		LayerManager.newLayerFromName (layer_name) -- this method does not return layer properties, Maxscript BUG ?

		new_layer = LayerManager.getLayerFromName layer_name

		if parent != unsupplied then
		(
			parent_layer	= this._getLayer (parent)

			if parent_layer != undefined then
				new_layer.setParent (parent_layer)
		)
		new_layer --return
	),

	/** Delete
	  *
	  * @param string|array|<MixinInterface:LayerProperties> layers name, layer or array of them
	  */
	function deleteLayers layers =
	(
		--format "\n"; print "LayersManager_v.delete()"
		if classOf layers != Array then layers = #(layers)

		for layer in layers do
		(
			layer_name	= if classOf layer == MixinInterface then layer.name else layer
			layer	= this._getLayer (layer)

			if layer.canDelete() then
				LayerManager.deleteLayerByName (layer_name)
		)
	),

	/** Test if any of given layers is current active, if not ativeate first
	 */
	function setCurrent layers =
	(
		--format "\n"; print "LayersManager_v.setCurrent()"
		if (for layer in layers where layer.current == true collect layer).count == 0 then
			layers[1].current  = true
	),

	/** Select Layers
	  *
	  */
	function selectLayers layers =
	(
		format "\n"; print "LayersManager_v.select()"
		for layer in layers do format "layer.name:	% \n" layer.name

		for layer in layers do layer.select on
	),


	/** Expand layers
	  *
	  */
	function expand layers =
	(
		--format "\n"; print "LayersManager_v.expand()"
		_selection = for o in selection collect o

		max_mode = GetCommandPanelTaskMode()

		auto_expand_state = ExplorerManager.AutoExpand

		max create mode

		ExplorerManager.AutoExpand = true

		first_objects_in_each_layer = for layer in layers where (layer_nodes = this.getObjectsInLayers(layer)).count > 0 collect layer_nodes[1]
		--format "first_objects_in_each_layer:	% \n" first_objects_in_each_layer
		select first_objects_in_each_layer

		/* RESTORE STATE */
		ExplorerManager.AutoExpand = auto_expand_state

		select _selection

		SetCommandPanelTaskMode(max_mode)
	),

	/** Collapse all Layers
	 */
	function collapseAll =
	(
		--format "\n"; print "LayersManager_v.collapseAll()"
		ExplorerManager.collapseAll()
	),

	/*------------------------------------------------------------------------------
		VISIBILITY
	--------------------------------------------------------------------------------*/

	/** Set given layers visible
	  * Works with nested layers too
	  *
	  * @return array of layers
	 */
	function setVisibleTree layers state =
	(
		format "\n"; print "DEPRECATED: LayersManager_v.setVisibleTree()"
		--
		--layers_in_hierarchy = this.getLayersInHierarchy(layers)
		--
		--all_top_layers = this.getTopLayers(this.getAllLayers())
		--
		--
		--this.setVisibility (layers_in_hierarchy) (state)
		--
		----layers_not_in_hieararchy = this.getLayersNotInHierarchy(all_top_layers)(layers_in_hierarchy)
		----this.setVisibility (layers_not_in_hieararchy)(false)
		--
		--layers_in_hierarchy --return
	),


	/** Set visibility
	 */
	function setVisibility layers state =
	(
		--format "\n"; print "LayersManager_v.setVisibility()"
		if classOf layers != Array then layers = #(layers)

		for layer in layers do
		(
			layer.on = state

			if state == true and (parent_layer = layer.getParent()) != undefined then
				this.setVisibility(parent_layer)(true)
		)
	),

	/** Hide unselecvted
	  *
	  */
	function hideUnselected ISOLATE:false =
	(
		format "\n"; print "LayersManager_v.isolateLayers()"

		layers_selected = this.getLayers()

		layers_in_hierarchy = this.getLayersInHierarchy(layers_selected)

		this._hideUnseleted(layers_selected)(layers_selected)(layers_in_hierarchy) ISOLATE:ISOLATE
	),


	/** Hide unseleted layers, layers of selected objects or current layer if nothing selected
	  *
	  */
	function _hideUnseleted layers dont_hide_layers layers_in_hierarchy ISOLATE:false =
	(
		--format "\n"; print "LayersManager_v._hideUnseleted()"

		for layer in layers do
		(
			layer.on = true

			/* HIDE CHILD LAYERS */
			if ISOLATE then
				for child_layer in this.getChildren(layer) where findItem layers_in_hierarchy child_layer == 0 do
					child_layer.on = false

			/* IF NESDTED LAYER */
			if (parent_layer = layer.getParent()) != undefined then
			(
				/* HIDE OBJECTS IN PARENT LAYER */
				if ISOLATE then
					for obj_in_parent_layer in this.getObjectsInLayers(parent_layer) where findItem dont_hide_layers parent_layer == 0 do
						obj_in_parent_layer.isHidden = true

				/* HIDE LAYERS ON SAME LEVEL */
				for layer_of_same_level in this.getChildren(parent_layer) where findItem layers_in_hierarchy layer_of_same_level == 0 do
				(
					layer_of_same_level.on = false

					/* REPEAT FOR PARENT LAYERS */
					this._hideUnseleted #(parent_layer)(dont_hide_layers)(layers_in_hierarchy) ISOLATE:ISOLATE
				)
			)
			else
				for top_layer in this.getTopLayers (this.getAllLayers()) where findItem layers_in_hierarchy top_layer == 0 do
					top_layer.on = false
		)
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


	--/** Expand layers by obejcts
	--  *
	--  * Achived by workaround with auto expansion
	--  *
	-- */
	--function expandLayersByObjects _objects =
	--(
	--	--format "\n"; print "LayersManager_v.expandLayersByObejcts()"
	--	auto_expand_state = ExplorerManager.AutoExpand
	--
	--	this.CollapseAll()
	--
	--	ExplorerManager.AutoExpand = true
	--
	--	select _objects
	--
	--	ExplorerManager.AutoExpand = auto_expand_state
	--),

	/** Get diferrence between 2 arrays
	  */
	function difference array_a array_b =
	(
		array_diff = #()

		for element in array_a do
			if finditem array_b element == 0 then
				append array_diff element

		return array_diff
	),

	private



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
		format "\n"; print "DEPRECATED: LayersManager_v._getLayersNotInHierarchy()"

		--for layer in layers  do
		--	if findItem layers_in_hierarchy layer > 0 then
		--	(
		--		child_layers = for i = 1 to layer.getNumChildren() collect layer.getChild(i)
		--
		--		for child_layer in child_layers do
		--			this._getLayersNotInHierarchy(child_layers)(layers_in_hierarchy)(layers_not_in_hieararchy)
		--	)
		--	else
		--		appendIfUnique layers_not_in_hieararchy layer
		--
		--layers_not_in_hieararchy --return
	),


	--/** Show only layers of selected objects
	--  *
	--  * @return array #(<MixinInterface:LayerProperties>)
	-- */
	--function isolateLayers _objects =
	--(
	--	layers_of_objects = #()
	--
	--	if _objects.count > 0 then
	--	(
	--		all_layers       = for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i
	--
	--		layers_of_objects = makeUniqueArray (for obj in _objects collect obj.layer)
	--
	--		for layer in all_layers do
	--			layer.on = (findItem layers_of_objects layer > 0)
	--
	--		active_layer = for layer_of_selected_object in layers_of_objects where layer_of_selected_object.current collect layer_of_selected_object
	--
	--		if active_layer.count == 0 then
	--			_objects[1].layer.current  = true
	--	)
	--
	--	layers_of_objects --return
	--),

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


	/** Get layer
	  *
	  * @param string|<MixinInterface:LayerProperties> parent
	  */
	function _getLayer layer =
	(
		--format "\n"; print "LayersManager_v._getLayer()"
		if classOf layer == MixinInterface then layer else LayerManager.getLayerFromName (layer as string ) --return
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "LayersManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this.openLayerManager()
	)

)
