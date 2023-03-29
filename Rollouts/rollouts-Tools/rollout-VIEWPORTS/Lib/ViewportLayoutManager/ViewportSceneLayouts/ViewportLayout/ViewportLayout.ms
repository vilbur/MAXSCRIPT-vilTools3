filein( getFilenamePath(getSourceFileName()) + "/ViewportState/ViewportState.ms" ) -- "./ViewportState/ViewportState.ms"

/** Viewport layout
 */
struct ViewportLayout_v
(
	/* construct */


	/* properties */
	layout_name,
	ViewportStates = #(),

	/* dependency */
	/* reference */
	/* inhered */

	/** Save current layout
	 */
	function getCurrentLayout =
	(
		-- format "\n"; print "ViewportLayout_v.saveCurrentLayout()"
		-- format "layout_name	= % \n" layout_name

		for i = 1 to viewport.numViews do
		(
			ViewportState = ViewportState_v()

			ViewportState.type = viewport.getType index:i

			ViewportStates[i] = ViewportState
		)

	),

	/** Set viewport state
	 */
	function addViewportState type =
	(
		--format "\n"; print "ViewportLayout_v.setViewportState()"
		append ViewportStates (ViewportState_v( type as name ))
	),

	/** Reset layout
	 */
	function resetLayout =
	(
		-- format "\n"; print "ViewportLayout_v.resetLayout()"
		-- format "this.layout_name	= % \n" this.layout_name

		viewport.setLayout (this.layout_name)

		--format "ViewportStates	= % \n" ViewportStates

		for i = 1 to viewport.numViews where viewport.getType index:i != ViewportStates[i].type  do
			viewport.setType (ViewportStates[i].type)
	),

	/** Test if layout exists
	 */
	function exists =
	(
		--format "\n"; print "ViewportLayout_v.exist()"

		ViewportStates.count > 0 --return
	),

	private


	/**
	 */
	on create do
	(
	)

)
