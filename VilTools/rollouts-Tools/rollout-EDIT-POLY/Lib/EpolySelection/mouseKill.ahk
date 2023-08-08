#SingleInstance force
;#NoTrayIcon


CloseScript(scriptName, kill := false)  {
   static WM_COMMAND := 0x111, ID_FILE_TERMINATESCRIPT := 65405

   dhw_prev := A_DetectHiddenWindows
   tmm_prev := A_TitleMatchMode

   DetectHiddenWindows, On
   SetTitleMatchMode, 2
   WinExist(scriptName)

}

CloseScript("selectLoopOrRingOnMouseWheel.ahk")
