clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ViewportHud.ms" )	-- "./../ViewportHud.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Callbacks/viewportHudCallback.ms" )	-- "./../../Callbacks/viewportHudCallback.ms"


unregisterRedrawViewsCallback viewportHudCallback


/*------------------------------------------------------------------------------
	BASIC TEST
--------------------------------------------------------------------------------*/

--Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
--Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (green) )
--Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )
--
--Row_2.pos = 24
--
--Row_3.columns[1].width = 96
--
--HudDisplay = HudDisplay_v Rows: #( Row_1, Row_2, Row_3 ) pos:[ 0, 64 ]

--HUD_DISPLAYS[#TEST_HUD] = HudDisplay



/*------------------------------------------------------------------------------
	POSITION TEST
--------------------------------------------------------------------------------*/


Row_1 = HudRow_v columns: #( HudColumn_v ("CENTER HUD") )



--HudDisplay = HudDisplay_v pos:[ #CENTER, #CENTER ] Rows: #( Row_1, Row_2, Row_3 )

align_position = #( #CENTER, #CENTER )

HudDisplay = HudDisplay_v pos:align_position Rows: #( Row_1 )


HUD_DISPLAYS[#HUD_RIGHT] = HudDisplay







registerRedrawViewsCallback viewportHudCallback
