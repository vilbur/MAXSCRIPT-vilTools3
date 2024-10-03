filein( getFilenamePath(getSourceFileName()) + "/layerDialogButtonCallback/layerDialogButtonCallback.ms" )	--"./layerDialogButtonCallback/layerDialogButtonCallback.ms"

global DIALOG_toogle_layers -- define global for use in callbacks

/** Layers toogle dialog
 */
struct LayersToogleDialog_v
(
	/* construct */
	layers,
	Dialog,

	/* properties */
	Ini,

	default_width	= 196,

	button_height = 36,

	left_padding	= 8, -- less size of how nested buttonn
	height_offset	= 2, -- less size of how nested buttonn

	tooltip_layer = "CRL: Select objects in layer. \nSHIFT:Select children layers. \nCRL + SHIFT: Select objects in all nested layers",

	/* dependency */
	LayersManager = LayersManager_v(), --"./../LayersManager/LayersManager.ms"

	RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" ),

	IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase,


	/* reference */
	/* inhered */

	/** Layers toogle dialog
	  --*
	  */
	function create layers: =
	(
		format "\n"; print "LayersToogleDialog_v.create()"
		format "LAYERS: %\n" layers
		--clearListener(); print("Cleared in:"+getSourceFileName())

		if layers == unsupplied then
		(
			this.layers = if Ini.isDefined() and (layers_ini = this.getLayersFromIni()).count > 0 then
				layers_ini --return

			else if (layers_selected = LayersManager.getSelectedLayers()) != undefined then
				layers_selected

			else
				LayersManager.getAllLayers()
		)


		--if selection.count > 0 then
		----this.layers = LayersManager.getAllLayers()
		--this.layers = LayersManager.getSelectedLayers()
		--else
		--this.layers = this.getLayersFromIni()


		format "LAYERS: %\n" layers
		this.saveLayerToIni()

		--format "\n-----------\nARRAY:layers:\n";  for layer in layers do format "layer:	%\n" layer.name

		top_layers = this.LayersManager.getTopLayers( this.layers ) -- get top layers for group control

		this.layers = this.difference( this.layers )( top_layers )

		--this.default_width = Dialog.width - 3

		this.default_width += 64

		Dialog.width = this.default_width

		/* MIAN CONTROLS */
		this._createMainControls (Dialog.Controls())

		_SubRollouts	 = Dialog.Rollouts()

		/* LAYER BUTTONS */
		for top_layer in this.sortLayers(top_layers) do
			this.createRolloutForTopLayer(top_layer)(_SubRollouts)


		/* DIALOG CREATE */
		--Dialog.create height:undefined lockWidth:false
		--format "THIS.DEFAULT_WIDTH: %\n" this.default_width
		Dialog.create width:this.default_width height:undefined lockWidth:false

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
		function getTooltip button_type = "ON\OFF layer.\n\nCRL: Select displayed layers in "+button_type+".\n\nSHIFT:Select all layers in "+button_type+".\n\n"

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

		/* BUTTONS FOR NESTED LAYERS */
		this._createButtonForNestedLayers (_Controls) (layer) level:2
	),

	/** Create rollout for top layer
	 */
	function createRolloutForTopLayer top_layer _SubRollouts =
	(
		--format "\n"; print "LayersToogleDialog_v.createRolloutForTopLayer()"

		_SubRollout    = _SubRollouts.Roll ( this.sanitazeName(top_layer.name))

		_SubRollout.Events.add #open	"print(\"Custom dialog event #open\")"
		_SubRollout.Events.add #close	"print(\"Custom dialog event #close\")"

		_Controls   = _SubRollout.Controls() --group:(this.sanitazeName(top_layer.name))

		/* BUTTON FOR TOP LAYER */
		--this.addLayerButton (_Controls) (top_layer) width:(this.default_width - 16)

		/* BUTTONS FOR NESTED LAYERS */
		this._createButtonForNestedLayers (_Controls) (top_layer) level:1
	),

	/** Create button for neste layers
	  *
	  */
	function _createButtonForNestedLayers _Controls parent_layer level: =
	(
		--format "\n"; print "LayersToogleDialog_v._createButtonForNestedLayers()"
		--format "parent_layer:	% \n" parent_layer
		level +=1

		if (children_layers = (LayersManager.getChildren(parent_layer))).count > 0 then
		(
			/* BUTTONS */
			for child_layer in this.sortLayers (children_layers) do
			(
				--level +=1
				--format "child_layer:	% \n" child_layer.name
				--format "CHILD_LAYER:	% \n" child_layer
				if ( findItem this.layers child_layer ) > 0 then
					this.addLayerButton (_Controls) (child_layer) width:(this.default_width - (level * this.left_padding)) height:(this.button_height - (level * this.height_offset)) parent_layer:parent_layer

				this._createButtonForNestedLayers (_Controls) (child_layer) level:(level)
			)
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
			this._rxReplace (layer_name) ("^[^a-zA-Z]*(.*?(?=[^a-zA-Z0-9]+$)).*$") ("$1") -- strip special character from left and right side of layer name
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

			search = ("[\s_-]*"+ this.sanitazeName(top_layer.name) + "[\s_-]*$")

			this._rxReplace (child_layer_name) (search) ""
		)

		button_caption = if parent_layer == unsupplied then this.sanitazeName(layer.name) else removeParentLayerName(parent_layer)(layer.name)

		layer_index = LayersManager.getLayerIndex(layer)
		--format "LAYER_INDEX:	% \n" layer_index

		_Button = _Controls.control #checkbutton button_caption id:("layer_id_"+layer_index as string ) checked:layer.on ini:false across:1 width:(width - 16) height:height align:#right ini:false--offset:[0,0]

		--_Button.Event #changed ("layerDialogButtonCallback") params:layer_index tooltip:tooltip_layer --params:layer.name
		_Button.Event #changed ("layerDialogButtonCallback val "+layer_index as string ) tooltip:tooltip_layer --params:layer.name

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

	/** Get layers from ini
	  *
	  */
	function getLayersFromIni =
	(
		format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
		--format "this.Ini:	% \n" this.Ini
		/** Get layer by index
		 */
		function getLayerByIndex layer_name =
		(
			--format "\n"; print "LayersToogleDialog_v.getLayerByIndex()"
			index	= this.Ini.load "layers" layer_name

			layer_by_index = LayerManager.getLayer index

			--format "LAYER_BY_INDEX: % %\n" layer_by_index.name layer_by_index
			--format "TEST: %\n" (this.Ini.load "layers" layer_by_index.name)

			 if this.Ini.load "layers" layer_by_index.name == undefined then
				layer_by_index --return
			else
				format "LayersToogleDialog:LAYER NOT FOUND: %\n" layer_name

		)


		layers = #()

		for layer_name in this.Ini.keys "layers" do
		(
			if ( layer = LayerManager.getLayerFromName layer_name) == undefined then
				layer = getLayerByIndex( layer_name )

			if layer != undefined then
				appendIfUnique layers layer
		)

		--format "LAYERS: % --return\n" layers

		layers --return
	),

	--/** Get selected layers
	--  *
	--  */
	--function getSelectedLayers =
	--(
	--	--format "\n"; print "LayersToogleDialog_v.getSelectedLayers()"
	--	LayersManager.getSelectedLayers() --return
	--),


	/** Get selected layers
	  *
	  */
	function getIniOrSelected =
	(
		--format "\n"; print "LayersToogleDialog_v.getIniOrSelected()"
		--format "this.Ini:	% \n" this.Ini
		--format "layers_ini:	% \n" layers_ini

		if (layers_ini = this.getLayersFromIni()).count == 0 then
			LayersManager.getSelectedLayers()

		else
			layers_ini --return

	),

	/** Differrence layer
	  *
	  */
	function difference arr_1 arr_2 =
	(
		--format "\n"; print "LayersToogleDialog_v.differrenceLayer()"
		this.LayersManager.difference( arr_1 )( arr_2 )
	),

	/** Save layer to ini
	  *
	  */
	function saveLayerToIni =
	(
		--format "\n"; print "LayersToogleDialog_v.saveLayerToIni()"
		this.Ini.delete "layers"

		layers_index	= LayersManager.getLayersIndex(layers)
		--format "LAYERS_INDEX: %\n" layers_index

		for i = 1 to layers.count do
			this.Ini.save "layers" layers[i].name layers_index[i]
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
		ini_file = ( getDir #temp + "\\ini_files\\LayersToogleDialog\\"+ (this._getSceneBaseName()) + ".ini" )

		--format "ini_file:	% \n" ini_file
		this.Dialog = Dialog_v ("Toogle Layers") ini:ini_file

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
		if maxFileName != "" then
		(
			matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches maxFileName "(.*[^0-9]+)(\d+)*\.max" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

			match	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))[1] --return

			trimRight match[2] "-" --return
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

	/** Regex is match
	  *
	  * @return boolean
	  */
	function _rxIsMatch _string pattern ignore_case:true =
	(
		if ignore_case then RegEx.isMatch _string pattern IgnoreCase else  RegEx.isMatch _string pattern
	),

	/** Regex get match
	  */
	function _rxGetMatch _string pattern ignore_case:true =
	(
		matches = if ignore_case then RegEx.matches _string pattern IgnoreCase else  RegEx.matches _string pattern

		groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return

		if groups.count == 1 then groups[1] else groups
	),

	/** Regex replace
	  */
	function _rxReplace _string _search _replace ignore_case:true =
	(
		RegExReplace = if ignore_case then ( dotNetObject "System.Text.RegularExpressions.Regex" _search IgnoreCase ) else ( dotNetObject "System.Text.RegularExpressions.Regex" _search )

		RegExReplace.Replace _string _replace
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "LayersToogleDialog.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		this._setDialog()

		this.Ini = this.Dialog.Ini
	)

)
