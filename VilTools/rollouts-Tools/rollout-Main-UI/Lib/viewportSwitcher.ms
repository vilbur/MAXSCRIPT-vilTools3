

/** Viewport switcher
 */
struct ViewportSwitcher_v
(
	
	/* properties */
	switch,
	
	/** Switch
	 */
	function _switch =
	(
		if( this._isMaximized() ) then 
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		
		--views = viewport.numViews 
		
		for i = 1 to viewport.numViews do
			if( (viewport.getType index:i) == switch ) then 
				viewport.activeViewportEx i
		
		actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	),
	
	/** _is maximized
	 */
	function _isMaximized =
	(
		viewport.numViews  == 1 --return
	),
	
	
	/**  
	 */
	on create do
	(
		this._switch()
	)
	
)

