filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportChangeCallback.ms" )	-- "./Lib/Callbacks/viewportChangeCallback.ms"

 /**
 *
 */
macroscript	viewport_wireframe_outline_toggle
category:	"_Viewports-Setup"
buttontext:	"Wire \ Outline"
tooltip:	"Toggle Wireframe \ Outline"
(
	on execute do
	(

        ViewportSettings	= NitrousGraphicsManager.GetViewportSetting( viewport.activeViewport )
        SelectionEffectImpl 	= NitrousGraphicsManager.GetSelectionSetting()

        if ViewportSettings.VisualStyleMode == #REALISTIC then
		(
			ViewportSettings.VisualStyleMode = #WIREFRAME

			SelectionEffectImpl.SelectionOutlineEnabled	= not ViewportSettings.ShowEdgedFacesEnabled
			--SelectionEffectImpl.PreviewOutlineEnabled	= not ViewportSettings.ShowEdgedFacesEnabled
			SelectionEffectImpl.PreviewOutlineEnabled	= true

		)
		else
			ViewportSettings.VisualStyleMode = #REALISTIC


	)
)

 /**
 *
 */
macroscript	viewport_shaded_outline_toggle
category:	"_Viewports-Setup"
buttontext:	"Shaded \ Outline"
tooltip:	"Toggle Shaded \ Outline"
(
	on execute do
	(

        ViewportSettings	= NitrousGraphicsManager.GetViewportSetting( viewport.activeViewport )
        SelectionEffectImpl 	= NitrousGraphicsManager.GetSelectionSetting()

        if ViewportSettings.VisualStyleMode == #REALISTIC then
		(
			ViewportSettings.ShowEdgedFacesEnabled = not ViewportSettings.ShowEdgedFacesEnabled
			SelectionEffectImpl.SelectionOutlineEnabled	= not ViewportSettings.ShowEdgedFacesEnabled

		)
		else
			ViewportSettings.VisualStyleMode = #REALISTIC



        --SelectionEffectImpl.PreviewOutlineEnabled	= not ViewportSettings.ShowEdgedFacesEnabled
        SelectionEffectImpl.PreviewOutlineEnabled	= true
    )
)



/**
*
*/
macroscript	viewport_selection_bracets
category:	"_Viewports-Setup"
buttontext:	"Sel Brackets"
tooltip:	"Toogle Selection Brackets"
icon:	"MENU:true"
(
	current_state = (NitrousGraphicsManager.GetActiveViewportSetting()).ShowSelectionBracketsEnabled

	 for i = 1 to viewport.numViews do
		(NitrousGraphicsManager.GetViewportSetting i).ShowSelectionBracketsEnabled = not current_state

)



macroscript	viewport_show_face_index
category:	"_Viewports-Setup"
buttontext:	"Show Face ID"
toolTip:	"Show selected faces' index in the viewport"
--icon:	"width:72"

(
	local FaceIndexShow = false
	local lastviewport
	global Laca_callbacks
	global redrawscr_laca()

	fn redrawscr_laca = gw.updatescreen()

	fn FaceShow = (
		try (
			if viewport.activeViewport != lastviewport do (
				completeredraw()
				lastViewport = viewport.activeViewport
			)
			if (selection.count == 1) and ((classof $.baseobject == Editable_Mesh) or (classof $.baseobject == Editable_Poly)) then
			(
				gw.setTransform (matrix3 1)
				if (classof $ == Editable_Mesh) then
					for gw_i in (getfaceselection $) do (
						local posss = [0,0,0]
						local face_i = meshop.getfacecenter $ gw_i
						gw.wtext ((gw.wtransPoint face_i)+[0,0,100]) (gw_i as string) color:[255,255,255]
					)
				else (
					for gw_i in (polyop.getfaceselection $.baseobject) do (
						local face_i = polyop.getfacecenter $ gw_i
						gw.wtext ((gw.wtransPoint face_i)+[0,0,100]) (gw_i as string) color:[255,255,255]
					)
				)
				gw.enlargeupdaterect #whole
			)
		)
		catch()
	)

	on ischecked return FaceIndexShow

	on Execute do (
		if FaceIndexShow then (
			Laca_callbacks -= 1
			unregisterRedrawviewscallback FaceShow
			if Laca_callbacks == 0 then unregisterRedrawViewsCallback redrawscr_laca
		)
		else (
			if Laca_callbacks != undefined then Laca_callbacks += 1
			if Laca_callbacks == undefined then Laca_callbacks = 1
			registerRedrawviewscallback FaceShow
			unregisterRedrawviewsCallback redrawscr_laca
			registerRedrawviewsCallback redrawscr_laca
		)
		FaceIndexShow = not FaceIndexShow
		forcecompleteredraw()
		updateToolbarbuttons()
	)
)

/** SET GRID
 */
macroscript	viewport_set_grid_spacing
category:	"_Viewports-Setup"
buttontext:	"Set Grid"
tooltip:	"Set grid spacing in milimeters: 0.05 | 1 | 10 | 100\n\n0.05 is resolution of 3D printer`s LCD Creality LD-006"
--icon:	"width:72"
(

	grid_spacings = #( 0.05, 1.0, 10.0, 100.0  ) -- SPACING OF GRID IN mm units


	display_units = case units.SystemType of -- convert to milimeters
	(
		#millimeters:	1
		#centimeters:	10
		#meters:	1000
		#kilometers:	1000000
		default:	1 -- non metric units
	)

	next_index = if ( index = findItem grid_spacings (GetGridSpacing()) ) > 0 and index < grid_spacings.count then index + 1 else 1

	format "grid_spacings[next_index]: %\n" grid_spacings[next_index]
	format "display_units: %\n" display_units
	grid_spacing = grid_spacings[next_index] / display_units

	SetGridSpacing grid_spacing

	SetGridMajorLines 10

	format "\nGRID SPACING: %mm" grid_spacing

)


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
