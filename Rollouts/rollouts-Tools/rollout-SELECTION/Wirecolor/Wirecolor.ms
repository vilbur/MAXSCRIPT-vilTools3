/** Wirecolor
 */
struct Wirecolor_v
(
	/* construct */

	/* properties */
	mode = #object, -- #object|#selection

	colors = #(
		#( #white,	0,	0,	255 ),
		#( #brown,	17,	187,	153 ),
		#( #orange,	21,	255,	255 ),
		#( #yellow,	42,	255,	255 ),
		#( #green,	85,	255,	255 ),
		#( #cyan,	120,	220,	180 ),
		#( #blue,	170,	255,	255 ),
		#( #magenta,	185,	240,	135 ),
		#( #red,	255,	255,	255 ),
		#( #black,	0,	0,	0 )	
	),
	/* dependency */
	/* reference */
	/* inhered */

	/** Randomize
	  * 
	  * @param	Literal	_color	red|green|blue|white|black|orange|yellow|brown|gray
	 */
	function randomize col: range:0 =
	(

		format "\n"

		color_values = this._getColor(col)

		print color_values[1] as string

		--_color = blue
		_color = blue

		this._setValue (_color) #hue color_values[2] 4
		this._setValue (_color) #saturation color_values[3] 100
		this._setValue (_color) #value color_values[4] 100
		--format "_color	= % \n" _color
		_color --return
	),

	private

	/** Set value
	 */
	function _setValue &_color property val range =
	(
		--format "\n"; print "Wirecolor_v._setValue()"
		format "val A	= % \n" val
		if range > 0 then 
		(

			val_min = val - (range/2)
			val_max = val + (range/2)

			val = ( random val_min val_max )

			if val > 255 then
				val = 255
			else if val < 0 then
				val = 0
			
		)
		format "val B	= % \n" val

		setProperty _color property val

		_color --return
	),

	/** Get color
	 */
	function _getColor _color =
	(
		--format "\n"; print "Wirecolor_v._getColor()"

		for color_values in colors where color_values[1] == _color do
			return color_values

	),

	/**  
	 */
	on create do
	(
		--format "\n"; print "Wirecolor.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)

)
