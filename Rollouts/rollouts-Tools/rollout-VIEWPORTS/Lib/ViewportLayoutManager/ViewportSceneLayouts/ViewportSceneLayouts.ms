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
		-- format "\n"; print "ViewportSceneLayouts_v.saveCurrentLayout()"

		ViewportLayout 	= this.getLayout( viewport.getLayout() )
		--format "ViewportLayout	= % \n" ViewportLayout

		ViewportLayout.getCurrentLayout()

		this.saveIni(ViewportLayout)
	),

	/** Get viewport layout
	 */
	function getLayout layout_name =
	(
		--format "\n"; print "ViewportSceneLayouts_v._getViewportLayout()"
		ViewportLayoutsByName = for ViewportLayout in ViewportLayouts where ViewportLayout.layout_name == layout_name collect ViewportLayout

		if ViewportLayoutsByName.count == 0 then
			this._getViewportLayout(layout_name) --return

		else
			ViewportLayoutsByName[1] --return
	),


	private


	/** Set new scene layout
	 */
	function _getViewportLayout layout_name =
	(
		--format "\n"; print "ViewportLayoutManager_v._getNewSceneLayout()"
		if ( ViewportLayout = this._getNewViewportFromIni(layout_name) ) == undefined then
			ViewportLayout = this._getNewViewportLayout(layout_name)

		ViewportLayout --return
	),

	/** Set new scene layout
	 */
	function _getNewViewportLayout layout_name =
	(
		--format "\n"; print "ViewportLayoutManager_v._getNewSceneLayout()"
		ViewportLayout = ViewportLayout_v(layout_name)

		append ViewportLayouts ViewportLayout

		ViewportLayout
	),

	/** Save ini
	 */
	function saveIni ViewportLayout =
	(
		-- format "\n"; print "ViewportSceneLayouts_v.saveIni()"

		ini_file = this._getIniFile()

		for i = 1 to ViewportLayout.ViewportStates.count do
		(
			ViewportState = ViewportLayout.ViewportStates[i]

			setINISetting ini_file ViewportLayout.layout_name (i as string +"_type") ViewportState.type
		)
	),

	/** Get viewport ini
	 */
	function _getNewViewportFromIni layout_name =
	(
		-- format "\n"; print "ViewportSceneLayouts_v._getNewViewportFromIni()"

		ini_file = this._getIniFile()

		if doesFileExist ini_file then
			if (keys = getINISetting ini_file layout_name).count > 0 then
			(
				ViewportLayout = ViewportLayout_v(layout_name)

				for key in keys do
					ViewportLayout.addViewportState ( getINISetting ini_file layout_name key)
			)

		ViewportLayout --return
	),

	/** Get ini file
	 */
	function _getIniFile =
	(
		--format "\n"; print "ViewportSceneLayouts_v._getIniFile()"
		getDir(#temp) + "/VipeportLayouts/" + this.scene_name + ".ini" --return
	),

	/**
	 */
	on create do
	(
	)

)