/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("C O L O R")

	--QuadMenu.addMenu("_Epoly-Vertex-Color")	separators: #( 2, 7, 9 ) --title:"" flat:false
	--QuadMenu.addMenu("_Epoly-Vertex-Color")	separators: #( 2, 8, 11 ) --title:"" flat:false
	QuadMenu.addMenu("_Epoly-Vertex-Color")	separators: #( 2,  11 ) flat:true

	QuadMenu.addMenu("_Wirecolor")	--flat:false --index:1

	--FooMenu	= Menu_v("Selection")
	--FooMenu.removeItem()
	--FooMenu.clearSeparators()


	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()

	--QuadMenu.addMenu("Selection")	separators: #( 1 )	--title:"" --index: --flat:false

)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 2")
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 3")

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 4")
)


/** DEFIEN QUAD
  */
QuadMenuNew = QuadMenu_v( getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.Quads[1] )
addQuad2( QuadMenuNew.Quads[2] )
addQuad3( QuadMenuNew.Quads[3] )
addQuad4( QuadMenuNew.Quads[4] )