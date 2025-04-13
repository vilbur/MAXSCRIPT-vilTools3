
/** Toggle hud callback
  */
function toggleHudCallback hud_name data: =
(
	format "\n"; print "HUD.mcr.toggleHudCallbeack()"
	format "data: %\n" data
	
	if data != unsupplied then
	(
		--print ("HudCallback ON: #"+ hud_name as string )

		HUD_DATA[hud_name] = data

		unregisterRedrawViewsCallback viewportHudCallback

		registerRedrawViewsCallback viewportHudCallback
	)
	else
	(
		RemoveDictValue HUD_DATA hud_name

		--print ("HudCallback OFF: #"+ hud_name as string )

		if HUD_DATA.count == 0 then
		(
			unregisterRedrawViewsCallback viewportHudCallback

			--print "HudCallback DISABLE"
		)
	)
)
