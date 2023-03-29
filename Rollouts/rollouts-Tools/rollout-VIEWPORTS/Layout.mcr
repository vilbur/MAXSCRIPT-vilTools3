filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportLayoutManager/ViewportLayoutManager.ms" ) -- "./Lib/ViewportLayoutManager/ViewportLayoutManager.ms"

/*------------------------------------------------------------------------------
	GLOBAL
--------------------------------------------------------------------------------*/

--if ViewportLayoutManager == undefined then
	ViewportLayoutManager = ViewportLayoutManager_v()

/**
*
*/
macroscript	viewport_layout_save
category:	"_Viewports"
buttontext:	"Save Layout"
(
	clearListener()
	--viewport.getLayout()
	ViewportLayoutManager.saveCurrentLayout()

)

 /**
 *
 */
macroscript	viewport_load_layout_4
category:	"_Viewports"
buttontext:	"Layout 4"
--toolTip:	"Perspective view"
icon:	"images:#('/Icons/Layouts.bmp',undefined,14,14,14,14,14)"
(
	clearListener()
	--viewport.getLayout()
	ViewportLayoutManager.resetLayout(#layout_4)

)
