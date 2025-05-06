

/**
*
*/
macroscript	viewport_rotate_top_view
category:	"_Viewports-Setup"
buttontext:	"Rotate Top"
tooltip:	"Keep top view rotated by 90°"
icon:	"control:checkbox|offset:[ 4, 4 ]"
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
category:	"_Viewports-Setup"
buttontext:	"Background"
tooltip:	"Set Viewport Background Color"
icon:	"control:colorpicker|value:[56,56,56]"
(
	background_color = ROLLOUT_viewports.cp_background.color

	fn RGBToUIColor clr = [clr.r/255,clr.g/255,clr.b/255]

   --format "RGBToUIColor(background_color):	% \n"( RGBToUIColor(background_color))
    --format "background_color:	% \n" background_color

	viewport.EnableSolidBackgroundColorMode(true)

	SetUIColor 41 ( RGBToUIColor(background_color) )

	CompleteRedraw()
)

/** Reset viewport background color
*
*/
macroscript	viewport_background_color_reset
category:	"_Viewports-Setup"
buttontext:	"Reset"
tooltip:	"Reset Viewport Background Color"
icon:	"offset:[ 4, 0 ]"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\Viewport Setup.mcr"
	--messageBox "Yupiii" title:"Title"  beep:false

    format "ROLLOUT_viewports:	% \n" ROLLOUT_viewports

	ROLLOUT_viewports.cp_background.color = ( color 56 56 56 )

	macros.run "_Viewports-Setup" "viewport_background_color"
)


-- /**
-- *
-- */
--macroscript	viewport_test
--category:	"_Viewports-Setup"
--buttontext:	"Test"
----tooltip:	"Keep top view rotated by 90°"
----icon:	"control:checkbox"
--(
--	format "EventFired:	% \n" EventFired
--	--viewport_matrix = viewport.getTM()
--
--	--format "viewport_matrix = % \n" viewport_matrix
--
--	--is_top = (ViewportSwitcher_v())._isThisRotatedTopView(viewport.getTM())
--
--	--format "is_top = % \n" is_top

--)
