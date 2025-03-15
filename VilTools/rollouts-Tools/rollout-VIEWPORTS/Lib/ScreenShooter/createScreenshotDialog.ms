global DIALOG_screenshooter


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
function createScreenshotDialog =
(
	format "\n"; print "createScreenshotDialog()"

	--getViewportHeight()
	--format "DIALOG_slicer_slider == undefined	= % \n" (DIALOG_slicer_slider == undefined)
	--if DIALOG_slicer_slider == undefined then

	--SlicerCallbacks = "::SlicerCallbacks_v"

	controls_height = 86

	--slider_height = SLICER_SYSTEM.viewport_height - ( mod SLICER_SYSTEM.viewport_height 10 ) - 70 -- round viewport height to ceil 10 E.G.: 1789 >>> 1780
	--slider_height = SLICER_SYSTEM.viewport_height - controls_height -- round viewport height to ceil 10 E.G.: 1789 >>> 1780

	--if slider_height > slider_ticks then
		--slider_ticks /= 10

	--slider_ticks  = SLICER_SYSTEM.slice_count
	--slider_ticks = (floor ( slider_ticks / 10 ) ) * 10
	--slider_ticks = (ceil ( SLICER_SYSTEM.slice_count / 100 ) ) * 10
	frames_count = 10
	--slider_ticks = 100

	frame_delays = #( 0.1, 0.25, 0.5 )
	
	for i = 1 to 10 do append frame_delays i
	
	frame_delays = for delay in frame_delays collect delay as string
	
	--format "SLICER_SYSTEM.slice_count: %\n" SLICER_SYSTEM.slice_count
	--format "SLICER_SYSTEM.viewport_height: %\n" SLICER_SYSTEM.viewport_height
	--format "slider_height: %\n" slider_height
	--format "slider_ticks: %\n" slider_ticks

	/*------------------------------------------------------------------------------
		DIALOG
	--------------------------------------------------------------------------------*/
	min_size = [ 42, -1 ]

    Dialog 	    = Dialog_v "xxx" id:#DIALOG_screenshooter width:min_size.x min_size:min_size --ini:(getSourceFileName()) --min_size:[48, -1] max_size:[48, -1]

	_Controls   = Dialog.Controls() --group:"Main Controls"

	/*------------------------------------------------------------------------------
		CONTROLS
	------------------------------------------------------------------------------*/
	--tooltip_btn = "Shift slider 1 layer UP \ DOWN\n\nCTRL:  Go 10 layers UP \ DOWN\n\nSHIFT: Go 100 layers UP \ DOWN\n\nALT:  Go NEXT\PREVIOUS island"

	--btn_exit = _Controls.control #BUTTON "IN\OUT" width:42 height:24 offset:[ 12, -4 ] border:false tooltip:"Exit and remove slicer from all objects"

	btn_preview = _Controls.control #IMGTAG "PREVIEW " across:1  width:380 height:380 -- offset:[ -4, -4 ] tooltip:tooltip_btn



    /*------ SLIDER ------*/
    _slider = _Controls.control #SLIDER "Frames" \
                    id:	#SLIDER_frames	\
                    range:	[1, frames_count, 0]	\
                    type:	#INTEGER	\
                    params:	#(#orient, #horizontal  )	\
                    ticks:	(frames_count - 1)	\
                    width:	362	\
                    height:	24	\
                    across:	2	\
                    offset:	[ -6, -4 ]	\
                    ini:	false

	_dropdown = _Controls.control #DROPDOWNLIST "" id:#DDL_slider_snaps across:2 align:#right width:48 items:frame_delays offset:[ 0, 16 ] --ini:false --params:#( #UNSELECT, true ) across:1 offset:[ 4, 2 ] --align:#center  --width:96
	
	btn_screen = _Controls.control #BUTTON "S C R E E N" across:1 width:256 height:64 

	--btn_plus_minus = _Controls.control #BUTTON "+ \ -"across:1  width:42 height:32 offset:[ -4, -4 ] tooltip:tooltip_btn


	--_spinner = _Controls.control #SPINNER "" id:#SPIN_layer_current across:1 range:[ SLICER_SYSTEM.slice_start, SLICER_SYSTEM.layers_count, 0] width:46 type:#integer offset:[ -6, 0 ]
	--
	--
	--
	--/*------------------------------------------------------------------------------
	--	EVENTS
	----------------------------------------------------------------------------------*/
	btn_screen.Event #PRESSED   "ScreenShooter.getScreenshotOfCurrentViewport()" tooltip:"SLICE CURRENT SELECTED OBJECT"

	btn_preview.Event #RIGHTCLICK "ScreenShooter.showFrameMenu()" tooltip:"Show Menu"
	
	_slider.Event #CHANGED     "ScreenShooter.showFrame(val)"
	--_slider.Event #CHANGED     "format \"val: %\n\" val"
	--_slider.Event #BUTTONDOWN	"flagForeground SLICER_SYSTEM.obj true"
	--_slider.Event #BUTTONUP	"flagForeground SLICER_SYSTEM.obj false"
	--
	--_spinner.Event #CHANGED "::SlicerCallbacks_v.onSpinnerChanged(val)"
	--
	--btn_plus_minus.Event #PRESSED    "::SlicerCallbacks_v.onPlusMinusButton( 1 )"
	--btn_plus_minus.Event #RIGHTCLICK "::SlicerCallbacks_v.onPlusMinusButton( -1 )"

	--_dropdown.Event #CHANGED "SLICER_SYSTEM.changeSliderSnamps"

	/*------------------------------------------------------------------------------
		CREATE DIALOG
	--------------------------------------------------------------------------------*/
	--Dialog.create width:min_size.x height:#VIEWPORT --style:#()  --lockWidth:false --bgcolor:( color 60 130 140 )
	--Dialog.create width:(42) height:#VIEWPORT lockWidth:false --style:#()   --bgcolor:( color 60 130 140 )
	--Dialog.create height:#VIEWPORT --style:#()  --lockWidth:false --bgcolor:( color 60 130 140 )
	--Dialog.create()
	Dialog.create width:420 height:640

	--Dialog.dock #RIGHT



)