/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O V E")

	--FooMenu	= Menu_v("Selection")
	--FooMenu.removeItem()
	--FooMenu.clearSeparators()


	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()

	QuadMenu.addMenu("_SceneLayers-Move")	title:"Move To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Copy")	title:"Copy To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Instance")	title:"Instance To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Reference")	title:"Reference To"	flat:false --separators: #( 1 ) --index:--index:--index:

)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E" )
	QuadMenu.addMenu("_SceneLayers-Manage")	--title:""	flat:false --separators: #( 1 ) --index:--index:--index:

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	--QuadMenu.setTitle("I N S T A N C E")
	QuadMenu.setTitle("V I S I B I L I T Y")

	QuadMenu.addMenu("_SceneLayers-Visibility")	--title:""	flat:false --separators: #( 1 ) --index:--index:--index:
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(

)


/** DEFIEN QUAD
  */
QUAD_MENU_INSTALL = QuadMenu_v( "_" + getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QUAD_MENU_INSTALL.Quads[1] )
addQuad2( QUAD_MENU_INSTALL.Quads[2] )
addQuad3( QUAD_MENU_INSTALL.Quads[3] )
addQuad4( QUAD_MENU_INSTALL.Quads[4] )