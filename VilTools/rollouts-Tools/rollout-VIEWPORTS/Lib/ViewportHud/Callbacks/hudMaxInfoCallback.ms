

/** GET DATA FOR 3DS MAX HUD
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
		default:	white
	)

	axises = sort(for i = 1 to (axist_string = toolMode.axisConstraints as string ).count collect axist_string[i])


	/*------------------------------------------------------------------------------
		SET HUD ROWS
	--------------------------------------------------------------------------------*/
	HUD = Hud_v pos:#( #CENTER, #TOP ) callback:hudMaxInfoCallback


	/* CURRENT LAYER */
	HUD.row (if ( LayerManager.current).name == "0" then "Default Layer" else ( LayerManager.current).name) color:yellow


	/* CURRENT TOOL */
	RowTool	= HUD.row (  HUD.Column ( toUpper ( toolMode.commandmode as string ) + " in" ) width:( if toolMode.commandmode == #move then 42 else 52  ) )


	/* COORD SYS */
	RowTool.Column ( toUpper ( coord_sys as string ) ) color:coord_sys_color width:42


	/* AXISES */
	for i = 1 to axises.count do
		RowTool.Column (toUpper (axises[i])) color:axis_colors[axises[i] as name ] width:16


	/* AXIS SNAP */
	if toolMode.commandmode == #MOVE and snapMode.axisConstraint then
		RowTool.Column ( "SNAP" )


	/* ANGLE SNAP */
	else if toolMode.commandmode == #ROTATE then
	(
		AngleSnapClass = ((( dotNetClass "Autodesk.Max.GlobalInterface").Instance).COREInterface7)

		if AngleSnapClass.ASnapStatus then
		(
			--snap_value = if (snap_value = AngleSnapClass.SnapAngle_) as integer == snap_value then  snap_value as integer else  snap_value
			snap_value = AngleSnapClass.SnapAngle_

			RowTool.Column  ("Snap " + snap_value as string + " °" ) color:white
		)
	)

	/* SNAPS MODES */
	HUD.row  (getSnapModes()) color:( color 164 164 164 )

	/* CURENT KEY FRAME */
	if sliderTime > 0 then
		HUD.row ( "FRAME: "+ (( sliderTime.frame as integer) as string ) ) color:red height:row_height_big


	/* DONT AFFECT CHILDRE */
	if not maxOps.affectChildren then
		HUD.row ( "------ "+ "DONT AFFECT CHILDREN" + " ------" ) color:orange height:row_height_big


	/* SELECTION FILETER */
	if GetSelectFilter() != 1 then
		HUD.row ( "------ "+ toUpper (GetSelectFilterName(GetSelectFilter())) + " ------" ) color:green height:row_height_big


	/* SET DATA TO HUD */
	HUD_DATA[#MAX_INFO] = HUD

)
