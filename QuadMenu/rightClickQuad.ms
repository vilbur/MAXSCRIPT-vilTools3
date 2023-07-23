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
	QuadMenu1.setTitle("Edit            ")

	QuadMenu1.addMenu("_Wirecolor") --flat:false --index:1 -- "./../VilTools/rollouts-Tools/rollout-SELECTION/Wirecolor.mcr"

	--QuadMenu1.addMenu("_Tools")

	--QuadMenu1.addItem ("_Modifiers") ("modifier_add_editpoly") index:1
	--QuadMenu1.addSeparator index:2


)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 =
(
	QuadMenu1.setTitle("Selection            ")

)


/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 =
(
	QuadMenu3.setTitle("               Title")

)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 =
(
	QuadMenu3.setTitle("               Title")

)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/



editQuad1()
editQuad2()
editQuad3()
editQuad4()

--/* Set options */
RcQuad.setRightClick()
--
--RcQuad.showAllQuads()
