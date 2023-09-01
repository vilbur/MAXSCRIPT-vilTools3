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
		--format "classOf modObject:	% \n" (classOf this.modObject)

		this._getModProperties()

		case classOf this.modObject of
		(
			Edit_Poly:	"EPoly"
			SliceModifier:	this._SliceModifier()
			Poly_Select:	this._PolySelect()
			Vol__Select:	this._VolSelect()
			Face_Extrude:	"Extrude Face"
			Materialmodifier:	"Mat ID " + this.modObject.materialID as string
			FFDBox:	"FFDBox"
			FFD_2x2x2:	"FFD2"

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

	/** Extrude
	  *
	  */
	function _SliceModifier =
	(
		--format "\n"; print "ModifierRenamer_v._SliceModifier()"

		--format "modObject.Slice_Type:	% \n" modObject.Slice_Type

		case this.modObject.Slice_Type of
		(
			0: "Refine"
			1: "Split"
			2: "Remove Positive"
			3: "Remove Negative"
		)
	),

	/** Name based on subobject level selected and material if not ID 1
	  * @return E.g.: "Select Face Mat 1"
	  */
	function _PolySelect =
	(
		--format "\n"; print "ModifierRenamer_v._PolySelect()"

		--format "\n-----------\nDICTIONARY:preset_values:%\n" (mod_values = this._getModProperties()); for data_pair in mod_values do format "%:	%\n" data_pair.key data_pair.value

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
		mod_name += case modObject.level of
		(
			0: " Object"
			1: " Vertex"
			2: " Face"
			default:	""
		)

		/* SELECT BY */
		if modObject.level > 0 then -- if not "object" mode
			mod_name += case modObject.volume of
			(
				0: " by Box"
				1: " by Sphere"
				2: " by Cylinder"
				3: " by "    + modObject.node.name
				4: " by "    + getTextureName(modObject.texture) + ( if modObject.mapChannel > 1 then " "+ modObject.mapChannel as string else "" )
				5: " by ID " + modObject.matID	as string
				6: " by SG " + modObject.smGroup	as string

				default:	""
			)

		--format "MOD_NAME:	% \n" mod_name
		mod_name --return
	),
	/** Get mod propertiees
	  *
	  * For development
	  */
	function _getModProperties =
	(
		--format "\n"; print "ModifierRenamer_v._getModProperties()"
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

		--format "\n-----------\nDICTIONARY:preset_values:%\n" mod_values; for data_pair in mod_values do format "%:	%\n" data_pair.key data_pair.value

		mod_values --return
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
