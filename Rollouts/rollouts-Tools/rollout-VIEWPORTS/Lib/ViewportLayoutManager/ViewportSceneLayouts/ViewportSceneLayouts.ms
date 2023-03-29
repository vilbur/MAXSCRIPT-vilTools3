filein( getFilenamePath(getSourceFileName()) + "/ViewportLayout/ViewportLayout.ms" ) -- "./ViewportLayout/ViewportLayout.ms"

/** Viewport layouts for each scene name
 */
struct ViewportSceneLayouts_v
(
	/* construct */


	/* properties */
	scene_name, --  scene name witout number suffix e.g.: "foo-scene-001.max" >>> "foo-scene"

	ViewportLayouts = #(),

	/* dependency */
	/* reference */
	/* inhered */

	/** Save current layout
	 */
	function saveCurrentLayout =
	(
		format "\n"; print "ViewportSceneLayouts_v.saveCurrentLayout()"

		ViewportLayout 	= this.getLayout( viewport.getLayout() )
		--format "ViewportLayout	= % \n" ViewportLayout
		ViewportLayout.saveCurrentLayout()
	),

	/** Get viewport layout
	 */
	function getLayout layout_name =
	(
		--format "\n"; print "ViewportSceneLayouts_v._getViewportLayout()"
		ViewportLayoutsByName = for ViewportLayout in ViewportLayouts where ViewportLayout.name == layout_name collect ViewportLayout

		if ViewportLayoutsByName.count == 0 then
			this._getNewViewportLayout (layout_name) --return

		else
			ViewportLayoutsByName[1] --return
	),

	private

	/** Set new scene layout
	 */
	function _getNewViewportLayout layout_name =
	(
		--format "\n"; print "ViewportLayoutManager_v._getNewSceneLayout()"
		ViewportLayout = ViewportLayout_v(layout_name)

		append ViewportLayouts ViewportLayout

		ViewportLayout
	),


	/**
	 */
	on create do
	(
	)

)