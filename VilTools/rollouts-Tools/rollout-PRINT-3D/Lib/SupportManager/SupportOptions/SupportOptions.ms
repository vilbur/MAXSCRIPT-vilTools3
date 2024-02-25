/** Support options
 */
struct SupportOptions_v
(
	/* construct */

	base_extrude,
	extrude_top,

	layer_height,
	bar_width,
	chamfer_top,
	normal_length,

	cross_section,
	cross_section_max,

	/* properties */


	/* dependency */
	/* reference */
	/* inhered */



	private


	/**
	 */
	on create do
	(
		--format "\n"; print "SupportOptions.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
