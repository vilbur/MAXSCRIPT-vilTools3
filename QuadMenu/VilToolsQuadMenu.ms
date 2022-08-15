
filein( getFilenamePath(getSourceFileName()) + "/../../Library/MAXSCRIPT-UI-framework/Lib/Menus/QuadMenu/QuadMenu.ms" )

quad_menu_name = "_VilToolsQuadMenu"


QuadMenu 	= QuadMenu_v(quad_menu_name)

QuadMenu.Quads[1].setTitle("Transform")
QuadMenu.Quads[2].setTitle("Edit")
QuadMenu.Quads[3].setTitle("Scene")
QuadMenu.Quads[4].setTitle("Selection")

TransformQuad	= QuadMenu.Quads[1]
SceneQuad	= QuadMenu.Quads[3]


TransformQuad.addMenu "_Tools"

SceneQuad.addSeparator()
SceneQuad.addMenu "_Scene"
SceneQuad.addSeparator()



SceneQuad.addItem "Tools" "Hide Unselected"	group:"Main UI" 
SceneQuad.addItem "Tools" "Hide Selection"	group:"Main UI" 
SceneQuad.addItem "Tools" "Unhide All"	group:"Main UI" 


QuadMenu.Quads[4].addMenu "_Group" flat:true
	
--QuadMenu.addItem "_Test Menu Submenu" ("context_menu_test") ("_Test") title:"Context Menu Test"


QuadMenu.setRightClick()
	
QuadMenu.showAllQuads()