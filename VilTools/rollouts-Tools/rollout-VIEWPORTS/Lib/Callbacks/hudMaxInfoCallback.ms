

/** Hud max info callback
  *
  */
function hudMaxInfoCallback =
(
	--format "\n"; print "hudMaxInfoCallback.ms.hudMaxInfoCallback()"

	row_height_big = 24

	/** Get snap modes
	  *
	  */
	function getSnapModes =
	(
		snap_modes = ""

		for i = 1 to snapMode.numOSnaps do
		(
			 --format "%: name: \"%\"\n" i (snapmode.getOSnapName i)
			 for j = 1 to ( snapMode.getOSnapNumItems i) where snapMode.getOSnapItemActive i j do
				 snap_modes += ( snapMode.getOSnapItemName i j) + " "
		)
		snap_modes --return
	)


	/*------------------------------------------------------------------------------
		GET HUD DATA
	--------------------------------------------------------------------------------*/

	axis_colors = Dictionary #( #x, red ) #( #y, green ) #( #z, ( color 0 155 255 ) )

	coord_sys = case ( coord_sys_current = GetRefCoordSys() ) of
	(
		#HYBRID:	#View
		default:	coord_sys_current
	)

	coord_sys_color = case coord_sys of
	(
		#VIEW:	( color 50 150 230 )
		#SCREEN:	( color 115 235 50 )
		#PARENT: 	red
		#LOCAL:	orange
		default:	yellow
	)

	axises = sort(for i = 1 to (axist_string = toolMode.axisConstraints as string ).count collect axist_string[i])

	layer_name = if ( LayerManager.current).name == "0" then "Default Layer" else ( LayerManager.current).name

	/*------------------------------------------------------------------------------
		SET HUD ROWS
	--------------------------------------------------------------------------------*/


	/*------ HUD ------*/
	HUD = Hud_v pos:#( #CENTER, #TOP ) callback:hudMaxInfoCallback

	/* CURRENT LAYER */
	HUD.row (layer_name) color:yellow

	/* COORD SYS */
	HUD.row ( "coordsys: " +  toUpper ( coord_sys as string ) ) color:coord_sys_color


	/* AXIS SNAP */
	if toolMode.commandmode == #MOVE and snapMode.axisConstraint then
	(
		Row	= HUD.row "Snap: " color:white

		/* AXISES */
		for i = 1 to axises.count do
			Row.Column (toUpper (axises[i])) color:axis_colors[axises[i] as name ] width:16
	)


	/* ANGLE SNAP */
	if toolMode.commandmode == #ROTATE then
	(
		AngleSnapClass = ((( dotNetClass "Autodesk.Max.GlobalInterface").Instance).COREInterface7)

		if AngleSnapClass.ASnapStatus then
		(
			--snap_value = if (snap_value = AngleSnapClass.SnapAngle_) as integer == snap_value then  snap_value as integer else  snap_value
			snap_value = AngleSnapClass.SnapAngle_

			HUD.row ("Snap Angle " + snap_value as string + "°" ) color:white
		)
	)

	/* SNAPS MODES */
	HUD.row  (getSnapModes()) color:( color 164 164 164 )

	/* CURENT KEY FRAME */
	if sliderTime > 0 then
		HUD.row ( "------------------ KEYFRAME: "+ trimRight (sliderTime as string ) "f" + " ------------------" ) color:red height:row_height_big


	/* DONT AFFECT CHILDRE */
	if not maxOps.affectChildren then
		HUD.row ( "------ "+ "DONT AFFECT CHILDREN" + " ------" ) color:orange height:row_height_big


	/* SELECTION FILETER */
	if GetSelectFilter() != 1 then
		HUD.row ( "------ "+ toUpper (GetSelectFilterName(GetSelectFilter())) + " ------" ) color:green height:row_height_big


	/* SET DATA TO HUD */
	HUD_DATA[#MAX_INFO] = HUD

)






