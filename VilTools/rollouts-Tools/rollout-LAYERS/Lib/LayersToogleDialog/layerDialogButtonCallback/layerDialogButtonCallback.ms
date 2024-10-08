global CALLBACK_DELAY_TIMER


/**
  *
  * Check dialog position, size and state
  * Find out type of event based on change of dialog states
  */
function updateDialog sender evt =
(
	format "\n"; print "DefaultEvents_v.updateDialog()"
	--sender.enabled = false
	--
	--dotNet.removeEventHandler sender "Elapsed" PerformDelayedTasks
	--
	--CALLBACK_DELAY_TIMER = undefined

	(LayersToogleDialog_v()).refreshButtons()
)


/**
  *
  */
function startUpdateDialogTimer =
(
	--format "\n"; print "DefaultEvents_v.startResizeEventTimer()"

	if CALLBACK_DELAY_TIMER == undefined then
	(
		CALLBACK_DELAY_TIMER = dotNetObject "Windows.Forms.Timer"

		--CALLBACK_DELAY_TIMER.Interval = 250
		CALLBACK_DELAY_TIMER.Interval = 1000

		dotNet.addEventHandler CALLBACK_DELAY_TIMER "Tick" updateDialog

		CALLBACK_DELAY_TIMER.enabled = true

		--DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]	= dialog_id
	)

)


/** Toggle layer visiblity
  *
  * CTRL: Select Layer members
  *
  *
  TODO:

	On button click :

		Ctrl:	Select layer objects
		Ctrl+Shift:	Select all children, layers and objects

  */
function layerDialogButtonCallback val index =
(
	--clearListener(); print("Cleared in:"+getSourceFileName())
	format "\n"; print "LayersToogleDialog_v.layerDialogButtonCallback()"
	format "EventFired:	% \n" EventFired
	format "val:	% \n" val
	format "index:	% \n" index
	--format "index:	% \n" (classOf index)

	LayersManager = LayersManager_v()
    LayersToogleDialog = LAYERS_TOOGLE_DIALOG


    /* NO KEYBOARD SHORTCUT */
    if not keyboard.controlPressed and not keyboard.shiftPressed then
	(
		if classOf index == integer then
			LayersManager.setVisibility( index ) (val)

		else if index == #dialog then
			LayersManager.setVisibility( LayersToogleDialog.getDialogLayers() ) (val)

		else if index == #others then
			LayersManager.setVisibilityOthers( LayersToogleDialog.getDialogLayers() ) (val)

	)
	/* KEYBOARD SHORTCUTS */
	else
	(
		layers = case of
		(
			(classOf index == integer ): #( LayerManager.getLayer index )
			(index == #dialog):			 LayersToogleDialog.getDialogLayers()
			(index == #others):			 LayersManager.difference(  LayersManager.getAllLayers() ) ( LayersToogleDialog.getDialogLayers() )
		)

        --format "\n-----------\nARRAY:layers:%\n" layers; for layer in layers do format "layer:	%\n" layer.name


		/* IF CTRL + SHIFT PRESSED */
		if keyboard.controlPressed and keyboard.shiftPressed then
		(
			--layers_tree = makeUniqueArray (join layers (LayersManager.getLayersTree(layers)))
			--layers_tree = join layers (LayersManager.getLayersInHierarchy(layers))
			layers_tree = (LayersManager.getNestedLayers(layers))
			--format "\n-----------\nARRAY:layers_tree:%\n" layers_tree; for layer in layers_tree do format "layer:	%\n" layer.name

			selectmore (LayersManager.getObjectsInLayers(layers_tree))
		)
		/* IF CTRL PRESSED */
		else if keyboard.controlPressed then
			selectmore (LayersManager.getObjectsInLayers(layers))

		/* IF SHIFT PRESSED */
		else if keyboard.shiftPressed then
		(
			layers_selected = LayersManager.getSelectedLayers()
			format "\n-----------\nARRAY:layers_selected:%\n" layers_selected; for layer in layers_selected do format "layer:	%\n" layer.name
			format "\n-----------\nARRAY:layers:%\n" layers; for layer in layers do format "layer:	%\n" layer.name

			LayersManager.selectLayers( join layers_selected layers ) -- Select all layers in dialog
		)


		/* RESET "Dialog" & "Others" CHEKBUTTONS STATE */
		----if classOf index == name and then
			--EventFired.control.state = not val

	)


	/* UPDATE OTHER BUTTONS */
	--LayersToogleDialog.refreshButtons()

	redrawViews()

)


/** Top layer button callback
 */
function topLayerButtonCallback val index =
(
	format "\n"; print ".topLayerButtonCallback()"
	format "val: %\n" val
	layer = LayerManager.getLayer index

	layer.nodes &theNodes

	for obj in theNodes do
	--format "obj: %\n" obj.isHidden
		obj.isHidden = not val
)

/** Set lyer wirecolor
 */
function setLyerWirecolor clr index =
(
	--format "\n"; print ".setLyerWirecolor()"
	if (layer = LayerManager.getLayer index) != undefined then
	(
		format "clr:    %\n" clr
		format "layer: %\n" layer.wirecolor
		layer.wirecolor = clr
	)
)


/** Toggle display as layer
 */
function toggleDisplayAsLayer index =
(
	format "\n"; print ".toggleDisplayAsLayer()"
	if (layer = LayerManager.getLayer index) != undefined then
	(

		--redrawViews()
		layer.nodes &theNodes


		format "theNodes.count: %\n" theNodes.count
		--format "theNodes[1].displayByLayer: %\n" theNodes[1].displayByLayer
		--
		if theNodes.count >  0 then
		(
			--macros.run "Layers" "LayerPropertiesByLayer"
			state = not theNodes[1].displayByLayer
			format "state: %\n" state

			_selection = for o in selection collect o

			with redraw off
			(
				select theNodes

				macros.run "Layers" "LayerPropertiesByLayer"

				select _selection
			)
			redrawViews()


			execute ( EventFired.Roll.name + ".CLR_layer_id_" + index as string + ".visible = " + state as string )


			--for obj in theNodes do
				--obj.displayByLayer = not state

		)
	)


)



