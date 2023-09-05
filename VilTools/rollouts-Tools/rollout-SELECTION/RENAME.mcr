

/**  SUFFIX TEXT
  *
  */
macroscript selection_object_name
category:	"_Object-Name"
buttonText:	"[remove suffix text]"
tooltip:	"RegEx of suffix to remove"
icon:	"control:editText|across:1"--|width:256"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(
	format "EventFired	= % \n" EventFired

)



/**  SUFFIX TEXT
  *
  */
macroscript selection_object_rename
category:	"_Object-Name"
buttonText:	"Rename"
tooltip:	"RegEx of suffix to remove"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(

	
--	ObjectRenamer = ObjectRenamer_v()
--
--	_selection = selection
--
--	ObjectRenamer.rename _selection
--
--	select _selection

)

--
--/**
--  *
--  */
--macroscript selection_remove_rename
--category:	"_Object-Name"
--buttonText:	"Remove suffix"
--tooltip:	"Remove suffix from object name"
--icon:	"across:2|align:#right"
----icon:	"control:checkbox|Groupbox:Prefix|across:1"
--(
--	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV
--
--	undo "Remove suffix" on
--	(
--		suffix_text = ROLLOUT_selection.ET_object_name.text
--
--		for obj in selection do
--			obj.name = (RegExer_v( obj.name )).removeSuffix()
--	)
--)
--
--
--


