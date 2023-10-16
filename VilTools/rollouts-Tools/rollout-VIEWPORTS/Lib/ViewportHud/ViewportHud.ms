filein( getFilenamePath(getSourceFileName()) + "/HudColumn.ms" )	-- "./HudColumn.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudRow.ms" )	-- "./HudRow.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudDisplay.ms" )	-- "./HudDisplay.ms"


--if HUD_DISPLAYS == undefined then -- DEV
global HUD_DISPLAYS = Dictionary() -- #( #hud_name, HudData_v ),

/** Show hud display
 */
struct ViewportHud_v
(
	/* construct */
	HUD, -- HudDisplay_v

	/* properties */

	private

	current_pos = [ 0, 0 ],

	/** Show hud
	  */
	function _showHud =
	(
		--format "\n"; print "HudColumn_v._showHud()"
		for HudRow in HUD.Rows where HudRow != undefined do
			this._showRow (HudRow)
	),

	/** Show row
	  */
	function _showRow HudRow =
	(
		--format "\n"; print "HudColumn_v._showRow()"
		--format "this.current_pos:	% \n" this.current_pos
		this.current_pos.x = HUD.pos.x -- reset position for 1st position

		for Column in HudRow.Columns do
			this._showColumn (Column)

		this.current_pos.y += HudRow.pos
	),

	/** Show column
	  */
	function _showColumn Column =
	(
		gw.wText [ this.current_pos.x, this.current_pos.y, 0 ] Column.text color:Column.color

		this.current_pos.x += Column.width
	),

	/** Set hud position
	  *
	  */
	function _setHudPosition =
	(
		--format "\n"; print "ViewportHud_v._setHudPosition()"
		--format "HUD.pos:	% \n" HUD.pos

		/* SET DEFAULT */
		if HUD.pos == undefined then
			HUD.pos = [ 0, 0 ]

		--format "this.current_pos:	% \n" this.current_pos

		/* SET ALIGN POSITION */
		if classOf HUD.pos == Array then
		(
			pos_x = HUD.pos[1]
			pos_y = HUD.pos[2]

			HUD.pos = this.current_pos -- set default postion

			/* HORIZONTAL POSITION */
			HUD.pos.x =
				case pos_x of
				(
					#CENTER:	gw.getWinSizeX()/2
					--:
					default: 0
				)

			/* VERTICAL POSITION */
			HUD.pos.y = if pos_y == undefined then 0 else
				case pos_y of
				(
					#CENTER:	gw.getWinSizeY()/2
					--:
					default: 32
				)


		)


		/* SET POSITION */
		--else

		this.current_pos = copy HUD.pos

		--format "this.current_pos:	% \n" this.current_pos
	),

	/**
	 */
	on create do
	(
		this._setHudPosition()

		this._showHud()
	)
)
