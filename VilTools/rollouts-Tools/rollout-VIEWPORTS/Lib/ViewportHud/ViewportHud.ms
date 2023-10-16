filein( getFilenamePath(getSourceFileName()) + "/HudColumn.ms" )	-- "./HudColumn.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudRow.ms" )	-- "./HudRow.ms"
filein( getFilenamePath(getSourceFileName()) + "/HudDisplay.ms" )	-- "./HudDisplay.ms"


if HUD_DISPLAYS == undefined then -- DEV
global HUD_DISPLAYS = Dictionary() -- #( #hud_name, HudData_v ),

/** Show hud display
 */
struct ViewportHud_v
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
