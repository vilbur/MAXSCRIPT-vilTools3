




/** Selection quad menu
 */
function SELECTIONmenu QuadMenu =
(
	--format "\n"; print "selectionQuad.ms.selectionQuadMenu()"
	QuadMenu.setTitle("SELECTION")

	QuadMenu.addMenu("_Wirecolor")	--flat:false --index:1

)
--format "EMPTY_QUAD	= % \n" EMPTY_QUAD



--SelectionQuad = Menu_v("Animation" ) quad:true
--
--LayerQuad = Menu_v("Layers" ) quad:true
----SelectionQuad = Menu_v("ABCDEFGHIJKLMNOPQRSTUVWXYZ" )
--
----format "SelectionQuad	= % \n" SelectionQuad
----format "LayerQuad	= % \n" LayerQuad
--
--format "SelectionQuad.menu.name	= % \n" (SelectionQuad.menu.getTitle())
--format "LayerQuad.menu.name	= % \n" (LayerQuad.menu.getTitle())
--
--
--SelectionQuad.addMenu("_Wirecolor")	--flat:false --index:1
--
--LayerQuad.addMenu("_Layers")	--flat:false --index:1
--
--global RightClickQuad = QuadMenu_v("_rightClickQuad")
--global ControlQuad = QuadMenu_v("_controlQuad")
--
--
--RightClickQuad.addMenu SelectionQuad #BOTTOM_RIGHT
--
--ControlQuad.addMenu LayerQuad #BOTTOM_RIGHT
----RightClickQuad.addMenu SelectionQuad #BOTTOM_LEFT
--
--
--format "RightClickQuad.Quads	= % \n" RightClickQuad.Quads
----MainQuad.addMenu QuadMenu #BOTTOM_LEFT
----MainQuad.addMenu QuadMenu #BOTTOM_RIGHT
----MainQuad.addMenu QuadMenu #TOP_LEFT
----MainQuad.addMenu QuadMenu #TOP_RIGHT
--
--RightClickQuad.setRightClick() --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
--ControlQuad.setRightClick which:#controlPressed --#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
--

--AnimationQuad = QuadMenu_v("Animation")
--
--
--format "AnimationQuad.quadMenu	= % \n" AnimationQuad.quadMenu
--format "AnimationQuad.quadMenu	= % \n" (AnimationQuad.quadMenu.getMenu(3))
--format "AnimationQuad.quadMenu	= % \n" (AnimationQuad.quadMenu.getMenu(3))
