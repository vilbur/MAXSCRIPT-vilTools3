

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
	--format "DIALOG_slicer_slider == undefined	= % \n" (DIALOG_slicer_slider == undefined)
	--if DIALOG_slicer_slider == undefined then

	--SlicerCallbacks = "::SlicerCallbacks_v"

	controls_height = 86

	--format "VIEWPORT_SIZE: %\n" viewport_size
	--slider_height = SLICER_SYSTEM.viewport_height - ( mod SLICER_SYSTEM.viewport_height 10 ) - 70 -- round viewport height to ceil 10 E.G.: 1789 >>> 1780
	--slider_height = SLICER_SYSTEM.viewport_height - controls_height -- round viewport height to ceil 10 E.G.: 1789 >>> 1780

	--if slider_height > slider_ticks then
		--slider_ticks /= 10

	--slider_ticks  = SLICER_SYSTEM.slice_count
	--slider_ticks = (floor ( slider_ticks / 10 ) ) * 10
	--slider_ticks = (ceil ( SLICER_SYSTEM.slice_count / 100 ) ) * 10
	frames_count = 10
	--slider_ticks = 100

	--frame_delays = #( 0.1, 0.25, 0.5 )
	frame_delays = #( 0.5 )
	
	for i = 1 to 10 do append frame_delays i
	
	frame_delays = for delay in frame_delays collect delay as string
	
	--format "SLICER_SYSTEM.slice_count: %\n" SLICER_SYSTEM.slice_count
	--format "SLICER_SYSTEM.viewport_height: %\n" SLICER_SYSTEM.viewport_height
	--format "slider_height: %\n" slider_height
	--format "slider_ticks: %\n" slider_ticks

	/*------------------------------------------------------------------------------
		DIALOG
	--------------------------------------------------------------------------------*/
	--min_size = [ 42, -1 ]
	min_size = getViewSize()

    Dialog 	    = Dialog_v "GIF RECORDER" id:#DIALOG_GifRecorder width:min_size.x min_size:min_size ini:(getSourceFileName()) --min_size:[48, -1] max_size:[48, -1]

	_Controls   = Dialog.Controls() --group:"Main Controls"

	/*------------------------------------------------------------------------------
		CONTROLS
	------------------------------------------------------------------------------*/
	--tooltip_btn = "Shift slider 1 layer UP \ DOWN\n\nCTRL:  Go 10 layers UP \ DOWN\n\nSHIFT: Go 100 layers UP \ DOWN\n\nALT:  Go NEXT\PREVIOUS island"

	--btn_exit = _Controls.control #BUTTON "IN\OUT" width:42 height:24 offset:[ 12, -4 ] border:false tooltip:"Exit and remove slicer from all objects"

	--btn_preview = _Controls.control #IMGTAG "PREVIEW " across:1  width:380 height:380 -- offset:[ -4, -4 ] tooltip:tooltip_btn



    /*------ SLIDER ------*/
    _slider = _Controls.control #SLIDER "Frames" \
                    id:	#SLIDER_frames	\
                    range:	[1, 1, 0]	\
                    type:	#INTEGER	\
                    params:	#(#orient, #horizontal  )	\
                    ticks:	0	\
                    width:	min_size.x 	\
                    height:	24	\
                    across:	2	\
                    offset:	[ -6, -4 ]	\
                    ini:	false

	
	--btn_screen = _Controls.control #BUTTON	"S C R E E N"	across:1 width:256 height:64 offset:[ 32, 0 ]
	btn_record = _Controls.control #CHECKBUTTON	"R E C O R D"	across:3 width:128 height:64 offset:[ 0, 0 ] ini:false checked:true --autorun:true
	
	_dropdown = _Controls.control #DROPDOWNLIST "Delay" id:#DDL_delay across:3 align:#right width:48 items:frame_delays offset:[ 0, 16 ] --ini:false --params:#( #UNSELECT, true ) across:3 offset:[ 4, 2 ] --align:#center  --width:96
	
	btn_save   = _Controls.control #BUTTON	"Save Gif"	across:3 width:128 height:64 offset:[ 0, 0 ] --ini:false checked:true --autorun:true

	btn_preview = _Controls.control #IMGTAG "PREVIEW " across:1  params:	#(#STYLE, #bmp_center ) -- offset:[ -4, -4 ] tooltip:tooltip_btn

	
	/*------------------------------------------------------------------------------
		EVENTS
	--------------------------------------------------------------------------------*/


	
	btn_preview.Event #RIGHTCLICK "GifRecorder.showFrameMenu()" tooltip:"Show Menu"
	btn_preview.Event #DBLCLICK   "GifRecorder.generateGif()" tooltip:"Show Menu"
	
	_slider.Event #CHANGED     "GifRecorder.showFrame(val)"
	
	btn_save.Event #PRESSED   "GifRecorder.saveGifFile()" tooltip:""
	
	btn_record.Event #CHANGED   "GifRecorder.recording = val == 1 ; grabFrameTimerStart( val == 1 )" tooltip:""
	
	
	Dialog.Events.add #OPEN   "GifRecorder.startRecording()" tooltip:""
	--Dialog.Events.add #CLOSE   "print \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\"" tooltip:""


	/*------------------------------------------------------------------------------
		CREATE DIALOG
	--------------------------------------------------------------------------------*/
	Dialog.create()
	--Dialog.create width:(viewport_size.x + 64 ) height:(viewport_size.y + 256)

	--Dialog.dock #RIGHT



)