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

			--redrawViews()
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
		format "index: %\n" index
		format "color_picker: %\n" color_picker
		layer = LayerManager.getLayer index
		format "layer: %\n" layer

		if (layer = LayerManager.getLayer index) != undefined then
		(
			--format "layer.wirecolor: %\n" layer.wirecolor

			::LayerToggleCallbacks_v.setWireColorToLayer (layer) (layer.wirecolor)

		)

	),
	/** ADD LAYER BUTTONS
	  *
	  */
	function setWireColorToLayer parent_layer wirecolor level:1 =
	(
		format "\n"; print "LayersToogleDialog_v.setWireColorToLayer()"
		--format "parent_layer:	% \n" parent_layer

		/*------------------------------------------------------------------------------
			BUTTON FOR EACH LAYER
		--------------------------------------------------------------------------------*/
		for child_layer in (LayersManager_v()).getChildren(parent_layer) do
		(
			child_layer.wirecolor = wirecolor

			::LayerToggleCallbacks_v.setWireColorToLayer (child_layer) wirecolor level:(level + 1)
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
