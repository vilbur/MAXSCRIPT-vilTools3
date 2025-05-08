#SingleInstance force
;#NotrayIcon

/* CHANGE VALUE OF 'Perspective View Grid Extent'
   
	EDIT SPINNER INTHIS TAB: https://help.autodesk.com/cloudhelp/2024/ENU/3DSMax-Basics/images/GUID-284B9A3B-5305-4958-8D5A-ACD0C0627AC6.png
	
	Grid and Snap Settings: https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-55F70CB0-0590-4F1E-9879-EF070AF11CE6

	@parameter integer $grid_size
*/ 

$grid_size	= %1%

$hwnd_max := WinExist("ahk_class Qt5151QWindowIcon" )

$grid_size_spinner_pattern := ".*Perspective View Grid Extent.*"

$wait := 100
$wait_long := 300

Sleep, %$wait_long%

SetTitleMatchMode, 2 ; Partial title matching for 3ds Max window
DetectHiddenText off


if $hwnd_max != ""
{
	WinGet, $pid_max,  PID, ahk_id %$hwnd_max%

	$settings_title := "Grid and Snap Settings ahk_pid " $pid_max

	$hwnd_grid := WinExist( $settings_title )

	
	/** ACTIVATE "Grid and Snap Settings" window
	  */
	WinActivate, ahk_id %$hwnd_grid%

	Sleep, %$wait%

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

}

exitApp