unregisterRedrawViewsCallback viewportHudCallback


/** Viewport hud callback
  *
  */
function viewportHudCallback =
(
	format "\n"; print "HudColumn_v.viewportHudCallback()"

	/* SET SCREEN SPACE */
	gw.setTransform( Matrix3 1 )

	for HudDisplay_data in HUD_DISPLAYS do
		ViewportHud_v (HudDisplay_data.value)
	

	/* UPDATE VIEWPORT */
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	CompleteRedraw()

)
