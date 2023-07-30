filein( getFilenamePath(getSourceFileName()) + "/createQuad.ms" ) -- "./createQuad.ms"


clearListener()

/**
 *
 */
macroscript	test_macroscript
category:	"_Test"
buttontext:	"Test"
toolTip:	"Test"
--icon:	"Menu:Tooltip"
--icon:	"Tooltip:" --"#(path, index)"
(
	messageBox "Test" title:"Test Macroscript"
)


/*------------------------------------------------------------------------------

	RIGHT CLICK QUAD

--------------------------------------------------------------------------------*/

RightClickQuad = createQuad( "_RightClickQuad" ) #(

	#EDIT1,	 -- "./Quads/EDIT1-menu.ms"
	#EDIT2,	 -- "./Quads/EDIT2-menu.ms"
	#HIDEPOLY,	 -- "./Quads/HIDEPOLY-menu.ms"
	#PALCEHOLDER	 -- "./Quads/PALCEHOLDER-menu.ms"
)

/*------------------------------------------------------------------------------

	CONTROL QUAD

--------------------------------------------------------------------------------*/
ControlQuad = createQuad( "_ControlQuad" ) #(

	#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	#PRIMITIVES,	 -- "./Quads/PRIMITIVES-menu.ms"
	#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	#PALCEHOLDER	 -- "./Quads/PALCEHOLDER-menu.ms"

	--#SELECTION,	 -- "./Quads/SELECTION-menu.ms"
	--#PIVOT,	 -- "./Quads/PIVOT-menu.ms"
	--#SNAP,	 -- "./Quads/SNAP-menu.ms"
	--
	--#(
	--	#SNAP,	 -- "./Quads/SNAP-menu.ms"
	--	#TRANSFORM	 -- "./Quads/TRANSFORM-menu.ms"
	--)

)
/*------------------------------------------------------------------------------

	SHIFT QUAD

--------------------------------------------------------------------------------*/
ShiftQuad = createQuad( "_ShiftQuad" ) #(

	#SELECTION,	 -- "./Quads/SELECTION-menu.ms"
	#visiblityOBJECTS,	 -- "./Quads/visiblityOBJECTS-menu.ms"
	#visiblitySUBOBJECT,	 -- "./Quads/visiblitySUBOBJECT-menu.ms"
	#LAYERS	 -- "./Quads/LAYERS-menu.ms"
)

/*------------------------------------------------------------------------------

	ALT QUAD

--------------------------------------------------------------------------------*/
AltQuad = createQuad( "_Animation" ) #(

	--#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	--#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	--#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	--#PALCEHOLDER	 -- "./Quads/PALCEHOLDER-menu.ms"
)

/*------------------------------------------------------------------------------

	CONTROL ALT QUAD

--------------------------------------------------------------------------------*/
ControlAltQuad = createQuad( "_ControlAltQuad" ) #(

	#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	#ANIMATION,	 -- "./Quads/ANIMATION-menu.ms"
	#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	#PALCEHOLDER	 -- "./Quads/PALCEHOLDER-menu.ms"
)

/*------------------------------------------------------------------------------

	CONTROL SHIFT QUAD

--------------------------------------------------------------------------------*/
CotrolShiftQuad = createQuad( "_CotrolShiftQuad" ) #(

	#SCENE,	 -- "./Quads/SCENE-menu.ms"
	#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	#PALCEHOLDER,	 -- "./Quads/PALCEHOLDER-menu.ms"
	#PALCEHOLDER	 -- "./Quads/PALCEHOLDER-menu.ms"
)


/*==============================================================================

		CREATE QUAD MENUS

================================================================================*/

RightClickQuad.setRightClick() --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

ControlQuad.setRightClick which:#controlPressed

ShiftQuad.setRightClick which:#shiftPressed

AltQuad.setRightClick which:#altPressed

ControlAltQuad.setRightClick which:#controlAndAltPressed

CotrolShiftQuad.setRightClick which:#shiftAndControlPressed









