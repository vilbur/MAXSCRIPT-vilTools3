
filein( getFilenamePath(getSourceFileName()) + "/../../Library/MAXSCRIPT-UI-framework/Lib/Menus/QuadMenu/QuadMenu.ms" )

quad_menu_name = "_VilToolsQuadMenu"


QuadMenu 	= QuadMenu_v(quad_menu_name)

QuadMenu.Quads[1].setTitle("Transform")
QuadMenu.Quads[2].setTitle("Edit")
QuadMenu.Quads[4].setTitle("Selection")


QuadMenu.Quads[1].addMenu "_Tools" flat:true
QuadMenu.Quads[4].addMenu "_Group" flat:true
	
--QuadMenu.addItem "_Test Menu Submenu" ("context_menu_test") ("_Test") title:"Context Menu Test"
--
QuadMenu.setRightClick()
	
QuadMenu.showAllQuads()