/** Layer toggle callbacks
 */
struct LayerToggleCallbacks_v
(
	/* construct */
	layer_index,

	/* properties */
	layer,

	min_saturation = 100,	-- below this value color is to saturated
	min_brightness = 50,	-- below this value color is to dark

	dir_saturation = 1, -- 1|-1 -- make color more or less starurated
	dir_brightness = 1, -- 1|-1 -- make color lighter or darker

	wirecolors = #(),

	/* dependency */
	LayersManager = LayersManager_v(),

	/** Toggle display as layer
	 */
	function toggleDisplayAsLayer hierarchy:false =
	(
		--format "\n"; print ".toggleDisplayAsLayer()"

		if layer != undefined then
		(
			state = not this._getDisplayWirecolorState(layer)

			this._setColorPickerVisibility (layer) (state)

			this._setColorByLayerStateToObjects (layer) (state)

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

			this._setColorByLayerStateToObjects (child_layer) (state)

			this._setDisplayCoorStateToNestedLayers (child_layer) (state)
		)
	),

	/** Set color picker visibility
	 */
	function _setColorPickerVisibility layer state =
	(
		--format "\n"; print "LayerToggleCallbacks_v._setColorPickerVisibility()"
		--format "layer: %\n" layer
		layer_index = LayersManager.getLayerIndex layer
		--format "layer_index: %\n" layer_index
		color_picker = this._getColorPicker layer_index

		color_picker.visible = state
	),

	/** Propagate wirecolor to children layers
	 */
	function propagateWirecolorToChildrenLayers =
	(
		format "\n"; print "LayerToggleCallbacks_v.propagateWirecolorToChildrenLayers()"
		--color_picker = this._getColorPicker layer_index
		format "layer.name: %\n" layer.name
		format "layer.wirecolor: %\n" layer.wirecolor
		if layer != undefined then
		(
			wirecolor = layer.wirecolor

			/* SET MINIMAL VALUES OF COLOR */
			if wirecolor.value      < min_brightness then wirecolor.value      = min_brightness
			if wirecolor.saturation < min_saturation then wirecolor.saturation = min_saturation

			/* SET DIRECTION OF CHANGING VALUES -- add or substract value */
			if (wirecolor.value - min_brightness > 255 - wirecolor.value) then
				dir_brightness = -1

			if (wirecolor.saturation - min_saturation > 255 - wirecolor.saturation) then
				dir_saturation = -1


			/* COLOR TO NESTED LAYERS */
			this._setWireColorToNestedLayer (layer) (wirecolor)

		)
	),

	/** Set lyer wirecolor
	 */
	function setLayerWirecolorOnPickerChanged clr =
	(
		format "\n"; print "LayerToggleCallbacks_v.setLayerWirecolorOnPickerChanged()"
		if layer != undefined then
		(
			format "clr:    %\n" clr
			format "layer: %\n" layer.wirecolor
			layer.wirecolor = clr
		)
	),

	private

	/** WIRE COLOR TO NESTED LAYER
	  *
	  *
	  */
	function _setWireColorToNestedLayer parent_layer wirecolor level:1 =
	(
		--format "\n"; print "LayersToogleDialog_v._setWireColorToNestedLayer()"

		saturation = wirecolor.saturation
		brightness = wirecolor.value

		wirecolor.saturation	= (if saturation > 200 then saturation - 5 else saturation + 5 ) -- saturation
		wirecolor.value	= (if brightness > 220 then brightness - 5 else brightness + 5 ) -- brightness

		wirecolor.saturation	+= 5 * dir_brightness
		wirecolor.value	+= 5 * dir_saturation

		for child_layer in LayersManager.getChildren(parent_layer) do
		(
			--format "\n--------------------------------------------------------\n"
			format "\n"
			--format "child_layer: %\n" child_layer.name
			--format "level: %\n" level
			format "wirecolor: %\n" wirecolor
			--format "brightness: %\n" wirecolor.value
			--format "saturation: %\n" wirecolor.saturation

			--wirecolor.hue += random 5 20

			/* MODIFY HUE */
			wirecolor.hue += 3

			if wirecolor.hue > 255 then wirecolor.hue -= 255 -- loop hue value if more than 255 E.G.: 265 > 10


			if findItem wirecolors wirecolor > 0 then
				format "DUPLICIT WIRECOLOR: % LAYER:%\n" wirecolor child_layer.name
			else
				append wirecolors wirecolor

			/* MODIFY COLOR PICKER */
			child_layer_index = LayersManager.getLayerIndex (child_layer)

			color_picker = this._getColorPicker (child_layer_index)

			color_picker.color    = wirecolor
			color_picker.visible    = true

			--format "%: % hue: % brightness: % saturation: %\n" child_layer.name wirecolor wirecolor.hue wirecolor.value wirecolor.saturation
			/* COLOR TO NESTED LAYERS */
			this._setWireColorToNestedLayer (child_layer) (copy wirecolor) level:(level + 1)
		)
	),

	/** Get color picker
	 */
	function _getColorPicker layer_index =
	(
		--format "\n"; print "LayerToggleCallbacks_v._getColorPicker()"
		--format "layer_index: %\n" layer_index

		picker_name = "CLR_layer_id_" + layer_index as string

		local color_picker

		for roll in DIALOG_toogle_layers.Subrollouts.Rollouts do
			for ctrl in roll.controls while color_picker == undefined where ctrl.name == picker_name do
				color_picker = ctrl

		color_picker --return
	),


	/*
	*/
	function _getDisplayWirecolorState layer =
	(
		layer.nodes &theNodes

		if theNodes.count > 0 then theNodes[1].colorByLayer else false
	),

	/*
	*/
	function _setColorByLayerStateToObjects layer state =
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
			this.layer = LayerManager.getLayer layer_index
	)
)
