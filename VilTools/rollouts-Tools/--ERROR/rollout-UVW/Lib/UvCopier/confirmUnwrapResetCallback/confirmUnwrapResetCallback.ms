/** Press "Yes" button when reset unwrap dialog appears
  *	
  */
function confirmUnwrapResetCallback =
(
	hwnd	= DialogMonitorOPS.GetWindowHandle()
	title	=  (UIAccessor.GetWindowText hwnd)

	if title == "Unwrap UVW" then
		UIAccessor.SendMessageID hwnd #IDYES

	true --return
)