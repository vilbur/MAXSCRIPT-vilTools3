/** Toggle layer visiblity
  *
  * CTRL: Select Layer members
  *
  *
  */
function layerDialogButtonCallback val which =
(
	format "\n"; print "LayersToogleDialog_v.onClickLayerButton()"
	format "EventFired:	% \n" EventFired
	format "val:	% \n" val
	format "which:	% \n" which
	format "which:	% \n" (classOf which)

	LayersManager 	= LayersManager_v()
	LayersToogleDialog 	= LayersToogleDialog_v()

	if not keyboard.controlPressed and not keyboard.shiftPressed then
	(
		if classOf which == integer then
			LayersManager.setVisibility( which ) (val)

		else if which == #dialog then
			LayersManager.setVisibility( LayersToogleDialog.getDialogLayers() ) (val)

		else if which == #others then
			LayersManager.setVisibilityOthers( LayersToogleDialog.getDialogLayers() ) (val)

	)
	else
	(
		layers = case of
		(
			(classOf which == integer ): LayerManager.getLayer which
			(which == #dialog): LayersToogleDialog.getDialogLayers()
			(which == #others): LayersManager.difference(  LayersManager.getAllLayers() ) ( LayersToogleDialog.getDialogLayers() )
		)

		--format "\n-----------\nARRAY:layers:%\n" layers; for layer in layers do format "layer:	%\n" layer.name


		/* IF CONTROL PRESSED */
		if keyboard.controlPressed then
			selectmore (LayersManager.getObjectsInLayers(layers))

		/* IF SHIFT PRESSED */
		else if keyboard.shiftPressed then
			LayersManager.selectLayers( layers ) -- Select all layers in dialog

		if classOf which == name then
			EventFired.control.state = not val

	)


	/* UPDATE OTHER BUTTONS */
	(LayersToogleDialog_v()).refreshButtons()
)


global DIALOG_toogle_layers
/** Layers toogle dialog
 */
struct LayersToogleDialog_v
(
	/* construct */
	selected_layers,
	Dialog,

	/* properties */
	Ini,

	default_width	= 128,

	button_height = 36,

	width_offset	= 16, -- less size of how nested buttonn
	height_offset	= 2, -- less size of how nested buttonn

	tooltip_mod = "CRL: Select displayed layers in dialog.\nSHIFT:Select all layers in dialog.\n",

	/* dependency */
	LayersManager = LayersManager_v(),

	/* reference */
	/* inhered */

	/** Layers toogle dialog
	  *
	  */
	function create reset_layers:false =
	(
		--format "\n"; print "LayersToogleDialog_v.create()"
		--clearListener(); print("Cleared in:"+getSourceFileName())
		/* DIALOG */
		this._setDialog()

		if reset_layers then
			this.resetSelectedLayers()

		this.selected_layers = this.getSelectedOrCurrent() -- after ini

		top_layers = this.LayersManager.getTopLayers( this.selected_layers ) -- get top layers for group control

		this.selected_layers = this.LayersManager.difference( this.selected_layers )(top_layers)

		this.default_width = Dialog.width - 3
		/* CONTROLS */
		this._createMainControls (Dialog.Controls())
		--format "top_layers:	% \n" top_layers

		for layer in this.sortLayers(top_layers) do
			this.createControlsGroupForLayer(layer)(Dialog)

		/* DIALOG CREATE */
		Dialog.create height:undefined lockWidth:false
		--Dialog.register()
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

		buttons_count = 2

		_Controls.Default #across	buttons_count
		--_Controls.Default #width	(this.default_width / buttons_count)
		_Controls.Default #width	32


		HideBtn = _Controls.Control  #checkbutton "DIALOG" tooltip:tooltip_mod
		HideBtn.Event #changed	"layerDialogButtonCallback" params:#dialog	tooltip:"Show all layers in dialog"
		--HideBtn.Event #rightclick	"layerDialogButtonCallback" params:false	tooltip:"Hide all layers in dialog"

		HideOthersBtn = _Controls.Control  #checkbutton "OTHERS" tooltip:tooltip_mod
		HideOthersBtn.Event #changed	"layerDialogButtonCallback" params:#others	tooltip:"Show all other layers then in dialog"
		--HideOthersBtn.Event #rightclick	"layerDialogButtonCallback" params:false	tooltip:"Hide all other layers then in dialog"

		--HideOthersBtn = _Controls.Control  #button "RELOAD"
		--HideOthersBtn.Event #pressed	"macros.run \"_Layers-Dialogs\" \"layers_manager_toogle_dialog\"" tooltip:"Reload dialog with new selection"
	),

	/** Create rollout for each top layer
	  *
	  */
	function createControlsGroupForLayer Layer _Rollout_parent =
	(
		--format "\n====================================\n"
		--format "\n"; print "LayersToogleDialog_v.createControlsGroupForLayer()"

		_Controls   = Dialog.Controls group:layer.name

		/* BUTTON FOR TOP LAYER */
		this.addLayerButton (_Controls) (layer)
		--format "LAYER:	% \n" layer
		--/* BUTTONS FOR NESTED LAYERS */
		this._createButtonForNesteLayers (_Controls) (layer) level:0
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
			level +=1
			--format "child_layer:	% \n" child_layer.name
			--format "CHILD_LAYER:	% \n" child_layer
			if ( findItem this.selected_layers child_layer ) > 0 then
				this.addLayerButton (_Controls) (child_layer) width:(this.default_width - (level * this.width_offset))  height:(this.button_height - (level * this.height_offset)) parent_layer:parent_layer

			this._createButtonForNesteLayers (_Controls) (child_layer) level:(level+1)
		)

	),

	function sanitazeName layer_name = ( dotNetObject "System.Text.RegularExpressions.Regex" ("^[^A-Z0-1\s]*(.*)[^A-Z0-1\s]$") ).Replace layer_name "$1",


	/** Add layer button
	  *
	  */
	function addLayerButton _Controls layer parent_layer: width:this.default_width height:this.button_height =
	(
		--format "\n"; print "LayersToogleDialog_v.addLayerButton()"
		/** Get button caption
		  *
		  */
		function removeParentLayerName parent_layer_name child_layer_name =
		(
			--format "\n"; print "LayersToogleDialog_v.removeParentLayerName()"
			( dotNetObject "System.Text.RegularExpressions.Regex" ("[\s_-]*"+ this.sanitazeName(parent_layer_name) + "[\s_-]*") ).Replace child_layer_name ""
		)

		button_caption = if parent_layer == unsupplied then this.sanitazeName(layer.name) else removeParentLayerName(parent_layer.name)(layer.name)

		layer_index = LayersManager.getLayerIndex(layer)
		--format "LAYER_INDEX:	% \n" layer_index
		_Button = _Controls.control #checkbutton button_caption id:("layer_id_"+layer_index as string ) checked:layer.on across:1 width:width height:height align:#right

		_Button.Event #changed ("layerDialogButtonCallback") params:layer_index tooltip:tooltip_mod --params:layer.name
		_Button --return
	),

	/** Reset selected layers
	  *
	  */
	function resetSelectedLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.resetSelectedLayers()"
		this.Ini.delete "selected_layers"
	),


	--/** Get layers from ini
	--  *
	--  */
	--function getLayersFromIni =
	--(
	--	--format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
	--	layers_ini = this.Ini.keys "selected_layers"
	--
	--	for layer_name in layers_ini where (layer = LayerManager.getLayerFromName layer_name ) != undefined collect layer
	--),
	/** Get layers from ini
	  *
	  */
	function getLayersFromIni =
	(
		--format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
		keys = this.Ini.keys "selected_layers"

		layers = #()

		for key in keys do
		(
			split = filterString key "_"
			format "SPLIT:	% \n" SPLIT

			if ( index = split[split.count] as integer ) != undefined and ( layer = LayerManager.getLayer (index)) != undefined then
				appendIfUnique layers layer
		)

		layers --return
	),


	private

	/** Get selected layers
	  *
	  */
	function getSelectedOrCurrent =
	(
		--format "\n"; print "LayersToogleDialog_v.getSelectedOrCurrent()"
		--format "this.Ini:	% \n" this.Ini
		--format "layers_ini:	% \n" layers_ini

		layers_ini = this.getLayersFromIni()

		if layers_ini.count == 0 then
		(
			selected_layers	= LayersManager.getSelectedOrCurrent()
			layers_index	= LayersManager.getLayersIndex(selected_layers)

			for i = 1 to selected_layers.count do
				this.Ini.save "selected_layers" layers_index[i] selected_layers[i].on

			selected_layers --return
		)
		else
			layers_ini --return

	),


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

		this.Ini = this.Dialog.ini
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


		--format "this.selected_layers:	% \n" this.selected_layers

		--if this.selected_layers.count > 0 then
		--else
		--	messageBox "NOTHING SELECTED\n\nSelect layer in layer manager\n\n\tor\n\n       some object" title:"Title"  beep:false

	)

)
