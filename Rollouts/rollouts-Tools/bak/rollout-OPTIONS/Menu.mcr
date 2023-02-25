
/**  LINK TO NODE
 */
macroscript	_options_quadmenu_reset
category:	"_Otions"
buttontext:	"Reset Menus"
tooltip:	"Load default quad menu and menus"
(

	menuMan.loadMenuFile "$userscripts/MAXSCRIPT-vilTools3/QuadMenu/QuadMenu-deafalt.mnux"

	menuMan.setViewportRightClickMenu #nonePressed (menuMan.findQuadMenu "Default Viewport Quad")
	menuMan.setViewportRightClickMenu #nonePressed (menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]")

)