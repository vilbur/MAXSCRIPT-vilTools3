filein( getFilenamePath(getSourceFileName()) + "/ViewportSceneLayouts/ViewportSceneLayouts.ms" ) -- "./ViewportSceneLayouts/ViewportSceneLayouts.ms"

/** Viewport layout manager
 */
struct ViewportLayoutManager_v
(
	/* construct */


	/* properties */
	SceneLayouts = #(),

	/* dependency */
	/* reference */
	/* inhered */

	/** Save current layout
	 */
	function saveCurrentLayout =
	(
		SceneLayout = this._getSceneLayout( this._getSceneName () )

		SceneLayout.saveCurrentLayout()
	),

	/** Reset layout
	  *
	  * @param name layout_name
	 */
	function resetLayout layout_name =
	(
		 format "\n"; print "ViewportLayout_v.resetLayout()"
		 format "layout_name	= % \n" layout_name
		SceneLayout = this._getSceneLayout( this._getSceneName () )
		-- format "SceneLayout	= % \n" SceneLayout
		ViewportLayout = SceneLayout.getLayout(layout_name)
		-- format "ViewportLayout	= % \n" ViewportLayout

		if ViewportLayout.exists() then
			ViewportLayout.resetLayout()

		else
			viewport.setLayout(layout_name)
			--messageBox "Setup for this layout not exists yet" title:"LAYOUT SETUP NOT EXISTS"
	),


	private

	/** Get scene layout
	 */
	function _getSceneLayout scene_layout_name =
	(
		-- format "\n"; print "ViewportLayoutManager_v.getSceneLayout()"
		SceneLayoutsByName = for SceneLayout in SceneLayouts where SceneLayout.scene_name == scene_layout_name collect SceneLayout
		--format "SceneLayoutsByName	= % \n" SceneLayoutsByName
		if SceneLayoutsByName.count == 0 then
			this._getNewSceneLayout (scene_layout_name) --return

		else
			SceneLayoutsByName[1] --return
	),

	/** Set new scene layout
	 */
	function _getNewSceneLayout scene_layout_name =
	(
		--format "\n"; print "ViewportLayoutManager_v._getNewSceneLayout()"
		SceneLayout = ViewportSceneLayouts_v(scene_layout_name)

		append SceneLayouts SceneLayout

		SceneLayout
	),



	/** Get scene name
	 */
	function _getSceneName =
	(
		-- format "\n"; print "ViewportLayoutManager_v.getSceneName()"
		( dotNetObject "System.Text.RegularExpressions.Regex" @"[-_\s]*\d+.max" ).Replace maxFileName "" --return
	),


	/**
	 */
	on create do
	(
	)

)