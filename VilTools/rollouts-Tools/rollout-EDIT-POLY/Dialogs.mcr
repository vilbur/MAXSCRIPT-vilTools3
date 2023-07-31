
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


/** Open Smooth group dialog on mouse position
 *
 */
macroscript	epoly_open_smoothgroups_dialog
category:	"_Epoly-Dialogs"
buttontext:	"Smooth Grops"
toolTip:	"Open Smooth group dialog"
icon:	"menu:true"
(
	on isEnabled return Filters.Is_EPolySpecifyLevel #{4..5}
	on isVisible return Filters.Is_EPolySpecifyLevel #{4..5}

	on execute do (
		try (
			max modify mode
			local _Mod = Filters.GetModOrObj()

			if (Filters.Is_EPoly()) then
				showRibbonPopUpDialog "SmoothingGroupsDialog"
		)
		catch ()
	)
)

/** Open material ID dialog on mouse position
 *
 */
macroscript	epoly_open_mat_id_dialog
category:	"_Epoly-Dialogs"
buttontext:	"Material IDs"
toolTip:	"Open material ID dialog"
icon:	"menu:true"
(
	on isEnabled return Filters.Is_EPolySpecifyLevel #{4..5}
	on isVisible return Filters.Is_EPolySpecifyLevel #{4..5}

	on execute do (
		try (
			max modify mode
			local _Mod = Filters.GetModOrObj()

			if (Filters.Is_EPoly()) then
				showRibbonPopUpDialog "MaterialIDDialog"
		)
		catch ()
	)
)
