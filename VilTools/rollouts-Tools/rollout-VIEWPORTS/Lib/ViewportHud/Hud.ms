/** Viewport hud
 */
struct Hud_v
(
	/* construct */
	Rows = #(), -- #( HudRow_v )

	callback,	-- callback for refreshing data

	/* properties */
	pos	= #( #CENTER,	#CENTER ),  -- position of HUD -- Point2|Array E.G.: [ 0, 0 ] OR #( #LEFT|#RIGHT|#CENTER, #TOP|#BOTTOM|CENTER )
	offset,

	/* private */
	pos_init = [ 8, 16 ],

	/* dependency */
	/* reference */
	/* inhered */

	/** Shorthand for adding row to HUD
	  *
	  * @retrun HudRow_v
	  */
	function row row_text color:white height:undefined =
	(
		--format "\n"; print "ViewportHud_v.row()"
		Column	= HudColumn_v (row_text)	color:color

		HudRow	= HudRow_v columns:#( Column )	height:height

		append this.Rows HudRow

		HudRow --return
	),

	/** Adjust hud postion if is placed in Max native viewport controls
	  * E.G.: left upper corner of viewport
	  */
	function setPosition pos_param =
	(
		if pos_param != undefined then
		(
			--/* SET ALIGN POSITION */
			if classOf pos_param == Array then
			(
				pos = this.pos_init -- set default postion

				/* HORIZONTAL POSITION */
				pos.x =
					case pos_param[1] of
					(
						#LEFT:	pos.x -- use default
						#CENTER:	gw.getWinSizeX()/2
						#RIGHT:	gw.getWinSizeX()

						default: if classOf pos_param[1] == integer then pos_param[1] else pos.x -- get user defined OR init pos_param
					)

				/* VERTICAL POSITION */
				pos.y =
					case pos_param[2] of
					(
						#TOP:	pos.y -- use default
						#BOTTOM:	gw.getWinSizeY()
						#CENTER:	gw.getWinSizeY()/2

						default: if classOf pos_param[2] == integer then pos_param[2] else pos.y -- get user defined OR init position
					)

			)

			this.pos_init = pos
		)

		this.pos_init += this.offset
		--
		--if classOf this.pos == Point2 then
		--	if this.pos.x < 256 and this.pos.y < 32  then
		--		this.pos = [ 256, 32 ]

		this.pos = undefined
	),

	/** Set offset
	  *
	  */
	function setOffset pos_param =
	(
		--format "\n"; print "Hud_v.setOffset()"

		if classOf pos_param == Array and this.offset == undefined then
		(
			--format "\n"; print "Hud_v.setOffset()"
			this._setDefaultOffset()

			/* HORIZONTAL OFFSET */
			if pos_param[1] == #RIGHT then
				this.offset.x = - 128

			/* VERTICAL OFFSET */
			if pos_param[2] == #BOTTOM then
				this.offset.y = - 128

		)

		this._setDefaultOffset() -- fallback
		--format "this.offset:	% \n" this.offset
	),


	private

	/** Set default offset
	  *
	  */
	function _setDefaultOffset =
	(
		--format "\n"; print "Hud_v._setDefaultOffset()"

		if this.offset == undefined then
			this.offset = [ 0, 0 ]
	),

	/**
	 */
	on create do
	(
		this.setOffset(pos)

		this.setPosition(pos)
	)
)