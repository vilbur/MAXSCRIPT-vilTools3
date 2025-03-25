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
	ini_file,

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
		--format "\n"; print "ViewData_v.restoreLayout()"
		
		viewport.setLayout(layout_name)

		ini_file = this._getIniFile( layout_name )
		--format "doesFileExist ini_file: %\n" (doesFileExist ini_file)
		
		if not doesFileExist ini_file then
			return false

		for index = 1 to viewport.numViews do
			this._configureViewport(index)
			
		--ViewPanelManager.SetSplitterBarPos
	),

	/** Restore split bars
	 */
	function restoreSplitBars =
	(
		format "\n"; print "ViewportLayoutManager_v.restoreSplitBars()"

		/** Get view size
		 */
		function getViewportSize ViewportData x_y = ( getProperty ViewportData.view_size x_y ) --as integer

		
		local main_view
		local splitter_position
		

		layout_name = viewport.getLayout()

		ini_file = this._getIniFile( layout_name )
		
		views_num = viewport.numViews 

		if not doesFileExist ini_file then
			return false
			
		ViewportsData = for i = 1 to views_num collect this._loadIni(i)

		split_dir  = (layout_name as string)[9] as name -- #V|#H
		split_side = (layout_name as string)[10] as name -- #L|#R|#B|#T
	
		main_view = case of
		(
			(views_num == 2   ): 1
			(split_side == #R ): 1
			(split_side == #B ): 1
			(split_side == #L ): views_num
			(split_side == #T ): views_num
		)
		
		other_views = for i = 1 to ViewportsData.count where i != main_view collect i

		
		splitter_index = if ( views_num == 2 or views_num == 3 ) and split_dir == #V then 1 else 0
		
			
		x_y = if split_dir == #H then #Y else #X
		

		/* SET MAIN SPLITTER */
		if viewport.numViews == 2 then
		(
			viewport_1 = getViewportSize ViewportsData[1] x_y 
			viewport_2 = getViewportSize ViewportsData[2] x_y 
			
			splitter_position =  (viewport_1 / (viewport_2 + viewport_1))

		)
		else
		(
			main_view_size  = getViewportSize ViewportsData[main_view] x_y 
			
			other_view_size = getViewportSize ViewportsData[other_views[1]] x_y
			format "main_view_size: %\n" main_view_size
			
			splitter_position =  (other_view_size / (main_view_size + other_view_size))
		)
		
		

		if split_side == #R then
			splitter_position -= 1
			
		format "\n"
		format "splitter_index: %\n" splitter_index
		format "splitter_position: %\n" splitter_position

		
		
		format "SPLITTER_POSITION: %\n" splitter_position
		ViewPanelManager.SetSplitterBarPos splitter_index (abs(splitter_position))
	
	),

	private
	
	/** Configure viewport
	 */
	function _configureViewport index =
	(
		--format "\n"; print "ViewportLayoutManager_v._configureViewport()"
		ViewportData = this._loadIni(index)

		viewport.activeViewportEx index

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
	),
	
	
	

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
	function _loadIni index =
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
		ini_file = getDir(#temp) + "/ViewportLayouts" + (this._getSceneName()) + "/" + (layout_name as string ) +".ini" --return
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
