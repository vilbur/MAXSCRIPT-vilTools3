/** Toggle layer visiblity
  *
  */
function toggleLayerVisiblity layer_name =
(
	format "\n"; print "LayersToogleDialog_v.toggleLayerVisiblity()"
	--format "layer_name:	% \n" layer_name

	if ( layer = LayerManager.getLayerFromName layer_name ) != undefined then
		layer.on = not layer.on

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
	default_width = 256,

	/* dependency */
	LayersManager = LayersManager_v(),


	/* reference */
	/* inhered */

	/** Layers toogle dialog
	  *
	  */
	function createDialog =
	(
		format "\n"; print "LayersToogleDialog.ms.layersToogleDialog()"
		--clearListener(); print("Cleared in:"+getSourceFileName())
		/* DIALOG */

		this._setSelectedLayers() -- after ini

		--format "SELECTED_LAYERS:	% \n" selected_layers
		--format "Dialog.ini:	% \n" Dialog.ini
		--format "Dialog.width:	% \n" Dialog.width

		if Dialog.width != unsupplied then
			default_width = Dialog.width

		/* ROLLOUTS */
		--_Rollouts	 = Dialog.Rollouts() --height:512
		--_Rollout    = Dialog.Roll "Subrollout" height:256


		/* CONTROLS */
		--_Controls   = _Rollout.Controls() --group:"Controls"
		_Controls   = this.Dialog.Controls() --group:"Controls"


		/* CONTROLS */
		for layer in this.selected_layers do
		(
			_Button = _Controls.control #button layer.name across:1 width:default_width height:64

			_Button.Events.add #pressed ("toggleLayerVisiblity") params:layer.name

		)

		/* DIALOG CREATE */
		--Dialog.create()
		Dialog.min_size = [-1,-1]


		--if Dialog.width == undefined then
		Dialog.create width:default_width --lockWidth:false

		Dialog.register()
	),

	/** Reset selected layers
	  *
	  */
	function resetSelectedLayers =
	(
		format "\n"; print "LayersToogleDialog_v.resetSelectedLayers()"

		this.Ini.delete "selected_layers"
	),

	private

	/** Set dialog
	  *
	  */
	function _setDialog =
	(
		format "\n"; print "LayersToogleDialog_v._setDialog()"
		this.Dialog = Dialog_v ("Toogle Layers") ini:( getDir #temp + "\\ini_files\\LayersToogleDialog\\"+ (this._getSceneBaseName()) + ".ini" )

		this.Ini = this.Dialog.ini
	),
	/** Get selected layers
	  *
	  */
	function _setSelectedLayers =
	(
		--format "\n"; print "LayersToogleDialog_v._setSelectedLayers()"
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
			"deafault_scene"
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
