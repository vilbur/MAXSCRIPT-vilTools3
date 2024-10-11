/** Layer toggle callbacks
 */
struct LayerToggleCallbacks_v
(


	/** Toggle display as layer
	 */
	function toggleDisplayAsLayer index =
	(
		--format "\n"; print ".toggleDisplayAsLayer()"
		if (layer = LayerManager.getLayer index) != undefined then
		(
			layer.nodes &theNodes

			if theNodes.count >  0 then
			(
				state = not theNodes[1].colorByLayer

				for obj in theNodes do
					obj.colorByLayer = state

				color_picker = ::LayerToggleCallbacks_v.getColorPicker index

				color_picker.visible = state
			)
		)
	),

	/** Propagate wirecolor to children layers
	 */
	function propagateWirecolorToChildrenLayers index =
	(

		format "\n"; print "LayerToggleCallbacks_v.propagateWirecolorToChildrenLayers()"
		color_picker = ::LayerToggleCallbacks_v.getColorPicker index
		--format "index: %\n" index
		--format "color_picker: %\n" color_picker
		layer = LayerManager.getLayer index
		format "layer: %\n" layer

		if (layer = LayerManager.getLayer index) != undefined then
		(
			--format "layer.wirecolor: %\n" layer.wirecolor
			format "%: %\n" layer.name layer.wirecolor

			color_picker.color = layer.wirecolor

			::LayerToggleCallbacks_v.setWireColorToNestedLayer (layer) (copy layer.wirecolor)

			CompleteRedraw()
		)

	),
	/** ADD LAYER BUTTONS
	  *
	  */
	function setWireColorToNestedLayer parent_layer wirecolor level:1 =
	(
		format "\n"; print "LayersToogleDialog_v.setWireColorToNestedLayer()"
		format "parent_layer.name: %\n" parent_layer.name
		format "wirecolor:	% \n" wirecolor
		format "level: %\n" level

		LayersManager = LayersManager_v()
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

			color_picker = ::LayerToggleCallbacks_v.getColorPicker (child_layer_index)

			child_layer.wirecolor = wirecolor
			--child_layer.wirecolor = orange

			color_picker.color    = wirecolor
			--color_picker.enabled = layer.wirecolor

			--format "%: % hue: % brightness: % saturation: %\n" child_layer.name wirecolor wirecolor.hue wirecolor.value wirecolor.saturation

			::LayerToggleCallbacks_v.setWireColorToNestedLayer (child_layer) (copy wirecolor) level:(level + 1)
			--::LayerToggleCallbacks_v.setWireColorToNestedLayer (child_layer) (wirecolor) level:(level + 1)
		)
	),

	/** Set lyer wirecolor
	 */
	function setLayerWirecolorOnPickerChanged clr index =
	(
		--format "\n"; print ".setLyerWirecolor()"
		if (layer = LayerManager.getLayer index) != undefined then
		(
			format "clr:    %\n" clr
			format "layer: %\n" layer.wirecolor
			layer.wirecolor = clr
		)
	),

	/** Get color picker
	 */
	function getColorPicker  index =
	(
		--format "\n"; print "LayerToggleCallbacks_v.getColorPicker()"

		picker_name = "CLR_layer_id_" + index as string

		for roll in DIALOG_toogle_layers.Subrollouts.Rollouts do
			for ctrl in roll.controls where ctrl.name == picker_name do
				return ctrl
				--return roll.name +"."+ ctrl.name
	),


	private


	/**
	 */
	on create do	()

)
