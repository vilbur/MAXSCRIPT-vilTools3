/** Get color by name and randomize it
 */
struct Color_v
(
	/* construct */

	/* properties */
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
	  * @param	Literal	color_name	first items in this.hues
	 */
	function randomize color_name: hue:0 brightness:255 saturation:255 =
	(
		_color = blue -- origin color, no matter which, but not black or white

		_color_hue = if color_name == unsupplied then random 0 255 else this._getHue(color_name)

		if hue != unsupplied then 
			_color.hue	=  random (_color_hue - hue) (_color_hue + hue)

		_color.value	= if classOf brightness == Array then ( random brightness[1] brightness[2]) as integer else brightness
		_color.saturation	= if classOf saturation == Array then ( random saturation[1] saturation[2]) as integer else saturation

		_color --return
	),

	private


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
	)
)