
/*
	TODO:
	 WRAP METHODS IN THIS FILE TO STRUCT

*/
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
	LayersToogleDialog.refreshButtons()

	redrawViews()

)


/** Top layer button callback
 */
function topLayerButtonCallback val layer_index =
(
	--format "\n"; print ".topLayerButtonCallback()"
	--format "val: %\n" val
	--format "EventFired: %\n" EventFired

	layer = LayerManager.getLayer layer_index

	layer.nodes &theNodes

	for obj in theNodes do
		obj.isHidden = not val

	if keyboard.shiftPressed then
		layer.on = val

	LAYERS_TOOGLE_DIALOG.refreshButtons()
)

global LAYER_HUE_LAST_VAL

/** Tune hue of layer recolor
 */
function tuneHueOfLayerRecolor val =
(
	--format "\n"
	--format "\n"; print ".tuneHueOfLayerRecolor()"
	format "val: %\n" val
	--format "LAYER_HUE_LAST_VAL: %\n" LAYER_HUE_LAST_VAL

	layers_selected = (LayersManager_v()).getSelectedLayers()

	prop = case of
	(
		(keyboard.controlPressed): "saturation"
		(keyboard.shiftPressed):   "value"
		default: "hue"
	)

	if LAYER_HUE_LAST_VAL == undefined then
		LAYER_HUE_LAST_VAL = val

	increment = if val < LAYER_HUE_LAST_VAL then val - LAYER_HUE_LAST_VAL else val - LAYER_HUE_LAST_VAL

	if (layers_selected) != undefined and layers_selected.count > 0 then
	(

		--format "layers_selected[1].name: %\n" layers_selected[1].name

		for layer in layers_selected do
		(
			--format "layer.name: %\n" layer.name
			color_picker = (LayerToggleCallbacks_v()).getColorPickerByLayer(layer)

			wirecolor = layer.wirecolor

			if val > 0 and val < 255 then
			(
				prop_val = (getProperty wirecolor prop) + increment

				if prop == "hue" then
				(
					if prop_val < 0   then prop_val = 255 - prop_val
					if prop_val > 255 then prop_val = prop_val - 255
				)
				else
				(
					if prop_val < 0   then prop_val = 0
					if prop_val > 255 then prop_val = 255
				)

				if prop != "hue" then
				(
					if prop_val == 0   then EventFired.control.value = 0
					if prop_val == 255 then EventFired.control.value = 255
				)

				format "prop_val: %\n" prop_val
				setProperty wirecolor prop ( prop_val as integer )

			)
			else
				setProperty wirecolor prop ( val as integer )


			layer.wirecolor = wirecolor
			--format "hue: %\n" layer.wirecolor.hue
			color_picker.color = wirecolor
		)

		LAYER_HUE_LAST_VAL = val
	)
)


/** Get layer controls
 */
function getLayerButtons =
(
	--format "\n"; print ".getLayerButtons()"
	/** Get layer id
	 */
	function _getLayerId ctrl_name = (trimLeft ctrl_name "layer_id_") as integer

	layers_buttons	=  Dictionary #INTEGER -- KEY: layer id VALUE: button or rollout

	/* GET LAYER BUTTONS */

	for roll in DIALOG_toogle_layers.Subrollouts.Rollouts do
		for control in roll.controls where classOf control == CheckButtonControl do
			layers_buttons[_getLayerId control.name] = control

	--for key in layers_buttons.keys do
	--	format "layers_buttons[key]: %\n" layers_buttons[key]

	layers_buttons --return
)

/** Get layers rollouts
 */
function getLayersRollouts =
(
	--format "\n"; print ".getLayersRollouts()"
	function _getLayerId ctrl_name = (trimLeft ctrl_name "ROLLOUT_layer_id_") as integer

	layers_rollouts	=  Dictionary #INTEGER -- KEY: layer id VALUE: button or rollout

	for roll in DIALOG_toogle_layers.Subrollouts.Rollouts do
		layers_rollouts[_getLayerId roll.name] = roll

	layers_rollouts --return
)


/** Sync with layer manager
 */
function syncDialogToScene =
(
	--format "\n"; print ".syncDialogToScene()"
	--format "val: %\n" val
	if queryBox ("Sync state of scene layers ?\n\nDIALOG > SCENE ") title:"SYNC LAYERS STATE" then
	(
		layers_buttons = getLayerButtons()
		layers_rollouts = getLayersRollouts()

		/* SET LAYERS STATE */
		for i = 0 to LayerManager.count - 1 do
		(
			layer =  LayerManager.getLayer i

			layer.on = false

			--if layers_rollouts[i] != undefined then
			--format "roll: %\n" layers_rollouts[i]

			if (roll = layers_rollouts[i]) != undefined then
				layer.on = roll.open

			--if layers_buttons[i] != undefined then
			--format "control: %\n" layers_buttons[i]

			if (check_button = layers_buttons[i]) != undefined and roll == undefined then
				layer.on = check_button.state

			/* TURN LAYER OF IF NOT IN DIALOG */
			--if roll == undefined and check_button == undefined  then
				--layer.on = false
		)
	)
)

/** Sync scene to dialog
 */
function syncSceneToDialog =
(
	--format "\n"; print ".syncSceneToDialog()"

	if queryBox ("Sync state of scene layers ?\n\nSCENE > DIALOG") title:"SYNC LAYERS STATE" then
	(
		layers_buttons = getLayerButtons()
		layers_rollouts = getLayersRollouts()


		/* SET LAYERS STATE */
		for i = 0 to LayerManager.count - 1 do
		(
			layer =  LayerManager.getLayer i

			/* SET RLLOUT STATE */
			if (roll = layers_rollouts[i]) != undefined then
				roll.open = layer.on


			/* SET CHECKBUTTON STATE */
			if (check_button = layers_buttons[i]) != undefined then
				check_button.state = layer.on -- CHECKBUTTON


			/* TURN OFF LAYERS WHICH ARE NOT IN DIALOG */
			if roll == undefined and check_button == undefined  then
				layer.on = false
		)
	)
)
