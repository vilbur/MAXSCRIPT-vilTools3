

if LAST_HIDDEN_NODES == undefined then
	global LAST_HIDDEN_NODES = #()


/*
*/
macroscript	visibility_hide_unhide_selected
category:	"_Visibility-Hide"
buttonText:	"Hide Selected"
-- tooltip:	"Hide \ Unhide selected objects. \n\nSelected object is not hidden if SubObject is active. \n\nIf "
tooltip:	"Hide Selected Toggle"
icon:	"MENU:true|tooltip:Hide selected objects. \nUnhide last hidden objects. \n\nSelected object is not hidden if SubObject is active. Hidden objects stay hidden"
autoUndoEnabled: true
(
	on execute do undo "Hide Toggle" on
	(
		 --clearListener(); print("Cleared in:"+getSourceFileName())
		 --filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VISIBILITY\OBJECTS HIDE UNHIDE.mcr"
		/* CLEAN UP */
		for obj in LAST_HIDDEN_NODES where not isValidNode obj do
			deleteItem LAST_HIDDEN_NODES (findItem LAST_HIDDEN_NODES obj)

		_selection = for obj in selection  where obj.isHidden == false collect obj

		last_nodes_hidden	= for obj in LAST_HIDDEN_NODES where isValidNode obj and obj.isHidden == true  collect obj
		last_nodes_unhidden	= for obj in LAST_HIDDEN_NODES where isValidNode obj and obj.isHidden == false collect obj

		new_nodes_added = false

		/* HIDE NEW OBJECTS */
		if _selection.count > 0 then
		(

			curr_mod	= modPanel.getCurrentObject()
			baseobject_is_active	= curr_mod != undefined and superClassOf curr_mod != modifier and _selection[1].modifiers.count > 1
			modifier_is_active	= curr_mod != undefined and superClassOf curr_mod == modifier and modPanel.getModifierIndex _selection[1] curr_mod > 1
			subobject_active	= subObjectLevel != undefined and subObjectLevel > 0
			obj_is_edited	= baseobject_is_active or modifier_is_active or subobject_active

			--format "curr_mod:	% \n" curr_mod
			--format "classOf curr_mod:	% \n" (superClassOf curr_mod)
			--format "subobject_active:	% \n" subobject_active
			--format "modifier_is_active:	% \n" modifier_is_active
			--format "baseobject_is_active:	% \n" baseobject_is_active
			--format "obj_is_edited:	% \n" obj_is_edited

			/* OBJECT IS EDITED IF:
				1)  baseobject without modifiers is selected (clean object without modiers)
				2)	Any modifer then first is selected
				3)	SubObject is eneter
			*/

			if not obj_is_edited then
			(

				--print "HIDE NE NODES"
				LAST_HIDDEN_NODES = join LAST_HIDDEN_NODES ( _selection as Array )

				for obj in _selection do
				(
					deselect obj

					obj.isHidden = true
				)

				/* remove unhide nodes from last */
				for obj in last_nodes_unhidden where (index = findItem LAST_HIDDEN_NODES obj ) > 0 do
					deleteItem LAST_HIDDEN_NODES index

				new_nodes_added = true
			)
		)

		/* HIDE\UNHIDE LAST OBJECTS */
		if not new_nodes_added then
			--for obj in LAST_HIDDEN_NODES do obj.isHidden = last_nodes_unhidden.count == LAST_HIDDEN_NODES.count
			for obj in LAST_HIDDEN_NODES where findItem _selection obj == 0 do obj.isHidden = last_nodes_unhidden.count == LAST_HIDDEN_NODES.count -- do not hide selected object although is in LAST_HIDDEN_NODES

		redrawViews()
	)
)

/*
*/
macroscript	visibility_unhide_selected
category:	"_Visibility-Unhide"
buttonText:	"Unhide Selected"
tooltip:	"Unhide selected objects. \n\nUnhide last hidden objects if nothing selected"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
	undo "Unhide Selected" on
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-VISIBILITY\OBJECTS VISIBILITY.mcr"
		--format "LAST_HIDDEN_NODES:	% \n" LAST_HIDDEN_NODES

		if selection.count > 0 then
		(
			for obj in selection do obj.isHidden = false

		)
	)

)