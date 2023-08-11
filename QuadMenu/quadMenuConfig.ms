filein( getFilenamePath(getSourceFileName()) + "/createQuad.ms" ) -- "./createQuad.ms"

/*------ DOCUMENTATION ------

	 "./readme.md"

*/

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
/**
 */
function PLACEHOLDERmenu QuadMenu =
(
	--format "\n"; print "PLACEHOLDERmenu()"
)


/*------------------------------------------------------------------------------

	RIGHT CLICK QUAD

--------------------------------------------------------------------------------*/

RightClickQuad = createQuad( "_RightClickQuad" ) #(

	#EDIT1,	 -- "./Quads/EDIT1-menu.ms"
	#EDIT2,	 -- "./Quads/EDIT2-menu.ms"
	#EDIT3,	 -- "./Quads/EDIT3-menu.ms"
	#EDIT4	 -- "./Quads/EDIT4-menu.ms"
)

/*------------------------------------------------------------------------------

	CONTROL QUAD

--------------------------------------------------------------------------------*/
ControlQuad = createQuad( "_ControlQuad" ) #(

	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#PRIMITIVES,	 -- "./Quads/PRIMITIVES-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#PLACEHOLDER	 -- "./Quads/PLACEHOLDER-menu.ms"

	--#SELECTION,	 -- "./Quads/SELECTION-menu.ms"
	--#PIVOT,	 -- "./Quads/PIVOT-menu.ms"
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

	#visiblityOBJECTS,	 -- "./Quads/visiblityOBJECTS-menu.ms"
	#visiblitySUBOBJECT,	 -- "./Quads/visiblitySUBOBJECT-menu.ms"
	#LAYERS,	 -- "./Quads/LAYERS-menu.ms"
	#SELECTION	 -- "./Quads/SELECTION-menu.ms"
)

/*------------------------------------------------------------------------------

	ALT QUAD

--------------------------------------------------------------------------------*/
AltQuad = createQuad( "Animation" ) #(

	#ANIMATION,	 -- "./Quads/ANIMATION-menu.ms"
	#COORDSYS,	 -- "./Quads/COORDSYS-menu.ms"
	#SNAP,	 -- "./Quads/SNAP-menu.ms"
	#PLACEHOLDER	 -- "./Quads/PLACEHOLDER-menu.ms"
)

/*------------------------------------------------------------------------------

	CONTROL ALT QUAD

--------------------------------------------------------------------------------*/
ControlAltQuad = createQuad( "_ControlAltQuad" ) #(

	#MODIFIERS1,	 -- "./Quads/MODIFIERS-1-menu.ms"
	#MODIFIERS2,	 -- "./Quads/MODIFIERS-2-menu.ms"
	#MODIFIERSSTACK,	 -- "./Quads/MODIFIERSSTACK-menu.ms"
	#MODIFIERS3	 -- "./Quads/MODIFIERS-3-menu.ms"

	--#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	--#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	--#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	--#PLACEHOLDER	 -- "./Quads/PLACEHOLDER-menu.ms"

)

/*------------------------------------------------------------------------------

	CONTROL SHIFT QUAD

--------------------------------------------------------------------------------*/
CotrolShiftQuad = createQuad( "_CotrolShiftQuad" ) #(

	#SCENE,	 -- "./Quads/SCENE-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#MATERIALS	 -- "./Quads/MATERIALS-menu.ms"
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
