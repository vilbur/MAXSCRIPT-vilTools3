

/** Viewport switcher
 */
struct ViewportSwitcher_v
(
	
	/* properties */
	switch,
	
	
	view_perpective = #( #view_persp_user, #view_iso_user ),
	view_left_right = #( #view_right,      #view_left ),
	view_top_bottom = #( #view_top,        #view_bottom ),
	view_front_back = #( #view_front,      #view_back ),
	
	
	all_view_types = #( view_perpective, view_left_right, view_top_bottom, view_front_back ),
	
	
	
	
	/** Switch
	 */
	function _switch =
	(
		--view_types = for i = 1 to viewport.numViews collect viewport.getType index:i
		format "switch = % \n" switch
		
		if not( this._activateViewport switch ) then
			this._findSimilarView()
		
		--actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	),
	
	/** _find similar view
	 */
	function _findSimilarView =
	(
		print "ViewportSwitcher_v._findSimilarView()"		
		similar_type = undefined
		
		for all_view_type in all_view_types where (found_index = findItem all_view_type switch) > 0 do
			similar_type = (deleteItem all_view_type found_index)[1]
		
		similar_index = for i = 1 to viewport.numViews where ( viewport.getType index:i ) == similar_type collect i
	
		if( similar_index.count > 0 ) then
			this._activateSimilarViewportAndChangeView similar_index[1]		
		
		
	),
	
	/** _activate viewport by type
	 */
	function _activateViewport type =
	(
		print ("ViewportSwitcher_v._activateViewport "+ type as string )

		for i = 1 to viewport.numViews do
			if( viewport.getType index:i == type ) then
				viewport_switched = viewport.activeViewportEx i
		
		viewport_switched != undefined --return		
	),	
	
	/** Activate similar viewport and change view
	 */
	function _activateSimilarViewportAndChangeView index =
	(
		--print "_activateSimilarViewportAndChangeView()"
		viewport.activeViewportEx index
		
		viewport.setType switch
	),
	
	/** _show all views
	 */
	function _showAllViews =
	(
		if( this._isViewportMaximized() ) then 
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	),
	
	/** _is maximized
	 */
	function _isViewportMaximized =
	(
		viewport.numViews  == 1 --return
	),
	
	
	/**  
	 */
	on create do
	(
		this._showAllViews()
		
		
		this._switch()
	)
	
)

