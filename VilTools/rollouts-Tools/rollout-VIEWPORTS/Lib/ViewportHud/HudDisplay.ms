filein( getFilenamePath(getSourceFileName()) + "/HudColumn.ms" )	-- "./HudColumn.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudRow.ms" )	-- "./HudRow.ms"
filein( getFilenamePath(getSourceFileName()) + "/Hud.ms" )	-- "./HudDisplay.ms"


global HUD_DISPLAYS = Dictionary() -- #( #hud_name, HudData_v ),

/** Show hud display
 */
struct HudDisplay_v
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
		--format "HUD.pos_init:	% \n" HUD.pos_init
		--format "HudRow.pos:	% \n" HudRow.pos

		this.current_pos.x = HUD.pos_init.x -- reset position for 1st position
		this.current_pos.y += HudRow.height

		for Column in HudRow.Columns do
			this._showColumn (Column)

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
		this.current_pos = copy HUD.pos_init

		this._showHud()
	)
)
