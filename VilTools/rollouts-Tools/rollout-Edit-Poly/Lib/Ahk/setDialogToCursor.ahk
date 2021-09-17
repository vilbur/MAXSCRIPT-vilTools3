#SingleInstance Force

$max_hwnd	= %1%
$dialo_hwnd	= %2%


;WinSet, Style, -0xC00000	, ahk_id %$dialo_hwnd%	

WinGetPos , X_win, Y_win,,, ahk_id %$dialo_hwnd%	

MouseGetPos, x_1, y_1

WinMove, ahk_id %$dialo_hwnd%	, , X_win+x_1, Y_win + y_1