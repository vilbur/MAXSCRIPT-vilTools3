filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportHud/ViewportHud.ms" )	-- "./Lib/ViewportHud/ViewportHud.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/hudObjectInfo.ms" )	-- "./Lib/Callbacks/hudObjectInfo.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportInfoCallback.ms" )	-- "./Lib/Callbacks/viewportInfoCallback.ms"


/**
 */
macroscript	_viewport_hud_info_test
category:	"_Viewports"
buttontext:	"TEST"
--icon:	""
icon:	"control:checkbutton"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"

		format "EventFired:	% \n" EventFired

		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())

			Column = HudColumn_v ("Test")

			Row = HudRow_v columns: #( Column )

			HudDisplay = HudDisplay_v Rows: #( Row )

			HUD_DISPLAYS[#TEST_HUD] = HudDisplay


			registerRedrawViewsCallback viewportHudCallback
		)
		else
			unregisterRedrawViewsCallback viewportHudCallback




	)
)


/**
 */
macroscript	_viewport_hud_info
category:	"_Viewports"
buttontext:	"HUD Info"
--icon:	"control:checkbox|autorun:true|align:#left"
icon:	"control:checkbox|autorun:true"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"

		--if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		--	registerRedrawViewsCallback viewportInfoCallback
		--else
		--	unregisterRedrawViewsCallback viewportInfoCallback

	)
)
