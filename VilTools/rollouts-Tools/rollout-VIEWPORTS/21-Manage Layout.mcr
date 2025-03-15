
/*------------------------------------------------------------------------------
	FLOATING VIEWPORT
--------------------------------------------------------------------------------*/
/**
*/
macroscript	viewport_open_float_1
category:	"_Viewports-Manage"
buttontext:	"FLOAT Viewport"
tooltip:	"Open Float Viewport 1"
icon:	"MENU:true|across:3"
(
	on execute do
	(

		type	= viewport.getType()
		
		actionMan.executeAction -891545229 "0"
		--
		--sleep 1
		--
		--if viewport.numViews > 1 then
		--	actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		--
		--
		--viewport.SetType (type)
		--viewport.numViews 
		
				
	)
)

/*------------------------------------------------------------------------------
	SAVE \ RESET LAYOUT
--------------------------------------------------------------------------------*/


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

