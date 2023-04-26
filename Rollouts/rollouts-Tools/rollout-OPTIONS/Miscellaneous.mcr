
/**  LINK TO NODE
 */
macroscript	_options_quadmenu_reset
category:	"_Otions"
buttontext:	"Reset Quads"
tooltip:	"Load default quad menu and menus"
(

	menuMan.loadMenuFile "$userscripts/MAXSCRIPT-vilTools3/QuadMenu/QuadMenu-deafalt.mnux"

	menuMan.setViewportRightClickMenu #nonePressed (menuMan.findQuadMenu "Default Viewport Quad")
	menuMan.setViewportRightClickMenu #nonePressed (menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]")

)


/**
 */
macroscript	_options_free_memory
category:	"_Otions"
buttontext:	"Free Memory"
tooltip:	"Remove Undo\n\nClean Texture Memory"
(

	gc()	--Garbage Collection.
	freeSceneBitmaps()	--Cleans up in texture memory.
	clearUndoBuffer()	--Removes your Undo’s

	messageBox "Memory CLeaned" title:"Memory Clean"
)

