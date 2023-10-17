/** Viewport hud
 */
struct Hud_v
(
	/* construct */
	Rows = #(), -- #( HudRow_v )

	/* properties */
	pos,  -- position of HUD -- Point2|Array E.G.: [ 0, 0 ] OR #( #RIGHT|#CENTER, #TOP|CENTER )

	pos_init = [ 8, 16 ],

	/* dependency */
	/* reference */
	/* inhered */

	/** Approw to to HUD
	  *
	  */
	function row row_text color:white pos:16 =
	(
		--format "\n"; print "ViewportHud_v.row()"
		Column	= HudColumn_v (row_text)	color:color

		HudRow	= HudRow_v columns:#( Column )	--pos:pos

		append this.Rows HudRow
	),

	/** Adjust hud postion if is placed in Max native viewport controls
	  * E.G.: left upper corner of viewport
	  */
	function setPosition pos =
	(
		if pos != undefined then
		(
			--/* SET ALIGN POSITION */
			if classOf pos == Array then
			(
				pos_x = pos[1]
				pos_y = pos[2]

				pos = this.pos_init -- set default postion

				/* HORIZONTAL POSITION */
				pos.x =
					case pos_x of
					(
						#LEFT:	pos.x
						#CENTER:	gw.getWinSizeX()/2
						#RIGHT:	gw.getWinSizeX() - 128

						default: if classOf pos_x == integer then pos_x else pos.x -- get user defined OR init position
					)

				/* VERTICAL POSITION */
				pos.y =
					case pos_y of
					(
						#TOP:	pos.y
						#BOTTOM:	gw.getWinSizeY() - 128
						#CENTER:	gw.getWinSizeY()/2

						default: if classOf pos_y == integer then pos_y else pos.y -- get user defined OR init position
					)

			)

			this.pos_init = pos

			this.pos = undefined
		)


		--if classOf this.pos == Point2 then
		--	if this.pos.x < 256 and this.pos.y < 32  then
		--		this.pos = [ 256, 32 ]


	),

	private

	/**
	 */
	on create do
	(
		this.setPosition(pos)
	)

)