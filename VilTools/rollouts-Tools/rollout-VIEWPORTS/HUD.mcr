filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportHud/Hud.ms" )	-- "./Lib/ViewportHud/ViewportHud.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportHudCallback.ms" )	-- "./Lib/Callbacks/viewportHudCallback.ms"


--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/hudObjectInfo.ms" )	-- "./Lib/Callbacks/hudObjectInfo.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/viewportInfoCallback.ms" )	-- "./Lib/Callbacks/viewportInfoCallback.ms"


/** Toggle hud callback
  */
function toggleHudCallback hud_name data: =
(
	--format "\n"; print "HUD.mcr.toggleHudCallbeack()"

	if data != unsupplied then
	(
		print "HudCallback: ON"

		HUD_DATA[hud_name] = data

		unregisterRedrawViewsCallback viewportHudCallback

		registerRedrawViewsCallback viewportHudCallback
	)
	else
	(
		RemoveDictValue HUD_DATA hud_name

		if HUD_DATA.count == 0 then
		(
			unregisterRedrawViewsCallback viewportHudCallback

			print "HudCallback: OFF"
		)
	)
)


/**
 */
macroscript	_viewport_hud_info
category:	"_Viewports"
buttontext:	"Viewport Info"
--icon:	"control:checkbox|autorun:true|align:#left"
icon:	"control:checkbutton|autorun:true"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"

		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			/*------ GET HUD DATA ------*/
			--axis_colors = Dictionary #( #x, red ) #( #y, green ) #( #z, ( color 50 150 230 ) )
			--
			--coord_sys = case ( coord_sys_current = GetRefCoordSys() ) of
			--(
			--	#HYBRID:	#View
			--	default:	coord_sys_current
			--)
			--
			--coord_sys_color = case coord_sys of
			--(
			--	#VIEW:	( color 50 150 230 )
			--	#SCREEN:	( color 115 235 50 )
			--	#PARENT: 	red
			--	#LOCAL:	orange
			--	default:	yellow
			--)
			--
			--snap_modes = ""
			--
			--for i = 1 to snapMode.numOSnaps do
			--(
			--	 --format "%: name: \"%\"\n" i (snapmode.getOSnapName i)
			--	 for j = 1 to ( snapMode.getOSnapNumItems i) where snapMode.getOSnapItemActive i j do
			--		 snap_modes += ( snapMode.getOSnapItemName i j) + " "
			--)
			--
			--axist_string = toolMode.axisConstraints as string
			--
			--axises = sort(for i = 1 to axist_string.count collect axist_string[i])
			--
			--layer_name = if ( LayerManager.current).name == "0" then "Default Layer" else ( LayerManager.current).name
			--
			--
			--/*------ HUD ------*/
			--HUD = Hud_v pos:#( #CENTER, #CENTER )
			--
			--/* CURRENT LAYER */
			--HUD.row (layer_name) color:yellow
			--
			--
			--/* COORD SYS */
			----if coord_sys != #world then
			--HUD.row ( "coordsys: " +  toUpper ( coord_sys as string ) ) color:coord_sys_color
			--
			--
			----position_Y += line_height -- set height for a AXISES loop
			--
			--/* AXISES */
			----for i = 1 to axises.count do
			--	--HUD.row ( [viewport_mid_X + (column_width * ( i - 1 ) ) ,  position_Y, 0] ) ( toUpper (axises[i]) ) color:axis_colors[axises[i] as name]
			--
			--
			--/* AXIS SNAP */
			--if toolMode.commandmode == #MOVE and snapMode.axisConstraint then
			--	HUD.row "Snap Axis" color:white
			--
			--
			--/* ANGLE SNAP */
			--if toolMode.commandmode == #ROTATE then
			--(
			--	AngleSnapClass = ((( dotNetClass "Autodesk.Max.GlobalInterface").Instance).COREInterface7)
			--
			--	if AngleSnapClass.ASnapStatus then
			--	(
			--		--snap_value = if (snap_value = AngleSnapClass.SnapAngle_) as integer == snap_value then  snap_value as integer else  snap_value
			--		snap_value = AngleSnapClass.SnapAngle_
			--
			--		HUD.row ("Snap Angle " + snap_value as string + "°" ) color:white
			--	)
			--)

			--
			--
			/* SNAPS MODES */
			--HUD.row ( [ viewport_mid_X ,  position_Y += line_height, 0] ) snap_modes color:( color 164 164 164 )
			--
			/* CURENT KEY FRAME */
			--if sliderTime > 0 then
			--	HUD.row ( [ viewport_mid_X , position_Y += 32, 0] ) ( "------------------ KEYFRAME: "+ trimRight (sliderTime as string ) "f" + " ------------------" ) color:red
			--
			--
			/* DONT AFFECT CHILDRE */
			--if not maxOps.affectChildren then
			--	HUD.row ( [ viewport_mid_X , position_Y += 32, 0] ) ( "------ "+ "DONT AFFECT CHILDREN" + " ------" ) color:red
			--
			--
			/* SELECTION FILETER */
			--if GetSelectFilter() != 1 then
			--	HUD.row ( [ viewport_mid_X , position_Y += 64, 0] ) ( "------ "+ toUpper (GetSelectFilterName(GetSelectFilter())) + " ------" ) color:red
			--

			--toggleHudCallback #VIEWPORT_INFO data:HUD
		)
		else
			toggleHudCallback #VIEWPORT_INFO
	)
)

/**
 */
macroscript	_viewport_hud_info_object
category:	"_Viewports"
buttontext:	"Selection Info"
--icon:	"control:checkbox|autorun:true|align:#left"
icon:	"control:checkbutton|autorun:true"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\HUD.mcr"


		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
			Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (green) )
			Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )

			Row_2.pos = 24

			Row_3.columns[1].width = 96


			HUD = Hud_v Rows: #( Row_1, Row_2, Row_3 ) pos:[ 256, 64 ]


			toggleHudCallback #OBJECT_INFO data:HUD
		)
		else
			toggleHudCallback #OBJECT_INFO

	)
)
