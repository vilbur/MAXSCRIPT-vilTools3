/**
  * Keep your setup of viewports layout.
  * Switch viewports of current layout.
  * Default Max only change viewport type, and it breaks layout
  *
  * HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-8AA71F9E-F4F0-4437-A44E-9683619E89DE
  *
  * Sequence of switching view:
  *
  * 	1) MAXIMIZE\MINIMIZE	viewport if desired view is ACTIVE ALREADY
  * 	2) SWITCH VIEW	if view exist in layout
  * 	3) FIND SIMILAR	view and change it, if desired view does`t exists E.G.: If you want #left view and only #right exists in layout, then switch to right and change it to #left
  *	4) CHANGE CURRENT	view in default way if similar view does`t exist
  *
  *
  * @property	#name	switch #view_persp_user|#view_iso_user|#view_right|#view_left|#view_top|#view_bottom|#view_front|#view_back	
  *
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
	
	
	/** Switch or show all views
	 */
	function toggle switch =
	(
		this.switch = switch
		
		if( this._viewIsActiveAlready() ) then
		(
			if( this._isViewportMaximized()) then
				this._showAllViews()
			
			else
				this._maximizeViewport()
		)
		else
			this._switchViewport()
	),
	
	
	/** Switch
	 */
	function _switchViewport = 
	(
		--print "ViewportSwitcher_v._switchViewport()"		
		--view_types = for i = 1 to viewport.numViews collect viewport.getType index:i
		this._showAllViews()
		
		if not( this._activateViewport switch ) then
			if not( this._findSimilarView() ) then
				this._changeViewportTypeOfCurrentView()
		
		this._maximizeViewport()
	),
	
	/** _activate viewport by type
	 */
	function _activateViewport type =
	(
		--print ("ViewportSwitcher_v._activateViewport "+ type as string )
		local viewport_switched = undefined

		for i = 1 to viewport.numViews do
			if( viewport.getType index:i == type ) then
				viewport_switched = viewport.activeViewportEx i
				
		--format "viewport_switched = % \n" viewport_switched
		--format "return = % \n" (viewport_switched != undefined )
		viewport_switched != undefined --return		
	),	
	
	/** _find similar view
	 */
	function _findSimilarView =
	(
		--print "ViewportSwitcher_v._findSimilarView()"		
		local similar_type = undefined
		rotated_top_view = false
		
		for all_view_type in all_view_types where (found_index = findItem all_view_type switch) > 0 do
			similar_type = (deleteItem all_view_type found_index)[1]
		
		similar_index = for i = 1 to viewport.numViews where ( viewport.getType index:i ) == similar_type collect i
	
		if( switch == #view_top and similar_index.count == 0 ) then 
			rotated_top_view = this._searchRotatedTopView()
		
		if( rotated_top_view != false ) then
			similar_index = rotated_top_view
	
		if( similar_index.count > 0 ) then
			this._activateSimilarViewport similar_index[1]		
		
		if( rotated_top_view == false ) then
			this._setViewType()
		
		similar_index.count > 0 --return
	),

	/** _search rotated top view
	 */
	function _searchRotatedTopView =
	(
		--print "ViewportSwitcher_v._searchRotatedTopView()"
		active_view = viewport.activeViewport

		rotated_top_view_found = #()
				
		for i = 1 to viewport.numViews where ( viewport.getType index:i ) == #view_iso_user do
		(
			viewport.activeViewportEx i
			
			if( this._isThisRotatedTopView( viewport.getTM()) ) then
				append rotated_top_view_found i	
		)
		
		 viewport.activeViewportEx active_view
		
		--format "rotated_top_view_found = % \n" rotated_top_view_found
		rotated_top_view_found --return
	),
	
	/** _is this rotated top view
	 */
	function _isThisRotatedTopView view_tm =
	(
		--print "ViewportSwitcher_v._isThisRotatedTopView()"
		( view_tm as quat ) == ((eulerAngles 0 0 -90) as quat) --return
	),
	
	/** Activate similar viewport and change view
	 */
	function _activateSimilarViewport index =
	(
		--print ("ViewportSwitcher_v._activateSimilarViewport " + index as string )
		viewport.activeViewportEx index
	),
	
	/** Activate similar viewport and change view
	 */
	function _setViewType =
	(
		viewport.setType switch
	),
	
	/** _set viewport
	 */
	function _changeViewportTypeOfCurrentView =
	(
		--print "ViewportSwitcher_v._changeViewportTypeOfCurrentView()"		
		viewport.setType switch
		
		actionMan.executeAction 0 "310"  -- Tools: Zoom Extents Selected
	),
	
	/** _show all views
	 */
	function _showAllViews =
	(
		if( this._isViewportMaximized() ) then 
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	),
	
	/** Maximize viewport
	 */
	function _maximizeViewport =
	(
		actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	),
	
	/** _is maximized
	 */
	function _isViewportMaximized =
	(
		viewport.numViews  == 1 --return
	),
	
	/** _view is active already
	 */
	function _viewIsActiveAlready =
	(
		--print "ViewportSwitcher_v._viewIsActiveAlready()"		
		view_is_active = viewport.getType() == switch
		--format "view_is_active = % \n" view_is_active
		
		if( switch == #view_top and view_is_active == false and this._isThisRotatedTopView( viewport.getTM()) ) then 
			view_is_active = true
		--format "switch = % \n" switch
		--format "view_is_active = % \n" view_is_active
		--format "view_is_active = % \n" view_is_active
		view_is_active --return
	),
	
	/**  
	 */
	on create do
	(		
		
	)	
)