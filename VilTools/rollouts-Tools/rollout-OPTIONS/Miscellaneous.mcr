
/**
 */
macroscript	_miscellaneous_listener_toggle
category:	"_miscellaneous"
buttontext:	"MAXScript Wins"
tooltip:	"MAXScript Windows Toggle"
(

	listener_hwnd	= (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "MAXScript Listener"	collect hwnd)[1]
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


/*------------------------------------------------------------------------------
	MEMORY
--------------------------------------------------------------------------------*/
/**
 */
macroscript	_miscellaneous_free_memory
category:	"_miscellaneous"
buttontext:	"Free Memory"
tooltip:	"Remove Undo\n\nClean Texture Memory"
(

	gc()	--Garbage Collection.
	freeSceneBitmaps()	--Cleans up in texture memory.
	clearUndoBuffer()	--Removes your Undo’s

	messageBox "Memory CLeaned" title:"Memory Clean"
)


/*------------------------------------------------------------------------------

	TEST

--------------------------------------------------------------------------------*/



/**
 */
macroscript	_maxscript_test
category:	"_miscellaneous"
buttontext:	"TEST"
icon:	"control:checkbutton"
(

	on execute do
	(

	--	unregisterRedrawViewsCallback showGWtextTest
	--
	--
	--	if EventFired.val then
	--	(
	--		global showGWtextTest_TEXT = "WHOOOOOOOOOOOOOOA"
	--	startTextTimer()
	--
	----format "showGWtextTest_TEXT:	% \n" showGWtextTest_TEXT
	--
	--	registerRedrawViewsCallback showGWtextTest
	--	)
	--
	--	else
	--		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\Miscellaneous.mcr"



	)

)