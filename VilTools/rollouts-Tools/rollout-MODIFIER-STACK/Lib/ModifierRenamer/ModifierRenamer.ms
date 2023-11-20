/** Rename modifiers based on their values
 */
struct ModifierRenamer_v
(
	/* construct */

	/* properties */
	modObject,

	/* dependency */
	/* reference */
	/* inhered */

	/** Get name
	  *
	  */
	function generateName =
	(
		--format "\n"; print "ModifierRenamer_v.generateName()"
		format "classOf modObject:	% \n" (classOf this.modObject)

		this._printModProperties()

		case classOf this.modObject of
		(
			Edit_Poly:	"EPoly"
			SliceModifier:	this._SliceModifier()
			Poly_Select:	this._PolySelect()
			Vol__Select:	this._VolSelect()
			Chamfer:	this._Chamfer()
			Smooth:	this._Smooth()
			Face_Extrude:	"Extrude"
			DeleteMesh:	"Delete"
			Materialmodifier:	"Mat ID " + this.modObject.materialID as string
			FFDBox:	"FFDBox"
			FFD_2x2x2:	"FFD2"
			SplineOffset:	this._SplineOffset()
			Meshsmooth:	this._Meshsmooth()

			default: this.modObject.name
		)
	),

	/** Rename dialog
	  *
	  * @param boolean generate modifier name, current name is used if false or default name
	  */
	function renameDialog generate:true =
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		default_text = if generate then this.generateName() else modObject.name


		_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" default_text
		_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"

		_dotNet.ShowModal()

		_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
		_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )

		if( _ok and (_string = _dotNet.InstanceName) != ""  ) then
			modObject.name = _string
	),

	private

	/** Chamfer
	  *
	  */
	function _Chamfer =
	(
		format "\n"; print "ModifierRenamer_v.chamfer()"
		chamfer_name = "Chamfer"

		selection_option = case this.modObject.selectionoption of
			(
				0: "Sel"
				1: "Sel Edge"
				2: "Sel Face Edge"
				3: "Sel Face Broder"
				4: "Sel Edge Verts"
				5: "All Edges"
				6: "Sel Verts"
				7: "All Verts"
			)

		smooth_type = case this.modObject.SmoothType of
			(
				0: ""
				1: "Smooth"
				1: "Hard"
			)

		material_option = case this.modObject.materialoption of
			(
				0: ""
				1: "Diff Mat"
				1: "Same Mat"
			)

		for val in #( selection_option, smooth_type, material_option  ) where val != "" do chamfer_name += " " + val

		ammount = this.convertToDisplayUnits(this.modObject.amount)

		chamfer_name +=  " " + (if ammount as integer == ammount then ammount as integer else ammount) as string
		--format "chamfer_name:	% \n" chamfer_name

		chamfer_name --return
	),

	/** Extrude
	  */
	function _SliceModifier =
	(
		--format "\n"; print "ModifierRenamer_v._SliceModifier()"

		--format "modObject.Slice_Type:	% \n" modObject.Slice_Type
		mod_name = ""


		mod_name += case this.modObject.Slice_Type of
		(
			0: "Refine"
			1: "Split"
			2: "Remove Positive"
			3: "Remove Negative"
		)

		if this.modObject.cap then
			mod_name += " Cap"

		mod_name --return

	),

	/** Name based on subobject level selected and material if not ID 1
	  * @return E.g.: "Select Face Mat 1"
	  */
	function _PolySelect =
	(
		--format "\n"; print "ModifierRenamer_v._PolySelect()"

		--format "\n-----------\nDICTIONARY:preset_values:%\n" (mod_values = this._printModProperties()); for data_pair in mod_values do format "%:	%\n" data_pair.key data_pair.value

		--format "subObjectLevel:	% \n" subObjectLevel
		mod_name = "Select"

		mod_name += case subObjectLevel of
		(
			1: " Verts"
			2: " Edge"
			3: " Border"
			4: " Face"
			5: " Element"

			default:	""
		)

		if (mat_id = this.modObject.materialID) > 1 then
			mod_name += " Mat ID " + mat_id as string

		mod_name --return

	),
	/** Name based on subobject level selected and material if not ID 1
	  * @return E.g.: "Select Face Mat 1"
	  */
	function _VolSelect =
	(
		--format "\n"; print "ModifierRenamer_v._VolSelect()"
		--format "\n-----------\nDICTIONARY:preset_values:%\n" (mod_values = this._getModProperties()); for data_pair in mod_values do format "%:	%\n" data_pair.key data_pair.value

		--format "subObjectLevel:	% \n" subObjectLevel
		mod_name = "VolSel "

		/** Get texture name
		  *
		  */
		function getTextureName map =
		(
			--format "\n"; print "ModifierRenamer_v.getTextureName()"
			if classOf map != Bitmaptexture then
			(
				string_split	= filterString (map as string )  ":"

				string_split[string_split.count]
			)
			else
				filenameFromPath(map.filename)
		)

		/* STACK SELECTIONM LEVEL */

		if this.modObject.volume != 3 then -- if not by object
			mod_name += case modObject.level of
			(
				0: " Object"
				1: " Vertex"
				2: " Face"
				default:	""
			)


		/* INVERT */
		--mod_name += if this.modObject.invert then " not" else ""


		/* SELECT BY */
		if modObject.level > 0 then -- if not "object" mode
			mod_name += case modObject.volume of
			(
				0: " by Box"
				1: " by Sphere"
				2: " by Cylinder"
				3: " by "    + modObject.node.name -- by object
				4: " by "    + getTextureName(modObject.texture) + ( if modObject.mapChannel > 1 then " "+ modObject.mapChannel as string else "" )
				5: " ID " + modObject.matID	as string
				6: " SG " + modObject.smGroup	as string

				default:	""
			)

		/* INVERT */
		mod_name += if this.modObject.invert then " [invert]" else ""

		--format "MOD_NAME:	% \n" mod_name
		mod_name --return
	),
	/* Get mod propertiees
	  *
	  * For development
	  */
	function _printModProperties =
	(
		--format "\n"; print "ModifierRenamer_v._printModProperties()"
		mod_values	= Dictionary()

		for prop in getPropNames modObject do
		(
			if ( val = getProperty modObject prop ) != undefined then
			(
				--format "%:	% \n" prop val
				classof_val = superClassOf val

				if classof_val == Number or classof_val == value then
					mod_values[prop] = val
			)
		)

		format "\n-----------\nDICTIONARY:preset_values:%\n" mod_values; for data_pair in mod_values do format "%:	%\n" data_pair.key data_pair.value

		mod_values --return
	),

	/** Convert to display units
	  */
	function convertToDisplayUnits val  =
	(
		val = case units.SystemType of -- convert to milimeters
		(
			#centimeters:	val * 10
			#meters:	val * 1000
			#kilometers:	val * 1000000
			default:	val -- mnilimeters or non metric units
		)

		val = case units.MetricType of -- convert to dispaly units
		(
			#centimeters:	val / 10
			#meters:	val / 1000
			#kilometers:	val / 1000000
			default:	val -- mnilimeters or non metric units
		)
		val --return
	),

	/**  meshsmooth
	  *
	  */
	function _Meshsmooth =
	(
		--format "\n"; print "ModifierRenamer_v._Meshsmooth()"
		mod_name = "Meshsmooth"

		if this.modObject.iterations >= 2 then
			mod_name += " " + this.modObject.iterations  as string

		mod_name --return
	),

	/**  Smooth
	  */
	function _Smooth =
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		format "\n"; print "ModifierRenamer_v._Smooth()"

		 if this.modObject.autosmooth then
		 (


			threshold = if matchPattern ((threshold = this.modObject.threshold) as string ) pattern:"*.0" then threshold as integer else threshold -- remove float if not needed

			"AutoSmooth " + 	threshold as string + "°"
		 )

		else if this.modObject.smoothingBits == 0 then
			"Unsmooth"

		else
			"Smooth"
	),


	/**  spline offset
	  *
	  */
	function _SplineOffset =
	(
		--format "\n"; print "ModifierRenamer_v._SplineOffset()"

		mod_name = "Offset"


		mod_name --return

	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ModifierRenamer.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
