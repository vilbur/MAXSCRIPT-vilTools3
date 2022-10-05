/** Color
 */
struct Color_v
(
	/* construct */

	/* properties */
	mode = #object, -- #object|#selection

	hues = #(
		#( #orange,	10	),
		#( #yellow,	40	),
		#( #lime,	60	),
		#( #green,	85	),
		#( #cyan,	120	),
		#( #blue_light,	150	),
		#( #blue,	170	),
		#( #violete,	180	),
		#( #magenta,	200	),
		#( #pink,	220	),
		#( #red,	255	)
	),
	
	/* dependency */
	/* reference */
	/* inhered */

	/** Randomize
	  * 
	  * @param	Literal	col	red|green|blue|white|black|orange|yellow|brown|gray
	 */
	function randomize col: hue:0 brightness:255 saturation:255 =
	(
		_color = blue -- origin color, no matter which, but not black or white
				
		_color_hue = if col == unsupplied then random 0 255 else this._getHue(col)
		
		if hue != unsupplied then 
			_color.hue	=  random (_color_hue - hue) (_color_hue + hue)
		
		_color.value	= if classOf brightness == Array then ( random brightness[1] brightness[2]) as integer else brightness
		_color.saturation	= if classOf saturation == Array then ( random saturation[1] saturation[2]) as integer else saturation
		
		
		_color --return
	),

	private

	/** Set value
	 */
	function _setValue &_color property val range =
	(
		--format "\n"; print "Wirecolor_v._setValue()"
		--format "val A	= % \n" val
		if range > 0 then 
		(

			val = ( random (val - range) (val + range) )

			if val > 255 then
				val = 255
			else if val < 0 then
				val = 0
			
		)
		--format "val B	= % \n" val

		setProperty _color property val

		_color --return
	),

	/** Get color
	 */
	function _getHue _color =
	(
		--format "\n"; print "Wirecolor_v._getHue()"

		for hue in hues where hue[1] == _color do
			return hue[2]

	),

	/**  
	 */
	on create do
	(
		--format "\n"; print "Color_v.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)

)
