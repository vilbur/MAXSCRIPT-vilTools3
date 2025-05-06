/* CHANGE VALUE OF 'Perspective View Grid Extent'
   
   E.G.: 'https://help.autodesk.com/cloudhelp/2024/ENU/3DSMax-Basics/images/GUID-284B9A3B-5305-4958-8D5A-ACD0C0627AC6.png'

	@parameter integer $grid_size

*/ 

$grid_size	= %1%
;$grid_size	= 888
;$grid_size	= 333

SetTitleMatchMode, 2 ; Partial title matching for 3ds Max window

$hwnd_max := WinExist("ahk_class Qt5151QWindowIcon" )

/* GET 3DS MAX WINDOW
*/ 
if $hwnd_max != ""
{
	$hwnd_grid := WinExist( "Grid and Snap Settings" )
	
	WinGet, pid_max, PID, ahk_id %$hwnd_max%
	WinGet, pid_grid, PID, ahk_id %$hwnd_grid%
	
	/* OPEN GRID SETTINGS WINDOW
		
		'Grid and Snap Settings' via MENU: Max > Tools > Grids and Snaps > Grid and Snap Settings
	*/ 
	if not $hwnd_grid
	{
	    WinActivate, ahk_id %$hwnd_max%
	    Sleep, 300
	
	    
	    Send, !t ; OPEN MENU 'Tools'
	    Sleep, 500
	
	    Send, {up 4} ; Go to menu item
	    Sleep, 200
	    Send, {right} ; Open submenu
		
	    Sleep, 200
	    Send, {Enter} ; Open "Grid and Snap Settings" window
		
		Sleep, 1000
		
		$hwnd_grid := WinExist( "Grid and Snap Settings" )
	}

	/** ACTIVATE "Grid and Snap Settings" window
	  */
    WinActivate, ahk_id %$hwnd_grid%
	    Sleep, 500

	/* GO TO 3rd TAB, find this tab by matching label of spinner
	*/
	DetectHiddenText, off
	
	regex_pattern := ".*Perspective View Grid Extent.*" 


	Loop
	{
	    ;counter++

		;if counter == 5
			;break
		
		WinGetText, $win_text, ahk_id %$hwnd_grid%
		
		if (RegExMatch($win_text, regex_pattern))
			break

		Send, ^{Tab} ; Ctrl+Tab usually cycles tabs; you may use {Right} if needed

		Sleep, %interval_ms%
	}

	/* SET VALUE TO SPINNER
	*/ 
	Sleep, 1000
	
	ControlSetText , Edit3, %$grid_size%,  ahk_id %$hwnd_grid%

	ControlSend , Edit3, {Enter} ,  ahk_id %$hwnd_grid%

	WinClose, Grid and Snap Settings

}

