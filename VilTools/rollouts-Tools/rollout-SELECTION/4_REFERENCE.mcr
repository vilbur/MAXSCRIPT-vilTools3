

/*------------------------------------------------------------------------------
	SELECT REFERENCE
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	selection_select_references
category:	"_Selection"
buttontext:	"Select References"
toolTip:	"Select References"
icon:	"across:2"
(
	max create mode

	for obj in selection do
		selectmore ((Selection_v()).getInstances( obj ) type:#REFERENCE)
)

/*------------------------------------------------------------------------------

	RE REFERENCE OBEJCTS

--------------------------------------------------------------------------------*/

/** MACROS BELOOW SHOULD BE IN OWN STRUCT
  */
macroscript	selection_make_references
category:	"_Selection"
buttontext:	"Re-Reference"
toolTip:	"Each object will be THE SAME reference."
icon:	"tooltip:Make references of selection.\nLast object in selection is master object.\n"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\4_REFERENCE.mcr"

		if selection.count >= 2 then
		(
			if queryBox "Replace References ?" title:"Replace References"  then
				--undo "Replace Reference" on
				(
					max create mode

					master_object	= selection[selection.count]

					for_replace = deleteItem ( selection as Array ) selection.count

					for obj in for_replace do
						maxOps.CollapseNodeTo obj 1 off


					for obj in for_replace do
						referenceReplace obj master_object

					messageBox "References Replaced" title:"SUCCESS"

				)

		)
		else
			messageBox "Select at least 2 objects for referencing" title:"Reinstancer"

	)
)

--/**
--  *
--  */
--macroscript	selection_make_references_each_copy
--category:	"_Selection"
--buttontext:	"Re-reference"
--toolTip:	"Each object will be INDEPENDTENT reference."
----icon:	"#(path, index)"
--(
--	max create mode
--
--	if selection.count >= 2 then
--	(
--		--undo "Re-reference Objects" on
--		--(
--			master_object	= selection[selection.count]
--
--			for_replace = deleteItem ( selection as Array ) selection.count
--
--
--			for obj in for_replace do
--			(
--				select #( obj, master_object)
--
--				macros.run "_Selection" "selection_make_references"
--			)
--
--
--		--)
--
--	)
--	else
--		messageBox "Select at least 2 objects for referencing" title:"Reinstancer"
--)
