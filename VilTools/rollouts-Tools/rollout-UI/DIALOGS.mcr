
/**
 */
macroscript	_miscellaneous_listener_toggle
category:	"ui-dIALOGS"
buttontext:	"MAXScript Listener"
tooltip:	"MAXScript Listener and Editor Toggle"
(

	listener_hwnd	= (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "MAXScript Listener"	collect hwnd)[1]

	format "Miscellaneous.mcr.listener_hwnd	= % \n" listener_hwnd
	ms_editor_hwnd = (for hwnd in  ( windows.getChildrenHWND (windows.GetDesktopHwnd())  ) where matchPattern ( UIAccessor.GetWindowText hwnd[1]) pattern:"* - MAXScript" and hwnd[6] == (windows.getMAXHWND()) collect hwnd)[1]

	if listener_hwnd != undefined then
	(
		/* close windows */
		actionMan.executeAction 0 "40472"  -- MAX Script: MAXScript Listener
		UIAccessor.CloseDialog ms_editor_hwnd[1]

	)
	else
	(
		/* open windows */
		actionMan.executeAction 0 "40472"  -- MAX Script: MAXScript Listener
		actionMan.executeAction 0 "40839"  -- MAX Script: MAXScript Editor
	)
)


