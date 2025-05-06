#SingleInstance force
;#NotrayIcon

/* CHANGE VALUE OF 'Perspective View Grid Extent'
   
	EDIT SPINNER INTHIS TAB: https://help.autodesk.com/cloudhelp/2024/ENU/3DSMax-Basics/images/GUID-284B9A3B-5305-4958-8D5A-ACD0C0627AC6.png
	
	Grid and Snap Settings: https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-55F70CB0-0590-4F1E-9879-EF070AF11CE6

	@parameter integer $grid_size
*/ 

$grid_size	= %1%
;$grid_size	= 888
;$grid_size	= 333

SetTitleMatchMode, 2 ; Partial title matching for 3ds Max window
DetectHiddenText off

$grid_size_spinner_pattern := ".*Perspective View Grid Extent.*"

$hwnd_max := WinExist("ahk_class Qt5151QWindowIcon" )

$wait := 100
;$wait := 200


/* GET 3DS MAX WINDOW
*/ 
if $hwnd_max != ""
{
	WinGet, $pid_max, PID, ahk_id %$hwnd_max%
	
	$settings_title := "Grid and Snap Settings ahk_pid " $pid_max
	
	$hwnd_grid := WinExist( $settings_title )

		
	/* OPEN GRID SETTINGS WINDOW
		
		'Grid and Snap Settings' via MENU: Max > Tools > Grids and Snaps > Grid and Snap Settings
	*/ 
	if not $hwnd_grid
	{
		BlockInput, on	
	
	    WinActivate, ahk_id %$hwnd_max%
	    Sleep, %$wait%
	    
	    Send, !t ; OPEN MENU 'Tools'
	    Sleep, %$wait%
	
	    Send, {up 4} ; Go to menu item
	    Sleep, %$wait%
	    Send, {right} ; Open submenu
		
	    Sleep, %$wait%
	    Send, {Enter} ; Open "Grid and Snap Settings" window

		BlockInput, off
	}
	
	/** ACTIVATE "Grid and Snap Settings" window
	  */
	WinWaitActive, %$settings_title%,, 3
	
	if not ErrorLevel
		$hwnd_grid := WinExist( $settings_title )

	;msgBox %$hwnd_grid%

	/* GO TO 3rd TAB, find this tab by matching label of spinner
	*/
	Loop
	{
		WinGetText, $win_text, ahk_id %$hwnd_grid%
		
		if (RegExMatch($win_text, $grid_size_spinner_pattern))
			break
	
		Send, ^{Tab} ; Ctrl+Tab usually cycles tabs; you may use {Right} if needed
	
	    Sleep, %$wait%
	}
	
	/* SET VALUE TO SPINNER
	*/ 
	ControlSetText , Edit3, %$grid_size%,  ahk_id %$hwnd_grid%
	
	ControlSend , Edit3, {Enter} ,  ahk_id %$hwnd_grid%
	
	WinClose, Grid and Snap Settings

	BlockInput, off
}

exitApp