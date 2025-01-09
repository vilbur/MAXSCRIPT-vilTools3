
/*------------------------------------------------------------------------------

	REPLACE BASEOBJECTS REFERENCE OBEJCTS

--------------------------------------------------------------------------------*/

/** MACROS BELOOW SHOULD BE IN OWN STRUCT
  */
macroscript	selection_replace_baseobjects
category:	"_Selection-Copy"
buttontext:	"Replace Baseobjects"
--toolTip:	"Replace baseobjects"
icon:	"MENU:true|across:2|tooltip:Replace baseobjects of selection.\nLast object in selection is master object.\n"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\5_COPY nad REPLACE.mcr"

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



/**
  */
macroscript	selection_copy_as_children
category:	"_Selection-Copy"
buttontext:	"Copy As Child"
toolTip:	"Copy As Child"
icon:	"MENU:true|tooltip:Copy selected objects.\n\nEACH NEW COPY WILL BE CHILD OF ORIGINAL"
(

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\5_COPY nad REPLACE.mcr"

		if ( nodes_orig = for o in selection collect o ).count > 0 then
		(
			nodes_copy = #()

			maxOps.cloneNodes nodes_orig cloneType:#copy newNodes:&nodes_copy

			for i = 1 to nodes_copy.count do
				nodes_copy[i].parent = nodes_orig[i]

			select nodes_copy

			format "\nSUCCESS: SELCTION COPY AS CHILDREN"

		)
	)
)