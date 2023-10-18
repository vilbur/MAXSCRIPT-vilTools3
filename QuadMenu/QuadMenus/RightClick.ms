/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("Edit 1")

	QuadMenu.addItem ("Modifier Stack") ("Convert To Editable Polygon") group:"Main UI" --index:1

	QuadMenu.addMenu("_Object-ConvertTo")

	QuadMenu.addMenu("_Epoly-Constraints")  separators: #( 1 )

	QuadMenu.addMenu("_Epoly-Tools-Options")

	SplineToolsMenu = QuadMenu.addMenu("Context Spline Tools 1") separators: #( 1 )	--flat:false --index:1

	/* EDIT SPLINE TOOLS MENU */
	SplineToolsMenu.addSeparator index:1
	SplineToolsMenu.removeItem("Bind")
	SplineToolsMenu.removeItem("Unbind")
	SplineToolsMenu.clearSeparators()
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("Edit 2")

	QuadMenu.addMenu("Context Spline Tools 2")

	QuadMenu.addMenu("_Epoly-Connect") separators: #( 2, 3 )

	QuadMenu.addMenu("_Epoly-Edit")	 separators: #( 1 ) --flat:false 	-- "./../../VilTools/rollouts-Tools/rollout-EDIT-POLY/EDIT.mcr"

	QuadMenu.addMenu("_Epoly-Edges")	title:"Edges" separators: #( 1 )	--flat:false

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("Edit 3")


	QuadMenu.addMenu("_Epoly-Object") separators: #( 1, 3 )	--flat:false

	--QuadMenu.addSeparators #( 1 )

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("EDIT 4")

	QuadMenu.addMenu("_Epoly-Tools-Main") separators: #( 2, 6 )

	QuadMenu.addMenu("_Epoly-PolyTools") separators: #( 1 )

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
