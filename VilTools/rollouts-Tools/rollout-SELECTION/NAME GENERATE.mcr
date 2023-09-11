
filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )	-- "./Lib/ObjectRenamer/ObjectRenamer.ms"


global ROLLOUT_selection

/*------------------------------------------------------------------------------
	RADIOBUTTON
--------------------------------------------------------------------------------*/

/**  LAYER NAME INCLUDE
  */
macroscript selection_name_include_layer_name
category:	"_Object-Name"
buttonText:	"          Layer Name"
tooltip:	"Layer Name as sufix or prefix"
icon:	"control:radiobuttons|items:#('Prefix','Sufix')||across:3|offset:[ -16, 0]"
(
	format "EventFired:	% \n" EventFired
)

/**  LAYER NAME INCLUDE
  */
macroscript selection_name_include_parent_name
category:	"_Object-Name"
buttonText:	"          Parent Name"
tooltip:	"Parent Name as sufix or prefix"
icon:	"control:radiobuttons|items:#('Prefix','Sufix')|across:3"
(
	--format "EventFired:	% \n" EventFired
)

/**  OBJECT TYPE INCLUDE INCLUDE
  */
macroscript selection_name_include_object_type
category:	"_Object-Name"
buttonText:	"          Object Type "
tooltip:	"Object Type as sufix or prefix"
icon:	"control:radiobuttons|items:#('Prefix','Sufix')|across:3|offset:[ 14, 0]"
(
	--format "EventFired:	% \n" EventFired
)

/*------------------------------------------------------------------------------
	EDIT TEXT
--------------------------------------------------------------------------------*/

/**  EDIT BASENAME
  */
macroscript selection_object_name
category:	"_Object-Name"
buttonText:	"[Base Name]"
tooltip:	"base name for rename. \n\nSPACE: Space key pressed in empty field will get name of first object"
icon:	"control:editText|across:2|width:256|align:#left|offset:[ 0, 16]"
--icon:	"control:editText|across:1|offset:[ 0, 8 ]"
(
	--format "EventFired:	% \n" EventFired

	if EventFired.val == " " and selection.count > 0 then
		ROLLOUT_selection.ET_base_name.text = selection[1].name
)

--/**  EDIT BASENAME
--  */
--macroscript selection_object_name_counter
--category:	"_Object-Name"
--buttonText:	"Counter"
--tooltip:	"RegEx of sufix to remove"
--icon:	"control:editText|id:#ET_object_counter|across:2|width:96|align:#right|offset:[ 4, 16]"
--(
--	format "EventFired:	% \n" EventFired
--
--)

/*------------------------------------------------------------------------------
	BUTTONS
--------------------------------------------------------------------------------*/

/**  SUFIX TEXT
  */
macroscript selection_object_rename
category:	"_Object-Name"
buttonText:	"Rename"
tooltip:	"Rename selected objects"
icon:	"across:2|offset:[ 4, 8 ]|height:36|align:#right"
(
	--clearListener(); print("Cleared in:"+getSourceFileName())
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Lib\ObjectRenamer\ObjectRenamer.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\NAME GENERATE.mcr"

	ObjectRenamer = ObjectRenamer_v()

	prefix_sufix_values = #( undefined, #PREFIX, #SUFIX )

	by_type	= prefix_sufix_values[ROLLOUT_selection.RB_object_type.state + 1 ]
	by_layer	= prefix_sufix_values[ROLLOUT_selection.RB_layer_name.state  + 1 ]
	by_parent	= prefix_sufix_values[ROLLOUT_selection.RB_parent_name.state + 1 ]

	prefixes_sufixes = Dictionary #( #layer, by_layer ) #( #parent, by_parent ) #( #type, by_type ) -- #( #NameIncludes_v.prop, undefined|#PREFIX|#SUFIX )

	for data in prefixes_sufixes where data.value != undefined do
	(
		prop_prefixes_sufixes = getProperty ObjectRenamer data.value -- get E.G.: ObjectRenamer.prefix

		setProperty prop_prefixes_sufixes data.key true  -- sget E.G.: ObjectRenamer.prefix = true
	)

	base_name = ROLLOUT_selection.ET_base_name.text

	ObjectRenamer.base_name = 	if base_name == " " then selection[1].name else base_name

	ObjectRenamer.rename( selection )
)
