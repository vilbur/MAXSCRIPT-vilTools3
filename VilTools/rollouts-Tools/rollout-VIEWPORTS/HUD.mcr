
filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportHud/HudDisplay.ms" )	-- "./Lib/ViewportHud/HudDisplay.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportHudCallback.ms" )	-- "./Lib/Callbacks/viewportHudCallback.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/hudMaxInfoCallback.ms" )	-- "./Lib/Callbacks/hudMaxInfoCallback.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/hudObjectInfoCallback.ms" )	-- "./Lib/Callbacks/hudObjectInfoCallback.ms"

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/hudObjectInfo.ms" )	-- "./Lib/Callbacks/hudObjectInfo.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportInfoCallback.ms" )	-- "./Lib/Callbacks/viewportInfoCallback.ms"


/** Toggle hud callback
  */
function toggleHudCallback hud_name data: =
(
	--format "\n"; print "HUD.mcr.toggleHudCallbeack()"

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


/**
 */
macroscript	_viewport_hud_info
category:	"_Viewports"
buttontext:	"Viewport Info"
--icon:	"control:checkbox|autorun:true|align:#left"
icon:	"control:checkbutton|autorun:true"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\Lib\Callbacks\hudMaxInfoCallback.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"

		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			HUD = Hud_v callback: hudMaxInfoCallback

			toggleHudCallback #MAX_INFO data:HUD
		)
		else
			toggleHudCallback #MAX_INFO
	)
)

/**
 */
macroscript	_viewport_hud_info_object
category:	"_Viewports"
buttontext:	"Object Info"
--icon:	"control:checkbox|autorun:true|align:#left"
icon:	"control:checkbutton|autorun:true"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\Lib\Callbacks\hudObjectInfoCallback.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"

		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			HUD = Hud_v callback: hudObjectInfoCallback

			toggleHudCallback #OBJ_INFO data:HUD
		)
		else
			toggleHudCallback #OBJ_INFO
	)
)
