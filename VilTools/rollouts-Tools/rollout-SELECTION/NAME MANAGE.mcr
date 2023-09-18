filein( getFilenamePath(getSourceFileName()) + "/Lib/showObjectNames.ms" )	-- "./Lib/showObjectNames.ms"


/** RENAME BY LAST
  */
macroscript selection_reneme_by_last
category:	"_Object-Name"
buttonText:	"Rename by last"
tooltip:	"Rename by last selected object"
icon:	"MENU:true"
(

	on execute do
		undo "Remove sufix" on
			for obj in selection do
				obj.name = selection[selection.count].name
)

/** CONVERT CASE
  */
macroscript selection_name_convert_case_sence
category:	"_Object-Name"
buttonText:	"Convert Case"
tooltip:	"Convert case of selected object names\n\nCapital Case >>> UPPER CASE >>> lower case"
icon:	"MENU:true"
(
	on execute do
	(
		undo "Remove sufix" on
			for obj in selection do
			(
				----obj_name = obj.name
				RX = ( dotNetClass "System.Text.RegularExpressions.RegEx" )
				has_lowercase = (RX.match obj.name "[a-z]").success
				has_uppercase = (RX.match obj.name "[A-Z]").success

				if has_lowercase and not has_uppercase then -- if "lower case" then "Capital Case"
				(
					capital_string	= ""
					delimeters	= "-_, "

					test_delimeters	= RX.matches obj.name ("["+delimeters+"]") ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase
					delimeters_match	= (for matchIdx = 0 to test_delimeters.count-1 collect for groupIdx = 0 to test_delimeters.item[matchIdx].groups.count-1 collect ( test_delimeters.item[matchIdx].groups.item[groupIdx].value )) --return

					delimeter = if delimeters_match.count > 0 then delimeters_match[1][1] else ""

					for word in (filterString obj.name delimeters) do
						capital_string += replace word 1 1 ( toUpper word[1]) + delimeter

					obj.name = trimRight capital_string delimeter
				)
				else if has_uppercase and not has_lowercase then -- if "lower case" then "Capital Case"
					obj.name = toLower obj.name

				else if has_lowercase and has_uppercase then
					obj.name = toUpper obj.name
			)
	)
)


/** REMOVE SUFIX
  */
macroscript selection_remove_suffix
category:	"_Object-Name"
buttonText:	"Remove sufix"
tooltip:	"Remove sufix from object name"
icon:	"MENU:true"
autoUndoEnabled: true
(
	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV
	on execute do
	(
		undo "Remove sufix" on
			for obj in selection do
				obj.name = (RegExer_v( obj.name )).removeSufix()
	)
)


/** https://forums.cgsociety.org/t/unregister-a-redrawviewscallback-in-scripted-modifier/2048394/4
  */
macroscript selection_name_show_in_viewport
category:	"_Object-Name"
buttonText:	"Show Names"
icon:	"MENU:true"
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())

		is_registred = (for _callback in showRegisteredRedrawViewsCallbacks asArray:true where _callback[1] == "displayObjectNames" collect _callback).count > 0

		unregisterRedrawViewsCallback displayObjectNames

		if not is_registred then
			registerRedrawViewsCallback displayObjectNames

	)
)



/*------------------------------------------------------------------------------
	GROUPBOX PREFIX
--------------------------------------------------------------------------------*/

--
--/**
--  *
--  */
--macroscript selection_edit_name_prefix_by_parent
--category:	"_Object-Name"
--buttonText:	"by parent"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
--(
--
--)
--
--/**
--  *
--  */
--macroscript selection_edit_name_prefix_by_layer
--category:	"_Object-Name"
--buttonText:	"by layer"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
--(
--
--)




--/**
--  *
--  */
--macroscript selection_edit_name
--category:	"_Object-Name"
--buttonText:	"[Object base name]"
--tooltip:	"original name is used, if name is empty"
--icon:	"control:editText|Groupbox:Base Name|across:1"
----icon:"offset:[-32,16]" -- BUG: offset does not work in groupsbox
--(
--
--)

/*------------------------------------------------------------------------------
	SUFFIX
--------------------------------------------------------------------------------*/

--macroscript selection_edit_name_suffix_by_parent
--category:	"_Object-Name"
--buttonText:	"A-Z"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Suffix|across:1"
--(
--
--)
--
--
--/**
--  *
--  */
--macroscript selection_rename
--category:	"_Object-Name"
--buttonText:	"Rename"
--tooltip:	"Load Selection"
--icon:	"across:1|height:48"
--(
--
--	ObjectRenamer = ObjectRenamer_v()
--
--	_selection = selection
--
--	ObjectRenamer.rename _selection
--
--	select _selection
--)
