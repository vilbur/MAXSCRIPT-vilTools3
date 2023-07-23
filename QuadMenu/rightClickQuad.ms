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
function editQuad1 =
(
	QuadMenu1.setTitle("Edit            ")

	--SnapToMenu 	= (QuadMenu_v("Snap")).Quads[1].menu

	--QuadMenu1.addSeparator()

	--QuadMenu1.addMenu(SnapToMenu) --flat:false --index:1
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 =
(
	QuadMenu2.setTitle("Transform            ")
	--
	--QuadMenu2.addMenu("_Modifiers") --flat:false --index:1
)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 =
(
	QuadMenu3.setTitle("               Snap")

	--QuadMenu3.addMenu("_Layers") --flat:false --index:1

	--SnapToMenu 	= (QuadMenu_v("Snap")).Quads[1].menu

	--QuadMenu1.addSeparator()

	--QuadMenu1.addMenu(SnapToMenu) --flat:false --index:1
)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 =
(
	messageBox "Yupiii" title:"Title"  beep:false
	QuadMenu4.setTitle("              Selection")

	QuadMenu4.addMenu("_Wirecolor") --flat:false --index:1

)




editQuad1()
editQuad2()
editQuad3()
editQuad4()

--/* Set options */
RcQuad.setRightClick()
--
--RcQuad.showAllQuads()
