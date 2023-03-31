filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportLayoutManager/ViewportLayoutManager.ms" ) -- "./Lib/ViewportLayoutManager/ViewportLayoutManager.ms"

/**
*
*/
macroscript	viewport_layout_save
category:	"_Viewports"
buttontext:	"Save Layout"
--icon:	"width:56|height:48"
(
	clearListener()
	ViewportLayoutManager.saveCurrentLayout()
)