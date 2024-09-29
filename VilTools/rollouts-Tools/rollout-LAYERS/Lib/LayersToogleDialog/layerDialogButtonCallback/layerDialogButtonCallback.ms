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
function layerDialogButtonCallback val which =
(
	--clearListener(); print("Cleared in:"+getSourceFileName())
	format "\n"; print "LayersToogleDialog_v.layerDialogButtonCallback()"
	format "EventFired:	% \n" EventFired
	format "val:	% \n" val
	format "which:	% \n" which
	--format "which:	% \n" (classOf which)

	LayersManager = LayersManager_v()
    LayersToogleDialog = LayersToogleDialog_v()


    /* NO KEYBOARD SHORTCUT */
    if not keyboard.controlPressed and not keyboard.shiftPressed then
	(
		if classOf which == integer then
			LayersManager.setVisibility( which ) (val)

		else if which == #dialog then
			LayersManager.setVisibility( LayersToogleDialog.getDialogLayers() ) (val)

		else if which == #others then
			LayersManager.setVisibilityOthers( LayersToogleDialog.getDialogLayers() ) (val)

	)
	/* KEYBOARD SHORTCUTS */
	else
	(
		layers = case of
		(
			(classOf which == integer ): #( LayerManager.getLayer which )
			(which == #dialog):			 LayersToogleDialog.getDialogLayers()
			(which == #others):			 LayersManager.difference(  LayersManager.getAllLayers() ) ( LayersToogleDialog.getDialogLayers() )
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
		----if classOf which == name and then
			--EventFired.control.state = not val

	)


	/* UPDATE OTHER BUTTONS */
	(LayersToogleDialog_v()).refreshButtons()

	redrawViews()

)
