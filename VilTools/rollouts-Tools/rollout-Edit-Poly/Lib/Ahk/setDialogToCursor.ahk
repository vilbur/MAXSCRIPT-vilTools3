#SingleInstance Force



$max_hwnd	= %1%
$dialo_hwnd	= %2%

;$max_hwnd	= TEST

WinSet, Style, -0xC00000	, ahk_id %$dialo_hwnd%	

MouseGetPos, x_1, y_1

WinMove, ahk_id %$dialo_hwnd%	, , x_1, y_1 +32