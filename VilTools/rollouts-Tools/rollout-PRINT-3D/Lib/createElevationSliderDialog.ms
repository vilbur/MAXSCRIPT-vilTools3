
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
	try(
		cui.UnRegisterDialogBar DIALOG_elevation_slider

		destroyDialog DIALOG_elevation_slider

	)catch()


	--getViewportHeight()
	--format "DIALOG_elevation_slider == undefined	= % \n" (DIALOG_elevation_slider == undefined)
	--if DIALOG_elevation_slider == undefined then
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
				for obj in geometry where obj.modifiers[mod_name] != undefined do
					deleteModifier obj obj.modifiers[mod_name]
		)



		/** Get Layer index by position in world
		 */
		function posToLayerIndex pos =
		(
			--format "\n"; print ".posToLayerIndex()"

			/*  Round float to iteger
			*/
			fn roundToInteger val = floor (val  + 0.5)  as integer

			display_units = case units.SystemType of -- convert to milimeters
			(
				#millimeters:	1
				#centimeters:	10
				#meters:	1000
				#kilometers:	1000000
				default:	1 -- non metric units
			)

			export_size = ROLLOUT_export.SPIN_export_size.value
			layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
			current_layer = DIALOG_elevation_slider.SPIN_layer_current.value

			/* MOVE SLICE PLANE TO SELCTION BOTTOM */
			layer_index = roundToInteger ((pos * display_units) / layer_height	/ export_size)

			layer_index --return
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


		on SLIDER_elevation RIGHTCLICK do
		(
			--print "createElevationSliderDialog SLIDER_elevation rightClick"

			/** Toggle slice modifiers
			 */
			function toggleSliceModifiers state mod_names:#( #SLICE_PLANE_TOP, #SLICE_PLANE_BOTTOM ) =
			(
				for obj in selection do
					for mod_name in mod_names where ( _mod = obj.modifiers[mod_name] ) != undefined do
						_mod.enabled = state
			)

			/** Get values of wolrd aligned bbox
			  * @return float
			 */
			function getBbox obj minmax axis = getProperty (( nodeGetBoundingBox obj (matrix3 1) )[if minmax == #min then 1 else 2 ]) axis


			if selection.count > 0 then
			(
				toggleSliceModifiers (false)

				current_layer	= DIALOG_elevation_slider.SPIN_layer_current.value
				selection_min	= amin(for obj in selection collect getBbox (obj) (#min) (#z) )
				selection_max	= amax(for obj in selection collect getBbox (obj) (#max) (#z) )
				selection_center	= (selection_min + selection_max ) / 2

				layer_index_min = posToLayerIndex( selection_min )
				layer_index_max = posToLayerIndex( selection_max )
				layer_index_center = posToLayerIndex( selection_center )

				layer_indexes = #( layer_index_min, layer_index_center, layer_index_max )

				layer_index =  if ( current_layer_index = findItem layer_indexes current_layer ) > 0  then
				(
					if layer_indexes[current_layer_index + 1] != undefined then
						layer_indexes[current_layer_index + 1] -- GET NEXT ITEM
					else
						layer_indexes[1] -- GET FIRST ITEM
				)
				else
					layer_index_center -- SET CENTER LAYER AS FIRST

				toggleSliceModifiers (true)

				updateSlicePlaneSystem ( layer_index )
			)
		)

		on SLIDER_elevation BUTTONDOWN do
		(
			--for obj in selection where obj.modifiers[ #SELECT_LAYER ] != undefined do
				 --obj.modifiers[ #SELECT_LAYER ].enabled = false

		)

		on SLIDER_elevation BUTTONUP do
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
		on BTN_move_layer_increment PRESSED do
			updateSlicePlaneSystem ( if keyboard.controlPressed then 10 else 1) incremental:true

		on BTN_move_layer_increment RIGHTCLICK do
			updateSlicePlaneSystem ( if keyboard.controlPressed then -10 else -1) incremental:true

		/* ON SLIDER CHANGE */
		on SPIN_layer_current CHANGED val do
			updateSlicePlaneSystem (val)


		/* ON DIALOG OOPEN */
		on DIALOG_elevation_slider OPEN do
			updateSlicePlaneSystem (DIALOG_elevation_slider.SPIN_layer_current.value)

	)

	--format "GetDialogPos DIALOG_elevation_slider	= % \n" (GetDialogPos DIALOG_elevation_slider == [0,0])
	if GetDialogPos DIALOG_elevation_slider == [0,0] then
	(
		CreateDialog DIALOG_elevation_slider pos:[100,100] style:#(#cui_max_sized,#style_border, #style_sysmenu, #style_minimizebox) width:32  --if state then print "Rolled Down!" else print "Rolled Up!"

		cui.RegisterDialogBar DIALOG_elevation_slider minSize:[ 16, -1] maxSize:[ 16, -1] style:#(#cui_dock_right)

		cui.DockDialogBar DIALOG_elevation_slider #cui_dock_right


	)

)