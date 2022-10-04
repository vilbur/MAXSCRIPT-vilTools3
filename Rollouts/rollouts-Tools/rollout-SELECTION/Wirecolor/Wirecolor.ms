filein( getFilenamePath(getSourceFileName()) + "/../../../../Lib/Color/Color.ms" )
	
/** Wirecolor
 */
struct Wirecolor_v
(
	/* construct */

	/* properties */
	mode = #object, -- #object|#selection

	
	/* dependency */
	_Color 	= Color_v(),

	/* reference */
	/* inhered */

	/** Randomize
	  * 
	  * @param	Literal	_color	red|green|blue|white|black|orange|yellow|brown|gray
	 */
	function randomize col: hue:0 brightness:255 saturation:255 =
	(
		
		_Color.randomize col:col hue:hue brightness:brightness saturation:saturation

	),

	private



	/**  
	 */
	on create do
	(
		--format "\n"; print "Wirecolor.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)

)
