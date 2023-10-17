

/** Viewport hud callback
  *
  */
function viewportHudCallback =
(
	--format "\n"; print "HudColumn_v.viewportHudCallback()"

	/* SET SCREEN SPACE */
	gw.setTransform( Matrix3 1 )

	for HUD_datapair in HUD_DATA do
	(
		HUD = HUD_datapair.value

		if HUD.callback != undefined then
			HUD.callback()

		HudDisplay_v (HUD)
	)


	/* UPDATE VIEWPORT */
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	CompleteRedraw()

)
