#SingleInstance Force
#NoTrayIcon

/** Set weld treshold in modify panel of Edit_Spline modifier 
  *	
  */

$treshold	= %1%

SetTitleMatchMode, 2

ControlSetText, Edit14, %$treshold%, Autodesk 3ds Max
ControlSend, Edit14, {Enter}, Autodesk 3ds Max