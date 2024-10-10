/** Get color by name and randomize it
 */
struct Color_v
(
	/* construct */

	/* properties */
	hues = Dictionary          \
		#( #ORANGE,	10	) \
		#( #YELLOW,	40	) \
		#( #LIME,	60	) \
		#( #GREEN,	85	) \
		#( #CYAN,	120	) \
		#( #LIGHTBLUE,	150	) \
		#( #BLUE,	170	) \
		#( #VIOLETE,	180	) \
		#( #MAGENTA,	200	) \
		#( #PINK,	220	) \
		#( #RED,	255	),

	/* dependency */
	/* reference */
	/* inhered */

	/** Randomize
	  *
	  * @param	Literal	color_name	first items in this.hues
	 */
	function randomize clr: hue: brightness: saturation: =
	(

		/** Get random value
		 */
		function getRandomValue threshold val =
		(
			--format "\n"; print "Color_v.getRandomValue val threshold()"

			/** make sure then range is 0-255
			 */
			function minMax val =
			(
				case of
				(
					(val > 255):	255
					(val < 0):	0
					default:	val
				)
			)

			if classOf threshold == integer then
				( random (minMax( val - threshold)) (minMax( val + threshold))) as integer

			else if classOf threshold == Array then
				( random (minMax(threshold[1])) (minMax(threshold[2]))) as integer

			else if classOf threshold == Point2 then
				( random (minMax(threshold.x)) (minMax(threshold.y))) as integer
		)

		clr = this.getColor clr

		if hue != unsupplied then
			clr.hue	= getRandomValue(hue)(clr.hue)

		if brightness != unsupplied then
			clr.value	= getRandomValue(brightness)(clr.value)

		if saturation != unsupplied then
			clr.saturation	= getRandomValue(saturation)(clr.saturation)

		clr --return
	),

	/** Get color
	 */
	function getColor clr =
	(
		--format "\n"; print "Color_v._getColor()"
		if classOf clr != color then
		(
			clr_base = blue

			clr_base.hue = if classof clr == name then hues[clr] else random 0 255

			clr_base --return
		)
		else
			clr --return
	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "Color_v.onCreate()"
	)
)