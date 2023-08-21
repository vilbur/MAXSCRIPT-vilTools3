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

		format "layers:	% \n" layers


		/* IF CONTROL PRESSED */
		if keyboard.controlPressed then
			selectmore (LayersManager.getObjectsInLayers(layers))

		/* IF SHIFT PRESSED */
		else if keyboard.shiftPressed then
			LayersManager.selectLayers( layers ) -- Select all layers in dialog


		if classOf which == name then
			EventFired.control.state = not val

	)


	--layer = LayerManager.getLayerFromName EventFired.Control.text
	--
	--if layer != undefined then
	--(
	--	LayersManager 	= LayersManager_v()
	--
	--	if keyboard.controlPressed then
	--		selectmore (LayersManager.getObjectsInLayers(layer))
	--
	--	/* TOGGLE LAYER OF BUTTON CLICKED */
	--	else
	--		(LayersManager_v()).setVisibility( layer ) (EventFired.val) -- Turn on with parent layers
	--
	--)

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

	button_height = 32,

	width_offset = 8, -- less size of how nested buttonn

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

		top_layers = this.LayersManager.getTopLayers( this.selected_layers ) -- get top layers for group controls

		this.selected_layers = this.LayersManager.difference( this.selected_layers )(top_layers)

		this.default_width = Dialog.width - 32

		/* CONTROLS */
		this._createMainControls (Dialog.Controls())

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
		layers_in_dialog = for control in DIALOG_toogle_layers.controls where classOf control == CheckButtonControl collect LayerManager.getLayerFromName control.text

		for layer in layers_in_dialog where layer != undefined collect layer
	),

	/** Refresh buttons
	  *
	  */
	function refreshButtons =
	(
		--format "\n"; print "LayersToogleDialog_v.refreshButtons()"
		for control in DIALOG_toogle_layers.controls where classOf control == CheckButtonControl do
			if ( layer = LayerManager.getLayerFromName control.text ) != undefined then
				 control.state = layer.on
	),

	/** Create main controls
	  *
	  */
	function _createMainControls _Controls =
	(
		format "\n"; print "LayersToogleDialog_v._createMainControls()"

		buttons_count = 3

		_Controls.Default #across	buttons_count
		--_Controls.Default #width	(this.default_width / buttons_count)
		_Controls.Default #width	32


		HideBtn = _Controls.Control  #checkbutton "DIALOG" tooltip:"CRL: Select displayed layers in dialog.\nSHIFT:Select all layers in dialog.\n"
		HideBtn.Event #changed	"layerDialogButtonCallback" params:#dialog	tooltip:"Show all layers in dialog"
		--HideBtn.Event #rightclick	"layerDialogButtonCallback" params:false	tooltip:"Hide all layers in dialog"

		HideOthersBtn = _Controls.Control  #checkbutton "OTHERS"
		HideOthersBtn.Event #changed	"layerDialogButtonCallback" params:#others	tooltip:"Show all other layers then in dialog"
		--HideOthersBtn.Event #rightclick	"layerDialogButtonCallback" params:false	tooltip:"Hide all other layers then in dialog"

		HideOthersBtn = _Controls.Control  #button "RELOAD"
		HideOthersBtn.Event #pressed	"macros.run \"_Layers-Dialogs\" \"layers_manager_toogle_dialog\"" tooltip:"Reload dialog with new selection"

	),

	/** Create rollout for each top layer
	  *
	  */
	function createControlsGroupForLayer Layer _Rollout_parent =
	(
		--format "\n====================================\n"
		_Controls   = Dialog.Controls group:layer.name

		/* BUTTON FOR TOP LAYER */
		this.addLayerButton (_Controls) (layer)

		/* BUTTONS FOR NESTED LAYERS */
		this._createButtonForNesteLayers (_Controls) (layer) level:0
	),

	/** Create button for neste layers
	  *
	  */
	function _createButtonForNesteLayers _Controls layer level: =
	(
		--format "\n"; print "LayersToogleDialog_v.craeteButtonForNesteLayers()"
		--format "layer:	% \n" layer

		/* BUTTONS */
		for child_layer in LayersManager.getChildren(layer) do
		(
			level +=1

			if ( findItem this.selected_layers child_layer ) > 0 then
				this.addLayerButton (_Controls) (child_layer) width:(this.default_width - (level * this.width_offset))

			this._createButtonForNesteLayers (_Controls) (child_layer) level:(level+1)
		)
	),


	/** Add layer button
	  *
	  */
	function addLayerButton _Controls layer width:default_width =
	(
		--format "\n"; print "LayersToogleDialog_v.addLayerButton()"

		layer_index = LayersManager.getLayerIndex(layer)
		--format "LAYER_INDEX:	% \n" layer_index
		_Button = _Controls.control #checkbutton layer.name id:("layer_id_"+layer_index as string ) checked:layer.on across:1 width:width height:this.button_height align:#right

		_Button.Event #changed ("layerDialogButtonCallback") params:layer_index tooltip:"Toogle layer visibility.\n\nCTRL: Select objects in layer" --params:layer.name

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


	/** Get layers from ini
	  *
	  */
	function getLayersFromIni =
	(
		--format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
		layers_ini = this.Ini.keys "selected_layers"

		for layer_name in layers_ini where (layer = LayerManager.getLayerFromName layer_name ) != undefined collect layer
	),

	private

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
			selected_layers = LayersManager.getSelectedOrCurrent()

			for selected_layer in selected_layers do
				this.Ini.save "selected_layers" selected_layer.name true

			selected_layers --return
		)
		else
			layers_ini --return

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
