/** Viewport hud
 */
struct HudDisplay_v
(
	/* construct */
	Rows = #(), -- #( HudRow_v )

	/* properties */
	pos	= [ 0 , 32 ],  -- column offset to HudRow_v.offset

	/* dependency */
	/* reference */
	/* inhered */


	private

	/** Adjust hud postion if is placed in Max native viewport controls
	  * E.G.: left upper corner of viewport
	  */
	function checkHudposition =
	(
		if this.pos.x < 256 and this.pos.y < 32  then
			pos = [ 256, 32 ]
	),

	/**
	 */
	on create do
	(
		this.checkHudposition()
	)
)