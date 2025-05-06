/** Wrapper for remote layers manager UI
  *
  * MixinInterface:LayerProperties https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-78B79975-7BA5-4A03-8FEF-27E78D14B575
 */
struct LayersManager_v
(
	/* construct */


	/* properties */
	SceneExplorerInstance,

	/* dependency */
	/* reference */
	/* inhered */

	/*------------------------------------------------------------------------------
		GET LAYERS
	--------------------------------------------------------------------------------*/
	/** Get current
	  *
	  */
	function getCurrent =
	(
		for layer in this.getAllLayers() where layer.current do return layer
	),

	/** Get layers
	  *
	  * @param integer|string|<MixinInterface:LayerProperties>|ReferenceTarget:BaseLayer|Array layers index, name, properties, refaTarget or array of them
	  *
	  * @return array of <MixinInterface:LayerProperties>
	  */
	function getLayers layers =
	(
		if classOf layers != Array then layers = #(layers)

		for layer in layers where (layer = this._getLayer(layer)) != undefined collect layer
	),

	/** Get layer by property
	  *
	  */
	function getLayersByProp prop val layers: =
	(
		--format "\n"; print "LayersManager_v.getLayersByProp()"
		layers = if layers != unsupplied then this.getLayers(layers) else this.getAllLayers()

		for layer in layers where ( prop_val = getProperty layer prop ) == val collect layer
	),

	/** Get selected layers
	  *  1) By slection in layer manager
	  *  2) By current objects selection if nothing is selected in layer manager
	  *  3) Get current layer if nothing is selected
	  *
	 */
	function getSelectedOrCurrent =
	(
		format "\n"; print "LayersManager_v.getSelectedOrCurrent()"
		--if LayerManager.isDialogOpen() and (selected_layers = this.getSelectedLayers()).count == 0 then
		if  (selected_layers = this.getSelectedLayers()).count == 0 then
			selected_layers = #(this.getCurrent())

		selected_layers --return
	),
	
	/** Get selected layers
	  *  1) By slection in layer manager
	  *  2) By current objects selection if nothing is selected in layer manager
	  *
	  * Return array of layers
	 */
	function getSelectedLayers =
	(
		format "\n"; print "LayersManager_v.getSelectedLayers()"
		if  (selected_layers = this.getSelectedByManager()).count == 0 then
			selected_layers = this.getLayersByObjects( selection as Array )
		--format "SELECTED_LAYERS: %\n" selected_layers
		selected_layers --return
	),

	/** Get selected layers from Layers manager
	 */
	function getSelectedByManager =
	(
		format "\n"; print "LayersManager_v.getSelectedByManager()"
		selected_layers = #()
		
		if LayerManager.isDialogOpen() and SceneExplorerInstance != undefined then
			for layer in SceneExplorerInstance.SelectedItems() where superClassOf layer == Base_Layer collect this._getLayer(layer) --return
			
		--format "SELECTED IN MANAGER: %\n" selected_layers
		selected_layers --return
	),

	/** Get layers by object selection
	  *
	  */
	function getLayersByObjects _objects =
	(
		format "\n"; print "LayersManager_v.getLayersByObjects()"
		--format "_objects: %\n" _objects
		layers_by_obj	= #()

		for obj in _objects do
			appendIfUnique layers_by_obj obj.layer
		--format "LAYERS_BY_OBJ: %\n" layers_by_obj
		layers_by_obj --return
	),

	/** Get layer by name
	  * @param string|#(string) patterns for matchPattern
	  */
	function getLayerByName patterns =
	(
		--format "\n"; print "LayersManager_v.getLayerByName()"
		if classOf patterns != Array then patterns = #(patterns)

		layers = #()
		layers_all = this.getAllLayers()

		for pattern in patterns do

			layers = join layers ( for layer in layers_all where matchPattern layer.name pattern:pattern collect layer )

		layers --return
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
		--format "\n"; print "LayersManager_v.getTopLayers()"

		layers = 	if layers == #ALL then this.getAllLayers() else this.getLayers(layers)

		for layer in this.getLayersTree(layers) where layer.getParent() == undefined collect layer
	),

	/** Find top layer
	 */
	function findLayer pattern search_only_top_layers:false =
	(
		--format "\n"; print "SceneLayers_v.findLayer()"

		all_layers = this.getAllLayers()

		search_layers  = if search_only_top_layers then this.getTopLayers (all_layers) else all_layers

		--top_layers = LayersManager.getTopLayers (pattern)
		--format "all_layers: %\n" all_layers

		found_layers = for layer in search_layers where matchPattern layer.name pattern:("*"+pattern+"*") collect layer
		--format "found_layers: %\n" found_layers
		if found_layers.count > 0 then
			found_layers[1] --return
	),


	/** Get children layers of given layers
	  */
	function getChildren layers =
	(
		--format "\n"; print "LayersManager_v.getChildren()"
		layers	= this.getLayers(layers)

		children = #()

		if layers.count > 0 then
			for layer in layers do
				children = join children ( for i = 1 to layer.getNumChildren() collect layer.getChild i )

		children --return
	),

	/** Get All children of given layers
	  */
	function getNestedLayers layers =
	(
		--format "\n"; print "LayersManager_v.getNestedLayers()"
		layers	= this.getLayers(layers)

		children = #()

		if (children_layers = this.getChildren(layers)).count > 0 then
		(
			--format "\n-----------\nARRAY:children_layers:%\n" children_layers; for layer in children_layers do format "layer:	%\n" layer.name
			children = join children children_layers

			nested_layers = this.getNestedLayers(children_layers)

			children = join children nested_layers
		)

		children --return
	),

	/** Get parent layers in hierarchy up to top layer
	  *

		TODO: RENAME THIS METHOD to getLayersInChain()

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

	/** Get layers index
	  *
	  */
	function getLayersIndex layers =
	(
		--format "\n"; print "LayersManager_v.getLayersIndex()"
		layers = this.getLayers(layers)

		for layer in layers collect this.getLayerIndex(layer)
	),

	/** Get layer index
	  *
	  */
	function getLayerIndex layer =
	(
		--format "\n"; print "LayersManager_v._getLayerIndex()"
		for i = 0 to LayerManager.count - 1 where LayerManager.getLayer i == layer do return i
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

		--format "LayerManager.isDialogOpen():	% \n" (LayerManager.isDialogOpen())

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

	/** Create layers tree
	  *
	  * @param #(string) layer_names hierrachy of layer names in order Parent > Child E.G.: #("Layer Title Top", "Layer Title child" )
	 */
	function createLayersTree layer_names parent_layer:undefined =
	(
		--format "\n"; print "LayersManager_v.createLayersTree()"

		layers = #()

		for i = 1 to layer_names.count do
		(
			layers_by_name = this.getLayerByName(layer_names[i])

			layer = if layers_by_name.count == 0 then
						this.newLayer layer_names[i] parent:parent_layer
					else
						layers_by_name[1]

			append layers layer

			parent_layer = layer
		)

		layers --return
	),

	/** Set current first layer of layers, if not current in layers array
	  *
	  * @pram <mixin> layers
	 */
	function setCurrent layers =
	(
		--format "\n"; print "LayersManager_v.setCurrent()"
		layers = this.getLayers(layers)

		if layers.count > 0 then
		(
			current_layers = for layer in layers where layer.current == true collect layer

			if (for layer in layers where layer.current == true collect layer).count == 0 then
				layers[1].current  = true

		)
		else if this.isCurrentHidden() then
		(
			/* GET ONLY VISIBLE LAYERS FROM SELECTED LAYERS */
			selected_layers = this.getLayersByProp #isHidden false layers:(this.getSelectedLayers())

			/* IF NOT CURRET IN SELECTED ALREADY */
			if (this.getLayersByProp #current true layers:selected_layers).count == 0 and selected_layers.count > 0 then
				this.setCurrent (selected_layers)

			else
				this.setCurrent (this.getLayersByProp #isHidden false layers:(this.getAllLayers())) -- select any of visible layers
		)

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

	/** Select Layers
	  * @param string|<MixinInterface:LayerProperties>|array layers
	  */
	function selectLayers layers =
	(
		format "\n"; print "LayersManager_v.selectLayers()"

		layers = this.getLayers(layers)

		--_selection = for o in selection collect o

		this.selectLayersByObjects ( this.getObjectsInLayers(layers) )
	),

	/** Select layers by objects
	  *
	  */
	function selectLayersByObjects _objects =
	(
		format "\n"; print "LayersManager_v.selectLayersByObjects()"

		clearSelection()

		auto_expand_state = SceneExplorerInstance.AutoExpand

		SceneExplorerInstance.AutoExpand = true

		select _objects

		SceneExplorerInstance.SelectLayerOfSelection()

		SceneExplorerInstance.AutoExpand = auto_expand_state
	),

	/** Expand layers
	  *
	  * @param boolean children will expand children laayers too
	  */
	function expand layers children:false =
	(
		--format "\n"; print "LayersManager_v.expand()"
		layers = this.getLayers(layers)

		_selection = for o in selection collect o

		this.selectLayersByObjects ( this.getObjectsInLayers(layers) )

		select _selection

		--this.selectLayers (layers)
		--format "\n-----------\nARRAY:layers:%\n" layers; for layer in layers do format "layer:	%\n" layer.name

		--SceneExplorerInstance.ExpandSelected()
		--(SceneExplorerManager.GetActiveExplorer()).ExpandSelected()
		--format "SceneExplorerInstance:	% \n" SceneExplorerInstance


		--if children == false then
			--for layer in layers do this.collapse(this.getChildren(layers))
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
		--format "SceneExplorerInstance:	% \n" SceneExplorerInstance
		SceneExplorerInstance.collapseAll()
	),

	/*------------------------------------------------------------------------------
		VISIBILITY
	--------------------------------------------------------------------------------*/

	/** Is current hidden
	  *
	  */
	function isCurrentHidden =
	(
		--format "\n"; print "LayersManager_v.isCurrentHidded()"
		(for layer in this.getAllLayers() where layer.isHidden and layer.current collect layer).count > 0
	),


	/** Set visibility
	 */
	function setVisibility layers state =
	(
		--format "\n"; print "LayersManager_v.setVisibility()"
		layers = this.getLayers(layers)

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

		this._setVisibilityOthers(this.getAllLayers())(layers)(layers_in_tree) STATE:state ISOLATE:true
	),

	/** Hide unselecvted
	  *
	  */
	function hideUnselected ISOLATE:false =
	(
		--format "\n"; print "LayersManager_v.hideUnselected()"
		layers_selected = this.getSelectedOrCurrent()
		--format "layers_selected:	% \n" layers_selected
		layers_in_tree = this.getLayersTree(layers_selected)
		--format "layers_in_tree:	% \n" layers_in_tree

		top_layers =  this.getTopLayers(this.getAllLayers())

		this.setVisibility (layers_selected) (true)

		this._setVisibilityOthers (top_layers)(layers_selected)(layers_in_tree) STATE:false ISOLATE:ISOLATE
	),

	/** Set visibility others
	  *
	  */
	--function _setVisibilityOthers layers layers_in_hierarchy STATE:true =
	function _setVisibilityOthers layers not_toggle layers_in_tree STATE:true ISOLATE:false =
	(
		--format "\n"; print "LayersManager_v._setVisibilityOthers()"
		--for layer in not_toggle do format "NOT_TOGGLE:	% \n"  layer.name
		for layer in layers do
			if (findItem layers_in_tree layer) > 0 then
			(
				--format "NOT HIDE:	% \n"  layer.name
				--format "ISOLATE:	% \n" ISOLATE
				if ISOLATE then
					for obj in this.getObjectsInLayers(layer) where findItem not_toggle layer == 0 do
						obj.isHidden = not STATE


				this._setVisibilityOthers (this.getChildren(layer))(not_toggle)(layers_in_tree) STATE:STATE ISOLATE:ISOLATE
			)
			else
				layer.on = STATE
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

		--format "this.getObjectsInLayers(layers):	% \n" (this.getObjectsInLayers(layers))
		--for layer in layers where (layer = this._getLayer(layer)) != undefined do layer.select on
		--for layer in layers where layer != undefined do layer.select on

		select ( this.getObjectsInLayers(layers) )

		/* SELECT LAYER BY OBJECTS */
		SceneExplorerInstance.SelectLayerOfSelection()

		--(SceneExplorerManager.GetActiveExplorer()).SelectLayerOfSelection()
		--macros.run "Scene Explorer" "SESelectLayerOfSelection"

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
	  * @param integer|string|<MixinInterface:LayerProperties>|ReferenceTarget:BaseLayer layers index, name, properties, refaTarget
	  */
	function _getLayer layer =
	(
		--format "\n"; print "LayersManager_v._getLayer()"
		--format "layer:	% \n" layer
		case classOf layer of
			(
				string:	LayerManager.getLayerFromName	(layer)
				integer:	LayerManager.getLayer	(layer)
				MixinInterface:	layer
				Base_LayerBase_Layer:	LayerManager.getLayerFromName	(layer.name)
				default:	undefined
			)
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "LayersManager.onCreate()"

		SceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()

		--this.openLayerManager()
	)
)
