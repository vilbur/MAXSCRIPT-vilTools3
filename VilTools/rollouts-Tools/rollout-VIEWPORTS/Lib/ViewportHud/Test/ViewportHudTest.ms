clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../HudDisplay.ms" )	-- "./../HudDisplay.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Callbacks/viewportHudCallback.ms" )	-- "./../../Callbacks/viewportHudCallback.ms"


unregisterRedrawViewsCallback viewportHudCallback


/*------------------------------------------------------------------------------
	DEFINE ROWS AND COLUMNS
--------------------------------------------------------------------------------*/

function defineRowsAndColumns =
(
	--format "\n"; print "ViewportHudTest.ms.defineRowsAndColumns()"
	Row_1 = HudRow_v columns: #( HudColumn_v ("Row 1") )
	Row_2 = HudRow_v columns: #( HudColumn_v ("Row 2"),	HudColumn_v ("Row 2") (red) )
	Row_3 = HudRow_v columns: #( HudColumn_v ("Column 1"),	HudColumn_v ("Column 2") )

	Row_2.height = 32

	Row_3.columns[1].width = 96

	HUD = Hud_v Rows: #( Row_1, Row_2, Row_3 ) pos:[ 0, 32 ]

	HUD_DISPLAYS[#TEST_HUD] = HUD

)



/*------------------------------------------------------------------------------
	POSITION TEST
--------------------------------------------------------------------------------*/

function positionTest =
(
	Row_1 = HudRow_v columns: #( HudColumn_v ("CENTER HUD") )

	--HUD = Hud_v pos:[ #CENTER, #CENTER ] Rows: #( Row_1, Row_2, Row_3 )

	align_position = #( #CENTER, #CENTER )

	HUD = Hud_v pos:align_position Rows: #( Row_1 )


	HUD_DISPLAYS[#HUD_RIGHT] = HUD

)


/*------------------------------------------------------------------------------
	SHORTHAND DEFINE ONLY ROWS
------------------------------------------------------------------------------*/
function simpleDefineOnlyRows =
(
	/* DEFAULT POSTION */
	--HUD = Hud_v()

	/* TOP POSTION */
	HUD = Hud_v pos:#( #LEFT,	#TOP )
	--HUD = Hud_v pos:#( #CENTER,	#TOP )
	--HUD = Hud_v pos:#( #RIGHT,	#TOP )

	/* CENTER Y POSTION */
	--HUD = Hud_v pos:#( #LEFT,	#CENTER )
	--HUD = Hud_v pos:#( #CENTER,	#CENTER )
	--HUD = Hud_v pos:#( #RIGHT,	#CENTER )
	--HUD = Hud_v pos:#( #RIGHT,	#CENTER )  offset:[ -256, 0]


	/* BOTTOM POSTION */

	--HUD = Hud_v pos:#( #LEFT,	#BOTTOM )
	--HUD = Hud_v pos:#( #CENTER,	#BOTTOM )
	--HUD = Hud_v pos:#( #RIGHT,	#BOTTOM )
	--HUD = Hud_v pos:#( #RIGHT,	#BOTTOM ) offset:[ -256, -512 ]


	/* DEFINE ROWS */
	HUD.row ( "Row 1" )
	HUD.row ( "Row 2" ) color:red height:64
	HUD.row ( "Row 3" ) color:red height:-64

	/* ADD TO HUD DATA */
	HUD_DISPLAYS[#QUICK_ADD] = HUD


)

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/
--defineRowsAndColumns()
--positionTest()
simpleDefineOnlyRows()




/* REGISTR CALLBACK */
registerRedrawViewsCallback viewportHudCallback
