filein( getFilenamePath(getSourceFileName()) + "/layerDialogButtonCallback/layerDialogButtonCallback.ms" )	--"./layerDialogButtonCallback/layerDialogButtonCallback.ms"
filein( getFilenamePath(getSourceFileName()) + "/layerDialogButtonCallback/LayerToggleCallbacks.ms" )	--"./layerDialogButtonCallback/LayerToggleCallbacks.ms"

filein( getFilenamePath(getSourceFileName()) + "/layerDialogButtonCallback/openLayerRcMenu.ms" )	--"./layerDialogButtonCallback/openLayerRcMenu.ms"

global DIALOG_toogle_layers -- define global for use in callbacks

global LAYERS_TOOGLE_DIALOG

/** Layers toogle dialog
 */
struct LayersToogleDialog_v
(
	/* construct */
	layers,
	Dialog,

	/* properties */
	_SubRollouts,
	Ini,

	default_width	= 196,

	button_height = 36,

	--left_padding	= 8, -- less size of how nested buttonn
	left_padding	= 10, -- less size of how nested buttonn
	height_offset	= 2, -- less size of how nested buttonn


	--top_layer_suffix = "⬇", -- ▼
	top_layer_suffix = "▼", -- ▼

	/* dependency */
	LayersManager = LayersManager_v(), --"./../LayersManager/LayersManager.ms"

	RegEx = ( dotNetClass "System.Text.RegularExpressions.RegEx" ),

	IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase,

	layer_ids = #(),

	/* reference */
	/* inhered */

	/** Layers toogle dialog
	  *
	  * @param array	layers used for dialog, if unsupplied, then layers are determine by layer manager or selected objects
	  * @param boolean  	chain  FALSE:use only selected layers   TRUE: use whole chain up to top layer
	  *
	  */
	function create layers: chain:false reset_layers:false =
	(
		format "\n"; print "LayersToogleDialog_v.create()"
		format "LAYERS: %\n" layers
		--clearListener(); print("Cleared in:"+getSourceFileName())
		if reset_layers then
			this.resetLayers()

		this.setLayerIds()

		if layers == unsupplied then
		(
			this.layers = if Ini.isDefined() and (layers_ini = this.getLayersFromIni()).count > 0 then
				layers_ini --return

			else if (layers_selected = LayersManager.getSelectedLayers()) != undefined and layers_selected.count > 1 then
				layers_selected

			else
				LayersManager.getAllLayers()
		)

		if chain then
			this.layers = LayersManager.getLayersTree(this.layers)

		this.checkLayerNames()
		format "LAYERS: %\n" this.layers
		format "LAYERS name: %\n" this.layers[1].name
		this.saveLayerToIni()

		--format "\n-----------\nARRAY:layers:\n";  for layer in layers do format "layer:	%\n" layer.name

		top_layers = this.LayersManager.getTopLayers( this.layers ) -- get top layers for group control
		--format "top_layers name: %\n" top_layers[1].name

		this.layers = this.difference( this.layers )( top_layers )

		--format "LAYERS name: %\n" this.layers[1].name

		/* MIAN CONTROLS */
		this._createMainControls (Dialog.Controls())

        /* ADD ROLLOUT FOR EACH TOP LAYER */
        _SubRollouts = Dialog.Rollouts()

		--Dialog.Events.add #open  "print @#OPEN@"
		--Dialog.Events.add #close "print @#CLOSE@"

		/* LAYER BUTTONS */
		for top_layer in this.sortLayers(top_layers) do
			this.createRolloutForTopLayer(top_layer)


		/* DIALOG CREATE */
		--Dialog.create()
		Dialog.create height:#AUTO

		Dialog.register()

		--startUpdateDialogTimer()
	),

	/** Add layers
	 */
	function addLayers add_layers chain:false  =
	(
		--format "\n"; print "LayersToogleDialog_v.addLayers()"
		--format "this.layers: %\n" this.layers
		this.layers =  makeUniqueArray ( join this.layers add_layers)

		if chain then
			this.layers = LayersManager.getLayersTree(this.layers)

		this.checkLayerNames()

		top_layers = this.LayersManager.getTopLayers( this.layers ) -- get top layers for group control

		--_subrollouts = DIALOG_toogle_layers.Subrollouts.Rollouts

		--_subrollout_names = for _subrollout in _subrollouts collect _subrollout.name

		--format "top_layers: %\n" top_layers
		--format "_subrollouts: %\n" _subrollouts
		--format "_subrollout_names: %\n" _subrollout_names

		for top_layer in this.sortLayers(top_layers)  do
			this.createRolloutForTopLayer(top_layer)

		for _SubRollout in _SubRollouts.Rollouts do
		--format "_SubRollout: %\n" _SubRollout
			Dialog.updateRollout(_SubRollout)

	),

	/** CREATE ROLLOUTS
	 */
	function createRolloutForTopLayer top_layer =
	(
		--format "\n"; print "LayersToogleDialog_v.createRolloutForTopLayer()"
		--format "top_layer: %\n" top_layer.name

		layer_index = LayersManager.getLayerIndex(top_layer)

		_SubRollout    = _SubRollouts.Roll ( this.sanitazeName(top_layer.name)) rolledUp:( not top_layer.on) id:("layer_id_"+(this._getLayerId (top_layer) as string ))
		--format "_SubRollout: %\n" _SubRollout

        _SubRollout.Events.add #ROLLEDUP ("layerDialogButtonCallback val "+layer_index as string ) --tooltip:tooltip_button --params:layer.name

		--_SubRollout.Events.add #ROLLEDUP	"print(\"#ROLLEDUP\")"
		--_SubRollout.Events.add #OPEN	"print(\"#OPEN\")"
		--_SubRollout.Events.add #CLOSE	"print(\"#CLOSE\")"

		_Controls   = _SubRollout.Controls() --group:(this.sanitazeName(top_layer.name))

		/* BUTTONS FOR NESTED LAYERS */
		this._createButtonForNestedLayers (_Controls) (top_layer) --level:0
	),

	/** ADD LAYER BUTTONS
	  *
	  */
	function _createButtonForNestedLayers _Controls parent_layer level:1 children_layers: =
	(
		--format "\n"; print "LayersToogleDialog_v._createButtonForNestedLayers()"
		--format "parent_layer:	% \n" parent_layer

        function _getChildreLayers parent_layer = for child_layer in this.LayersManager.getChildren(parent_layer) where findItem this.layers child_layer > 0 collect child_layer

		btn_base_width = this.default_width - this.left_padding  - 20

		--if children_layers == unsupplied then
			children_layers = _getChildreLayers (parent_layer)

		--if level == 1 then /* BUTTON FOR TOP LAYER - if child any child layer exists  */
		--	--format "PARENT_LAYER: %\n" parent_layer
		--	this.addLayerUiControls (_Controls) (parent_layer) width:(this.default_width - 32 ) height:20 offset:[ 0, -8 ] is_top_layer:true
		--
		/*------------------------------------------------------------------------------
			BUTTON FOR TOP LAYER - if child any child layer exists
		--------------------------------------------------------------------------------*/
		if level == 1 then
			this.addLayerUiControls (_Controls) (parent_layer) width:(this.default_width - 32 ) height:20 offset:[ 0, -8 ] is_top_layer:true

		/*------------------------------------------------------------------------------
			BUTTON FOR EACH LAYER
		--------------------------------------------------------------------------------*/
		if children_layers.count > 0 then
		(
			for child_layer in this.sortLayers (children_layers) do
			(
				offset = if level == 1 then [ 0, 6 ] else [ 0, 0 ]

				children_layers = _getChildreLayers (child_layer)

				this.addLayerUiControls (_Controls) (child_layer) width:(btn_base_width - (level * this.left_padding )) height:(this.button_height - (level * this.height_offset)) parent_layer:parent_layer offset:offset add_suffix_arrow:(children_layers.count  > 0)

				this._createButtonForNestedLayers (_Controls) (child_layer) level:(level + 1) children_layers:children_layers
			)
		)
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
		format "\n"; print "LayersToogleDialog_v.refreshButtons()"
		--for roll in DIALOG_toogle_layers.Subrollouts.Rollouts do
		--	for control in roll.controls where classOf control == CheckButtonControl and (layer = this._getLayerByControl (control)) != undefined do
		--		control.state = layer.on
	),

	/*------------------------------------------------------------------------------

		ADD LAYER CONTROLS

	--------------------------------------------------------------------------------*/
	function addLayerUiControls _Controls layer parent_layer: width: height:this.button_height offset:[0,0] is_top_layer:false add_suffix_arrow:false =
	(
		--format "\n"; print "LayersToogleDialog_v.addLayerUiControls()"
		--format "LAYER.name:	% \n" layer.name
		--format "LAYER.on:	% \n" layer.on

		fn getDisplayWirecolorState layer =( layer.nodes &theNodes; if theNodes.count > 0 then theNodes[1].colorByLayer else true )

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
		--format "LAYER_INDEX: %\n" layer_index

		LayerToggleCallbacks = "(LayerToggleCallbacks_v(" + layer_index as string + "))"

		button_pressed = if is_top_layer then "topLayerButtonCallback" else "layerDialogButtonCallback"
		--button_pressed = if is_top_layer then (LayerToggleCallbacks + ".toggleDisplayAsLayer") else "layerDialogButtonCallback"

		tooltip_top_layer = "SHOW \ HIDE objects in "+button_caption

        tooltip_button     = "Toggle layer visibility.\n\nRemote All nested \n\nLMB+CRL: Select objects in layer."
        tooltip_button_rc     = "Open Menu\n\nRMB+CTRL: Toggle wireframe object\Layer."

		picker_offset = if is_top_layer then [ 20, -24 ] else [ 20, (height * -1) - 4 ]


		if is_top_layer or add_suffix_arrow then
			button_caption += " " + top_layer_suffix


		/* LAYER CHECKBUTTON  */
		_Button = _Controls.control #CHECKBUTTON button_caption id:("layer_id_"+layer_index as string ) checked:layer.on ini:false across:1 height:height align:#RIGHT width:width offset:offset tooltip:"SHIFT: USE NESTED LAYERS IN TOOLS"

		/* COLOR PICKER  */
        _Picker = _Controls.control #COLORPICKER "" id:("CLR_layer_id_"+layer_index as string ) params:#(#color, layer.wirecolor  ) visible:(getDisplayWirecolorState layer) across:1 align:#RIGHT offset:picker_offset width:24 height:height


		/* BUTTON EVENTS */
        _Button.Event #CHANGED (button_pressed + " val "+layer_index as string ) tooltip:( if is_top_layer then tooltip_top_layer else tooltip_button ) --params:layer.name

        _Button.Event #RIGHTCLICK ("if not keyboard.controlPressed then openLayerRcMenu("+layer_index as string +")\n else\n "+LayerToggleCallbacks+".toggleDisplayAsLayer HIERARCHY:keyboard.shiftPressed" ) tooltip:tooltip_button_rc -- params:#( layer_index )	tooltip:"Open Menu\n\nALT: Display wireframe by OBJECT\LAYER"

		/* PICKER EVENTS */
		--_Picker.Event #CHANGED (LayerToggleCallbacks+".setLayerWirecolorOnPickerChanged(val)") --params:#( layer_index )
		_Picker.Event #CHANGED (LayerToggleCallbacks+".setLayerWirecolorOnPickerChanged") --params:#( layer_index )
		--_Picker.Event #CHANGED ( "print ") params:#( layer_index )
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
		--format "\n"; print "LayersToogleDialog_v.getLayersFromIni()"
		--format "this.Ini:	% \n" this.Ini
		/** Get layer by index
		 */
		function getLayerByIndex layer_name =
		(
			--format "\n"; print "LayersToogleDialog_v.getLayerByIndex()"
			index	= this.Ini.load "layers" layer_name

			layer_by_index = LayerManager.getLayer index

			if not ( layer_by_index != undefined and this.Ini.load "layers" layer_by_index.name == undefined ) then
				format "LayersToogleDialog:LAYER NOT FOUND: %\n" layer_name

			layer_by_index --return
		)


		layers = #()

		--format "TEST: %\n" (this.Ini.keys "layers")

		for layer_name in this.Ini.keys "layers" where layer_name != "" do
		(
			if ( layer = LayerManager.getLayerFromName layer_name) == undefined then
				layer = getLayerByIndex( layer_name )

			if layer != undefined then
				appendIfUnique layers layer
		)

		--format "layers.count: %\n" layers.count

		layers --return
	),

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

	/** Create main controls
	  *
	  */
	function _createMainControls _Controls =
	(
		--format "\n"; print "LayersToogleDialog_v._createMainControls()"

		/** Get tooltip
		  *
		  */
		function getTooltip button_type = "ON\OFF layer.\n\nCRL: Select displayed layers in "+button_type+".\n\nSHIFT:Select all layers in "+button_type

		buttons_in_row = 2

		width = ( (this.default_width - 6)  / buttons_in_row ) as integer

        _Controls.Default #across buttons_in_row

        --_Controls.Default #WIDTH width
        _Controls.Default #HEIGHT 32
        _Controls.Default #BORDER false
        --_Controls.Default #OFFSET [ 0, -8 ]


	    /* "LAYERS" BUTTON  */
        LayerManagerBtn = _Controls.Control #BUTTON "LAYERS" width:width offset:[ -6, 0 ]

        LayerManagerBtn.Event #PRESSED "if LayerManager.isDialogOpen() then LayerManager.closeDialog() else LayerManager.editLayerByName \"\"" tooltip:"Open Close Layer Manager"

		/* "SYNC" BUTTON  */
        sync_button = _Controls.Control #BUTTON "SYNC" width:width offset:[ 6, 0 ]

        sync_button.Event #PRESSED    "syncWithLayerManager" params:#(#DIALOG_TO_MANAGER) tooltip:""
        sync_button.Event #RIGHTCLICK "syncWithLayerManager" params:#(#MANAGER_TO_DIALOG) tooltip:""

        /* "DIALOG" BUTTON  */
        dialog_button = _Controls.Control #CHECKBUTTON "DIALOG" tooltip:(getTooltip("dialog")) width:width offset:[ -6, -6 ]

        dialog_button.Event #CHANGED    "layerDialogButtonCallback" params:#dialog	tooltip:"Toggle all layers in dialog"
        dialog_button.Event #RIGHTCLICK "layerDialogButtonCallback" params:#(false, #dialog)	tooltip:"Hide all layers in dialog"


        /* "OTHERS" BUTTON  */
        others_button = _Controls.Control #CHECKBUTTON "OTHERS" tooltip:(getTooltip("not in dialog")) width:width offset:[ 6, -6 ]

        others_button.Event #CHANGED    "layerDialogButtonCallback" params:#others          	tooltip:"Toggle all layers not in dialog"
        others_button.Event #RIGHTCLICK "layerDialogButtonCallback" params:#(false, #others)	tooltip:"Hide all layers not in dialog"


		/* HUE SLIDER */
		hue_slider = _Controls.Control #SLIDER "[hue slider]" across:1 range:[0,255,0] width:this.default_width offset:[ -8, 0 ] ini:false type:#INTEGER ticks:0 tooltip:"Change `HUE` of selected layer`s wirecolor\n\nCTRL: Change `SATURATION`\n\nSHIFT: Change `BRIGHTNESS`"
        hue_slider.Event #CHANGED "tuneHueOfLayerRecolor"

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


	/** Get layer by control
	  *
	  */
	function _getLayerByControl _Control =
	(
		--format "\n"; print "LayersToogleDialog_v._getLayerByControl()"
		id_split = filterString ( _Control.name as string ) "_"

		layer_id =  id_split[id_split.count] as integer

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
		this.Dialog = Dialog_v ("Toogle Layers") ini:ini_file width:this.default_width
	 ),

	/** Get visible layers
	  *
	  */
	function _getVisibleLayers =
	(
		--format "\n"; print "LayersToogleDialog_v.getVisibleLayers()"
		for i = 0 to LayerManager.count - 1 where (layer = LayerManager.getLayer i).on collect layer --return
	),

	/** Get layers array
	 */
	function getLayersArray =
	(
		--format "\n"; print "LayersToogleDialog_v.getLayersArray()"

		for i = 0 to LayerManager.count - 1 collect if (layer = LayerManager.getLayer i).on then layer else undefined
	),

	/** Get visible layers
	 */
	function _getVisibleLayersBitArray =
	(
		--format "\n"; print "LayersToogleDialog_v._getVisibleLayers()"
		(for i = 0 to LayerManager.count - 1 where (layer = LayerManager.getLayer i).on collect i) as BitArray --return
	),

	/** Check layer names
	 */
	function checkLayerNames =
	(
		--format "\n"; print "LayersToogleDialog_v.checkLayerNames()"
		for i = this.layers.count to 1 by -1 where matchPattern this.layers[i].name pattern:("*=*") do
		(
			--messageBox ("Layer name MUST NOT contain \"=\"\n\nWRONG LAYER NAME:\n\n"+this.layers[i].name) title:"LayersToogleDialog_v"
			if queryBox ("Layer name MUST NOT contain \"=\"\n\nWRONG LAYER NAME:\n\n"+this.layers[i].name+"\n\nREPLACE \"=\" with \"-\"") title:"LayersToogleDialog_v" then
			(
				layer = this.layers[i]

				layer_renamed =  ( dotNetObject "System.Text.RegularExpressions.Regex" "=" ).Replace layer.name "—"

				layer.setName layer_renamed
			)

			deleteItem this.layers i
		)
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


	/** Set layer ids
	 */
	function setLayerIds =
	(
		--format "\n"; print "LayersToogleDialog_v.setLayerIds()"
		layer_ids = for i = 0 to LayerManager.count - 1 collect (LayerManager.getLayer i ).name --return
	),

	/** Get layer id
	 */
	function _getLayerId layer =
	(
		--format "\n"; print "LayersToogleDialog_v._getLayerId()"
		(findItem layer_ids (layer.name)) - 1
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
