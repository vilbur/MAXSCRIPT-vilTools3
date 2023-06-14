filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportLayoutManager/ViewportLayoutManager.ms" ) -- "./Lib/ViewportLayoutManager/ViewportLayoutManager.ms"

/**
*
*/
macroscript	viewport_layout_save
category:	"_Viewports"
buttontext:	"Save Layout"
tooltip:	"Save view types and positions of current layout.\n\nLayots are store for each scene name without number suffix separately"
--icon:	"width:56|height:48"
(
	clearListener()
	ViewportLayoutManager.saveCurrentLayout()
)