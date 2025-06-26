/*
	https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-3E389A4A-740A-4D64-888D-04A51EBA061A
*/ 
macroscript	viewport_auto_quick_layout
category:   "_Viewports-Layout"
buttontext:	"QUICK"
tooltip:	"ctrl OR shift:  Split 3 viewports\n\nctrl AND shift: Split 4 viewports"
icon:	"ACROSS:3|MENU:QUICK Layout|height:32|tooltip:CHOOSE BEST LAYOUT for size and ratio of viewport\n\nTOGGLE BETWEEN 2 and 4 views split"
(

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
	
	/** Get layout name
	 */
	--function getLayoutName num_of_splits split_direction side_suffix = ("layout_" + num_of_splits as string + split_direction + side_suffix) as name
	function getLayoutName num_of_splits split_direction _side_suffix = ("layout_" + num_of_splits as string + split_direction + _side_suffix) as name		

	
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		
		ctrl  = keyboard.controlPressed
		shift = keyboard.shiftPressed
		alt   = keyboard.altPressed
		
		layout_current = viewport.getLayout()
		

		if layout_current == #layout_1 then
		(
			(ViewportLayoutManager_v()).restoreLayout( #layout_4 )
			
			return true
		)

		--format "ctrl: %\n" ctrl
		--format "shift: %\n" shift
		/* GET SIZE OF VIEWPORT  */ 

		viewport_size = getSizeOfMaximizedViewport()
		
		--difference_treshold = (viewport_size.x + viewport_size.y) / 2 / 4 -- get 1 third of average of viewport size
		--difference_treshold = (viewport_size.x + viewport_size.y) / 2 / 4 -- get 1 third of average of viewport size
		difference_treshold = 0.2
		
		--differnece = abs ( viewport_size.x - viewport_size.y )
		format "differnece: %\n" ( viewport_size.x / viewport_size.y )
		differnece =  viewport_size.x / viewport_size.y 
		format "HORIZONTAL: %\n" ( differnece > 1.2 )
		format "VERTICAL:   %\n" ( differnece < 0.8 )
		
		/* GET NAME OF LAYOUT */ 
		shape_of_viewport = case of
		(
			(differnece > 1.2): #HORIZONTAL
			(differnece < 0.8): #VERTICAL
			
			default:  #SQUARE
			
			--(differnece < difference_treshold):  #SQUARE
			--(viewport_size.x > viewport_size.y): #HORIZONTAL
			--(viewport_size.x < viewport_size.y): #VERTICAL
			
			
		)
		format "SHAPE_OF_VIEWPORT: %\n" shape_of_viewport
		--ViewportLayoutManager = ViewportLayoutManager_v()
		--format "\n"
		--format "TEST AND: %\n" (ctrl and shift)
		--format "TEST OR:  %\n" (ctrl or shift)
		num_of_splits = case of
			(
				( ctrl and shift ): 4
				( ctrl or  shift ): 3
				          default: 2 
			)
		

		--split_direction = case shape_of_viewport of
		--(
		--	(#VERTICAL):	"h"
		--	(#HORIZONTAL):	"v"
		--	(#SQUARE):	""
		--)
		--format "split_direction: %\n" split_direction
		
		side_suffix = if ctrl or shift then
			case shape_of_viewport of
			(
				(#VERTICAL):	"t"
				(#HORIZONTAL):	"l"
				(#SQUARE):	""
			)
			else ""
	
		--layout_name = getLayoutName num_of_splits split_direction side_suffix
		
		
		--if layout_name == layout_current and split_direction == "v" and (num_of_splits == 2 or num_of_splits == 4) then
		

			split_direction = if num_of_splits == 2 then
				case shape_of_viewport of
					(
						(#VERTICAL):	"h"
						(#HORIZONTAL):	"v"
						(#SQUARE):	""
					)
			else
				"" -- no split if 2 viewports
		--
			layout_name = getLayoutName num_of_splits split_direction side_suffix
		--)

		/* TOGGLE 2 AND 4 SPLIT */ 		
		if layout_name == layout_current and (num_of_splits == 2 or num_of_splits == 4) then
		(
			num_of_splits = if num_of_splits == 2 then 4 else 2
			
			split_direction = if num_of_splits == 2 then
				case shape_of_viewport of
					(
						(#VERTICAL):	"h"
						(#HORIZONTAL):	"v"
						(#SQUARE):	""
					)
			else
				"" -- no split if 2 viewports
			
			
			layout_name = getLayoutName num_of_splits split_direction side_suffix
		)
		
	

		
		format "layout_current: %\n" layout_current
		format "layout_name:    %\n" layout_name

		/*------------------------------------------------------------------------------
			LOAD LAYOUT
		--------------------------------------------------------------------------------*/
		try(
			(ViewportLayoutManager_v()).restoreLayout( layout_name )
			
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
tooltip:	"SAVE CURRENT LAYOUT"
icon:	"MENU:SAVE Layout|id:BTN_save_layout"
(
	--clearListener()
	ViewportLayoutManager.saveCurrentLayout()
)

/**
*/
macroscript	viewport_layout_reset
category:	"_Viewports-Manage"
buttontext:	"RESET"
tooltip:	"Reset Current Layout\n\nCTRL: Reset splitters"
icon:	"MENU:RESET Layout CTRL:Splitters|id:BTN_reset_layout"
(
	--clearListener()
	on execute do
	(
		ViewportLayoutManager.resetCurrent reset_splitters:keyboard.controlPressed
	
		print " *** RESET Layout: PRESS CTRL TO RESET SPLITTERS"	
	)
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
