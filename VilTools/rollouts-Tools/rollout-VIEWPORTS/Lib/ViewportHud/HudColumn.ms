
/** Hud column
 */
struct HudColumn_v
(
	/* construct */
	text,

	/* properties */
	color = white,
	width,

	/* private */
	_width_default = 64,


	private

	/**
	 */
	on create do
	(
		if width == undefined then
			width = _width_default
	)
)