#NoEnv

#SingleInstance Force


;$parameter	= %1%

;MsgBox,262144,$parameter, %$parameter%,3

;GuiWindowHwnd := WinExist("Pick Object")

GuiWindowHwnd := WinExist( "Pick Object" )


WinWait, ahk_id %GuiWindowHwnd%,, 3

if ! ErrorLevel
{

	WinGet, CtrlList, ControlList, ahk_id %GuiWindowHwnd%

	EditList := ""

	Loop, Parse, CtrlList, `n
	{

	   If InStr( A_LoopField, "EDIT" )  {
		ClassNN := A_LoopField

		ControlFocus, %ClassNN%, ahk_id %GuiWindowHwnd%
		ControlSend, %ClassNN% ,{down}

	   }

	}

	ControlSend,, {Enter}, ahk_id %GuiWindowHwnd%

}



exitApp
