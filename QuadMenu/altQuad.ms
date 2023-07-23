
AltQuad 	= QuadMenu_v("_Alt Quad")

QuadMenu1	= AltQuad.Quads[1]
QuadMenu2	= AltQuad.Quads[2]
QuadMenu3	= AltQuad.Quads[3]
QuadMenu4	= AltQuad.Quads[4]


/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/


/**
		BOTTOM RIGHT quad menu - ADD default items
 */
function editQuad1 =
(
	QuadMenu1.setTitle("")

	--fooMenu	= Menu_v("fooMenu")

	QuadMenu1.addMenu("") flat:false --index:1

	QuadMenu1.addSeparator index:1
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/


/**
		RIGHT TOP quad menu - ADD default items
*/
function editQuad2 =
(

)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/


/**
		TOP LEFT quad menu - ADD default items
*/
function editQuad3 =
(

)

/*==============================================================================

	QUAD 1 - BOTTOM - LEFT

================================================================================*/

/**
		BOTTOM LEFT quad menu - ADD default items
*/
function editQuad4 =
(

)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/



--editQuad1()
--editQuad2()
--editQuad3()
--editQuad4()

/* Set options */
VilToolsQuad.setRightClick which:#altPressed --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--AltQuad.showAllQuads()
