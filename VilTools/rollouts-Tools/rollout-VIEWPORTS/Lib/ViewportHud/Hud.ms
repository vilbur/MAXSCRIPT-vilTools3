/** Viewport hud
 */
struct Hud_v
(
	/* construct */
	Rows = #(), -- #( HudRow_v )

	/* properties */
	pos,  -- position of HUD -- Point2|Array E.G.: [ 0, 0 ] OR #( #RIGHT|#CENTER, #TOP|CENTER )

	/* dependency */
	/* reference */
	/* inhered */

	/** Approw to to HUD
	  *
	  */
	function row row_text color:white pos:12 =
	(
		--format "\n"; print "ViewportHud_v.row()"
		Column	= HudColumn_v (row_text)	color:color

		HudRow	= HudRow_v columns:#( Column )	pos:pos

		append this.Rows HudRow
	),


	private

	--/** Adjust hud postion if is placed in Max native viewport controls
	--  * E.G.: left upper corner of viewport
	--  */
	--function checkHudposition =
	--(
	--	if classOf this.pos == Point2 then
	--		if this.pos.x < 256 and this.pos.y < 32  then
	--			this.pos = [ 256, 32 ]
	--),

	/**
	 */
	on create do
	(
		--this.checkHudposition()
	)
)