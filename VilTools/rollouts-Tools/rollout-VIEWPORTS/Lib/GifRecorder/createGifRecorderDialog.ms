

/*------------------------------------------------------------------------------
	DEV DESTROY
--------------------------------------------------------------------------------*/
	--try(
	--	cui.UnRegisterDialogBar DIALOG_slicer_slider
	--
	--	destroyDialog DIALOG_slicer_slider
	--
	--)catch()

/** Create screenshot dialog
 */
function createGifRecorderDialog =
(
	format "\n"; print "createScreenshotDialog()"

	--getViewportHeight()

	controls_height = 86

	frames_count = 10

	--frame_delays = #( 0.1, 0.25, 0.5 )
	frame_delays = #( 0.5 )
	
	for i = 1 to 10 do append frame_delays i
	
	frame_delays = for delay in frame_delays collect delay as string
	

	/*------------------------------------------------------------------------------control 
		DIALOG
	--------------------------------------------------------------------------------*/
	min_size = viewport_size = [ 512, -1 ]
	--min_size = [( getViewSize()).x, -1 ]
	--min_size = getViewSize()
	--viewport_size =  getViewSize()
	--
	--if min_size.x < 420 then
	--	min_size.x = 420

	format "min_size: %\n" min_size		
	
    Dialog 	    = Dialog_v "GIF RECORDER" id:#DIALOG_GifRecorder width:min_size.x min_size:min_size ini:(getSourceFileName()) --min_size:[48, -1] max_size:[48, -1]
    --Dialog 	    = Dialog_v "GIF RECORDER" id:#DIALOG_GifRecorder width:1024 --min_size:[48, -1] max_size:[48, -1]

	_Controls   = Dialog.Controls() --group:"Main Controls"

	/*------------------------------------------------------------------------------
		CONTROLS
	------------------------------------------------------------------------------*/
across = 6
	
	btn_record = _Controls.control #CHECKBUTTON	"R E C O R D"	across:across width:128 height:64 offset:[ 0, 0 ] ini:false checked:true --autorun:true
	
	btn_save   = _Controls.control #BUTTON	"Save Gif"	across:across width:128 height:64 offset:[ 64, 0 ] --ini:false checked:true --autorun:true
	
	_dropdown = _Controls.control #DROPDOWNLIST "DELAY" id:#DDL_delay across:across width:48 items:frame_delays offset:[ 112, 0 ] --ini:false --params:#( #UNSELECT, true ) across:across offset:[ 4, 2 ] --align:#center  --width:96


	--_GroupBox = _Controls.control #GroupBox "Safe Frame" height:96 across:across align:#right
	
	--safe_frame = _Controls.control #CHECKBOX	"SAFE FRAME"	across:across width:128 height:64 offset:[ 96, 0 ] --groupbox:_GroupBox.caption
	--spinner_height = _Controls.control #SPINNER "Height" type:#INTEGER across:across width:96 scale:1 range:[ 256, 8192, renderHeight ] offset:[ 128, 24 ] --groupbox:_GroupBox.caption
	--spinner_with   = _Controls.control #SPINNER "Width"  type:#INTEGER across:across width:96 scale:1 range:[ 256, 8192, renderWidth  ] offset:[ 56, 0 ] --groupbox:_GroupBox.caption


    /*------ SLIDER ------*/
    _slider = _Controls.control #SLIDER "Frames" \
                    id:	#SLIDER_frames	\
                    range:	[1, 1, 0]	\
                    type:	#INTEGER	\
                    params:	#(#orient, #horizontal  )	\
                    ticks:	0	\
                    width:	min_size.x 	\
                    height:	24	\
                    across:	1	\
                    offset:	[ -6, -4 ]	\
                    ini:	false

	
	
	/* PREVIEW WINDOW */ 
	btn_preview = _Controls.control #IMGTAG "PREVIEW " across:1  params:	#(#STYLE, #bmp_stretch  /*#bmp_center*/ ) -- offset:[ -4, -4 ] tooltip:tooltip_btn

	
	/*------------------------------------------------------------------------------
		EVENTS
	--------------------------------------------------------------------------------*/


	/* PREVIEW */ 
	btn_preview.Event #RIGHTCLICK "GifRecorder.showFrameMenu()" tooltip:"Show Menu"
	btn_preview.Event #DBLCLICK   "GifRecorder.generateGif()" tooltip:"Show Menu"
	
	/* SLIDER */ 
	_slider.Event #CHANGED     "GifRecorder.showFrame(val)"
	_slider.Event #RIGHTCLICK "GifRecorder.showFrameMenu()" tooltip:"Show Menu"

	/* BUTTONS */ 
	btn_save.Event #PRESSED   "GifRecorder.saveGifFile()" tooltip:""
	
	btn_record.Event #CHANGED   "GifRecorder.recording = val == 1 ; grabFrameTimerStart( val == 1 )" tooltip:""
	
	/* DIALOG EVENTS */ 
	Dialog.Events.add #OPEN   "GifRecorder.startRecording()" tooltip:""

	/*------------------------------------------------------------------------------
		CREATE DIALOG
	--------------------------------------------------------------------------------*/
	--Dialog.create()
	--Dialog.create lockWidth:false
	Dialog.create width:(viewport_size.x + 32 ) --height:(viewport_size.y + 128)
	--Dialog.create width:(viewport_size.x ) height:(viewport_size.y )
	--Dialog.create width:(viewport_size.x as integer ) height:(viewport_size.y as integer )

	--Dialog.dock #RIGHT



)