clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ViewportHud.ms" )	-- "./../ViewportHud.ms"



unregisterRedrawViewsCallback viewportHudCallback


Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (green) )
Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )

Row_2.pos = 24

Row_3.columns[1].width = 96


HudDisplay = HudDisplay_v Rows: #( Row_1, Row_2, Row_3 ) pos:[ 0, 64 ]


HUD_DISPLAYS[#TEST_HUD] = HudDisplay


registerRedrawViewsCallback viewportHudCallback
