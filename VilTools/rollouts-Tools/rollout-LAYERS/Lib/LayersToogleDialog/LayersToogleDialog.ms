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

	/* properties */

	width = 256,

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
		Dialog = Dialog_v ("Toogle Layers") ini:(getSourceFileName())

		--format "Dialog.ini:	% \n" Dialog.ini
		format "Dialog.width:	% \n" Dialog.width

		if Dialog.width != undefined then
			width = Dialog.width


		/* ROLLOUTS */
		--_Rollouts	 = Dialog.Rollouts() --height:512
		--_Rollout    = Dialog.Roll "Subrollout" height:256


		/* CONTROLS */
		--_Controls   = _Rollout.Controls() --group:"Controls"
		_Controls   = Dialog.Controls() --group:"Controls"


		/* CONTROLS */
		for layer in this.selected_layers do
		(
			_Button = _Controls.control #button layer.name across:1 width:width height:64

			_Button.Events.add #pressed ("toggleLayerVisiblity") params:layer.name

		)
		--for layer in this._getVisibleLayers() do
			--format "layer.name:	% \n" layer.name


		/* DIALOG CREATE */
		--Dialog.create()
		Dialog.min_size = [-1,-1]
		Dialog.create width:width --lockWidth:false

		Dialog.register()
	),

	private


	/** Get visible layers
	  *
	  */
	function _getVisibleLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.getVisibleLayers()"

		for i = 0 to LayerManager.count - 1 where (layer = LayerManager.getLayer i).on collect layer --return

	),


	/**
	 */
	on create do
	(
		--format "\n"; print "LayersToogleDialog.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this.selected_layers = LayersManager.getSelectLayersOrBySelection()
		--format "this.selected_layers:	% \n" this.selected_layers

		if this.selected_layers.count > 0 then
			this.createDialog()
		else
			messageBox "NOTHING SELECTED\n\nSelect layer in layer manager\n\n\tor\n\n       some object" title:"Title"  beep:false


	)

)
