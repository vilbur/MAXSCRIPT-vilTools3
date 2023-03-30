filein( getFilenamePath(getSourceFileName()) + "/ViewportData/ViewportData.ms" ) -- "./ViewportSceneLayouts/ViewportSceneLayouts.ms"

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
		for i = 1 to viewport.numViews do
			this._saveIni ( this._collectViewportData(i) )(i)
	),

	/** Restore Layout
	 */
	function restoreLayout layout_name =
	(
		format "\n"; print "ViewData_v.restoreLayout()"
		format "layout_name	= % \n" layout_name

		viewport.setLayout(layout_name)

		ini_file = this._getIniFile( layout_name )

		format "doesFileExist ini_file	= % \n" (doesFileExist ini_file)
		if not doesFileExist ini_file then
			return false

		for i = 1 to viewport.numViews do
		(

			ViewportData = this._loadIni (ini_file) (i)

			viewport.activeViewportEx i

			viewport.SetType (ViewportData.type)

			view_type_split	= filterString ( ViewportData.type as string ) "_"
			format "view_type_split	= % \n" view_type_split

			case view_type_split[view_type_split.count] of
			(
				#user:
				(
					viewport.setTM ViewportData.transform

					if ViewportData.type == #view_persp_user then
					(
						viewport.SetFOV ViewportData.field_of_view

						viewport.SetFocalDistance ViewportData.focal_distance
					)
					else
					(
						viewport.ZoomToBounds off ViewportData.start_pos ViewportData.end_pos

						viewport.zoom (ViewportData.field_of_view / (viewport.getFOV()))
					)
				)

				--#camera: (if isValidNode ViewportData.vpNode and viewport.canSetToViewport ViewportData.vpNode then viewport.setCamera ViewportData.vpNode else deadData = on)

				default: -- ORTHO
				(
					viewport.ZoomToBounds off ( ViewportData.start_pos) ( ViewportData.end_pos )

					viewport.zoom ((ViewportData.field_of_view) / ( viewport.getFOV()))
				)
			)

			CompleteRedraw()
		)

	),


	private

	/** Collect viewport data
	 */
	function _collectViewportData index =
	(
		format "\n"; print "ViewData_v.collectData()"

		ViewportData = ViewportData_v()

		viewport.activeViewportEx index

		view_bounds = this._minMaxSwap (( mapScreenToView [0,0] 0) * Inverse(getViewTM())) ((mapScreenToView (getViewSize ()) 0) * Inverse(getViewTM()))

		ViewportData.type	= viewport.getType()
		ViewportData.start_pos	= view_bounds[1]
		ViewportData.end_pos	= view_bounds[2]
		ViewportData.view_size	= getViewSize ()
		ViewportData.field_of_view	= getViewFOV()
		ViewportData.focal_distance	= viewport.getFocalDistance()
		--ViewportData.transform	= viewport.getTM()
		format "ViewportData	= % \n" ViewportData
		ViewportData --return
	),


	/** Save ini
	 */
	function _saveIni ViewportData index =
	(
		--format "\n"; print "ViewportLayoutManager_v._saveIni()"
		ini_file = this._getIniFile( viewport.getLayout() )

		for prop in (getPropNames (ViewportData)) do
			setINISetting ini_file ( index as string ) ( prop as string ) ((getProperty ViewportData prop) as string)
	),

	/** Load viewport data from ini
	 */
	function _loadIni ini_file index =
	(
		format "\n"; print "ViewportLayoutManager_v._loadIni()"

		ViewportData = ViewportData_v()

		for prop in (getPropNames (ViewportData)) do
		(
			val = getINISetting ini_file (index as string ) (prop as string )

			classOf_value = classOf (getProperty ViewportData prop)
			--format "\n"
			--format "val	= % \n" val
			--format "classOf_value	= % \n" classOf_value
			setProperty ViewportData prop (val as classOf_value )
		)
		format "ViewportData	= % \n" ViewportData
		ViewportData --return
	),

	/** Get ini file "MaxTemp/VipeportLayouts/{Scene_name}/layout_name.ini"
	 */
	function _getIniFile layout_name =
	(
		--format "\n"; print "ViewportSceneLayouts_v._getIniFile()"
		getDir(#temp) + "/ViewportLayouts" + (this._getSceneName()) + "/" + (layout_name as string ) +".ini" --return
	),

	/** Get scene name
	 */
	function _getSceneName =
	(
		 --format "\n"; print "ViewportLayoutManager_v.getSceneName()"
		( dotNetObject "System.Text.RegularExpressions.Regex" @"[-_\s]*\d+.max" ).Replace maxFileName "" --return
	),

	function _minMaxSwap p3min p3max =
	(
		if p3min.x > p3max.x then swap p3min.x p3max.x

		if p3min.y > p3max.y then swap p3min.y p3max.y

		if p3min.z > p3max.z then swap p3min.z p3max.z

		#(p3min, p3max) -- return
	),

	/**
	 */
	on create do
	(
	)

)

/*------------------------------------------------------------------------------
	GLOBAL
--------------------------------------------------------------------------------*/

--if ViewportLayoutManager == undefined then
	ViewportLayoutManager = ViewportLayoutManager_v()
