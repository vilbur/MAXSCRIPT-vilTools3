clearListener(); print("Cleared in:\n"+getSourceFileName())


	/* GET SIZE OF VIEWPORT  */ 
	is_maximized	= viewport.numViews == 1
	
	if not( is_maximized ) then
		actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	
	viewport_size = getViewSize()
	
	if not( is_maximized ) then
		actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		
	
	difference_treshold = (viewport_size.x + viewport_size.y) / 2 / 3 -- get 1 third of average of viewport size
	
	differnece = abs ( viewport_size.x - viewport_size.y )
	
	/* GET NAME OF LAYOUT */ 
	
	shape_of_viewport = case of
	(
		(differnece < difference_treshold):  #SQUARE
		(viewport_size.x > viewport_size.y): #HORIZONTAL
		(viewport_size.x < viewport_size.y): #VERTICAL
	)
	
	--ViewportLayoutManager = ViewportLayoutManager_v()
	
	num_of_splits = if shape_of_viewport != #SQUARE then
		case of
		(
			( keyboard.controlPressed and keyboard.shiftPressed ): "3"
			( keyboard.shiftPressed   or  keyboard.shiftPressed ): "4"
			default:"2" 
		)
	else /* IF SQUARE */ 
	(
		display_info = ( dotNetClass "System.Windows.Forms.Screen").PrimaryScreen.Bounds
		window_snapshot = windows.snapshot ( windows.getMAXHWND())
		snapshot_width = window_snapshot.width
		
		if snapshot_width < display_info.width then "1" else "4"
	
	)
	
	layout_name = case shape_of_viewport of
	(
		(#VERTICAL):	"h"
		(#HORIZONTAL):	"v"
		(#SQUARE):	""
	)
	
	
	/* LOAD LAYOUT */ 
	(ViewportLayoutManager_v()).restoreLayout( ("layout_" + num_of_splits + layout_name) as name )
	



