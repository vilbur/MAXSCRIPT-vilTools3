clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ViewportHud.ms" )	-- "./../ViewportHud.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Callbacks/viewportHudCallback.ms" )	-- "./../../Callbacks/viewportHudCallback.ms"


unregisterRedrawViewsCallback viewportHudCallback


/*------------------------------------------------------------------------------
	DEFINE ROWS AND COLUMNS
--------------------------------------------------------------------------------*/

Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (green) ) pos:32
Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )

Row_2.pos = 24

Row_3.columns[1].width = 96

HUD = Hud_v Rows: #( Row_1, Row_2, Row_3 ) pos:[ 0, 64 ]

HUD_DISPLAYS[#TEST_HUD] = HUD


/*------------------------------------------------------------------------------
	POSITION TEST
--------------------------------------------------------------------------------*/

--
--Row_1 = HudRow_v columns: #( HudColumn_v ("CENTER HUD") )
--
--
----HUD = Hud_v pos:[ #CENTER, #CENTER ] Rows: #( Row_1, Row_2, Row_3 )
--
--align_position = #( #CENTER, #CENTER )
--
--HUD = Hud_v pos:align_position Rows: #( Row_1 )
--
--
--HUD_DISPLAYS[#HUD_RIGHT] = HUD


/*------------------------------------------------------------------------------
	SIMPLE DEFINE ONLY ROWS
--------------------------------------------------------------------------------*/

--HUD = Hud_v pos:#( #CENTER, #CENTER )
--
--HUD.row ( "Row 1" )
--HUD.row ( "Row 2" ) color:red pos:64
--
--HUD_DISPLAYS[#QUICK_ADD] = HUD
--






registerRedrawViewsCallback viewportHudCallback
