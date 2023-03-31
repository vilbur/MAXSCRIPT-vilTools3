filein( getFilenamePath(getSourceFileName()) + "/Lib/viewportChangeCallback/viewportChange.ms" )


/**
*
*/
macroscript	viewport_rotate_top_view
category:	"_Viewports"
buttontext:	"Rotate Top"
tooltip:	"Keep top view rotated by 90°"
icon:	"control:checkbox"
(
	if( EventFired.val ) then
		viewportChangeCallback()
	else
		viewportChangeKill()
)


/** Set viewport background color
*
*/
macroscript	viewport_background_color
category:	"_Viewports"
buttontext:	"Background"
tooltip:	"Set Viewport Background Color"
icon:	"control:colorpicker|value:[56,56,56]"
(
	background_color = ROLLOUT_viewports.cp_background.color

	fn RGBToUIColor clr = [clr.r/255,clr.g/255,clr.b/255]

	viewport.EnableSolidBackgroundColorMode(true)

	SetUIColor 41 (RGBToUIColor(background_color))

	CompleteRedraw()
)

/** Reset viewport background color
*
*/
macroscript	viewport_background_color_reset
category:	"_Viewports"
buttontext:	"Reset"
tooltip:	"Reset Viewport Background Color"
icon:	"width:48"
(
	ROLLOUT_viewports.cp_background.color = ( color 56 56 56 )

	macros.run "_Viewports" "viewport_background_color"
)



--
-- /**
-- *
-- */
--macroscript	viewport_test
--category:	"_Viewports"
--buttontext:	"Test"
----tooltip:	"Keep top view rotated by 90°"
----icon:	"control:checkbox"
--(
--	viewport_matrix = viewport.getTM()
--
--	--format "viewport_matrix = % \n" viewport_matrix
--
--	is_top = (ViewportSwitcher_v())._isThisRotatedTopView(viewport.getTM())
--
--	format "is_top = % \n" is_top
--
--)


