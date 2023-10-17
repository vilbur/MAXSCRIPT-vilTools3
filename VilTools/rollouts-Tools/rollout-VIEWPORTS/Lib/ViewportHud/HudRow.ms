/** Hud row
 */
struct HudRow_v
(
	/* construct */
	Columns = #(), -- #( HudColumn_v )

	/* properties */
	height, -- row y position relative to previous row

	show_color = yellow,

	/* private */
	_height_default = 14,

	/** Shorthand for adding row to HUD
	  *
	  * @retrun HudColumn_v
	  */
	function column column_text color:white width:undefined =
	(
		--format "\n"; print "ViewportHud_v.row()"
		_Column	= HudColumn_v (column_text)	color:color width:width

		append this.Columns _Column

		_Column --return
	),


	private

	/**
	 */
	on create do
	(
		if height == undefined then
			height = _height_default

	)
)
