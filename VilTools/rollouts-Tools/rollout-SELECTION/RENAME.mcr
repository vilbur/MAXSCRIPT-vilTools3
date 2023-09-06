
filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )	-- "./Lib/ObjectRenamer/ObjectRenamer.ms"


global ROLLOUT_selection


/**  LAYER NAME INCLUDE
  */
macroscript selection_name_include_layer_name
category:	"_Object-Name"
buttonText:	"          Layer Name"
tooltip:	"Layer Name as suffix or prefix"
icon:	"control:radiobuttons|items:#('Prefix','Suffix')||across:3|offset:[ -16, 0]"
(
	format "EventFired:	% \n" EventFired
)

/**  LAYER NAME INCLUDE
  */
macroscript selection_name_include_parent_name
category:	"_Object-Name"
buttonText:	"          Parent Name"
tooltip:	"Parent Name as suffix or prefix"
icon:	"control:radiobuttons|items:#('Prefix','Suffix')|across:3"
(
	format "EventFired:	% \n" EventFired
)

/**  OBJECT TYPE INCLUDE INCLUDE
  */
macroscript selection_name_include_object_type
category:	"_Object-Name"
buttonText:	"          Object Type "
tooltip:	"Object Type as suffix or prefix"
icon:	"control:radiobuttons|items:#('Prefix','Suffix')|across:3|offset:[ 14, 0]"
(
	format "EventFired:	% \n" EventFired
)

/**  EDIT BASENAME
  */
macroscript selection_object_name
category:	"_Object-Name"
buttonText:	"Base Name"
tooltip:	"RegEx of suffix to remove"
icon:	"control:editText|across:2|width:256|align:#left|offset:[ 0, 16]"
(
	format "EventFired:	% \n" EventFired

	if EventFired.val == " " and selection.count > 0 then
		ROLLOUT_selection.ET_base_name.text = selection[1].name


)
/**  EDIT BASENAME
  */
macroscript selection_object_name_counter
category:	"_Object-Name"
buttonText:	"Counter"
tooltip:	"RegEx of suffix to remove"
icon:	"control:editText|id:#ET_object_counter|across:2|width:96|align:#right|offset:[ 4, 16]"
(
	format "EventFired:	% \n" EventFired


)




/**  SUFFIX TEXT
  *
  */
macroscript selection_object_rename
category:	"_Object-Name"
buttonText:	"Rename"
tooltip:	"Rename selected objects"
icon:	"across:2|offset:[ 0, 8 ]|height:32"
(
	clearListener(); print("Cleared in:"+getSourceFileName())
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Lib\ObjectRenamer\ObjectRenamer.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\RENAME.mcr"

	ObjectRenamer = ObjectRenamer_v()

	prefix_suffix_values = #( undefined, #PREFIX, #SUFFIX )

	by_type	= prefix_suffix_values[ROLLOUT_selection.RB_object_type.state + 1 ]
	by_layer	= prefix_suffix_values[ROLLOUT_selection.RB_layer_name.state  + 1 ]
	by_parent	= prefix_suffix_values[ROLLOUT_selection.RB_parent_name.state + 1 ]

	prefixes_suffixes = Dictionary #( #layer, by_layer ) #( #parent, by_parent ) #( #type, by_type ) -- #( #NameIncludes_v.prop, undefined|#PREFIX|#SUFFIX )

	for data in prefixes_suffixes where data.value != undefined do
	(
		prop_prefixes_suffixes = getProperty ObjectRenamer data.value -- get E.G.: ObjectRenamer.prefix

		setProperty prop_prefixes_suffixes data.key true  -- sget E.G.: ObjectRenamer.prefix = true
	)

	base_name = ROLLOUT_selection.ET_base_name.text

	ObjectRenamer.base_name = 	if base_name == " " then selection[1].name else base_name

	ObjectRenamer.rename( selection )
)


/**
  *
  */
macroscript selection_remove_rename
category:	"_Object-Name"
buttonText:	"Remove suffix"
tooltip:	"Remove suffix from object name"
icon:	"across:2|offset:[ 0, 8 ]|height:32"
(
	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV

	undo "Remove suffix" on
	(
		suffix_text = ROLLOUT_selection.ET_object_name.text

		for obj in selection do
			obj.name = (RegExer_v( obj.name )).removeSuffix()
	)
)



