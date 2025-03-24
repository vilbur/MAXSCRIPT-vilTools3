/*

*/ 
macroscript	viewport_auto_set_layout_by_shape_of_viewport 
category:	"_3D-Print"
buttontext:	"QUICK"
tooltip:	"CHOOSE BEST LAYOUT for size and ratio of viewport"
icon:	"ACROSS:3|MENU:true|height:32|tooltip:ctrl OR shift:  Split 3 viewports\n\nctrl AND shift: Split 4 viewports"
(
	/* https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5A4580C6-B5CF-12104-898B-9313D1AAECD4 */

	/** Get size of maximized viewport
	 */
	function getSizeOfMaximizedViewport =
	(
		--format "\n"; print ".getSizeOfMaximizedViewport()"
		is_maximized	= viewport.numViews == 1
		
		if not( is_maximized ) then
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		
		viewport_size = getViewSize()
		
		if not( is_maximized ) then
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		
		viewport_size --return
	)
	
	
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		
		ctrl  = keyboard.controlPressed
		shift = keyboard.shiftPressed
		alt   = keyboard.altPressed
		format "ctrl: %\n" ctrl
		format "shift: %\n" shift
		/* GET SIZE OF VIEWPORT  */ 

		viewport_size = getSizeOfMaximizedViewport()
		
		difference_treshold = (viewport_size.x + viewport_size.y) / 2 / 3 -- get 1 third of average of viewport size
		
		differnece = abs ( viewport_size.x - viewport_size.y )
		
		/* GET NAME OF LAYOUT */ 
		
		shape_of_viewport = case of
		(
			(differnece < difference_treshold):  #SQUARE
			(viewport_size.x > viewport_size.y): #HORIZONTAL
			(viewport_size.x < viewport_size.y): #VERTICAL
		)
		format "SHAPE_OF_VIEWPORT: %\n" shape_of_viewport
		--ViewportLayoutManager = ViewportLayoutManager_v()
		format "\n"
		format "TEST AND: %\n" (ctrl and shift)
		format "TEST OR:  %\n" (ctrl or shift)
		num_of_splits = if shape_of_viewport != #SQUARE then
			case of
			(
				( ctrl and shift ): "4"
				( ctrl or  shift ): "3"
				default:"2" 
			)
		else /* IF SQUARE */ 
		(
			display_info = ( dotNetClass "System.Windows.Forms.Screen").PrimaryScreen.Bounds
			window_snapshot = windows.snapshot ( windows.getMAXHWND())
			snapshot_width = window_snapshot.width
			
			if snapshot_width < (display_info.width * 0.7 ) then "1" else "4"
		
		)
		format "NUM_OF_SPLITS: %\n" num_of_splits
		split_direction = case shape_of_viewport of
		(
			(#VERTICAL):	"h"
			(#HORIZONTAL):	"v"
			(#SQUARE):	""
		)
		
		
		side_suffix = if ctrl or shift then
			case shape_of_viewport of
			(
				(#VERTICAL):	"t"
				(#HORIZONTAL):	"l"
				(#SQUARE):	""
			)
			else ""
		
		
		
		layout_name = "layout_" + num_of_splits + split_direction + side_suffix
		format "LAYOUT_NAME: %\n" layout_name
		/* LOAD LAYOUT */
		try(
			
			(ViewportLayoutManager_v()).restoreLayout( layout_name as name )
			
			
			)catch()
		
		
	)
	
)


/*------------------------------------------------------------------------------
	SAVE \ RESET LAYOUT
--------------------------------------------------------------------------------*/

/**
*/
macroscript	viewport_layout_save
category:	"_Viewports-Manage"
buttontext:	"SAVE"
tooltip:	"Save view types and positions of current layout.\n\nLayots are store for each scene name without number suffix separately"
icon:	"MENU:true|id:BTN_save_layout"
(
	--clearListener()
	ViewportLayoutManager.saveCurrentLayout()
)

/**
*/
macroscript	viewport_layout_reset
category:	"_Viewports-Manage"
buttontext:	"RESET"
tooltip:	"Reset Current Layout"
icon:	"MENU:true|id:BTN_reset_layout"
(
	--clearListener()
	ViewportLayoutManager.resetCurrent()
)

/*------------------------------------------------------------------------------
	FLOATING VIEWPORT
--------------------------------------------------------------------------------*/
/**
*/
macroscript	viewport_open_float_1
category:	"_Viewports-Manage"
buttontext:	"FLOAT Viewport"
tooltip:	"Open Float Viewport 1"
icon:	"MENU:true|ACROSS:1"
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
