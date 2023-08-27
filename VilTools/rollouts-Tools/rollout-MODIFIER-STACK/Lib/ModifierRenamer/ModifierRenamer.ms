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
	function getName modObject =
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		format "\n"; print "ModifierRenamer_v.getName()"
		format "classOf modObject:	% \n" (classOf modObject)

		--format "\n-----------\nDICTIONARY:preset_values:%\n" preset_values; for data_pair in preset_values do format "%:	%\n" data_pair.key data_pair.value

		this.modObject = modObject

		case classOf this.modObject of
		(
			SliceModifier:	this._SliceModifier()
			FFDBox:	"FFD"
			FFD_2x2x2:	"FFD"

		)


	),

	private

	/** Extrude
	  *
	  */
	function _SliceModifier =
	(
		format "\n"; print "ModifierRenamer_v._SliceModifier()"

		format "modObject.Slice_Type:	% \n" modObject.Slice_Type

		case modObject.Slice_Type of
		(
			0: "Refine"
			1: "Split"
			2: "Remove"
			3: "Remove"
		)

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
