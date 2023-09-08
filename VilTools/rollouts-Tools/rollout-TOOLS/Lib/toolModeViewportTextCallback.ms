
unregisterRedrawViewsCallback toolModeViewportTextCallback ---- TURNOFF TEXT

/** Tool mode viewport textfn
  *fn
  */
function toolModeViewportTextCallback =
(
	--format "\n"; print "ToolModeViewportText_v.toolModeViewportTextCallback()"

	axis_colors = Dictionary #( #x, red ) #( #y, green ) #( #z, ( color 50 150 230 ) )

	coord_sys = case ( coord_sys_current = GetRefCoordSys() ) of
	(
		#HYBRID:	#View
		--:
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

	snap_modes = ""

	for i = 1 to snapMode.numOSnaps do
	(
		 --format "%: name: \"%\"\n" i (snapmode.getOSnapName i)
		 for j = 1 to ( snapMode.getOSnapNumItems i) where snapMode.getOSnapItemActive i j do
			 snap_modes += ( snapMode.getOSnapItemName i j) + " "
	)

	column_width = 16

	viewport_mid_X = (gw.getWinSizeX()/2)

	axist_string = toolMode.axisConstraints as string

	axises = sort(for i = 1 to axist_string.count collect axist_string[i])


	gw.setTransform( Matrix3 1 )

	/* COORD SYS */
	if coord_sys != #world then
		gw.wText ( [viewport_mid_X, 32, 0] ) ( toUpper (coord_sys as string ) ) color:coord_sys_color



	/* AXIS SNAP */
	if toolMode.commandmode == #MOVE and snapMode.axisConstraint then
		gw.wText ( [viewport_mid_X + 32 , 48, 0] ) "Snap" color:white

	/* ANGLE SNAP */
	if toolMode.commandmode == #ROTATE then
	(
		AngleSnapClass = ((( dotNetClass "Autodesk.Max.GlobalInterface").Instance).COREInterface7)

		if AngleSnapClass.ASnapStatus then
		(
			snap_value = if (snap_value = AngleSnapClass.SnapAngle_) as integer == snap_value then  snap_value as integer else  snap_value

			gw.wText ( [viewport_mid_X + 32 , 48, 0] ) ("Snap " + snap_value as string + "°" ) color:white
		)
	)


	/* AXISES */
	for i = 1 to axises.count do
		gw.wText ( [viewport_mid_X  , 48, 0] ) ( toUpper (axises[i]) ) color:axis_colors[axises[i] as name]

	/* SNAPS */
	gw.wText ( [ viewport_mid_X , 64, 0] ) snap_modes color:( color 164 164 164 )



	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	CompleteRedraw()

)










