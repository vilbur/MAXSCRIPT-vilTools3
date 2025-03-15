clearListener()

counter = 1
global LMB_LAST_STATE = false

/** Timer callback
 */
function grabFrameCallback TimerObject evt =
(
	--format "\n"; print "grabFrameCallback()"
	--format "grabFrameCallback	= % \n" counter
	lmb_state = mouse.buttonStates[1]
	
	--first_frame = GifRecorder.frames.count == 0
	
	--format "\n"
	--format "lmb_state: %\n" lmb_state
	--format "LMB_LAST_STATE: %\n" LMB_LAST_STATE
	--format "TEST: %\n" (LMB_LAST_STATE and not lmb_state)
	
	if LMB_LAST_STATE and not lmb_state then
		GifRecorder.grabGifFrame()
	
	
	LMB_LAST_STATE = lmb_state
	
	counter += 1
	
	
	if not GifRecorder.recording then
	(
		TimerObject.stop()
		
		GifRecorder.stopRecording()
		
		LMB_LAST_STATE = false
	)
)


/** Grab frame timer start
 */
function grabFrameTimerStart state =
(
	--format "\n"; print ".grabFrameTimerStart()"
	
	if state then
	(
		TimerObject	= dotNetObject "System.Windows.Forms.Timer"
		
		dotNet.addEventHandler TimerObject "tick" grabFrameCallback
		
		TimerObject.interval = 10
		
		TimerObject.start()
		
	)

)
