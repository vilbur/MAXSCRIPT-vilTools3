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
	function resetCurrent reset_splitters:false =
	(
		--format "\n"; print "ViewportLayoutManager_v.resetCurrent()"
		this.restoreLayout ( viewport.getLayout() ) reset_splitters:reset_splitters
	),

	/** Restore Layout
	 */
	function restoreLayout layout_name reset_splitters:false =
	(
		--format "\n"; print "ViewData_v.restoreLayout()"
		--format "layout_name: %\n" layout_name

		this._setIniFile( layout_name )

		/* TEMP LOAD LAYOUT TO FORCE RESET SPLITTERS */ 
		if reset_splitters then
			viewport.setLayout(#layout_1)
		
		/* LOAD SAVED LAYOUT */ 
		if doesFileExist ini_file then
			this.loadAndConfigureLayout (layout_name)
			
		/* SET DEFAULT LAYOUT */
		else
			viewport.setLayout(layout_name)

		/* RESTORE VIEWPORT SPLITTERS */ 
		if not reset_splitters then
			this.restoreSplitBars layout_name:layout_name
		
		if subObjectLevel == undefined or subObjectLevel == 0 then
			actionMan.executeAction 0 "311"  -- Tools: Zoom Extents All Selected

		CompleteRedraw()
	),

	/** Load and configure layout
	 */
	function loadAndConfigureLayout layout_name =
	(
		--format "\n"; print "ViewportLayoutManager_v._loadAndConfigureLayout()"
		if ini_file == undefined then this._setIniFile( layout_name )

		viewport.setLayout(layout_name)

		for index = 1 to viewport.numViews do
			this._configureViewport(index)
	),
	
	/** Restore split bars
	 */
	function restoreSplitBars layout_name: =
	(
		--format "\n"; print "ViewportLayoutManager_v.restoreSplitBars()"
		--format "layout_name A: %\n" layout_name
		--format "ini_file: %\n" ini_file

		/** Get view size
		 */
		function getViewportSize ViewportData x_y = ( getProperty ViewportData.view_size x_y ) --as integer

		
		local main_view
		local splitter_position
		

		views_num = viewport.numViews
		
		/* IN CASE THAT METHOD IS EXCECUTED ALONE */ 
		if layout_name == unsupplied then
		(
			layout_name = viewport.getLayout()
			--format "layout_name: %\n" layout_name
	
			if ini_file == undefined then this._setIniFile( layout_name )
			
			

		)
		
		if not doesFileExist ini_file then
			return false
			
			
		ViewportsData = for i = 1 to views_num collect this._loadIni(i)

		layout_name_str = layout_name as string
		
		if layout_name_str.count >= 9 then
			split_dir  = layout_name_str[9] as name -- #V|#H
			
		if layout_name_str.count >= 10 then
				split_side = layout_name_str[10] as name -- #L|#R|#B|#T

			main_view = case of
			(
				(views_num == 2   ): 1
				(layout_name == #layout_4 ): 1
				
				(split_side == #R ): 1
				(split_side == #B ): 1
				(split_side == #L ): views_num
				(split_side == #T ): views_num
			)
			--format "main_view: %\n" main_view
			other_views = for i = 1 to ViewportsData.count where i != main_view collect i
			--format "other_views: %\n" other_views
			--format "\n"
			
			main_splitter = if ( views_num == 2 or views_num == 3 ) and split_dir == #V then 1 else 0
			--format "main_splitter: %\n" main_splitter
			x_y = if split_dir == #H then #Y else #X
			--format "X_Y: %\n" x_y
			x_y_flip = if x_y == #X then #Y else #X

			/*------------------------------------------------------------------------------
			
				 SET MAIN SPLITTER
			
			--------------------------------------------------------------------------------*/
			--format "\nSET MAIN SPLITTER\n\n"
			/* LAYOUT 2,4 */
			if views_num == 2 or layout_name == #layout_4  then
			(
				other_view = if views_num == 2 then 2 else 3
				--format "other_view: %\n" other_view
				x_or_Y = if views_num == 2 then x_y else x_y_flip 
				
				
				viewport_1 = getViewportSize ViewportsData[1]          x_or_Y
				viewport_2 = getViewportSize ViewportsData[other_view] x_or_Y
				
				splitter_position =  (viewport_1 / (viewport_2 + viewport_1))

			)
			else
			(
				main_view_size  = getViewportSize ViewportsData[main_view] x_y 
				--format "main_view_size: %\n" main_view_size
				other_view_size = getViewportSize ViewportsData[other_views[1]] x_y
				--format "other_view_size: %\n" other_view_size
				splitter_position =  (other_view_size / (main_view_size + other_view_size))
				--format "splitter_position: %\n" splitter_position
			)
	
			if (views_num == 3 and split_side == #R) or ( views_num == 4 and split_side == #R ) then
			--if (views_num == 3 and split_side == #R) then
				splitter_position -= 1
				
			ViewPanelManager.SetSplitterBarPos main_splitter (abs(splitter_position))
			
	
			/*------------------------------------------------------------------------------
			
				 SET OTHER SPLITTERS
			
			--------------------------------------------------------------------------------*/
			
			--format "\n---------------------\nSET OTHER SPLITTERS\n\n"
	
		if views_num > 2 and layout_name != #layout_4 then
		(
			
			other_sizes    = for other_view in other_views collect getViewportSize ViewportsData[other_view] x_y_flip
			--format "other_sizes: %\n" other_sizes
			main_view_size = getViewportSize ViewportsData[main_view] x_y_flip 
			--format "main_view_size: %\n" main_view_size
		
			other_size_sum = 0
		
			splitter_positions = for other_size in other_sizes collect
			(
				other_size_sum += other_size
				--format "other_size: %\n" other_size
				other_size_sum / main_view_size
			)
			
			--format "\n"
			--format "splitter_positions: %\n" splitter_positions
			--format "SPLITTER_POSITIONS: %\n" splitter_positions
			splitters = for splitter = 0 to views_num - 2 where splitter != main_splitter collect splitter

			
			for i = 1 to splitters.count do
				ViewPanelManager.SetSplitterBarPos splitters[i] (abs(splitter_positions[i]))
		)
		else if layout_name == #layout_4 then
		(
			
			viewport_1 = getViewportSize ViewportsData[1] #X
			viewport_2 = getViewportSize ViewportsData[2] #X
			
			splitter_position =  (viewport_1 / (viewport_2 + viewport_1))

			ViewPanelManager.SetSplitterBarPos 1 splitter_position
		)
		
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

		--CompleteRedraw()
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
		this._setIniFile( viewport.getLayout() )

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
	function _setIniFile layout_name =
	(
		format "\n"; print "ViewportLayoutManager_v._setIniFile()"
		--format "layout_name: %\n" layout_name
		
		max_file_name = if maxFileName == "" then "undefined" else getFilenameFile( maxFileName ) 
		
		ini_file = getDir(#temp) + "/ViewportLayouts/" + max_file_name + "/" + (layout_name as string ) +".ini" --return
		
		format "ini_file:\n%\n" ini_file
		
		
		if not doesFileExist ini_file then
		(
			--format "\n"; format "ViewportLayoutManager_v._setIniFile()\n\nWARNING - INI FILE DOES NOT EXISTS\n\nINI FILE:%\n\n" ini_file
			
			return false
		)
	),

	--/** Get scene name
	-- */
	--function _getSceneName =
	--(
	--	 --format "\n"; print "ViewportLayoutManager_v.getSceneName()"
	--	 
	--	 getFilenameFile(maxFileName)
	--	--( dotNetObject "System.Text.RegularExpressions.Regex" @"[-_\s]*\d+.max" ).Replace maxFileName "" --return
	--),

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
