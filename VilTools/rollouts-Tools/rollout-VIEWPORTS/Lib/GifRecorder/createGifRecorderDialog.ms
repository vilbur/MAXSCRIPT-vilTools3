

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

	--rec_button_highlight_color = ( color 120 0 50 )
	rec_button_highlight_color = red
	
	--frame_delays = #( 0.1, 0.25, 0.5 )
	frame_delays = #( 0.5 )
	
	for i = 1 to 10 do append frame_delays i
	
	frame_delays = for delay in frame_delays collect delay as string
	

	/*------------------------------------------------------------------------------control 
		DIALOG
	--------------------------------------------------------------------------------*/
	min_size = GIF_RECORDER.preview_size
	--min_size = [( getViewSize()).x, -1 ]
	--min_size = getViewSize()
	--min_size =  getViewSize()
	--
	if min_size.x < 420 then
		min_size.x = 420

	
    Dialog 	    = Dialog_v "GIF RECORDER" id:#DIALOG_GifRecorder width:min_size.x min_size:min_size ini:(getSourceFileName()) --min_size:[48, -1] max_size:[48, -1]
    --Dialog 	    = Dialog_v "GIF RECORDER" id:#DIALOG_GifRecorder width:1024 --min_size:[48, -1] max_size:[48, -1]

	_Controls   = Dialog.Controls() --group:"Main Controls"

	/*------------------------------------------------------------------------------
		CONTROLS
	------------------------------------------------------------------------------*/
    across = 3

	--_GroupBox_gif = _Controls.control #GroupBox "CONTROLS" height:48 across:2 align:#LEFT orient:#HORIZONTAL

    --btn_record = _Controls.control #CHECKBUTTON	" ⬣ R E C O R D" across:4 width:128 height:64 offset:[ 0, 0 ] ini:false checked:true highlightColor:rec_button_highlight_color --groupbox:_GroupBox_gif.caption --autorun:true
    btn_save   = _Controls.control #BUTTON "Save Gif" across:4 width:128 height:64 offset:[ -48, 0 ] --groupbox:_GroupBox_gif.caption
	
    btn_photoshop = _Controls.control #BUTTON "Open in Photoshop"	across:4 width:128 height:64 offset:[ -96, 0 ] --groupbox:_GroupBox_gif.caption
	
	--_GroupBox = _Controls.control #GroupBox "[save options]" width:256 height:48 across:4 align:#right offset:[ -64, 0 ]
	
	delay = _Controls.control #DROPDOWNLIST "Delay" id:#DDL_delay across:4 width:48 items:frame_delays offset:[ 112, 0 ] --groupbox:_GroupBox.caption
	
	filename = _Controls.control #EDITTEXT "Filename" across:4  width:256 offset:[ 0, 20 ] --groupbox:_GroupBox.caption


	
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

	
	--btn_preview_rec = _Controls.control #CHECKBUTTON	"" id:"CBTN_record"	across:1 width:(min_size.x + 10 ) height:1 ini:false checked:true highlightColor:rec_button_highlight_color --groupbox:_GroupBox_gif.caption --autorun:true
	--btn_preview_rec = _Controls.control #BITMAP "" id:"CBTN_record"	across:1 value:rec_button_highlight_color --groupbox:_GroupBox_gif.caption --autorun:true
	--btn_preview_rec = _Controls.Control #IMGTAG "" id:"CBTN_record_indicator" color:red width:min_size.x height:1 across:1

	
	/* PREVIEW WINDOW */ 
	img_preview = _Controls.control #IMGTAG "PREVIEW " across:1  params:	#(#STYLE, #bmp_stretch  /*#bmp_center*/ ) width:min_size.x height:min_size.y -- offset:[ -4, -4 ] tooltip:tooltip_btn

	
	/*------------------------------------------------------------------------------
		EVENTS
	--------------------------------------------------------------------------------*/


	/* PREVIEW */ 
	img_preview.Event #CLICK "if GIF_RECORDER.recording then GIF_RECORDER.stopRecording() else GIF_RECORDER.startRecording()" tooltip:"START \ STOP RECORDING"
	img_preview.Event #RIGHTCLICK "GIF_RECORDER.showFrameMenu()" tooltip:"Show Menu"
	img_preview.Event #DBLCLICK   "if keyboard.controlPressed then GIF_RECORDER.generateGif()" tooltip:" + CTRL: Show Gif Preview"
	
	
	/* SLIDER */ 
	_slider.Event #CHANGED     "GIF_RECORDER.showFrame(val)"
	_slider.Event #RIGHTCLICK "GIF_RECORDER.showFrameMenu()" tooltip:"Show Menu"

	
	/*------ BUTTONS ------*/
	/* save file or open dir */ 
	btn_save.Event #PRESSED    "if keyboard.controlPressed then GIF_RECORDER.openDir() else GIF_RECORDER.saveGifFile browse:false" tooltip:""
	/* browse file */ 
	btn_save.Event #RIGHTCLICK "GIF_RECORDER.saveGifFile browse:true" tooltip:""
	
	
	--btn_record.Event #CHANGED   "if val == 1 then GIF_RECORDER.startRecording() else GIF_RECORDER.stopRecording()" tooltip:""
	
	btn_photoshop.Event #PRESSED   "GIF_RECORDER.openInPhotoshop()" tooltip:""
	
	/* DIALOG EVENTS */ 
	Dialog.Events.add #OPEN   "GIF_RECORDER.startRecording()" tooltip:""
	Dialog.Events.add #CLOSE   "GIF_RECORDER.onCloseDialog()" tooltip:""

	
	/*------------------------------------------------------------------------------
		CREATE DIALOG
	--------------------------------------------------------------------------------*/
	--Dialog.create()
	--Dialog.create lockWidth:false
	Dialog.create width:(min_size.x + 32 ) --height:(min_size.y + 128)
	--Dialog.create width:(min_size.x ) height:(min_size.y )
	--Dialog.create width:(min_size.x as integer ) height:(min_size.y as integer )

	--Dialog.dock #RIGHT

	--GIF_RECORDER.setPreviewWindowSize()

)