global DIALOG_GifRecorder
global GifRecorder

filein( getFilenamePath(getSourceFileName()) + "/Lib/GifRecorder/createGifRecorderDialog.ms" )	--"./Lib/GifRecorder/createGifRecorderDialog.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/GifRecorder/GifRecorder.ms" )	--"./Lib/GifRecorder/GifRecorder.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/GifRecorder/grabFrameTimer.ms" )	--"./Lib/GifRecorder/grabFrameTimer.ms"

/** https://imagemagick.org/script/download.php
   
	Step-by-Step Guide for Windows 11:
  1. Install ImageMagick on Windows 11
  Download ImageMagick:
  
  Visit the ImageMagick download page.
  Download the Windows binary (look for the "Win64 dynamic at 16 bits-per-pixel" version, depending on your system architecture).
  Install ImageMagick by following the installer instructions.
  Add ImageMagick to PATH (during installation):
  
  During the installation, make sure to check the box that says "Add to PATH" so that you can run the magick command from any directory in the command line.
  2. Prepare Your JPG Images
  Ensure all your JPG images are located in the same directory and are named in a sequential order (e.g., image1.jpg, image2.jpg, etc.). If the images are not in sequential order, you may need to rename them.
  
  3. Open Command Prompt
  Press Win + R to open the Run dialog.
  Type cmd and press Enter to open the Command Prompt.
  4. Navigate to the Directory with Your Images
  Use the cd command to navigate to the folder containing your JPG files. For example:
  
  
  
  cd C:\path\to\your\images
  5. Convert JPG Images to an Animated GIF
  Once you're in the correct directory, you can run the following command to create an animated GIF:
  
  
  
  magick convert -delay 20 -loop 0 *.jpg animated.gif
  -delay 20 sets the delay between frames (in hundredths of a second). You can adjust the number to speed up or slow down the animation.
  -loop 0 sets the GIF to loop infinitely. If you don't want an infinite loop, change 0 to the desired number of loops.
  *.jpg tells ImageMagick to include all .jpg files in the current directory.
  animated.gif is the name of the output GIF file.
  Example Command:
  If you have images named image1.jpg, image2.jpg, etc., the command would look like this:
  
  
  
  magick convert -delay 100 -loop 0 image*.jpg animated.gif
  Note: The image*.jpg pattern will match all .jpg files that start with image. If your files have different names, you can modify the pattern accordingly.
  6. Adjusting the Frame Delay
  If you want the animation to play faster or slower, you can adjust the -delay option.
  For example, -delay 10 would make the animation faster (10/100ths of a second between frames).
  -delay 100 would make it slower (100/100ths of a second). 
 */


/*
 *	
 */
macroscript	viewport_open_gifrecorder_dialog
category:	"_Viewports"
buttontext:	"GIF RECORDER"
toolTip:	"Open GifRecorder"
icon:	"across:2|height:32|menu:TRUE"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\90-SCREENSHOT.mcr"
		
		GifRecorder = GifRecorder_v()
		
		createGifRecorderDialog()
	)
)

/*   
 *	
 */
macroscript	_viewport_screenshot_open_dir
category:	"_Viewports"
buttontext:	"Screenshot"
toolTip:	"Screenshot of current viewport"
--icon:	"across:3"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\SCREENSHOT.mcr"
		--screenshot_dir = substituteString maxFilePath "\\" "\\\\" + "SCREENSHOTS"
		
		--ShellLaunch  screenshot_dir ""
	
	   --ShellLaunch "explorer.exe" "/e,/select,\"c:\\windows\\notepad.exe\""
	
		--ShellLaunch @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\temp\\SCREENSHOTS"
	)
)

--/*
-- *	
-- */
--macroscript	_viewport_screenshot_filename
--category:	"_Viewports"
--buttontext:	"[Screenshot filename]"
--toolTip:	""
--icon:	"across:3|control:edittext|offset:[ -8, 2]|width:164|tooltip:Filename of screenshot"
--(
--	on execute do
--	format "EventFired: %\n" EventFired
--
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\SCREENSHOT.mcr"
--	--(ViewportSwitcher_v()).toggle(#view_persp_user)
--	--img = gw.getViewportDib() --this grabs the viewport
--	--img.filename = "whatever" + ".jpg" --this will be the filename
--	--save img --grabs and saves the viewport, you could change up where it saves too
--	
--	--display img
--	
--	--magick convert -delay 20 -loop 0 *.jpg animated.gif
--
--	
--)
--
--
--/*
-- *	
-- */
--macroscript	_viewport_screenshot_format
--category:	"_Viewports"
--buttontext:	"[Screenshot format]"
--toolTip:	"Screenshot of current viewport"
--icon:	"across:3|control:radiobuttons|unselect:false|items:#( 'jpg', 'gif' )|offset:[ 32, 2 ]"
--(
--	
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\SCREENSHOT.mcr"
--	format "EventFired: %\n" EventFired
--	--(ViewportSwitcher_v()).toggle(#view_persp_user)
--	--img = gw.getViewportDib() --this grabs the viewport
--	--img.filename = "whatever" + ".jpg" --this will be the filename
--	--save img --grabs and saves the viewport, you could change up where it saves too
--	
--	--display img
--	
--	--magick convert -delay 20 -loop 0 *.jpg animated.gif
--
--	
--)

--/** 
-- */
--macroscript _viewport_screenshot_preview
--category:	"_Viewports"
--buttonText:	"preview"
--icon:	"control:imgTag|color:gray|across:1|width:420|height:420|align:#CENTER|offset:[ 0, 16 ]"
--(
--		format "EventFired: %\n" EventFired
--
--)
