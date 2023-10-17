filein( getFilenamePath(getSourceFileName()) + "/HudColumn.ms" )	-- "./HudColumn.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudRow.ms" )	-- "./HudRow.ms"
filein( getFilenamePath(getSourceFileName()) + "/Hud.ms" )	-- "./HudDisplay.ms"


--if HUD_DISPLAYS == undefined then -- DEV
global HUD_DISPLAYS = Dictionary() -- #( #hud_name, HudData_v ),

/** Show hud display
 */
struct ViewportHud_v
(
	/* construct */
	HUD, -- Hud_v

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

	/**
	 */
	on create do
	(
		this.current_pos = copy HUD.pos

		this._showHud()
	)
)
