clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../HudDisplay.ms" )	-- "./../HudDisplay.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Callbacks/viewportHudCallback.ms" )	-- "./../../Callbacks/viewportHudCallback.ms"


unregisterRedrawViewsCallback viewportHudCallback

/*------------------------------------------------------------------------------
	SET HUD DATA
--------------------------------------------------------------------------------*/
function setHudData =
(
	--format "\n"; print "ViewportHudTest.ms.setHudData()"
	Column	= HudColumn_v "Row 1"
	Row	= HudRow_v	columns: #( Column )
	HUD	= Hud_v	Rows: #( Row )

	HUD_DATA[#HUD_DATA] = HUD
)
/*------------------------------------------------------------------------------
	SET HUD CALLBACK -- callback for refreshing data
--------------------------------------------------------------------------------*/
/** Data callback
  *
  */
function refreshDataCallback =
(
	--format "\n"; print "ViewportHudTest.ms.refreshDataCallback()"
	HUD_DATA[#CALLBACK_DATA].Rows[1].Columns[1].text = ((timestamp() / 1000) as string )
)

function setDataCallback =
(
	--format "\n"; print "ViewportHudTest.ms.setHudData()"
	Column	= HudColumn_v "INIT TEXT"
	Row	= HudRow_v columns: #( Column )
	--HUD	= Hud_v Rows: #( Row )
	HUD	= Hud_v callback: refreshDataCallback Rows: #( Row )

	HUD_DATA[#CALLBACK_DATA] = HUD
)

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

	HUD_DATA[#TEST_HUD] = HUD
)

/*------------------------------------------------------------------------------
	POSITION TEST
--------------------------------------------------------------------------------*/

function positionTest =
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

	HUD.Rows = #( HudRow_v columns: #( HudColumn_v ("CENTER HUD") ) )

	HUD_DATA[#HUD_RIGHT] = HUD
)

/*------------------------------------------------------------------------------
	SHORTHAND DEFINE ONLY ROWS
------------------------------------------------------------------------------*/
function shorthandDefinition =
(
	HUD = Hud_v()

	/* DEFINE ROW */
	Row_1 = HUD.row ( "Row 1" )

	Row_1.Column "Column 2" width:96
	Row_1.Column "Column 3" color:yellow

	/* OTHER ROWS */
	HUD.row ( "Row 2" ) color:red height:64
	HUD.row ( "Row 3" ) color:red height:-32

	/* ADD TO HUD DATA */
	HUD_DATA[#QUICK_ADD] = HUD
)

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

--setHudData()
--setDataCallback()

--defineRowsAndColumns()
--positionTest()
shorthandDefinition()




/* REGISTR CALLBACK */
registerRedrawViewsCallback viewportHudCallback
