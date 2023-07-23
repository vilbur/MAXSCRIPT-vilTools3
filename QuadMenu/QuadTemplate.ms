
MainQuad 	= QuadMenu_v("TITLE")

QuadMenu1	= MainQuad.Quads[1]
QuadMenu2	= MainQuad.Quads[2]
QuadMenu3	= MainQuad.Quads[3]
QuadMenu4	= MainQuad.Quads[4]


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
--MainQuad.setRightClick() --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--MainQuad.showAllQuads()
