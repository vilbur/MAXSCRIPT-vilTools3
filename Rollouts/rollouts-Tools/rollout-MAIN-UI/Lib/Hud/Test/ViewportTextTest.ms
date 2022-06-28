clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Hud.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../HudItem/HudItem.ms" )
/** Declare just once, otherwise hide() doesn't work 
 */
function declareHud =
(
	--if( _Hud==undefined ) then
	--(
	--	filein ( getFilenamePath(getSourceFileName()) + "/../../includes.ms" )
	--	
		global _Hud
		
		_Hud = Hud_v id: "Hudest"
	--)
)


/** Show text test
 */
function showTextTest =
(
	_Hud.show "Lorem ipsum"
)

/** Hide text test
 */
function hideTextTest =
(
	_Hud.hide() 
)


/*---------------------------------------
	RUN TESTS
-----------------------------------------*/

--declareHud()
--showTextTest()
--hideTextTest()
 

HudItem = HudItem_v id:"gw_test" text:"Test" position:[512,0,0]
HudItem.show()

--HudItem.hide()