filein( getFilenamePath(getSourceFileName()) + "/ViewportState/ViewportState.ms" ) -- "./ViewportState/ViewportState.ms"

/** Viewport layout
 */
struct ViewportLayout_v
(
	/* construct */


	/* properties */
	name,
	ViewportStates = #(),

	/* dependency */
	/* reference */
	/* inhered */

	/** Save current layout
	 */
	function saveCurrentLayout =
	(
		format "\n"; print "ViewportLayout_v.saveCurrentLayout()"
		format "name	= % \n" name

		for i = 1 to viewport.numViews do
		(
			ViewportState = ViewportState_v()

			ViewportState.type = viewport.getType index:i

			append ViewportStates ViewportState
			format "ViewportState	= % \n" ViewportState
		)

	),

	/** Reset layout
	 */
	function resetLayout =
	(
		format "\n"; print "ViewportLayout_v.resetLayout()"
		viewport.setLayout (this.name)

		for i = 1 to viewport.numViews where viewport.getType index:i != ViewportStates[i].type  do
			viewport.setType (ViewportStates[i].type)
	),


	private


	/**
	 */
	on create do
	(
	)

)
