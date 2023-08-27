
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


/**
 *
 */
macroscript	edit_poly_insert_vertex
category:	"_Epoly-Edit"
buttonText:	"Insert vertex"
tooltip:	"Insert vertex to selected edges\n\nPress Ctrl|Alt|Shift to add more vertices.\n\nEach pressed mod key adds 1 more vertex (E.G.: Ctrl+Alt+Shift = 4 vertices)"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject #( 1, 2 )

	on execute do
	(
		--filein( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/EpolySelection.ms" )	-- "./Lib/EpolySelection/EpolySelection.ms"

		modkeys_pressed = for mod_key in #(keyboard.controlPressed, keyboard.altPressed, keyboard.shiftPressed) where mod_key == true collect mod_key
		
		PolyToolsModeling.InsertVertex (1 + modkeys_pressed.count)
	)
)


/**
 *
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Edit"
buttonText:	"Connect To Last vertex"
toolTip:	"Connect To Last vertex"
icon:	"MENU:true"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauu_connecttolastselvert.mcr" )
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	on IsVisible return Filters.Is_EPolySpecifyLevel #{2}

	on execute do
		macros.run "miauu" "miauu_ConnectToLastSelVertAlt"
)


/**
 *
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Edit"
buttontext:	"Merge Faces"
toolTip:	"Merge Faces"
icon:	"MENU:true"
(
	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/merge_faces_v10.ms" )

	macros.run "miauu" "Merge_Faces_v10"
)





--/** Open Smooth group dialog on mouse position
-- *
-- */
--macroscript	epoly_repeat_last
--category:	"_Epoly-Edit"
--buttontext:	"Repeat"
--toolTip:	"Repeat Last Action"
--icon:	"MENU:true"
--(
--	macros.run "Ribbon - Modeling" "RepeatLast"
--)

/** Open Smooth group dialog on mouse position
 *
 */
macroscript	epoly_open_smoothgroups_dialog
category:	"_Epoly-Edit"
buttontext:	"Smooth Groups"
toolTip:	"Open smooth group dialog"
icon:	"MENU:true"
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
category:	"_Epoly-Edit"
buttontext:	"Material IDs"
toolTip:	"Open material ID dialog"
icon:	"MENU:true"
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
