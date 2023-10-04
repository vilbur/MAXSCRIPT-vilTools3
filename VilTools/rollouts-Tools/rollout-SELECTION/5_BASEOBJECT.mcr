

/*------------------------------------------------------------------------------

	REPLACE BASEOBJECTS REFERENCE OBEJCTS

--------------------------------------------------------------------------------*/

/** MACROS BELOOW SHOULD BE IN OWN STRUCT
  */
macroscript	selection_replace_baseobjects
category:	"_Selection"
buttontext:	"Replace Baseobjects"
--toolTip:	"Replace baseobjects"
icon:	"tooltip:Replace baseobjects of selection.\nLast object in selection is master object.\n"
(

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\5_BASEOBJECT.mcr"

		if selection.count >= 2 then
		(
			if queryBox "Replace Baseobjects ?" title:"Replace Baseobjects"  then
				undo "Replace Baseobejcts" on
				(
					--max create mode
					master_object	= selection[selection.count]

					for_replace = deleteItem ( selection as Array ) selection.count

					for obj in for_replace do
						obj.baseobject = master_object.baseobject

					messageBox "Baseobejcts Replaced" title:"SUCCESS"

				)

		)
		else
			messageBox "Select at least 2 objects for referencing" title:"Reinstancer"

	)

)
