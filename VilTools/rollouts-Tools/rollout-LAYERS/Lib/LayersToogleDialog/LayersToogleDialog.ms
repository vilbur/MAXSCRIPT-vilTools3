/** Toggle layer visiblity
  *
  */
function toggleLayerVisiblity val =
(
	--format "\n"; print "LayersToogleDialog_v.toggleLayerVisiblity()"
	--format "EventFired:	% \n" EventFired.Roll

	/* TOGGLE LAYER OF BUTTON CLICKED */
	if ( layer = LayerManager.getLayerFromName EventFired.Control.text ) != undefined then
			(LayersManager_v()).setVisibility( layer ) (EventFired.val) -- Turn on with parent layers

	/* UPDATE OTHER BUTTONS */
	(LayersToogleDialog_v()).refreshButtons()
)

/** Toggle working layers
  *
  */
function toggleWorkingLayers =
(
	--format "\n"; print "LayersToogleDialog_v.toggleWorkingLayers()"

	LayersManager 	= LayersManager_v()
	LayersToogleDialog 	= LayersToogleDialog_v()

	LayersManager.setVisibility( LayersToogleDialog.getDialogLayers() ) (EventFired.type == #pressed)

	LayersToogleDialog.refreshButtons()
)

/** Hide layers then are not in dialog
  *
  */
function displayeOtherLayers =
(
	--format "\n"; print "LayersToogleDialog_v.displayeOtherLayers()"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"

	LayersManager 	= LayersManager_v()
	LayersToogleDialog 	= LayersToogleDialog_v()

	LayersManager.setVisibilityOthers( LayersToogleDialog.getDialogLayers() ) (EventFired.type == #pressed)
)

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

	width_offset = 8, -- less size of how nested button

	/* dependency */
	LayersManager = LayersManager_v(),

	/* reference */
	/* inhered */

	/** Layers toogle dialog
	  *
	  */
	function create reset_layers:false =
	(
		--format "\n"; print "LayersToogleDialog.ms.layersToogleDialog()"
		--clearListener(); print("Cleared in:"+getSourceFileName())
		/* DIALOG */
		this._setDialog()

		if reset_layers then
			this.resetSelectedLayers()

		this.selected_layers = this._getSelectedLayers() -- after ini

		top_layers = this.LayersManager.getTopLayers( this.selected_layers ) -- get top layers for group controls

		this.selected_layers = this.LayersManager.difference( this.selected_layers )(top_layers)

		this.default_width = Dialog.width - 32

		--format "DIALOG.WIDTH:	% \n" Dialog.width
		--format "\n----------------------\n"
		--for layer in this.selected_layers do
		--	format "SELECTED_LAYER:	% \n" layer.name

		--for layer in top_layers do
		--	format "TOP_LAYER:	% \n" layer.name

		hide_btn	= #( "Toggle Layers", #( "ToggleWorkingLayers", "ToggleWorkingLayers" ))
		hide_others_btn	= #( "Toggle Others",	#( "displayeOtherLayers", "displayeOtherLayers" ))
		reload_btn	= #( "Reload",	#( "macros.run \"_Layers-Dialogs\" \"layers_manager_toogle_dialog\"" ) )

		/* CONTROLS */
		buttons	= #(hide_btn, hide_others_btn, reload_btn)

		this._createMainControls (Dialog.Controls())(buttons)

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
	function _createMainControls _Controls buttons =
	(
		--format "\n"; print "LayersToogleDialog_v._createMainControls()"
		for data_pair in buttons do
		(
			_Button = _Controls.control #button ( data_pair[1] ) across:buttons.count

			_Button.Events.add #pressed ( data_pair[2][1] as string )

			if data_pair[2][2] != undefined then
				_Button.Events.add #rightclick ( data_pair[2][2] as string )

		)
	),


	/** Create rollout for each top layer
	  *
	  */
	function createControlsGroupForLayer Layer _Rollout_parent =
	(
		format "\n"; print "LayersToogleDialog_v.createControlsGroupForLayer()"
		format "TOP LAYER:	% \n" Layer.name
		_Controls   = Dialog.Controls group:layer.name

		this.addLayerButton (_Controls) (layer)

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
		format "\n"; print "LayersToogleDialog_v.addLayerButton()"
		format "layer:	% \n" layer.name
		--format "layer:	% \n" layer.on
		--_Button = _Controls.control #button layer.name across:1 width:default_width height:this.button_height
		_Button = _Controls.control #checkbutton layer.name checked:layer.on across:1 width:width height:this.button_height align:#right

		_Button.Events.add #changed ("toggleLayerVisiblity") params:layer.name

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
	function _getSelectedLayers =
	(
		--format "\n"; print "LayersToogleDialog_v._getSelectedLayers()"
		--format "this.Ini:	% \n" this.Ini
		--format "layers_ini:	% \n" layers_ini

		layers_ini = this.getLayersFromIni()

		if layers_ini.count == 0 then
		(
			selected_layers = LayersManager.getSelectLayersOrBySelection()

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
