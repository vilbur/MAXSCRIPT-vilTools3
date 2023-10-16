global HUD_DISPLAYS = Dictionary() -- #( #hud_name, HudData_v ),

/** Hud column
 */
struct HudColumn_v
(
	/* construct */
	text,

	/* properties */
	show_color = yellow,
	offset	= 0, -- x position offset

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
	offset	= [ 0 , 0 ],
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
	offset	= [ 0 , 32 ],
	row_height	= 64,

	/* dependency */
	/* reference */
	/* inhered */


	private


	/**
	 */
	on create do	()
)


/** Show hud display
 */
struct ShowHud_v
(
	/* construct */
	HudDisplay,

	/* properties */

	private

	/** Show hud
	  *
	  */
	function showHud =
	(
		--format "\n"; print "HudColumn_v.showHud()"

		for HudRow in HudDisplay.Rows do
			this.showRow (HudRow)

	),

	/** Show row
	  *
	  */
	function showRow HudRow =
	(
		--format "\n"; print "HudColumn_v.showRow()"
			--format "HudRow:	% \n" HudRow

		for Column in HudRow.Columns do
			--format "Column:	% \n" Column
			this.showColumn (Column)
	),

	/** Show column
	  *
	  */
	function showColumn Column =
	(
		format "\n"; print "HudColumn_v.showColumn()"
		--format "Column:	% \n" Column
		gw.wText ( [ 256  , 256, 0] ) Column.text color:red

	),

	/**
	 */
	on create do
	(
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


	try(
		for HudDisplay_data in HUD_DISPLAYS do
			ShowHud_v (HudDisplay_data.value)

	)catch(
		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())

		unregisterRedrawViewsCallback viewportHudCallback
	)


	--gw.wText ( [0 , 32, 0] ) "Column.text" color:red

	/* UPDATE VIEWPORT */
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	CompleteRedraw()
)




