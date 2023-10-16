filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportHud/ViewportHud.ms" )	-- "./Lib/ViewportHud/ViewportHud.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportHudCallback.ms" )	-- "./Lib/Callbacks/viewportHudCallback.ms"


--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/hudObjectInfo.ms" )	-- "./Lib/Callbacks/hudObjectInfo.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportInfoCallback.ms" )	-- "./Lib/Callbacks/viewportInfoCallback.ms"


/** Toggle hud callback
  */
function toggleHudCallback hud_name data: =
(
	format "\n"; print "HUD.mcr.toggleHudCallbeack()"

	if data != unsupplied then
	(
		print "HudCallback: ON"

		HUD_DISPLAYS[hud_name] = data

		unregisterRedrawViewsCallback viewportHudCallback

		registerRedrawViewsCallback viewportHudCallback
	)
	else
	(
		RemoveDictValue HUD_DISPLAYS hud_name

		if HUD_DISPLAYS.count == 0 then
		(
			unregisterRedrawViewsCallback viewportHudCallback

			print "HudCallback: OFF"
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
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"


		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			HUD = HudDisplay_v pos:#( #CENTER, #CENTER )

			--Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
			--Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (green) )
			--Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )
			--
			--Row_2.pos = 24
			--
			--Row_3.columns[1].width = 96



			append HUD.Rows ( HudRow_v columns: #( HudColumn_v ("XXXXXXXXXXXXXX") ) )

			toggleHudCallback #VIEWPORT_INFO data:HUD
		)
		else
			toggleHudCallback #VIEWPORT_INFO
	)
)

/**
 */
macroscript	_viewport_hud_info_object
category:	"_Viewports"
buttontext:	"Selection Info"
--icon:	"control:checkbox|autorun:true|align:#left"
icon:	"control:checkbutton|autorun:true"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"


		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
			Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (green) )
			Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )

			Row_2.pos = 24

			Row_3.columns[1].width = 96


			HUD = HudDisplay_v Rows: #( Row_1, Row_2, Row_3 ) pos:[ 256, 64 ]


			toggleHudCallback #OBJECT_INFO data:HUD
		)
		else
			toggleHudCallback #OBJECT_INFO

	)
)
