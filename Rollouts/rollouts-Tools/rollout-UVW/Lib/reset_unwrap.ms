

clearListener()

fn resetUnwrapButton =
(
	WindowHandle = DialogMonitorOPS.GetWindowHandle()
	WindowTitle =  (UIAccessor.GetWindowText WindowHandle)

		if WindowTitle == "Unwrap UVW" then
		(

			UIAccessor.SendMessageID WindowHandle #IDYES

		)

		true --return

)

_Unwrap_UVW = modpanel.getcurrentobject()

DialogMonitorOPS.enabled = true
DialogMonitorOPS.RegisterNotification resetUnwrapButton id:#resetUnwrapButton

_Unwrap_UVW.unwrap.reset()

DialogMonitorOPS.unRegisterNotification id:#resetUnwrapButton 
DialogMonitorOPS.enabled = false
