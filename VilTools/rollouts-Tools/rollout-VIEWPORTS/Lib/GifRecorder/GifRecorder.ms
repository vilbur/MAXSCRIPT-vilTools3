
filein( getFilenamePath(getSourceFileName()) + "/../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	--"./../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

global DIALOG_GifRecorder

--if GIF_RECORDER == undefined then 
	global GIF_RECORDER



/** Screen shooter
 */
struct GifRecorder_v
(
	/* construct */
	

	/* required */
	

	/* properties */
	frames = #(),
	
	recording = false, -- start\stop callback

	preview_size = [128,128],
	
	DotNetTimer,
	
	private
	
	/* private */
	temp_dir = getDir #TEMP + "/GifRecorder/gif-frames",
	
	maxfile_subdir = substituteString maxFilePath "\\" "/" + "_Screenshots",
		
	gif_filename,
	gif_temp_path,
	gif_final_path,
	
	user_save_path,

	_slider,

	--safe_frame = this.getViewportSafeFrameSize [gw.getWinSizeX(), gw.getWinSizeY()] [renderWidth, renderHeight],
		
	view_tm,
	camera_tm,
	view_type,
	--record_camera,
	view_cube_state,
	
	record_viewport,
	active_viewport,
	
	safe_frame_enabled,
	
	border_width = 1,
	lmb_last_state = false,
	
	public
	
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Get screenshot of current viewport
	 */
	function getScreenshotOfCurrentViewport =
	(
		--format "\n"; print "GifRecorder_v.getScreenshotOfCurrentViewport()"
		screenshot = gw.getViewportDib() --this grabs the viewport

			
		append frames screenshot
		
		
		this.showFrame(frames.count)
	),
	
	/** Grab gif frame
	 */
	function grabGifFrame =
	(
		--format "\n"; print "GifRecorder_v.grabGifFrame()"
		--format "frames.count: %\n" frames.count
		/* IF VIEW CHANGED */ 
		if view_tm != viewport.getTM() then
			this._setRecordCameraView()

		frame = if frames.count == 0 then 1 else this._getCurrentFrame() +1
			
		this._toggleViewCube(false)

		screenshot = gw.getViewportDib index:record_viewport --this grabs the viewport
					
		this._toggleViewCube(true)
	
		screenshot = this._cropSafeFrame(screenshot)

		
		--append frames screenshot
		insertItem screenshot frames frame
		
		this._setSliderRange(frames.count)
		
		this.setSlider(frame)
		
		this.showFrame(frame)
		
		this._restoreViewport()


		--format "FRAME: % \n" frame
	),
	
	/** Start recording
	 */
	function startRecording =
	(
		--format "\n"; print "GifRecorder_v.startRecording()"
		if gif_temp_path != undefined then 
			deleteFile gif_temp_path

		this.recording = true
		
		if frames.count == 0 then
			this.grabGifFrame()
			
		else
		--format "FRAME: %\n" (this._getCurrentFrame())
			this.showFrame(this._getCurrentFrame()) -- ADD red frame
		
		/*------ START TIMER  ------*/
		DotNetTimer	= dotNetObject "System.Windows.Forms.Timer"
		
		dotNet.addEventHandler DotNetTimer "tick" GIF_RECORDER.grabFrameOnLmbRelease
		
		DotNetTimer.interval = 10
		
		DotNetTimer.start()
		
		--grabFrameTimerStart( true )
	),
	
	/** Generate gif
	 */
	function generateGif open_in_viewer:false =
	(
		--format "\n"; print "GifRecorder_v.generateGif()"
		/** Combine frames to gif
		 */
		function combineFramesToGif =
		(
			--format "\n"; print "GifRecorder_v.combineFramesToGif()"
			delay = (DIALOG_GifRecorder.DDL_delay.items[ DIALOG_GifRecorder.DDL_delay.selection as integer ] as float * 100) 
			
			--format "DELAY OF FRAMES: %s\n" delay
			
			cmd = "cd \""+temp_dir+"\" & magick -delay "+ (delay as integer ) as string +" -loop 0 *.jpg \""+gif_filename+"\""
			
			--print ("GifRecorder.combineFramesToGif: "+cmd)
			
			DOSCommand cmd
		)
		
		this.saveFrames()

		combineFramesToGif()
		
		if open_in_viewer then
			DOSCommand ("start \"\" \""+gif_temp_path+"\"")
	),

	/** Grab frame on lmb release
	 */
	function grabFrameOnLmbRelease =
	(
		--format "\n"; print "GifRecorder_v.grabFrameOnLmbRelease()"
		lmb_state_current = mouse.buttonStates[1]
		
		/* GRAB FRAME ON LMB RELEASE */ 
		if lmb_last_state and not lmb_state_current then
			this.grabGifFrame()
		
		lmb_last_state = lmb_state_current
		
		
		/* STOP TIMER if not recording or dialog not exists */ 
		if not this.recording or GetDialogPos DIALOG_GifRecorder == [0,0] then
		(
			--format "STOP TIMER\n"
			
			DotNetTimer.stop()
			
			this.stopRecording()
			
			lmb_last_state = false
		)
		
		
	),
	
	/** STOP RECORDING
	 */
	function stopRecording =
	(
		--format "\n"; print "GifRecorder_v.stopRecording()"
		--delete $GifRecorderCamera*
		this.recording = false

		--this._setSliderRange (frames.count)
		DotNetTimer.stop()

		this.showFrame(this._getCurrentFrame()) -- REMOVE red frame

		--this.setPreviewWindowSize()
	),
	
	/** On close dialog
	 */
	function onCloseDialog =
	(
		format "\n"; print "GifRecorder_v.onCloseDialog()"
		format "DotNetTimer: %\n" DotNetTimer
		if DotNetTimer != undefined then 
			DotNetTimer.stop()
	),
	
	/** Save giff file
	 */
	function saveGifFile browse:false =
	(
		--format "\n"; print "GifRecorder_v.saveGifFile()"
		makeDir (getFilenamePath(gif_final_path)) all:true
		
		if browse and this._browseGifSavePath() == undefined then
			this._cancelBrowse() -- cancel save if getSaveFileName was canceled
		
		if not doesFileExist gif_temp_path then
			this.generateGif()
		--format "gif_temp_path: %\n" gif_temp_path

		/* DELETE OLD FINAL FILE */ 
		deleteFile gif_final_path
		
		/* COPY TEMP FILE TO FINAL */ 
		copyFile gif_temp_path gif_final_path
		
		/* DELETE TEMP FILE */ 
		deleteFile gif_temp_path

		--format "GIF SAVED\nFROM: %\nTO:   %\n" gif_temp_path gif_final_path
		format "GifRecorder.saveGifFile: %\n" gif_final_path
	),
	
	/** Browse gif save path
	 */
	function _browseGifSavePath =
	(
		--format "\n"; print "GifRecorder_v._browseGifSavePath()"
		user_save_path_browsed = getSaveFileName caption:"Browse" filename:gif_final_path  types:"GIF(*.gif)|*.*"  historyCategory:"GifRecorder"
		
		if user_save_path_browsed != undefined then -- use previous path if browsing is CANCELED
		(
			user_save_path_browsed = substituteString user_save_path_browsed "*.gif" "" --return filename of gif without ".gif" extension
			
			user_save_path_browsed += ".gif"
			
			/* UPDATE UI EDIT TEXT */ 
			DIALOG_GifRecorder.ET_filename.text = getFilenameFile( user_save_path_browsed )
			
			/* UPDATE PATHS */ 
			this.gif_filename = filenameFromPath( user_save_path_browsed )
			
			this.user_save_path = getFilenamePath(user_save_path_browsed) -- return
			
			this.setGifPaths()
		)
		--format "user_save_path: %\n" user_save_path
			
	),
	
	/** Remove empty dir
	 */
	function _cancelBrowse =
	(
		if (getFiles ( gif_final_path + "\*.*" )).count == 0 then
			HiddenDOSCommand ( "rmDir \"" + gif_final_path + "\""  )
		
		return false
	),
	
	/** Open in photoshop
	 */
	function openInPhotoshop =
	(
		--format "\n"; print "GifRecorder_v.openInPhotoshop()"
		/** Get photoshop path
		 */
		function getPhotoshopPath = substituteString ROLLOUT_options.BP_Photoshop_exe.text "/" "\\"

		Photoshop_exe = getPhotoshopPath()
		
		if gif_final_path == undefined then
			if this._browseGifSavePath() == undefined then
				this._cancelBrowse() -- cancel save if getSaveFileName was canceled
		
		this.saveGifFile()

				
		if not (ps_existis = doesFileExist Photoshop_exe )then
		(
			format "PATH TO PHOTOSHOP DOES NOT EXISTS\n\nPLEAS EDIT\n\nViltools->Options->Photoshop path\n\nCURRENT PATH: %\n" Photoshop_exe
		
			messageBox "BROWSE PATH TO PHOTOSHOP" title:"PHOTOSHOP PATH"
		
			macros.run "_Otions" "_options_paths_photoshop"
			
			Photoshop_exe = getPhotoshopPath()

			ps_existis = doesFileExist Photoshop_exe
		)
		
		if ps_existis then
		(
			print ("start \"\" \"" +	Photoshop_exe + "\" /open \"" +	gif_final_path +	"\"" )

			DOSCommand ("start \"\" \"" +	Photoshop_exe + "\" /open \"" +	gif_final_path +	"\"" )
		)

	),

	/** SAVE FRAMES OF GIF 
	 */
	function saveFrames =
	(
		--format "\n"; print "GifRecorder_v.saveFrames()"
		
		if doesFileExist temp_dir then
			this._clearTempDir()
		else
			makeDir temp_dir all:true
		
		suffix_length = ( frames.count as string ).count
		
		/* SAVE FRAMES */ 
		for i = 1 to frames.count do 
		(
			frame = frames[i]
			
			suffix = i as string
			
			if suffix_length > suffix.count then
				for i = 1 to suffix_length - suffix.count do
					suffix = "0" + suffix
			
			frame.filename = temp_dir +"\\frame-" + suffix + ".jpg" --this will be the filename
			
			save frame

			viewports
		)
	),
	
	/** Open dir
	 */
	function openDir =
	(
		--format "\n"; print "GifRecorder_v.openDir()"
		gif_dir = getFilenamePath(gif_final_path)

		ShellLaunch  gif_dir ""
		--ShellLaunch  maxfile_subdir ""
	),
	
	/** SHOW RC MENU
	 */
	function showFrameMenu =
	(
		--format "\n"; print "GifRecorder_v.showFrameMenu()"
		frame = this._getCurrentFrame()

		Menu = RcMenu_v name:"FrameMenu"
		
		Menu.item	"Grab Frame"	"GIF_RECORDER.grabGifFrame()"
		
		Menu.item	"Remove Frame"	"GIF_RECORDER.removeFrame quiet:false"
		
		
		if frame < frames.count then
			Menu.item	"Remove Frames Right"	"GIF_RECORDER.removeFrame quiet:false direction:#RIGHT"
		
		
		if frame > 1 then
			Menu.item	"Remove Frames Left"	"GIF_RECORDER.removeFrame quiet:false direction:#LEFT"
		
		
		popUpMenu (Menu.create())
		
	),

	/** REMOVE FRAME
	 */
	function removeFrame direction: quiet:true =
	(
		--format "\n"; print "GifRecorder_v.removeFrame()"
		--format "direction: %\n" direction
		
		current_frame = this._getCurrentFrame()
		
		frame = case direction of
		(
			#LEFT:  current_frame - 1
			
			#RIGHT: current_frame + 1
			
			default: current_frame
		)
	
		
		--format "frame: %\n" frame
		
		frame_msg = if direction == unsupplied then "FRAME: " else "FRAMES: "
		
		frame_msg = case direction of
		(
			#LEFT:  "1 - " + frame as string
			
			#RIGHT: frame as string + " - " + frames.count as string
			
			default:  frame as string
		)
	
		
		if quiet or queryBox ("REMOVE "+ frame_msg +" ?") title:"Remove Frame" then
		(
			if direction == unsupplied then
			(
				--show_frame = if frames[frame + 1] != undefined then frame + 1 else if frame > 1 then frame - 1 else 1
	
				--if show_frame != undefined then 
				deleteItem frames current_frame
				
				this.showFrame (current_frame)
				
				this.updateSliderRange -1
			)
			else
			(
				case direction of
				(
					#LEFT:  for i = 1 to frame do deleteItem frames 1
					
					#RIGHT: for i = frames.count to frame by -1 do deleteItem frames i
				)
					
				this._setSliderRange (frames.count)
				
				if direction == #LEFT then
				(
					this.showFrame(1)
					
					this.setSlider(1)
				)
				
			)
			--_slider.range.y -= 1
			--_slider.ticks   -= 1
		)
	),
	
	
	/** SHOW FRAME
	 */
	function showFrame frame =
	(
		--format "\n"; print "GifRecorder_v.showFrame()"
		fn getSizeWithBorder size = size + (border_width * 2)
		--fn getSizeWithBorder size = size + border_width
		

		if frame > 0 and (preview_image = frames[frame]) != undefined then
		(
			--format "preview_image: %\n" preview_image
			--background_img = bitmap ( getSizeWithBorder preview_image.width ) (getSizeWithBorder preview_image.height ) color:( if recording then red else ( color 40 40 40  ) )
			background_img = bitmap (getSizeWithBorder preview_size.x) (getSizeWithBorder preview_size.y) color:( if recording then red else ( color 40 40 40  ) )
			--background_img = bitmap preview_image.width preview_image.height color:( if recording then red else ( color 40 40 40  ) )
			--format "preview_size.x:      %\n" preview_size.x
			--format "preview_image.width: %\n" preview_image.width
			--format "TEST: %\n" (preview_image.width > preview_size.x or preview_image.height > preview_size.y)
			
			if preview_image.width > preview_size.x or preview_image.height > preview_size.y then
			(
				downsized_image = bitmap preview_size.x preview_size.y  --the new bitmap size
				
				copy preview_image downsized_image
				
				preview_image = downsized_image
				
				--free downsized_image
			)
			
			pasteBitmap preview_image background_img [ 0, 0 ] [ border_width, border_width ]	--src dest
			
			preview_image = background_img 
		)
		
		DIALOG_GifRecorder.IT_preview.bitmap = preview_image
	),
	
	/** Set slider
	 */
	function setSlider frame =
	(
		--format "\n"; print "GifRecorder_v.setSlider()"
		DIALOG_GifRecorder.SLIDER_frames.value = frame
	),
	
	/** Set slider
	 */
	function _setSliderRange val =
	(
		--format "\n"; print "GifRecorder_v.setSlider()"
		_slider = DIALOG_GifRecorder.SLIDER_frames
	
		_slider.range.y = val
			
		_slider.ticks   = val - 1
	),
	
	/** Upfate slider range
	 */
	function updateSliderRange val =
	(
		--format "\n"; print "GifRecorder_v.upfateSliderRange()"
		_slider = DIALOG_GifRecorder.SLIDER_frames
		
		_slider.range.y += val
		_slider.ticks   += val
	),
	
	/** Create camera
	 */
	function _saveCamera =
	(
		--format "\n"; print "GifRecorder_v._saveCamera()"
		with redraw off
		(
			_selection = selection as Array

			
			/* SAVE DATA OF CURRENT VIEWPORT */ 
			record_viewport = viewport.activeViewport
	
			view_tm = viewport.getTM()
	
			view_type = viewport.getType()
			
			/* CREATE CAMERA FROM VIEW */ 
			viewport.setType #view_persp_user
	
			macros.run "Lights and Cameras" "StandardCamera_CreateFromView"
			
			select  _selection -- reselect after creation of camera 
			
			record_camera = cameras[cameras.count]
			
			/* SAVE CAMERA TRANSFORM */ 
			camera_tm = record_camera.transform
			
			delete record_camera
			
			/* RESTORE VIEW */ 
			this._restoreViewport()
			
		)
				
		redrawViews()
	),
	

	/** Set paths
	 */
	function setGifPaths =
	(
		--format "\n"
		--format "\n"; print "GifRecorder_v.setGifPaths()"
		/** Get gif path
		 */
		function getGifTempPath =
		(
			--format "\n"; print "GifRecorder_v._getGifPath()"
			gif_path = temp_dir + "/" + gif_filename
			
			substituteString gif_path "/" "\\" --return
		)
			/** Get gif path
		 */
		function getGifSavePath temp_file:false =
		(
			--format "\n"; print "GifRecorder_v.getGifSavePath()"
			used_path = if user_save_path != undefined then user_save_path else maxfile_subdir

			file_path = used_path + "/" + gif_filename
			
			substituteString file_path "/" "\\" --return
		)
		
		/** Set filename
		 */
		function setFilename =
		(
			--format "\n"; print "GifRecorder_v._setFilename()"
			/** Get filename from edit text input
			  * 
			  * @return string|undefined 
			 */
			function getFilenameFromEditText =
			(
				--format "\n"; print "GifRecorder_v._getFilename()"
				
				user_basename = if DIALOG_GifRecorder != undefined then  DIALOG_GifRecorder.ET_filename.text else ""
				
				user_basename_is_empty = (( dotNetClass "System.Text.RegularExpressions.RegEx").match user_basename "^\s+$|^$" ).success
		
				if not user_basename_is_empty then
					substituteString user_basename "*.gif" "" --return filename of gif without ".gif" extension
			)
			
			gif_basename  = if (user_basename = getFilenameFromEditText()) != undefined then user_basename
				else if maxFileName != undefined then 
					getFilenameFile( maxFileName )
				
				else
					"undefined"
			
			this.gif_filename = gif_basename + ".gif"
		)

		setFilename()
		
		gif_temp_path  = getGifTempPath()
		gif_final_path = getGifSavePath()
		--format "gif_temp_path: %\n" gif_temp_path
		--format "gif_final_path: %\n" gif_final_path
	),

	private
	
	
	/** Clear temp dir
	 */
	function _clearTempDir =
	(
		--format "\n"; print "GifRecorder_v._clearTempDir()"
		for file in getFiles (temp_dir + "\\*.*") do
			deleteFile file
	),

	/** Crop safe frame
	 */
	function _cropSafeFrame screenshot =
	(
		--format "\n"; print "GifRecorder_v._cropSafeFrame()"
		function getViewportSafeFrameSize viewSize renderSize =
		(
			local viewAspect = viewSize.x as float / viewSize.y
			local renderAspect = renderSize.x as float / renderSize.y
		
			local x, y, w, h
			if (viewAspect > renderAspect) then
			(       
				h = viewSize.y
				w = (h * renderAspect) as integer
				y = 0
				x = (viewSize.x - w) / 2
			)
			else
			(
				w = viewSize.x
				h = (w / renderAspect) as integer
				x = 0
				y = (viewSize.y - h) / 2        
			)
			return box2 x y w h
		)
		
		
		
		if this._isSafeFrameEnabled(screenshot) then
		(
			safe_frame = getViewportSafeFrameSize [gw.getWinSizeX(), gw.getWinSizeY()] [ renderWidth , renderHeight ]
	
			screenshot_cropped = bitmap (safe_frame.w - 2) (safe_frame.h - 2) color:black-- filename:newTempName
	
			pasteBitmap screenshot screenshot_cropped [ safe_frame.x + 1, safe_frame.y + 1 ] [0,0]	--src dest
	
			free screenshot
			
			screenshot_cropped --return
		)
		else
			screenshot --return
	),

	/** Test if safe frame is on
	  * Test if bottom right pixel of viewport is black
	 */
	function _isSafeFrameEnabled screenshot =
	(
		--format "\n"; print "GifRecorder_v._isSafeFrameEnabled()"
		if safe_frame_enabled == undefined then
		(
			background_solor = (getPixels screenshot [ gw.getWinSizeX() - 1 , gw.getWinSizeY() - 1 ] 1 )[1]
			
			safe_frame_enabled = background_solor.r as integer == 0 and background_solor.g as integer == 0 and background_solor.b as integer == 0
		)
		else
			safe_frame_enabled --return
	),
		

	/** Set record camera view
	 */
	function _setRecordCameraView =
	(
		--format "\n"; print "GifRecorder_v._setRecordCameraView()"

		if viewport.numViews > 1 then
			viewport.activeViewport = record_viewport 
		
		/* CREATE CAMERA FROM SAVED VIEW */ 
		record_camera = Freecamera transform:camera_tm name:(uniquename "GifRecorderCamera") isHidden:true
		
		viewport.setCamera record_camera

		delete record_camera
		
		/* RESTORE VIEW */ 
		this._restoreViewport()
	),
	
	/** Restore viewport
	 */
	function _restoreViewport =
	(
		--format "\n"; print "GifRecorder_v._restoreViewport()"
		if viewport.numViews > 1 then
			viewport.activeViewport = record_viewport 
				
		viewport.setType view_type
		
		viewport.setTM view_tm
	),
	
	/** Toggle view cube
	 */
	function _toggleViewCube state =
	(
		--format "\n"; print "GifRecorder_v._toggleViewCube()"
		actionMan.executeAction 1920373763 "73"  -- ViewCube: Toggle ViewCube Visibility
		
		if view_cube_state == undefined then 
			view_cube_state = ViewCubeOps.Visibility

		if state and view_cube_state then
			ViewCubeOps.Visibility = true
		
		else if not state then
			ViewCubeOps.Visibility = false
	),
	
	/** Get current frame
	 */
	function _getCurrentFrame =
	(
		--format "\n"; print "GifRecorder_v._getCurrentFrame()"
		DIALOG_GifRecorder.SLIDER_frames.value
	),


	
	/** Init screenshot size
	 */
	function _initScreenshotSize =
	(
		--format "\n"
		--format "\n"; print "GifRecorder_v._initScreenshotSize()"
		
		screenshot = gw.getViewportDib index:record_viewport --this grabs the viewport
		--format "screenshot.width:  %\n" screenshot.width
		--format "screenshot.height: %\n" screenshot.height
		
		screenshot = this._cropSafeFrame(screenshot)
		
		--format "\n"
		--screenshot = this._cropSafeFrame(gw.getViewportDib())

		display_info = ( dotNetClass "System.Windows.Forms.Screen").PrimaryScreen.Bounds
		--format "DISPLAY_INFO: %\n" display_info
		--format "screenshot.width:  %\n" screenshot.width
		--format "screenshot.height: %\n" screenshot.height
		
		
		if screenshot.width > display_info.Width / 3 or screenshot.height > display_info.Height / 2  then
		(
			
			preview_size.x = (screenshot.width  / 2 ) as integer
			preview_size.y = (screenshot.height / 2 ) as integer
		)
		else
		(
			preview_size.x = screenshot.width
			preview_size.y = screenshot.height
		)

		--preview_size.x += border_width * 2
		--preview_size.y += border_width * 2
		--format "PREVIEW_SIZE: %\n" preview_size
		free screenshot
		
		--this.setPreviewWindowSize()
	),
	
	/**
	 */
	on create do
	(
		format "\n"; print "GifRecorder.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		--format "selection: %\n" ( selection  as Array )
		this._saveCamera()
		--format "selection: %\n" ( selection  as Array )

		this._initScreenshotSize()
		--format "selection: %\n" ( selection  as Array )
		this.setGifPaths()
	)

)
