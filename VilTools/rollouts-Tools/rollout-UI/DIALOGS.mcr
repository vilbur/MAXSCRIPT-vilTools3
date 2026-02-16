
/**
 */
macroscript	_miscellaneous_listener_toggle
category:	"_UI-Dialogs"
buttontext:	"MAXScript Listener"
tooltip:	"MAXScript Listener and Editor Toggle"
(
	on execute do
	(
		listener_hwnd	= (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "MAXScript Listener"	collect hwnd)[1]
	
		try(
			ms_editor_hwnd = (for hwnd in  ( windows.getChildrenHWND 0 ) where matchPattern ( UIAccessor.GetWindowText hwnd[1] ) pattern:"* - MAXScript" and hwnd[6] == ( windows.getMAXHWND() ) collect hwnd)[1]
		)catch()
			
	
		/* ALWAYS CLOSE EDITOR FIRST */ 
		if ms_editor_hwnd != undefined then 
			UIAccessor.CloseDialog ms_editor_hwnd[1]
	
	
		/* TOGGLE LISTENER */ 
		actionMan.executeAction 0 "40472"  -- MAX Script: MAXScript Listener
		
	
		/* OPEN IF LISTENER IS CLOSED */ 
		if listener_hwnd == undefined then
			actionMan.executeAction 0 "40839"  -- MAX Script: MAXScript Editor
		
	)

)


