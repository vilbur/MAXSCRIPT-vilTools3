global HUD_DISPLAYS = Dictionary() -- #( #hud_name, HudData_v ),

/** Hud column
 */
struct HudColumn_v
(
	/* construct */
	text,

	/* properties */
	color = white,
	width	= 64,

	private

	/**
	 */
	on create do	()
)

/** Hud row
 */
struct HudRow_v
(
	/* construct */
	Columns = #(), -- #( HudColumn_v )

	/* properties */
	pos	= 12, -- row y position relative to previous row

	show_color = yellow,

	private

	/**
	 */
	on create do	()
)


/** Viewport hud
 */
struct HudDisplay_v
(
	/* construct */
	Rows = #(), -- #( HudRow_v )

	/* properties */
	pos	= [ 0 , 32 ],  -- column offset to HudRow_v.offset

	/* dependency */
	/* reference */
	/* inhered */


	private

	/** Adjust hud postion if is placed in Max native viewport controls
	  * E.G.: left upper corner of viewport
	  */
	function checkHudposition =
	(
		if this.pos.x < 256 and this.pos.y < 32  then
			pos = [ 256, 32 ]
	),

	/**
	 */
	on create do
	(
		this.checkHudposition()
	)
)


/** Show hud display
 */
struct ShowHud_v
(
	/* construct */
	HudDisplay,

	/* properties */

	private

	current_pos = [ 0, 0 ],

	/** Show hud
	  */
	function showHud =
	(
		--format "\n"; print "HudColumn_v.showHud()"
		for HudRow in HudDisplay.Rows where HudRow != undefined do
			this.showRow (HudRow)
	),

	/** Show row
	  */
	function showRow HudRow =
	(
		this.current_pos.x = HudDisplay.pos.x -- reset position for 1st position

		for Column in HudRow.Columns do
			this.showColumn (Column)

		this.current_pos.y += HudRow.pos
	),

	/** Show column
	  */
	function showColumn Column =
	(
		gw.wText [ this.current_pos.x, this.current_pos.y, 0 ] Column.text color:Column.color

		this.current_pos.x += Column.width
	),


	/**
	 */
	on create do
	(
		this.current_pos = copy HudDisplay.pos

		showHud()
	)
)


unregisterRedrawViewsCallback viewportHudCallback


/** Viewport hud callback
  *
  */
function viewportHudCallback =
(
	--format "\n"; print "HudColumn_v.viewportHudCallback()"

	/* SET SCREEN SPACE */
	gw.setTransform( Matrix3 1 )

	for HudDisplay_data in HUD_DISPLAYS do
		ShowHud_v (HudDisplay_data.value)


	/* UPDATE VIEWPORT */
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	CompleteRedraw()
)
