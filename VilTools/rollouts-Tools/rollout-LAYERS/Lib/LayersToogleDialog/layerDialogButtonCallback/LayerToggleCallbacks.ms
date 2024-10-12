/** Layer toggle callbacks
 */
struct LayerToggleCallbacks_v
(
	/* construct */
	layer_index,

	/* properties */
	layer,

	min_saturation = 100,	-- below this value color is to saturated
	min_brightness = 100,	-- below this value color is to dark

	min_value = 100,


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
		--format "\n"; print "LayerToggleCallbacks_v.propagateWirecolorToChildrenLayers()"

		/** Find which side of gradient from current value is bigger
		 */
		function getDirection val = if ( val - this.min_value > 255 - val ) then -1 else 1

		if layer != undefined then
		(
			wirecolor = layer.wirecolor

			/* SET MINIMAL VALUES OF COLOR */
			if wirecolor.value      < min_value then wirecolor.value      = min_value
			if wirecolor.saturation < min_value then wirecolor.saturation = min_value

			--/* SET DIRECTION OF CHANGING VALUES -- add or substract value */
			dir_saturation = getDirection (wirecolor.saturation)
			dir_brightness = getDirection (wirecolor.value)

			/* SET SANITIZIED COLOR TO LAYER & PICKER */
			if wirecolor != layer.wirecolor then
				this._setWirecolorToLayerAndColorPicker (layer) (wirecolor) layer_index:layer_index

			--format "wirecolor: %\n" wirecolor
			--format "\n"
			--format "brightness: %\n" wirecolor.value
			--format "saturation: %\n" wirecolor.saturation
			--format "\n"
			--format "dir_saturation: %\n" dir_saturation
			--format "dir_brightness: %\n" dir_brightness

			/* COLOR TO NESTED LAYERS */
			this._setWireColorToNestedLayers (layer) (copy layer.wirecolor)
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
	function _setWireColorToNestedLayers parent_layer wirecolor level:1 =
	(
		--format "\n"; print "LayersToogleDialog_v._setWireColorToNestedLayers()"

		wirecolor.hue += 1

		for child_layer in LayersManager.getChildren(parent_layer) do
		(
			--format "\n--------------------------------------------------------\n"
			wirecolor.saturation	= ( (level * 3) * dir_saturation) + wirecolor.saturation
			wirecolor.value	= ( (level * 3) * dir_brightness) + wirecolor.value

			/* FIT VALUES TO RANGE min_value - 255 */
			if wirecolor.value      > 255 or wirecolor.value      < min_value then wirecolor.value      = min_value
			if wirecolor.saturation > 255 or wirecolor.saturation < min_value then wirecolor.saturation = min_value

			/* MODIFY HUE */
			wirecolor.hue = if wirecolor.hue < 255 then wirecolor.hue + 1 else 0

			/* FIND FIRST UNIQUE HUE */
			while findItem wirecolors wirecolor > 0 do
				wirecolor.hue += 1

			--format "\n"
			--format "child_layer: %\n" child_layer.name
			--format "wirecolor: %\n" wirecolor
			--format "brightness: %\n" wirecolor.value
			--format "saturation: %\n" wirecolor.saturation


			/* MODIFY COLOR PICKER */
			this._setWirecolorToLayerAndColorPicker (child_layer) (wirecolor)

			--format "%: % hue: % brightness: % saturation: %\n" child_layer.name wirecolor wirecolor.hue wirecolor.value wirecolor.saturation
			/* COLOR TO NESTED LAYERS */
			this._setWireColorToNestedLayers (child_layer) (copy wirecolor) level:(level + 1)
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

	/** Set wirecolor to layer and color picker
	 */
	function _setWirecolorToLayerAndColorPicker _layer wirecolor layer_index: =
	(
		--format "\n"; print "LayerToggleCallbacks_v._setWirecolorToLayerAndColorPicker()"

		if layer_index == unsupplied then
			layer_index = LayersManager.getLayerIndex (_layer)

		/* COLOR PICKER */
		color_picker = this._getColorPicker (layer_index)

		color_picker.color    = wirecolor
		color_picker.visible    = true

		/* SET LAYER WIRECOLOR */
		_layer.wirecolor    = wirecolor
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
