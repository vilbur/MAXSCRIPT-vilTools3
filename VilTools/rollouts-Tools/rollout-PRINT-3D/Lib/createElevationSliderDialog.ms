
global DIALOG_elevation_slider

/** Create slicer dialog
  *
  */
function createElevationSliderDialog =
(
	--format "\n"; print "test.ms.createSlicerDialog()"
	try(
		cui.UnRegisterDialogBar DIALOG_elevation_slider

		destroyDialog DIALOG_elevation_slider

	)catch()


	--getViewportHeight()


	rollout DIALOG_elevation_slider "Parent" --define a rollout and create a dialog
	(


		/** Get height of maximized viewport to find out height of docked dialog
		 */
		function getViewportHeight =
		(
			--print "Dialog_v._getViewportHeight()"
			is_maximized	= viewport.numViews == 1

			height_of_ui	= 0 -- Add heigh
			dialog_title_height	= 30

			--if( trackbar.visible ) then
			--	height_of_ui	+= 27
			--
			--if( timeSlider.isVisible() ) then
			--	height_of_ui	+= 18

			if not( is_maximized ) then
				actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle

			viewport_area_size = getViewSize()
			--format "viewport_area_size	= % \n" viewport_area_size
			if not( is_maximized ) then
				actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle

			(viewport_area_size[2] as integer) + height_of_ui - dialog_title_height --return
		)

		/** Show layer number
		  *
		  */
		function showLayerNumber =
		(
			--format "\n"; print "createElevationSliderDialog.ms.showLayerNumber()"
		)

		local viewport_height = (getViewportHeight())


		slider SLIDER_elevation "" range:[0,5000,0] type:#integer ticks:5000 orient:#vertical height:viewport_height pos:[ 10, 0 ]

		spinner SPIN_layer_current "" range:[0,5000,0] fieldWidth:32 pos:[ -8, viewport_height - 2 ] type:#integer


		on SLIDER_elevation changed val do
			setPrintPlaneElevation (val)


		on SLIDER_elevation rightClick do
		(
			/* SET LAYER 0 */
			if $SELECT_PLANE_HELPER != undefined and $SELECT_PLANE_HELPER.pos.z > 0 then
				setPrintPlaneElevation 0

			/* DELTE PLANE */
			else if $SELECT_PLANE_HELPER != undefined then
				delete $SELECT_PLANE_HELPER


		)

		on SPIN_layer_current changed val do
			setPrintPlaneElevation (val)



	)

	--CreateDialog DIALOG_elevation_slider pos:[100,100] style:#(#cui_max_sized,#style_toolwindow, #style_toolwindow, #style_sysmenu, #style_minimizebox) width:48  --if state then print "Rolled Down!" else print "Rolled Up!"
	CreateDialog DIALOG_elevation_slider pos:[100,100] style:#(#cui_max_sized,#style_border, #style_sysmenu, #style_minimizebox) width:32  --if state then print "Rolled Down!" else print "Rolled Up!"



	cui.RegisterDialogBar DIALOG_elevation_slider minSize:[ 16, -1] maxSize:[ 16, -1] style:#(#cui_dock_right)

	cui.DockDialogBar DIALOG_elevation_slider #cui_dock_right



)