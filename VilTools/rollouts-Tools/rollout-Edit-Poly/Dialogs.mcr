
/** Show ribbon pop up dialog
 */
function showRibbonPopUpDialog dialog =
(
	dialog_list_before = for i in (UIAccessor.GetPopupDialogs()) where not i == 0 collect i

	macros.run "Ribbon - Modeling" dialog

	dialog_list_after = for i in (UIAccessor.GetPopupDialogs()) where not i == 0 collect i
	
	max_hwnd = UIAccessor.GetParentWindow dialog_list_before[1] 

	ribbon_dialogs = for hwnd in dialog_list_after where findItem dialog_list_before hwnd == 0 collect hwnd
	
	if( ribbon_dialogs.count > 0 ) then
		ShellLaunch( getFilenamePath(getSourceFileName()) + "/Lib/Ahk/setDialogToCursor.ahk" ) ( (max_hwnd as string )+" "+ (ribbon_dialogs[1] as string)  )
)

/** Open material ID dialog on mouse position 
 *	
 */
macroscript	dialogs_open_face_id_dialogs
category:	"_Epoly"  
buttontext:	"Mat IDs"
toolTip:	"Open material ID dialog"
--icon:	"#(path, index)"
(
	showRibbonPopUpDialog "MaterialIDDialog"
)


/** Open Smooth group dialog on mouse position 
 *	
 */
macroscript	dialogs_open_smoothgroups_dialogs
category:	"_Epoly"  
buttontext:	"Smooth"
toolTip:	"Open Smooth group dialog"
--icon:	"#(path, index)"
(
	showRibbonPopUpDialog "SmoothingGroupsDialog"
)