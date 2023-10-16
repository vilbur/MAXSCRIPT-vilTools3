/** Viewport hud
 */
struct HudDisplay_v
(
	/* construct */
	Rows = #(), -- #( HudRow_v )

	/* properties */
	pos,  -- position of HUD -- Point2|Array E.G.: [ 0, 0 ] OR #( #RIGHT|#CENTER, #TOP|CENTER )

	/* dependency */
	/* reference */
	/* inhered */


	private

	/** Adjust hud postion if is placed in Max native viewport controls
	  * E.G.: left upper corner of viewport
	  */
	function checkHudposition =
	(
		if classOf pos == Point2 then
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