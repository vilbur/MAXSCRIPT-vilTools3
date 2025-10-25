/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("SELECTION SETS")

	--FooMenu	= Menu_v("_Selection-Sets")
	--FooMenu.removeItem()
	--FooMenu.clearSeparators()

	QuadMenu.addItem "_Selection-Sets" "selection_sets_select" title:"&SELECT"

	QuadMenu.addSeparator()
	
	--Menu.moveItem ("ITEM") 1

	--QuadMenu.addSeparators #()


)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("SELECTION SETS")
	
	SelectionSetsMenu = QuadMenu.addMenu("_Selection-Sets")	separators: #(  4, 6 )	--title:"" --index: --flat:false
	
	SelectionSetsMenu.removeItem 1

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("S C E N E   S T A T E S")
	
	_SceneStatesMenu = QuadMenu.addMenu("_Scene-States")	--separators: #(  4, 6 )	--title:"" --index: --flat:false
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