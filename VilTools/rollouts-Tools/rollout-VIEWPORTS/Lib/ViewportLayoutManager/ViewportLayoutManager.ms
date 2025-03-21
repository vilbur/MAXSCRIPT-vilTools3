filein( getFilenamePath(getSourceFileName()) + "/ViewportData/ViewportData.ms" ) --"./ViewportData/ViewportData.ms"
/** Viewport layout manager
  *
  *
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

	/** Reset current
	  *
	  */
	function resetCurrent =
	(
		--format "\n"; print "ViewportLayoutManager_v.resetCurrent()"
		this.restoreLayout ( viewport.getLayout() )
	),

	/** Restore Layout
	 */
	function restoreLayout layout_name =
	(
		format "\n"; print "ViewData_v.restoreLayout()"

		viewport.setLayout(layout_name)

		ini_file = this._getIniFile( layout_name )

		if not doesFileExist ini_file then
			return false

		for i = 1 to viewport.numViews do
		(
			ViewportData = this._loadIni (ini_file) (i)

			viewport.activeViewportEx i

			viewport.SetType (ViewportData.type)

			viewport.SetRenderLevel(ViewportData.render_mode)

			view_type_split	= filterString ( ViewportData.type as string ) "_"

			case view_type_split[view_type_split.count] as name of
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

				#camera:
				(
					cams = for cam in cameras where cam.name == ViewportData.camera collect cam

					if cams.count > 0 and isValidNode cams[1] and viewport.canSetToViewport cams[1] then
						 viewport.setCamera cams[1]
				)

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
		--format "\n"; print "ViewData_v.collectData()"
		ViewportData = ViewportData_v()

		viewport.activeViewportEx index

		view_bounds = this._minMaxSwap (( mapScreenToView [0,0] 0) * Inverse(getViewTM())) ((mapScreenToView (getViewSize ()) 0) * Inverse(getViewTM()))

		ViewportData.type	= viewport.getType()
		ViewportData.start_pos	= view_bounds[1]
		ViewportData.end_pos	= view_bounds[2]
		ViewportData.view_size	= getViewSize ()
		ViewportData.field_of_view	= getViewFOV()
		ViewportData.focal_distance	= viewport.getFocalDistance()
		ViewportData.transform	= viewport.getTM()
		ViewportData.render_mode	= viewport.GetRenderLevel()
		ViewportData.camera	= if ( _camera = viewport.getCamera()) != undefined then ( _camera.name )

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
		--format "\n"; print "ViewportLayoutManager_v._loadIni()"
		/** Convert ini value to valid data type
		 */
		function convertDataType val data_type =
		(
			--format "DATA_TYPE	= % \n" data_type
			case data_type of
			(
				UndefinedClass:	undefined
				matrix3:	execute val
				default:	val as data_type
			)
		)

		ViewportData = ViewportData_v()

		for prop in (getPropNames (ViewportData)) do
			setProperty ViewportData prop ( convertDataType(getINISetting ini_file (index as string ) (prop as string ))(classOf (getProperty ViewportData prop)) )

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

ViewportLayoutManager = ViewportLayoutManager_v()
