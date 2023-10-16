filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportChangeCallback.ms" )	-- "./Lib/Callbacks/viewportChangeCallback.ms"

/**
*
*/
macroscript	viewport_selection_bracets
category:	"_Viewports"
buttontext:	"Sel Brackets"
tooltip:	"Toogle Selection Brackets "
--icon:	"control:checkbox"
(
	current_state = (NitrousGraphicsManager.GetActiveViewportSetting()).ShowSelectionBracketsEnabled

	 for i = 1 to viewport.numViews do
		(NitrousGraphicsManager.GetViewportSetting i).ShowSelectionBracketsEnabled = not current_state

)

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




/** SET GRID
 */
macroscript	viewport_set_grid_spacing
category:	"_Viewports"
buttontext:	"Set Grid"
tooltip:	"Set grid spacing in milimeters: 0.05 | 1 | 10 | 100\n\n0.05 is resolution of 3D printer`s LCD Creality LD-006"
icon:	"width:72"
(

	spacings = #( 0.05, 1.0, 10.0, 100.0  ) -- SPACING OF GRID IN mm units

	unit_divider = case units.SystemType of
	(
		#Centimeters:10
		#Meters: 1000
		default: 1
	)

	next_index = if ( index = findItem spacings (GetGridSpacing()) ) > 0 and index < spacings.count then index + 1 else 1

	SetGridSpacing (spacings[next_index] / unit_divider )

	SetGridMajorLines 10

	format "\nGRID SPACING: %mm" spacings[next_index]

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
