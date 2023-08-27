filein( getFilenamePath(getSourceFileName()) + "/createQuad.ms" ) -- "./createQuad.ms"

/*------ DOCUMENTATION ------

	 "./readme.md"

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

function PLACEHOLDERmenu QuadMenu =
(
	--format "\n"; print "PLACEHOLDERmenu()"
)


/*------------------------------------------------------------------------------
	RIGHT CLICK QUAD
--------------------------------------------------------------------------------*/

EditQuad = createQuad( "_RightClickQuad" ) #(

	--#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#EDIT1,	 -- "./Quads/EDIT1-menu.ms"
	#EDIT2,	 -- "./Quads/EDIT2-menu.ms"
	#EDIT3,	 -- "./Quads/EDIT3-menu.ms"
	#EDIT4	 -- "./Quads/EDIT4-menu.ms"
)

/*------------------------------------------------------------------------------
	CONTROL QUAD
--------------------------------------------------------------------------------*/
Object_Selection = createQuad( "_ControlQuad" ) #(

	#OBJECT,	 -- "./Quads/OBJECT-menu.ms"
	#visiblitySUBOBJECT,	 -- "./Quads/visiblitySUBOBJECT-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#SELECTION	 -- "./Quads/SELECTION-menu.ms"

)

/*------------------------------------------------------------------------------
	SHIFT ALT QUAD
--------------------------------------------------------------------------------*/
Snap_Transform_Pivot = createQuad( "_ShiftAltQuad" ) #(

	#SNAP,	 -- "./Quads/SNAP-menu.ms"
	#COORDSYS,	 -- "./Quads/COORDSYS-menu.ms"
	#PIVOT,	 -- "./Quads/PIVOT-menu.ms"
	#TRANSFORM	 -- "./Quads/TRANSFORM-menu.ms"

)

/*------------------------------------------------------------------------------
	ALT QUAD
--------------------------------------------------------------------------------*/
Group_Primitives = createQuad( "Animation" ) #(

	#ANIMATION,	 -- "./Quads/ANIMATION-menu.ms"
	#PRIMITIVES,	 -- "./Quads/PRIMITIVES-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#GROUP	 -- "./Quads/GROUP-menu.ms"

	--#SELECTION,	 -- "./Quads/SELECTION-menu.ms"
)

/*------------------------------------------------------------------------------
	CONTROL ALT QUAD
--------------------------------------------------------------------------------*/
Scene_Materials = createQuad( "_ControlAltQuad" ) #(

	#SCENE,	 -- "./Quads/SCENE-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#MATERIALS	 -- "./Quads/MATERIALS-menu.ms"

)

/*------------------------------------------------------------------------------
	CONTROL SHIFT QUAD
--------------------------------------------------------------------------------*/
Modifiers = createQuad( "_CotrolShiftQuad" ) #(

	#MODIFIERS1,	 -- "./Quads/MODIFIERS-1-menu.ms"
	#MODIFIERS2,	 -- "./Quads/MODIFIERS-2-menu.ms"
	#MODIFIERSSTACK,	 -- "./Quads/MODIFIERSSTACK-menu.ms"
	#MODIFIERS4	 -- "./Quads/MODIFIERS-4-menu.ms"

)

/*------------------------------------------------------------------------------
	VIEPORTS QUAD - Under "V" key
--------------------------------------------------------------------------------*/
ViewportsMenu = createQuad( "Viewports" ) #(

	#PLACEHOLDER,	 -- "./Quads/PLACEHOLDER-menu.ms"
	#ViewportsLayout,	 -- "./Quads/VIEWPORTS-LAYOUT-menu.ms"
	#ViewportsManage,	 -- "./Quads/VIEWPORTS-MANAGE-menu.ms"
	#PLACEHOLDER	 -- "./Quads/PLACEHOLDER-menu.ms"

)
/*------------------------------------------------------------------------------
	LAYERS QUAD
--------------------------------------------------------------------------------*/
Layers = createQuad( "_ShiftQuad" ) #(

	#LAYERS1,	 -- "./Quads/LAYERS-1-menu.ms"
	#LAYERS2,	 -- "./Quads/LAYERS-2-menu.ms"
	#LAYERS3,	 -- "./Quads/LAYERS-3-menu.ms"
	#LAYERS4	 -- "./Quads/LAYERS-4-menu.ms"

)

/*==============================================================================

		CREATE QUAD MENUS

================================================================================*/

EditQuad.setRightClick() --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed


/* CONTROL */
Object_Selection.setRightClick which:#controlPressed

/* SHIFT */
Layers.setRightClick which:#shiftPressed

/* ALT */
Group_Primitives.setRightClick which:#altPressed

/* CONTROL SHIFT */
Modifiers.setRightClick which:#shiftAndControlPressed

/* CONTROL ALT */
Scene_Materials.setRightClick which:#controlAndAltPressed

/* SHIFT ALT */
Snap_Transform_Pivot.setRightClick which:#shiftAndAltPressed
