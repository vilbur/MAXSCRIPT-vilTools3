
global DIALOG_elevation_slider


/*------------------------------------------------------------------------------
	DEV DESTROY
--------------------------------------------------------------------------------*/
	try(
		cui.UnRegisterDialogBar DIALOG_elevation_slider

		destroyDialog DIALOG_elevation_slider

	)catch()

/** Create slicer dialog
  *
  */
function createElevationSliderDialog =
(
	--format "\n"; print "test.ms.createSlicerDialog()"
	--try(
	--	cui.UnRegisterDialogBar DIALOG_elevation_slider
	--
	--	destroyDialog DIALOG_elevation_slider
	--
	--)catch()


	--getViewportHeight()
	format "DIALOG_elevation_slider == undefined	= % \n" (DIALOG_elevation_slider == undefined)
	if DIALOG_elevation_slider == undefined then
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

		/** Remove slice plane modifier
		  *
		  */
		function removeSlicePlaneModifier _objects  =
		(
			--if classOf mod_names != Array then
				--mod_names = #(mod_names)

			--for mod_name in mod_names do
			for mod_name in #( #SLICE_PLANE_TOP, #SLICE_PLANE_BOTTOM, #SELECT_LAYER ) do
				for obj in _objects where obj.modifiers[mod_name] != undefined do
					deleteModifier obj obj.modifiers[mod_name]
		)


		local viewport_height = (getViewportHeight())

		/*------------------------------------------------------------------------------
			CONTROLS
		--------------------------------------------------------------------------------*/

		button BTN_exit_dialog "EXIT" width:32 height:16  pos:[ 0, 0 ]

		slider SLIDER_elevation "" range:[0,5000,0] type:#integer ticks:5000 orient:#vertical width:32 height:(viewport_height - 40) pos:[ 10, 16 ]

		button BTN_move_layer_increment "+ \ -" width:48 height:28  pos:[ -10, viewport_height - 24 ] tooltip:"LMB: Shift layer UP\n\nRMB: Shift layer DOWN\n\nCTRL: value is 10"

		spinner SPIN_layer_current "" range:[0,5000,0] fieldWidth:32 pos:[ -8, viewport_height + 6 ] type:#integer


		/*------------------------------------------------------------------------------
			BUTTON EVENTS
		--------------------------------------------------------------------------------*/
		on BTN_exit_dialog pressed do
			try(
				removeSlicePlaneModifier( selection )

				cui.UnRegisterDialogBar DIALOG_elevation_slider

				destroyDialog DIALOG_elevation_slider
			)catch()

		/*------------------------------------------------------------------------------
			SLIDER EVENTS
		--------------------------------------------------------------------------------*/
		on SLIDER_elevation changed val do
			updateSlicePlaneSystem (val)


		on SLIDER_elevation rightClick do
		(
			/*  round 123.456 -2 >>> 100.0
				round 123.456  0 >>> 123.0
				round 123.456  2 >>> 123.46
			*/
			fn round val = ((floor ((val * (mult = 10.0 ^ 0)) + 0.5)) / mult ) as integer -- n=0|1|2 number of tens after decimal point

			display_units = case units.SystemType of -- convert to milimeters
			(
				#millimeters:	1
				#centimeters:	10
				#meters:	1000
				#kilometers:	1000000
				default:	1 -- non metric units
			)

			if selection.count > 0 then
			(
				layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value

				export_size = ROLLOUT_export.SPIN_export_size.value

				layer_multiplier = display_units / layer_height	/ export_size

				--toggleSliceModifiers (false)

				/* MOVE SLICE PLANE TO SELCTION BOTTOM */
				layer_index = round ($.min.z ) * layer_multiplier

				current_layer = DIALOG_elevation_slider.SPIN_layer_current.value

				/* MOVE SLICE PLANE TO SELCTION TOP */
				if current_layer == layer_index then
					layer_index = round ($.max.z ) * layer_multiplier


				--toggleSliceModifiers (true)

				updateSlicePlaneSystem (layer_index)
			)


			--/* SET LAYER 0 *
			--if $SELECT_PLANE_HELPER != undefined and $SELECT_PLANE_HELPER.pos.z > 0 then
			--	updateSlicePlaneSystem 0
			--
			--/* DELTE PLANE */
			--else if $SELECT_PLANE_HELPER != undefined then
			--	delete $SELECT_PLANE_HELPER

		)

		on SLIDER_elevation buttondown do
		(
			--for obj in selection where obj.modifiers[ #SELECT_LAYER ] != undefined do
				 --obj.modifiers[ #SELECT_LAYER ].enabled = false

		)

		on SLIDER_elevation buttonup do
		(
			--for obj in selection where obj.modifiers[ #SELECT_LAYER ] != undefined do
				 --obj.modifiers[ #SELECT_LAYER ].enabled = true

			--if selection.count > 0 then
			--	if $.modifiers[ #SELECT_LAYER ] == undefined then
			--	(
			--		modPanel.addModToSelection (Poly_Select name:"SELECT SLICE")
			--
			--		subobjectLevel = 1
			--	)

		)

		/* ON BUTTON INCREMENT */
		on BTN_move_layer_increment pressed do
			updateSlicePlaneSystem ( keyboard.controlPressed then 10 else 1) incremental:true

		on BTN_move_layer_increment rightclick do
			updateSlicePlaneSystem ( keyboard.controlPressed then -10 else -1) incremental:true

		/* ON SLIDER CHANGE */
		on SPIN_layer_current changed val do
			updateSlicePlaneSystem (val)




		/* ON DIALOG OOPEN */
		on DIALOG_elevation_slider open do
			updateSlicePlaneSystem (DIALOG_elevation_slider.SPIN_layer_current.value)


	)


	format "GetDialogPos DIALOG_elevation_slider	= % \n" (GetDialogPos DIALOG_elevation_slider == [0,0])
	if GetDialogPos DIALOG_elevation_slider == [0,0] then
	(
		CreateDialog DIALOG_elevation_slider pos:[100,100] style:#(#cui_max_sized,#style_border, #style_sysmenu, #style_minimizebox) width:32  --if state then print "Rolled Down!" else print "Rolled Up!"

		cui.RegisterDialogBar DIALOG_elevation_slider minSize:[ 16, -1] maxSize:[ 16, -1] style:#(#cui_dock_right)

		cui.DockDialogBar DIALOG_elevation_slider #cui_dock_right


	)

)