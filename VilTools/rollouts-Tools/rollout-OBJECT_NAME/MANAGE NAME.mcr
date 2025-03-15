filein( getFilenamePath(getSourceFileName()) + "/Lib/showObjectNames.ms" )	-- "./Lib/showObjectNames.ms"


/*
	new_name = "same_name|same_name001| "

	A) SUFFIX ADDED TO COPIES, if new name is empty string
	B) SUFFIX ADDED TO ALL, if new name has number
	C) SUFFIX NOT ADDED, if new name is same source

*/ 
macroscript	selection_auto_rename_copy
category:	"_Object-Name"
buttontext:	"COPY COUNTER SUFFIX"
toolTip:	"Add suffix to copied objects.\n\nNAME OF COPIES ARE DRIVEN BY NEW NAME:\n\n• SUFFIX ADDED TO COPIES\n  If new name is empty string\n\n• SUFFIX ADDED TO ALL\n  If new name has number\n\n• SUFFIX NOT ADDED\n A) If new name is same source\n	B) If new name is empty and number of copies is 1"
icon:	"control:checkbox|MENU:true|checked:true|across:2|offset:[0,8]|AUTORUN:TRUE"
(
	--on IsChecked do AUTO_END_RESULT != undefined

	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--if AUTO_END_RESULT == undefined or ( EventFired != undefined and EventFired.val ) then
		
		if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
			CALLBACKMANAGER.start "autoRenameOnCopy" --"./../../../CallBacks/postNodesClonedEnd/autoRenameOnCopy.ms"
		else
			CALLBACKMANAGER.kill "autoRenameOnCopy"
    )
)

macroscript	selection_auto_on_create_and_delete
category:	"_Object-Name"
buttontext:	"AUTO MANAGE SUFFIX"
toolTip:	"ADD \ REMOVE NUMBER SUFFIX\n\nWhen object is CREATED or DELETED"
icon:	"control:checkbox|MENU:true|checked:true|across:2|offset:[0,8]|AUTORUN:TRUE"
(
	--on IsChecked do AUTO_END_RESULT != undefined

	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		format "EventFired: %\n" EventFired
		format "CALLBACKMANAGER: %\n" CALLBACKMANAGER
		
		if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
		(
			CALLBACKMANAGER.start "manageSuffixOnCreate" --"./../../../CallBacks/nodeCreated/manageSuffixOnCreate.ms"
			
			CALLBACKMANAGER.start "manageSuffixOnDelete" --"./../../../CallBacks/nodePreDelete/manageSuffixOnDelete.ms"
		)
		else
		(
			CALLBACKMANAGER.kill "manageSuffixOnCreate"
		
			CALLBACKMANAGER.kill "manageSuffixOnDelete"
		)
	)
)


/** RENAME BY LAST
  */
macroscript selection_reneme_by_last
category:	"_Object-Name"
buttonText:	"Rename by last"
tooltip:	"Rename by last selected object"
icon:	"MENU:true|offset:[0,8]"
(

	on execute do
		undo "Rename by last" on
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
		undo "Convert Case" on
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

/** RECOUNT object names
  */
macroscript selection_recount_name
category:	"_Object-Name"
buttonText:	"Recount"
tooltip:	"Replace number prefix of obejcts in selection"
icon:	"MENU:true"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\MANAGE NAME.mcr"
		ObjectRenamer	= ObjectRenamer_v()

		undo "Recount names" on
		(
			objects_count = if selection.count < 10 then 99 else selection.count -- keep two digits at least

			for i = 1 to selection.count do
			(
				obj = selection[i]

				obj.name = (RegExer_v( obj.name )).removeSufix()

				obj.name += ObjectRenamer.getSufixNumber (i) ( objects_count )
			)
		)
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
