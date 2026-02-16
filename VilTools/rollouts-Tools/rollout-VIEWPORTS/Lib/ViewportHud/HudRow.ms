/** Hud row
 */
struct HudRow_v
(
	/* construct */
	Columns = #(), -- #( HudColumn_v )

	/* properties */
	width,
	height, -- row y position relative to previous row

	color = white,

	/* private */
	_height_default = 14,

	/** Shorthand for adding row to HUD
	  *
	  * @retrun HudColumn_v
	  */
	function column column_text color:undefined width:undefined =
	(
		--format "\n"; print "ViewportHud_v.row()"
		--_Column	= HudColumn_v (column_text)	color:color width:width
		_Column	= HudColumn_v (column_text)	color:( if color != undefined then color else this.color ) width:( if width != undefined then width else this.width )

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
			
			
		if this.Columns.count > 0 then
			for Column in this.Columns where Column.color == undefined do 
				Column.color = this.color

	)
)
