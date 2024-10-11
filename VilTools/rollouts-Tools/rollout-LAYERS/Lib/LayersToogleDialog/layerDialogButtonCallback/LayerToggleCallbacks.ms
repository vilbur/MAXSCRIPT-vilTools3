/** Layer toggle callbacks
 */
struct LayerToggleCallbacks_v
(
	/* construct */
	layer_index,

	/* properties */
	layer,

	/* dependency */
	LayersManager = LayersManager_v(),

	/** Toggle display as layer
	 */
	function toggleDisplayAsLayer hierarchy:false =
	(
		--format "\n"; print ".toggleDisplayAsLayer()"

		if layer != undefined then
		(
			state = _getDisplayWirecolorState(layer)

			this._setColorPickerVisibility (child_layer) (state)

			this._setColorByLayerState (layer) (state)

			if hierarchy then
				this._setDisplayCoorStateToNestedLayers (layer) (state)

		)
	),

	/** Set display coor state to nested layers
	 */
	function _setDisplayCoorStateToNestedLayers parent_layer state =
	(
		--format "\n"; print "LayerToggleCallbacks_v._setDisplayCoorStateToNestedLayers()"

		for child_layer in LayersManager.getChildren(parent_layer) do
		(
			this._setColorPickerVisibility (child_layer) (state)

			this._setColorByLayerState (child_layer) (state)

			this._setDisplayCoorStateToNestedLayers (child_layer) (state)
		)
	),

	/** Set color picker visibility
	 */
	function _setColorPickerVisibility layer state =
	(
		--format "\n"; print "LayerToggleCallbacks_v._setColorPickerVisibility()"
		layer_index = LayersManager.getLayerIndex layer

		color_picker = this._getColorPicker layer_index

		color_picker.visible = state
	),

	/** Propagate wirecolor to children layers
	 */
	function propagateWirecolorToChildrenLayers =
	(

		format "\n"; print "LayerToggleCallbacks_v.propagateWirecolorToChildrenLayers()"
		color_picker = this._getColorPicker layer_index
		--format "layer_index: %\n" layer_index
		--format "color_picker: %\n" color_picker

		if layer != undefined then
		(
			--format "layer.wirecolor: %\n" layer.wirecolor
			format "%: %\n" layer.name layer.wirecolor

			color_picker.color = layer.wirecolor

			this._setWireColorToNestedLayer (layer) (copy layer.wirecolor)

			CompleteRedraw()
		)

	),

	/** ADD LAYER BUTTONS
	  *
	  */
	function _setWireColorToNestedLayer parent_layer wirecolor level:1 =
	(
		format "\n"; print "LayersToogleDialog_v._setWireColorToNestedLayer()"
		format "parent_layer.name: %\n" parent_layer.name
		format "wirecolor:	% \n" wirecolor
		format "level: %\n" level

		/*------------------------------------------------------------------------------
			BUTTON FOR EACH LAYER
		--------------------------------------------------------------------------------*/
		wirecolor.hue += 15

		for child_layer in LayersManager.getChildren(parent_layer) do
		(

			saturation = wirecolor.saturation
			brightness = wirecolor.value

			wirecolor.saturation	= (if saturation > 164 then saturation - 15 else saturation + 15 ) -- saturation
			wirecolor.value	= (if brightness > 164 then brightness - 15 else brightness + 15 ) -- brightness

			child_layer_index = LayersManager.getLayerIndex child_layer

			color_picker = this._getColorPicker (child_layer_index)

			child_layer.wirecolor = wirecolor
			--child_layer.wirecolor = orange

			color_picker.color    = wirecolor
			--color_picker.enabled = layer.wirecolor

			--format "%: % hue: % brightness: % saturation: %\n" child_layer.name wirecolor wirecolor.hue wirecolor.value wirecolor.saturation

			this._setWireColorToNestedLayer (child_layer) (copy wirecolor) level:(level + 1)
			--::LayerToggleCallbacks_v._setWireColorToNestedLayer (child_layer) (wirecolor) level:(level + 1)
		)
	),

	/** Set lyer wirecolor
	 */
	function setLayerWirecolorOnPickerChanged clr =
	(
		--format "\n"; print ".setLyerWirecolor()"
		if layer != undefined then
		(
			format "clr:    %\n" clr
			format "layer: %\n" layer.wirecolor
			layer.wirecolor = clr
		)
	),

	/** Get color picker
	 */
	function _getColorPicker layer_index =
	(
		--format "\n"; print "LayerToggleCallbacks_v._getColorPicker()"

		picker_name = "CLR_layer_id_" + layer_index as string

		for roll in DIALOG_toogle_layers.Subrollouts.Rollouts do
			for ctrl in roll.controls where ctrl.name == picker_name do
				return ctrl
				--return roll.name +"."+ ctrl.name
	),


	private

	/*
	*/
	function _getDisplayWirecolorState layer =
	(
		layer.nodes &theNodes

		if theNodes.count > 0 then theNodes[1].colorByLayer else false
	),

	/*
	*/
	function _setColorByLayerState layer state =
	(
		layer.nodes &theNodes

		for obj in theNodes do
			obj.colorByLayer = state
	),

	/**
	 */
	on create do
	(
		if layer_index != undefined then
			layer = LayerManager.getLayer layer_index
	)
)
