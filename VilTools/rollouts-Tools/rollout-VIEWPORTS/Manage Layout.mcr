filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportLayoutManager/ViewportLayoutManager.ms" ) -- "./Lib/ViewportLayoutManager/ViewportLayoutManager.ms"

/*------------------------------------------------------------------------------
	FLOATING VIEWPORT
--------------------------------------------------------------------------------*/
/**
*/
macroscript	viewport_open_float_1
category:	"_Viewports-Manage"
buttontext:	"Float Viewport"
tooltip:	"Open Float Viewport 1"
icon:	"MENU:true"
(
	on execute do
		actionMan.executeAction -891545229 "0"  -- Floating Viewport: Floating Viewport - 1
)

/*------------------------------------------------------------------------------
	SAVE \ RESET LAYOUT
--------------------------------------------------------------------------------*/
/**
*/
macroscript	viewport_layout_reset
category:	"_Viewports-Manage"
buttontext:	"Reset Layout"
tooltip:	"Reset Current Layout"
icon:	"MENU:true"
(
	--clearListener()
	ViewportLayoutManager.resetCurrent()
)

/**
*/
macroscript	viewport_layout_save
category:	"_Viewports-Manage"
buttontext:	"Save Layout"
tooltip:	"Save view types and positions of current layout.\n\nLayots are store for each scene name without number suffix separately"
icon:	"MENU:true"
(
	--clearListener()
	ViewportLayoutManager.saveCurrentLayout()
)