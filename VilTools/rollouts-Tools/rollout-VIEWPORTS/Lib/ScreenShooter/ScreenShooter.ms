/** Screen shooter
 */
struct ScreenShooter_v
(
	/* construct */
	

	/* required */
	

	/* properties */
	frames = #(),
	

	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Get screenshot of current viewport
	 */
	function getScreenshotOfCurrentViewport =
	(
		--format "\n"; print "ScreenShooter_v.getScreenshotOfCurrentViewport()"
		

		--
		--filename = if filename_is_empty = (( dotNetClass "System.Text.RegularExpressions.RegEx").match filename_user "^\s+$|^$" ).success then
		--				getFilenameFile( maxFileName )
		--			else
		--				filename_user
		--
		--img_format = #( "jpg", "gif" )[ROLLOUT_viewports.RB_screenshot_format.state]
		--	
		--if img_format == "gif" then
		--	screenshot_dir += "\\" + filename
		--
		--
		--makeDir screenshot_dir all:true
		--
		screenshot = gw.getViewportDib() --this grabs the viewport
		--
		----ROLLOUT_viewports.IT_preview.bitmap = screenshot
		--
		--screenshot.filename = screenshot_dir +"\\"+ filename + "-" + ".jpg" --this will be the filename
		--
		--save screenshot
		
		--display screenshot
			
		append frames screenshot
		
		DIALOG_screenshooter.IT_preview.bitmap = screenshot

		DIALOG_screenshooter.SLIDER_frames.value = frames.count

	),
	
	/** Show frame menu
	 */
	function showFrameMenu =
	(
		format "\n"; print "ScreenShooter_v.showFrameMenu()"
		Menu = RcMenu_v name:"FrameMenu"
		
		Menu.item	"Remove Frame"	"ScreenShooter.removeFrame quiet:false"
		
		popUpMenu (Menu.create())
		
	),

	/** Remove frame
	 */
	function removeFrame quiet:true =
	(
		format "\n"; print "ScreenShooter_v.removeFrame()"
		frame = DIALOG_screenshooter.SLIDER_frames.value
		
		if quiet or queryBox ("Remove frame: "+frame+" ?") title:"Remove Frame" then
		(
			this.showFrame (frame + 1)
			
			deleteItem frames frame
			
		)
		
		
	),
	
	/** Show frame
	 */
	function showFrame frame =
	(
		format "\n"; print "ScreenShooter_v.showFrame()"
		DIALOG_screenshooter.IT_preview.bitmap = if (next_frame = frames[frame]) != undefined then next_frame else undefined
	),
	
	private


	/**
	 */
	on create do
	(
		--format "\n"; print "ScreenShooter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
