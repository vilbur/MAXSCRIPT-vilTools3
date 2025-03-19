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


		--screenshot.filename = screenshot_dir +"\\"+ filename + "-" + ".jpg" --this will be the filename

		--save screenshot
		
		--display screenshot
			
		append frames screenshot
		
		
		this.showFrame(frames.count)
	),
	
	/** Grab gif frame
	 */
	function grabGifFrame =
	(
		format "\n"; print "GifRecorder_v.grabGifFrame()"
		
		/* IF VIEW CHANGED */ 
		if view_tm != viewport.getTM() then
			this._setRecordCameraView()

		this._toggleViewCube(false)

		screenshot = gw.getViewportDib index:record_viewport --this grabs the viewport
					
		this._toggleViewCube(true)
	
		screenshot = this._cropSafeFrame(screenshot)

		frame = this._getCurrentFrame() + 1
		
		--append frames screenshot
		insertItem screenshot frames frame
		
		this._setSliderRange(frame)
		
		this.setSlider(frame)
		
		this.showFrame(frame)
		
		this._restoreViewport()


		format "FRAME: % \n" frame
	),
	
	/** Start recording
	 */
	function startRecording =
	(
		format "\n"; print "GifRecorder_v.startRecording()"

		
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
	
	/** Grab frame on lmb release
	 */
	function grabFrameOnLmbRelease =
	(
		--format "\n"; print "GifRecorder_v.grabFrameOnLmbRelease()"
		lmb_state_current = mouse.buttonStates[1]
		
		if lmb_last_state and not lmb_state_current then
			this.grabGifFrame()
		
		lmb_last_state = lmb_state_current
		
		if not this.recording or GetDialogPos DIALOG_GifRecorder == [0,0] then
		(
			DotNetTimer.stop()
			
			this.stopRecording()
			
			lmb_last_state = false
		)
		
		
	),
	
	
	/** STOP RECORDING
	 */
	function stopRecording =
	(
		format "\n"; print "GifRecorder_v.stopRecording()"
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
		--format "\n"; print "GifRecorder_v.onCloseDialog()"
		stopRecording.stop()
	),
	
	/** Save giff file
	 */
	function saveGifFile browse:false =
	(
		--format "\n"; print "GifRecorder_v.saveGifFile()"
		format "gif_final_path: %\n" gif_final_path
		
		
		allow_save = true
		
		this._setGifPaths()

		save_dir = getFilenamePath(gif_final_path)
		
		makeDir save_dir all:true
		
		if not doesFileExist gif_temp_path then
			this.generateGif()
		
		
		if browse and this._browseGifSavePath() == undefined then
			this._cancelBrowse(save_dir) -- cancel save if getSaveFileName was canceled
		
			
		/*------ SAVE FILE ------*/
		
		deleteFile gif_final_path
		
		copyFile gif_temp_path gif_final_path
		
		format "GIF SAVED TO: %\n" gif_final_path
	),
	
	/** Browse gif save path
	 */
	function _browseGifSavePath =
	(
		--format "\n"; print "GifRecorder_v._browseGifSavePath()"
		user_save_path_browsed = getSaveFileName caption:"Browse" filename:gif_final_path  types:"GIF(*.gif)|*.*"  historyCategory:"GifRecorder"
		
		if user_save_path_browsed != undefined then -- use previous path if browsing is CANCELED
			user_save_path = getFilenamePath(user_save_path_browsed) -- return 
	),
	
	/** Remove empty dir
	 */
	function _cancelBrowse save_dir =
	(
		if (getFiles ( save_dir + "\*.*" )).count == 0 then
			HiddenDOSCommand ( "rmDir \"" + save_dir + "\""  )
		
		return false
	),
	
	/** Generate gif
	 */
	function generateGif =
	(
		format "\n"; print "GifRecorder_v.generateGif()"
		this._setGifPaths()

		this.saveFrames()

		this.combineFramesToGif()
		
		--DOSCommand ("start \"\" \""+gif_temp_path+"\"")
		--DOSCommand ("start \"\" \""+gif_temp_path+"\"")
		DOSCommand ("\""+gif_temp_path+"\"")
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
		
		format "Photoshop_exe: %\n" Photoshop_exe
		this._setGifPaths()

		gif_path = if gif_final_path != undefined  and doesFileExist gif_final_path then gif_final_path else gif_temp_path
		
		if gif_final_path == undefined then
			if this._browseGifSavePath() == undefined then
				this._cancelBrowse(save_dir) -- cancel save if getSaveFileName was canceled
		
		
		if not doesFileExist gif_final_path then
			this.generateGif()

				
		if (ps_existis = doesFileExist Photoshop_exe )then
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

	/** Save gif
	 */
	function saveFrames =
	(
		format "\n"; print "GifRecorder_v.saveFrames()"
		format "temp_dir: %\n" temp_dir
		
		--makeDir maxfile_subdir  all:true
		makeDir temp_dir all:true
		
		this._clearTempDir()
		
		/* SAVE FRAMES */ 
		for i = 1 to frames.count do 
		(
			frame = frames[i]
			
			frame.filename = temp_dir +"\\frame-" + i as string + ".jpg" --this will be the filename
			
			save frame
			viewports
			--free frame
		)
		
	),
	
	/** Open dir
	 */
	function openDir =
	(
		format "\n"; print "GifRecorder_v.openDir()"
		this._setGifPaths()

		
		gif_path = if gif_final_path != undefined  and doesFileExist gif_final_path then gif_final_path else gif_temp_path
		
		gif_dir = getFilenamePath(gif_path)

		ShellLaunch  gif_dir ""
		--ShellLaunch  maxfile_subdir ""
	),
	
	/** SHOW RC MENU
	 */
	function showFrameMenu =
	(
		format "\n"; print "GifRecorder_v.showFrameMenu()"
		frame = this._getCurrentFrame()

		Menu = RcMenu_v name:"FrameMenu"
		
		Menu.item	"Remove Frame"	"GifRecorder.removeFrame quiet:false"
		
		
		if frame < frames.count then
			Menu.item	"Remove Frames Right"	"GifRecorder.removeFrame quiet:false direction:#RIGHT"
		
		
		if frame > 1 then
			Menu.item	"Remove Frames Left"	"GifRecorder.removeFrame quiet:false direction:#LEFT"
		
		
		popUpMenu (Menu.create())
		
	),

	/** Remove frame
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
				show_frame = if frames[frame + 1] != undefined then frame + 1 else if frame > 1 then frame - 1 else 1
	
				--if show_frame != undefined then 
					this.showFrame (show_frame)
				
				deleteItem frames frame
				
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
	
	
	/** Show frame
	 */
	function showFrame frame =
	(
		format "\n"; print "GifRecorder_v.showFrame()"
		format "frame: %\n" frame
		--format "frames: %\n" frames
		--format "preview_image: %\n" frames[frame]
		
		--preview_image = if (frame_bitmap = frames[frame]) != undefined then frame_bitmap else undefined
		--format "preview_image: %\n" preview_image
		if (preview_image = frames[frame]) != undefined then
		(
			format "preview_image: %\n" preview_image
			background_img = bitmap preview_size.x preview_size.y color:(if recording then red else ( color 40 40 40  ) )
			
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
	
--	/** Set preview size
--	 */
--	function setPreviewWindowSize =
--	(
--		format "\n"; print "GifRecorder_v.setPreviewWindowSize()"
--		format "preview_size: %\n" preview_size
--		--width  = screenshot.width
--		--height = screenshot.height
--		--format "DIALOG_GifRecorder.CBTN_record_indicator: %\n" DIALOG_GifRecorder.CBTN_record_indicator
--		/* SLIDER */ 
--		--if width > 420 then
--		--DIALOG_GifRecorder.SLIDER_frames.width	= width 
----
--		/* PREVIEW BUTTON */ 
--		--DIALOG_GifRecorder.IT_preview.width	= width
--		--DIALOG_GifRecorder.IT_preview.height	= height
--		
--		--DIALOG_GifRecorder.IT_preview.pos.y	-= preview_size.y
--		
--		DIALOG_GifRecorder.IT_preview.width	= preview_size.x
--		DIALOG_GifRecorder.IT_preview.height	= preview_size.y
--		
--		DIALOG_GifRecorder.CBTN_record_indicator.width	= preview_size.x + 10
--		DIALOG_GifRecorder.CBTN_record_indicator.height	= (preview_size.y + 10) as integer
--		
--		/* DIALOG */ 
--		--if width > 420 then
--		DIALOG_GifRecorder.width	= preview_size.x + 32
--		DIALOG_GifRecorder.height	= preview_size.y + 128
--		
--	),

	
	/** Create camera
	 */
	function _saveCamera =
	(
		--format "\n"; print "GifRecorder_v._saveCamera()"
		with redraw off
		(
			/* SAVE DATA OF CURRENT VIEWPORT */ 
			record_viewport = viewport.activeViewport
	
			view_tm = viewport.getTM()
	
			view_type = viewport.getType()
			
			/* CREATE CAMERA FROM VIEW */ 
			viewport.setType #view_persp_user
	
			macros.run "Lights and Cameras" "StandardCamera_CreateFromView"
		
			record_camera = cameras[cameras.count]
			
			/* SAVE CAMERA TRANSFORM */ 
			camera_tm = record_camera.transform
			
			delete record_camera
			
			/* RESTORE VIEW */ 
			this._restoreViewport()
		)
				
		redrawViews()
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

	/** Combine frames to gif
	 */
	function combineFramesToGif =
	(
		--format "\n"; print "GifRecorder_v.combineFramesToGif()"
		--format "gif_file: %\n" gif_file
		--print("cd \""+temp_dir+"\"; magick -delay 100 -loop 0 *.jpg animated.gif")
		--DOSCommand ("cd \""+temp_dir+"\" & magick -delay 300 -loop 0 *.jpg animated.gif")
		
		--delay = DIALOG_GifRecorder.DDL_delay.selection

		delay = (DIALOG_GifRecorder.DDL_delay.items[ DIALOG_GifRecorder.DDL_delay.selection as integer ] as integer * 100) as integer
		
		format "DELAY: %\n" delay
		
		print      ("cd \""+temp_dir+"\" & magick -delay "+delay as string +" -loop 0 *.jpg \""+gif_filename+"\"")
		DOSCommand ("cd \""+temp_dir+"\" & magick -delay "+delay as string +" -loop 0 *.jpg \""+gif_filename+"\"")
		--DOSCommand ("start \"\" " + "cd \""+temp_dir+"\"; magick -delay 1000 -loop 0 *.jpg animated.gif")
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


	/** Set paths
	 */
	function _setGifPaths =
	(
		--format "\n"; print "GifRecorder_v._setGifPaths()"
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
			--format "\n"; print "GifRecorder_v._getGifPath()"
	
			used_path = if user_save_path != undefined then user_save_path else maxfile_subdir
			
			gif_path = used_path + "/" + gif_filename
			
			substituteString gif_path "/" "\\" --return
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
				
				user_basename = DIALOG_GifRecorder.ET_filename.text
				
				user_basename_is_empty = (( dotNetClass "System.Text.RegularExpressions.RegEx").match user_basename "^\s+$|^$" ).success
		
				if not user_basename_is_empty then
					substituteString user_basename "*.gif" "" --return filename of gif without ".gif" extension
			)
			
			gif_basename  = if (user_basename = getFilenameFromEditText()) != undefined  then user_basename else getFilenameFile( maxFileName )
			
			this.gif_filename = gif_basename + ".gif"
		)

		setFilename()
		
		gif_temp_path  = getGifTempPath()
		gif_final_path = getGifSavePath()
	),
	
	/** Init screenshot size
	 */
	function _initScreenshotSize =
	(
		--format "\n"; print "GifRecorder_v._initScreenshotSize()"
						
		screenshot = this._cropSafeFrame(gw.getViewportDib())

		display_info = (dotNetClass "System.Windows.Forms.Screen").PrimaryScreen.Bounds
		
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

		preview_size.x += border_width * 2
		preview_size.y += border_width * 2

		free screenshot
		
		--this.setPreviewWindowSize()
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "GifRecorder.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this._saveCamera()
		
		this._initScreenshotSize()
	)

)
