/** Wrapper for remote layers manager UI
 */
struct LayersManager_v
(
	/* construct */


	/* properties */
	SceneExplorerInstance = SceneExplorerManager.GetActiveExplorer(),

	/* dependency */
	/* reference */
	/* inhered */

	/*------------------------------------------------------------------------------
		GET LAYERS
	--------------------------------------------------------------------------------*/
	/** Get layers
	  * @param integer|string|<MixinInterface:LayerProperties>|ReferenceTarget:BaseLayer|Array layers index, name, properties, refaTarget or array of them
	  */
	function getLayers layers =
	(
		if classOf layers != Array then layers = #(layers)

		for layer in layers where (layer = this._getLayer(layer)) != undefined collect layer
	),

	/** Get selected layers
	  *  1) By slection in layer manager
	  *  2) By current objects selection if nothing is selected in layer manager
	  *
	  * Return array of layers
	 */
	function getSelectedLayers =
	(
		--format "\n"; print "LayersManager_v.getLayersByAnySelection()"
		if (selected_layers = this.getSelectedByManager()).count == 0 then
			selected_layers = this.getLayersByObjects( selection )

		selected_layers --return
	),

	/** Get selected layers
	  *  1) By slection in layer manager
	  *  2) By current objects selection if nothing is selected in layer manager
	  *  3) Get current layer if nothing is selected
	  *
	 */
	function getSelectedOrCurrent =
	(
		--format "\n"; print "LayersManager_v.getSelectLayersOrBySelection()"
		if (selected_layers = this.getSelectedLayers()).count == 0 then
			selected_layers = #(this.getCurrent())

		selected_layers --return
	),

	/** Get selected layers from Layers manager
	 */
	function getSelectedByManager =
	(
		 for layer in SceneExplorerInstance.SelectedItems() where superClassOf layer == Base_Layer collect this._getLayer(layer) --return
	),

	/** Get layers by object selection
	  *
	  */
	function getLayersByObjects _objects =
	(
		makeUniqueArray (for obj in _objects collect obj.layer) --return
	),

	/** Get all layers
	 */
	function getAllLayers =
	(
		--format "\n"; print "LayersManager_v.getAllLayers()"
		 for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i --return
	),

	/** Get top layers
	  *
	  * @return array of layers
	 */
	function getTopLayers layers =
	(
		--format "\n"; print "LayersManager_v.getAllTopLayers()"
		layers = this.getLayers(layers)

		for layer in this.getLayersTree(layers) where layer.getParent() == undefined collect layer
	),

	/** Get children of given layers
	  */
	function getChildren layers =
	(
		--format "\n"; print "LayersManager_v.getChildren()"
		layers	= this.getLayers(layers)

		children = #()

		for layer in layers do
			children = join children ( for i = 1 to layer.getNumChildren() collect layer.getChild i )

		children --return
	),

	/** Get layers in hierarchy up to top layer
	  *
	  */
	function getLayersTree layers =
	(
		--format "\n"; print "LayersManager_v.getParanetLayers()"
		layers = this.getLayers(layers)

		--layers_in_tree = for layer in layers where layer.getParent() == undefined collect layer
		layers_in_tree = deepCopy layers

		for curent_layer in layers do
			while curent_layer.getParent() != undefined do
				appendIfUnique layers_in_tree (curent_layer = curent_layer.getParent())

		layers_in_tree --return
	),


	/** Get all layers in hierarchy in path to nested layers
	 *
	 * @return array of parent layers
	 */
	function getLayersInHierarchy layers =
	(
		format "\n"; print "DEPRECATED:LayersManager_v.getLayersInHierarchy()"
		print "USE: getLayersTree()"
		this.getLayersTree (layers)
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
		layers = this.getLayers(layers)

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


	/** Get objects in layers
	 */
	function getObjectsInLayers layers =
	(
		--format "\n"; print "LayersManager_v.getObjectsInLayers()"
		layers = this.getLayers(layers)

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
	  * @param string|<MixinInterface:LayerProperties>|array layers
	  */
	function selectLayers layers =
	(
		format "\n"; print "LayersManager_v.selectLayers()"
		layers = this.getLayers(layers)

		_selection = for o in selection collect o

		this._selectLayers (layers) (_selection) --return
	),

	/** Select layers by objects
	  *
	  */
	function selectLayersByObjects _objects =
	(
		--format "\n"; print "LayersManager_v.selectLayersByObjects()"

		layers = this.getLayersByObjects(_objects)

		this._selectLayers (layers) (_objects) --return
	),

	/** Expand layers
	  *
	  * @param boolean children will expand children laayers too
	  */
	function expand layers children:false =
	(
		--format "\n"; print "LayersManager_v.expand()"
		layers = this.getLayers(layers)

		this.selectLayers (layers)

		SceneExplorerInstance.ExpandSelected()

		if children == false then
			for layer in layers do this.collapse(this.getChildren(layers))
	),

	/** Collapse slected
	  *
	  */
	function collapse layers =
	(
		--format "\n"; print "LayersManager_v.collapseSlected()"

		this.selectLayers ( this.getLayers(layers) )

		SceneExplorerInstance.CollapseSelected()
	),

	/** Collapse all Layers
	 */
	function collapseAll =
	(
		--format "\n"; print "LayersManager_v.collapseAll()"
		SceneExplorerInstance.collapseAll()
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


	/** Hide others
	  * @param array layers to keep shown
	  */
	function setVisibilityOthers layers state =
	(
		--format "\n"; print "LayersManager_v.hideOthers()"
		layers_in_tree = this.getLayersTree(layers)

		this._setVisibilityOthers(layers)(layers)(layers_in_tree) STATE:state ISOLATE:true
	),

	/** Hide unselecvted
	  *
	  */
	function hideUnselected ISOLATE:false =
	(
		format "\n"; print "LayersManager_v.isolateLayers()"

		layers_selected = this.getLayersByAnySelection()

		layers_in_tree = this.getLayersTree(layers_selected)

		this.setVisibility (layers_selected) (true)

		this._setVisibilityOthers(layers_selected)(layers_selected)(layers_in_tree) STATE:false ISOLATE:ISOLATE
	),

	/** Hide unseleted layers, layers of selected objects or current layer if nothing selected
	  *
	  */
	function _setVisibilityOthers layers not_toggle layers_in_hierarchy STATE:true ISOLATE:false =
	(
		--format "\n"; print "LayersManager_v._setVisibilityOthers()"

		for layer in layers do
		(
			/* HIDE CHILD LAYERS */
			if ISOLATE then
				for child_layer in this.getChildren(layer) where findItem layers_in_hierarchy child_layer == 0 do
					child_layer.on = STATE

			/* IF NESDTED LAYER */
			if (parent_layer = layer.getParent()) != undefined then
			(
				/* HIDE OBJECTS IN PARENT LAYER */
				if ISOLATE then
					for obj_in_parent_layer in this.getObjectsInLayers(parent_layer) where findItem not_toggle parent_layer == 0 do
						obj_in_parent_layer.isHidden = not STATE

				/* HIDE LAYERS ON SAME LEVEL */
				for layer_of_same_level in this.getChildren(parent_layer) where findItem layers_in_hierarchy layer_of_same_level == 0 do
				(
					layer_of_same_level.on = STATE

					/* REPEAT FOR PARENT LAYERS */
					this._setVisibilityOthers #(parent_layer)(not_toggle)(layers_in_hierarchy) STATE:STATE ISOLATE:ISOLATE
				)
			)
			else
				/* SET TOP LAYERS */
				for top_layer in this.getTopLayers (this.getAllLayers()) where findItem layers_in_hierarchy top_layer == 0 do
					top_layer.on = STATE
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

	/** Select layers
	  *
	  */
	function _selectLayers layers _objects =
	(
		--format "\n"; print "LayersManager_v.selectLayers()"

		clearSelection()

		--for layer in layers where (layer = this._getLayer(layer)) != undefined do layer.select on
		for layer in layers where layer != undefined do layer.select on

		/* SELECT LAYER BY OBJECTS */
		SceneExplorerInstance.SelectLayerOfSelection()

		selectmore _objects

		this.getSelectedByManager() --return

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

	/** Get layer
	  *
	  * @param string|<MixinInterface:LayerProperties> parent
	  */
	function _getLayer layer =
	(
		--format "\n"; print "LayersManager_v._getLayer()"
		case classOf layer of
			(
				integer:	LayerManager.getLayer	layer
				string:	LayerManager.getLayerFromName	layer
				MixinInterface:	layer
				Base_LayerBase_Layer:	LayerManager.getLayerFromName	layer.name
				default:	undefined
			)
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
