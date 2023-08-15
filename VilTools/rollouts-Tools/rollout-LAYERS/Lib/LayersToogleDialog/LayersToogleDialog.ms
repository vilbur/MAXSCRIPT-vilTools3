/** Toggle layer visiblity
  *
  */
function toggleLayerVisiblity val =
(
	format "\n"; print "LayersToogleDialog_v.toggleLayerVisiblity()"
	--format "EventFired:	% \n" EventFired.Roll

	/* TOGGLE LAYER OF BUTTON CLICKED */
	if ( layer = LayerManager.getLayerFromName EventFired.Control.text ) != undefined then
		layer.on = not layer.on

	/* UPDATE OTHER BUTTONS */
	for control in DIALOG_toogle_layers.controls where classOf control == CheckButtonControl do
		--format "control:	% \n" control.text
		if ( layer = LayerManager.getLayerFromName control.text ) != undefined then
			 control.state = layer.on

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

	min_width	= 128,
	default_width	= 256,

	button_height = 32,
	/* dependency */
	LayersManager = LayersManager_v(),


	/* reference */
	/* inhered */

	/** Layers toogle dialog
	  *
	  */
	function create =
	(
		format "\n"; print "LayersToogleDialog.ms.layersToogleDialog()"
		--clearListener(); print("Cleared in:"+getSourceFileName())
		/* DIALOG */

		this._setSelectedLayers() -- after ini

		top_layers = this.LayersManager.getTopLayers( this.selected_layers )

		format "top_layers:	% \n" top_layers


		_Controls_Dialog   = Dialog.Controls() --group:layer.name

		_Button = _Controls_Dialog.control #button "Reload" across:2
		_Button.Events.add #pressed ("macros.run \"_Layers\" \"layers_manager_toogle_dialog\"")



		for layer in this.sortLayers(top_layers) do
			this.createControlsGroupForLayer(layer)(Dialog)

		--format "SELECTED_LAYERS:	% \n" selected_layers
		--format "Dialog.ini:	% \n" Dialog.ini
		--format "Dialog.width:	% \n" Dialog.width

		if Dialog.width != unsupplied then
			default_width = Dialog.width



		/* DIALOG CREATE */
		--Dialog.create()
		Dialog.create height:#auto lockWidth:false
		--Dialog.min_size = [-1, 128]


		--if Dialog.width == undefined then
		--Dialog.create width:default_width --lockWidth:false

		Dialog.register()
	),

	/** Create rollout for each top layer
	  *
	  */
	function createControlsGroupForLayer Layer _Rollout_parent =
	(
		--format "\n"; print "LayersToogleDialog_v.createControlsGroupForLayer()"

		/* ROLLOUTS */

		--/* CONTROLS */
		_Controls   = Dialog.Controls group:layer.name

		this.addLayerButton (_Controls) (layer)

		--/* CONTROLS */
		for child_layer in LayersManager.getChildren(layer) do
			this.addLayerButton (_Controls) (child_layer)


	),

	/** Add layer button
	  *
	  */
	function addLayerButton _Controls layer =
	(
		--format "\n"; print "LayersToogleDialog_v.addLayerButton()"
		--format "layer:	% \n" layer.name
		--format "layer:	% \n" layer.on
		--_Button = _Controls.control #button layer.name across:1 width:default_width height:this.button_height
		_Button = _Controls.control #checkbutton layer.name checked:layer.on across:1 width:default_width height:this.button_height

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

	private

	/** Set dialog
	  *
	  */
	function _setDialog =
	(
		--format "\n"; print "LayersToogleDialog_v._setDialog()"
		--format "this._getSceneBaseName():	% \n" (this._getSceneBaseName())
		ini_path = ( getDir #temp + "\\ini_files\\LayersToogleDialog\\"+ (this._getSceneBaseName()) + ".ini" )

		this.Dialog = Dialog_v ("Toogle Layers") width:min_width ini:ini_path

		this.Ini = this.Dialog.ini

	),
	/** Get selected layers
	  *
	  */
	function _setSelectedLayers =
	(
		--format "\n"; print "LayersToogleDialog_v._setSelectedLayers()"
		--format "this.Ini:	% \n" this.Ini
		layers_ini = this.Ini.keys "selected_layers"
		--format "layers_ini:	% \n" layers_ini

		if layers_ini.count == 0 then
		(
			this.selected_layers = LayersManager.getSelectLayersOrBySelection()

			for selected_layer in selected_layers do
				this.Ini.save "selected_layers" selected_layer.name true
		)
		else
			this.selected_layers = for layer_name in layers_ini where (layer = LayerManager.getLayerFromName layer_name ) != undefined collect layer


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
			this._setDialog()
		--else
		--	messageBox "NOTHING SELECTED\n\nSelect layer in layer manager\n\n\tor\n\n       some object" title:"Title"  beep:false

	)

)
