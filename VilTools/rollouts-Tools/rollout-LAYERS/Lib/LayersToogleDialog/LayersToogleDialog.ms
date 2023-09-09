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
	format "\n"; print "LayersToogleDialog_v.onClickLayerButton()"
	--format "EventFired:	% \n" EventFired
	--format "val:	% \n" val
	--format "which:	% \n" which
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


global DIALOG_toogle_layers
/** Layers toogle dialog
 */
struct LayersToogleDialog_v
(
	/* construct */
	layers,
	Dialog,

	/* properties */
	Ini,

	default_width	= 96,

	button_height = 36,

	width_offset	= 16, -- less size of how nested buttonn
	height_offset	= 2, -- less size of how nested buttonn

	tooltip_layer = "CRL: Select objects in layer. \nSHIFT:Select children layers. \nCRL + SHIFT: Select objects in all nested layers",

	/* dependency */
	LayersManager = LayersManager_v(),

	/* reference */
	/* inhered */



	/** Layers toogle dialog
	  *
	  */
	function create layers: =
	(
		format "\n"; print "LayersToogleDialog_v.create()"
		--clearListener(); print("Cleared in:"+getSourceFileName())
		/* DIALOG */

		--if reset_layers then
			--this.resetLayers()

		if layers == unsupplied then
			layers = this.getIniOrSelectedOrCurrent() -- after ini

		--format "layers:	% \n" layers

		top_layers = this.LayersManager.getTopLayers( layers ) -- get top layers for group control

		this.layers = this.LayersManager.difference( layers )(top_layers)

		this.default_width = Dialog.width - 3
		/* CONTROLS */
		this._createMainControls (Dialog.Controls())
		--format "top_layers:	% \n" top_layers

		for layer in this.sortLayers(top_layers) do
			this.createControlsGroupForLayers(layer)(Dialog)

		/* DIALOG CREATE */
		Dialog.create height:undefined lockWidth:false

		Dialog.register()
	),

	/** Get dialog layers
	  *
	  */
	function getDialogLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.getDialogLayers()"
		layers_in_dialog = for control in DIALOG_toogle_layers.controls where classOf control == CheckButtonControl collect this._getLayerByControl (control)
			for layer in layers_in_dialog where layer != undefined collect layer
	),

	/** Refresh buttons
	  *
	  */
	function refreshButtons =
	(
		--format "\n"; print "LayersToogleDialog_v.refreshButtons()"
		for control in DIALOG_toogle_layers.controls where classOf control == CheckButtonControl and (layer = this._getLayerByControl (control)) != undefined do
			control.state = layer.on
	),

	/** Create main controls
	  *
	  */
	function _createMainControls _Controls =
	(
		--format "\n"; print "LayersToogleDialog_v._createMainControls()"

		/** Get tooltip
		  *
		  */
		function getTooltip button_type = "CRL: Select displayed layers in "+button_type+".\nSHIFT:Select all layers in "+button_type+".\n"

		buttons_count = 2

		_Controls.Default #across	buttons_count
		--_Controls.Default #width	(this.default_width / buttons_count)
		_Controls.Default #width	32

		HideBtn = _Controls.Control	#checkbutton "DIALOG"	tooltip:(getTooltip("dialog"))
		HideBtn.Event #changed	"layerDialogButtonCallback"	params:#dialog	tooltip:"Toggle all layers in dialog"
		HideBtn.Event #rightclick	"layerDialogButtonCallback"	params:#(false, #dialog)	tooltip:"Hide all layers in dialog"

		HideOthersBtn = _Controls.Control	#checkbutton "OTHERS"	tooltip:(getTooltip("not in dialog"))
		HideOthersBtn.Event #changed	"layerDialogButtonCallback"	params:#others	tooltip:"Toggle all layers not in dialog"
		HideOthersBtn.Event #rightclick	"layerDialogButtonCallback"	params:#(false, #others)	tooltip:"Hide all layers not in dialog"

		--HideOthersBtn = _Controls.Control  #button "RELOAD"
		--HideOthersBtn.Event #pressed	"macros.run \"_Layers-Dialogs\" \"layers_manager_toogle_dialog\"" tooltip:"Reload dialog with new selection"
	),

	/** Create rollout for each top layer
		*
	*/
	function createControlsGroupForLayers Layer _Rollout_parent =
	(
		--format "\n====================================\n"
		--format "\n"; print "LayersToogleDialog_v.createControlsGroupForLayers()"

		_Controls   = Dialog.Controls group:(this.sanitazeName(layer.name))

		/* BUTTON FOR TOP LAYER */
		this.addLayerButton (_Controls) (layer) width:(this.default_width - 16)
		--format "LAYER:	% \n" layer
		--/* BUTTONS FOR NESTED LAYERS */
		this._createButtonForNesteLayers (_Controls) (layer) level:1
	),

	/** Create button for neste layers
	  *
	  */
	function _createButtonForNesteLayers _Controls parent_layer level: =
	(
		--format "\n"; print "LayersToogleDialog_v.craeteButtonForNesteLayers()"
		--format "parent_layer:	% \n" parent_layer
		level +=1

		/* BUTTONS */
		for child_layer in LayersManager.getChildren(parent_layer) do
		(
			--level +=1
			--format "child_layer:	% \n" child_layer.name
			--format "CHILD_LAYER:	% \n" child_layer
			if ( findItem this.layers child_layer ) > 0 then
				this.addLayerButton (_Controls) (child_layer) width:(this.default_width - (level * this.width_offset)) height:(this.button_height - (level * this.height_offset)) parent_layer:parent_layer

			this._createButtonForNesteLayers (_Controls) (child_layer) level:(level)
		)

	),

	/** Remove
	  * 	PREFIX: Anything then A-Z
	  * 	SUFFIX: Anything then A-Z 0-9
	  *
	  * E.: "0-- _ - Layer-Name -_!#" >>> "Layer-Name"
	  */
	function sanitazeName layer_name =
	(
		--format "\n"; print "LayersToogleDialog_v.sanitazeName()"
		--format "LAYER_NAME:	% \n" layer_name

		if layer_name == "0" then
			"Default" --return
		else
			( dotNetObject "System.Text.RegularExpressions.Regex" ("^[^a-zA-Z]*(.*?(?=[^a-zA-Z0-9]+$)).*$") ).Replace layer_name "$1"
	),

	/** Add layer button
	  *
	  */
	function addLayerButton _Controls layer parent_layer: width: height:this.button_height =
	(
		--format "\n"; print "LayersToogleDialog_v.addLayerButton()"
		--format "LAYER.name:	% \n" layer.name
		--format "LAYER.on:	% \n" layer.on

		/** Get button caption
		  *
		  */
		function removeParentLayerName parent_layer child_layer_name =
		(
			--format "\n"; print "LayersToogleDialog_v.removeParentLayerName()"
			--( dotNetObject "System.Text.RegularExpressions.Regex" ("[\s_-]*"+ this.sanitazeName(parent_layer_name) + "[\s_-]*") ).Replace child_layer_name ""
			top_layer = ( LayersManager.getTopLayers( parent_layer ))[1]

			( dotNetObject "System.Text.RegularExpressions.Regex" ("[\s_-]*"+ this.sanitazeName(top_layer.name) + "[\s_-]*$") ).Replace child_layer_name ""

		)

		button_caption = if parent_layer == unsupplied then this.sanitazeName(layer.name) else removeParentLayerName(parent_layer)(layer.name)

		layer_index = LayersManager.getLayerIndex(layer)
		--format "LAYER_INDEX:	% \n" layer_index

		_Button = _Controls.control #checkbutton button_caption id:("layer_id_"+layer_index as string ) checked:layer.on ini:false across:1 width:width height:height align:#right

		_Button.Event #changed ("layerDialogButtonCallback") params:layer_index tooltip:tooltip_layer --params:layer.name
		_Button --return
	),

	/** Reset selected layers
	  *
	  */
	function resetLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.resetLayers()"
		this.Ini.delete "layers"
	),


	--/** Get layers from ini
	--  *
	--  */
	--function getLayersFromIni =
	--(
	--	--format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
	--	layers_ini = this.Ini.keys "layers"
	--
	--	for layer_name in layers_ini where (layer = LayerManager.getLayerFromName layer_name ) != undefined collect layer
	--),
	/** Get layers from ini
	  *
	  */
	function getLayersFromIni =
	(
		--format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
		keys = this.Ini.keys "layers"

		layers = #()

		for key in keys do
		(
			split = filterString key "_"
			--format "SPLIT:	% \n" SPLIT

			if ( index = split[split.count] as integer ) != undefined and ( layer = LayerManager.getLayer (index)) != undefined then
				appendIfUnique layers layer
		)

		layers --return
	),

	/** Get selected layers
	  *
	  */
	function getSelectedLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.getSelectedLayers()"
		LayersManager.getSelectedLayers() --return
	),


	/** Get selected layers
	  *
	  */
	function getIniOrSelectedOrCurrent =
	(
		--format "\n"; print "LayersToogleDialog_v.getIniOrSelectedOrCurrent()"
		--format "this.Ini:	% \n" this.Ini
		--format "layers_ini:	% \n" layers_ini

		layers_ini = this.getLayersFromIni()

		if layers_ini.count == 0 then
		(
			layers	= LayersManager.getSelectedLayers()
			layers_index	= LayersManager.getLayersIndex(layers)

			for i = 1 to layers.count do
				this.Ini.save "layers" layers_index[i] layers[i].on

			layers --return
		)
		else
			layers_ini --return

	),


	private


	/** Get layer by control
	  *
	  */
	function _getLayerByControl _Control =
	(
		--format "\n"; print "LayersToogleDialog_v._getLayerByControl()"
		--format "_Control:	% \n" _Control
		id_split = filterString ( _Control as string ) "_"
		--format "id_split:	% \n" id_split
		layer_id =  id_split[id_split.count] as integer
		--format "layer_id:	% \n" layer_id

		if layer_id != undefined then
			LayerManager.getLayer layer_id
	),

	/** Set dialog
	  *
	  */
	function _setDialog =
	(
		--format "\n"; print "LayersToogleDialog_v._setDialog()"
		--format "this._getSceneBaseName():	% \n" (this._getSceneBaseName())
		this.Dialog = Dialog_v ("Toogle Layers") width:this.default_width ini:( getDir #temp + "\\ini_files\\LayersToogleDialog\\"+ (this._getSceneBaseName()) + ".ini" )

	),

	/** Get visible layers
	  *
	  */
	function _getVisibleLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.getVisibleLayers()"

		for i = 0 to LayerManager.count - 1 where (layer = LayerManager.getLayer i).on collect layer --return

	),

	/** Get scene base name without nuber suffix
	  *
	  */
	function _getSceneBaseName =
	(
		if (file_name = maxFileName ) != "" then
		(
			matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches file_name "(.*[^0-9]+)(\d+)*\.max" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

			match	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))[1] --return

			trimRight match[2] "-"
		)
		else
			"untitled"
	),


	/** Sort layers
	  *
	  */
	function sortLayers layers =
	(
		--format "\n"; print "LayersToogleDialog_v.sortLayers()"
		fn compareNames layer1 layer2 = stricmp layer1.name layer2.name

		layers = for obj in layers collect obj

		qsort layers compareNames

		layers --return
	),
	/**
	 */
	on create do
	(
		--format "\n"; print "LayersToogleDialog.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this._setDialog()

		this.Ini = this.Dialog.ini


	)

)
