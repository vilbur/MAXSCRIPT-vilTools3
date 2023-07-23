/*
   DOCUMENTATION: "./readme.md"
*/

RcQuad 	= QuadMenu_v("_Right Click Quad")

QuadMenu1	= RcQuad.Quads[1]
QuadMenu2	= RcQuad.Quads[2]
QuadMenu3	= RcQuad.Quads[3]
QuadMenu4	= RcQuad.Quads[4]




/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/


/**
		BOTTOM RIGHT quad menu - ADD default items
 */
function editQuad1 =
(
	--format "\n"; print ".editQuad1()"
	--QuadMenu1.addMenu("_Modifiers")	index:1

	--QuadMenu1.addSeparator index:2

	--QuadMenu1.addMenu("_Tools")

	QuadMenu1.addItem ("_Modifiers") ("modifier_add_editpoly") index:1
	QuadMenu1.addSeparator index:2


)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 =
(

)


/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 =
(

)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 =
(

)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/

----clearListener()
--removeItemsQuad1()
--removeItemsQuad2()
--removeItemsQuad3()
--removeItemsQuad4()
--
--editQuad1()
--editQuad2()
--editQuad3()
--editQuad4()

--/* Set options */
RcQuad.setRightClick()
--
--RcQuad.showAllQuads()
