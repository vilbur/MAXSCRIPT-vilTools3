/** Hud row
 */
struct HudRow_v
(
	/* construct */
	Columns = #(), -- #( HudColumn_v )

	/* properties */
	height	= 12, -- row y position relative to previous row

	show_color = yellow,

	private

	/**
	 */
	on create do	()
)
