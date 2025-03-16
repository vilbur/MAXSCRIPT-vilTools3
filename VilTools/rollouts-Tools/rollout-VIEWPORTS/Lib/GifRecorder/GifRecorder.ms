/** Screen shooter
 */
struct GifRecorder_v
(
	/* construct */
	

	/* required */
	

	/* properties */
	frames = #(),
	
	recording = false, -- start\stop callback

	/* private */
	temp_dir = getDir #TEMP + "/GifRecorder/gif-frames",
	
	gif_dir = substituteString maxFilePath "\\" "/" + "_Screenshots",
		
	--gif_file,
	--gif_basename  = "untitled",
	gif_basename  = getFilenameFile( maxFileName ),
	gif_filename  = gif_basename + ".gif",
	gif_file_path = gif_dir + "/" + gif_filename,
	gif_temp_path = temp_dir + "/" + gif_filename,

	_slider,

	--safe_frame = this.getViewportSafeFrameSize [gw.getWinSizeX(), gw.getWinSizeY()] [renderWidth, renderHeight],
		
	record_camera,
	
	record_viewport,
	active_viewport,
	
	safe_frame_enabled,
	
	preview_size = [128,128],
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
		--format "\n"; print "GifRecorder_v.grabGifFrame()"
		
		this._setRecordCameraView()

		this._toggleViewCube()

		screenshot = gw.getViewportDib index:record_viewport --this grabs the viewport
					
		this._toggleViewCube()
	
		screenshot = this._cropSafeFrame(screenshot)

		append frames screenshot

		if frames.count == 1 then
		(
			display_info = (dotNetClass "System.Windows.Forms.Screen").PrimaryScreen.Bounds
			
			if screenshot.width > display_info.Width / 3 or screenshot.height > display_info.Height / 2  then
			(
				preview_size.x = (screenshot.width / 2 ) as integer
				preview_size.y = (screenshot.height / 2 ) as integer
			)
			else
			(
				preview_size.x = screenshot.width
				preview_size.y = screenshot.height
			)

			----preview_size.x = screenshot.width
			----preview_size.y = screenshot.height

			this._setPreviewWindowSize()
		)
		
		this._setSliderRange(frames.count)
		
		this.setSlider(frames.count)
		
		this.showFrame(frames.count)
		
		--this._restoreViewport()


		format "FRAME: % \n" GifRecorder.frames.count
	),
	
	/** Start recording
	 */
	function startRecording =
	(
		--format "\n"; print "GifRecorder_v.startRecording()"
		this.grabGifFrame()
		
		--this.createCamera()
		
		this.recording = true
		
		grabFrameTimerStart( true )
	),
	
	/** STOP RECORDING
	 */
	function stopRecording =
	(
		format "\n"; print "GifRecorder_v.stopRecording()"
		delete $GifRecorderCamera*

		this._setSliderRange (frames.count)

		this.showFrame(1)
		
		this._setPreviewWindowSize()
	),
	
	/** Save gif file
	 */
	function saveGifFile =
	(
		format "\n"; print "GifRecorder_v.saveGifFile()"
		format "gif_file_path: %\n" gif_file_path
		
		if not doesFileExist gif_temp_path then
			this.generateGif()
			
		save_path = getSaveFileName caption:"Browse" filename:gif_file_path  types:"GIF(*.gif)|*.*"  historyCategory:"GifRecorder" 
		
		format "SAVE_PATH: %\n" save_path
		
	),
	
	/** Generate gif
	 */
	function generateGif =
	(
		format "\n"; print "GifRecorder_v.generateGif()"
		
		this.saveFrames()

		this.combineFramesToGif()
		
		--DOSCommand ("start \"\" \""+gif_temp_path+"\"")
		--DOSCommand ("start \"\" \""+gif_temp_path+"\"")
		DOSCommand ("\""+gif_temp_path+"\"")
	),
	
	/** Save gif
	 */
	function saveFrames =
	(
		format "\n"; print "GifRecorder_v.saveFrames()"
		format "temp_dir: %\n" temp_dir
		
		makeDir gif_dir  all:true
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
		
		ShellLaunch  gif_file ""
		--ShellLaunch  gif_dir ""
	),
	
	/** SHOW RC MENU
	 */
	function showFrameMenu =
	(
		format "\n"; print "GifRecorder_v.showFrameMenu()"
		Menu = RcMenu_v name:"FrameMenu"
		
		Menu.item	"Remove Frame"	"GifRecorder.removeFrame quiet:false"
		Menu.item	"Remove Frames Right"	"GifRecorder.removeFrame quiet:false direction:#RIGHT"
		Menu.item	"Remove Frames Left"	"GifRecorder.removeFrame quiet:false direction:#LEFT"
		
		
		popUpMenu (Menu.create())
		
	),

	/** Remove frame
	 */
	function removeFrame direction: quiet:true =
	(
		--format "\n"; print "GifRecorder_v.removeFrame()"
		frame = DIALOG_GifRecorder.SLIDER_frames.value
		
		if quiet or queryBox ("Remove frame: "+frame as string +" ?") title:"Remove Frame" then
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
					#LEFT:  for i = 1 to frame do deleteItem frames i
					
					#RIGHT: for i = frames.count to frame by -1 do deleteItem frames i
				)
					
				this._setSliderRange (frames.count)
				this.showFrame(frames.count)

				
				
			)
			
			
			--_slider.range.y -= 1
			--_slider.ticks   -= 1
			
		)
	),
	
	
	/** Show frame
	 */
	function showFrame frame =
	(
		--format "\n"; print "GifRecorder_v.showFrame()"
		--format "frame: %\n" frame
		DIALOG_GifRecorder.IT_preview.bitmap = if (frame_bitmap = frames[frame]) != undefined then frame_bitmap else undefined
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
	
	/** Set preview size
	 */
	function _setPreviewWindowSize =
	(
		--format "\n"; print "GifRecorder_v._setPreviewWindowSize()"
		if frames.count > 0 then
		(
			width  = frames[1].width
			height = frames[1].height
			
			/* SLIDER */ 
			--if width > 420 then
			--DIALOG_GifRecorder.SLIDER_frames.width	= width 
--
			/* PREVIEW BUTTON */ 
			--DIALOG_GifRecorder.IT_preview.width	= width
			--DIALOG_GifRecorder.IT_preview.height	= height
			DIALOG_GifRecorder.IT_preview.width	= preview_size.x
			DIALOG_GifRecorder.IT_preview.height	= preview_size.y
			/* DIALOG */ 
			--if width > 420 then
			DIALOG_GifRecorder.width	= preview_size.x + 32
			DIALOG_GifRecorder.height	= preview_size.y + 128
						
		)		
	),

	
	/** Create camera
	 */
	function createCamera =
	(
		format "\n"; print "GifRecorder_v.createCamera()"
		viewTM=inverse ( viewport.gettm() )
		
		newcamName=uniquename "GifRecorderCamera"
		
		--record_camera = targetcamera transform:viewTM name:newcamName isHidden:true
		record_camera = Freecamera transform:viewTM name:newcamName isHidden:true
		
		--viewport.setCamera record_camera
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
		view_type = viewport.getType()

		--if viewport.activeViewport != record_viewport then
		--(
		--	active_viewport = viewport.activeViewport 
		--
		--	viewport.activeViewport = record_viewport 
		--)
		
		viewport.setCamera record_camera

		viewport.setType view_type
	),
	
	/** Restore viewport
	 */
	function _restoreViewport =
	(
		--format "\n"; print "GifRecorder_v._restoreViewport()"
		viewport.activeViewport = record_viewport 
	),
	
	/** Toggle view cube
	 */
	function _toggleViewCube =
	(
		--format "\n"; print "GifRecorder_v._toggleViewCube()"
		actionMan.executeAction 1920373763 "73"  -- ViewCube: Toggle ViewCube Visibility
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "GifRecorder.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		record_viewport = viewport.activeViewport 

		this.createCamera()
	)

)
