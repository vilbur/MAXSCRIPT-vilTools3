unregisterRedrawViewsCallback viewportHudCallback


/** Viewport hud callback
  *
  */
function viewportHudCallback =
(
	--format "\n"; print "HudColumn_v.viewportHudCallback()"

	/* SET SCREEN SPACE */
	gw.setTransform( Matrix3 1 )


	--format "HUD_DATA:	% \n" HUD_DATA

	for HUD_datapair in HUD_DATA do
	(
		HUD = HUD_datapair.value
		--format "HUD.callback:	% \n" (classOf HUD.callback)

		if HUD.callback != undefined then
			HUD.callback()

		HudDisplay_v (HUD)
	)


	/* UPDATE VIEWPORT */
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	CompleteRedraw()

)
