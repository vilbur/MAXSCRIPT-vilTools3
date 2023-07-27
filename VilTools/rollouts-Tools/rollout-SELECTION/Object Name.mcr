--filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )

/**
  *
  */
macroscript selection_name_convert_case_sence
category:	"Selection"
buttonText:	"Convert Case"
tooltip:	"Convert case of selected object names\n\nCapital Case >>> UPPER CASE >>> lower case"
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
(
	filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV

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

--fn showObjectNames = --start
--(
---- 	o=$
----	gw.setTransform(Matrix3 1)
----	for o in selection where not o.isHidden do
----	(
----
----		mdZpos = o.pos.z
----
----
----		nameString = o.name
----		newName = ""
----
----
----			if findstring nameString "\\" != 0 then
----			(
----
----				NameTokens = filterString nameString "\\"
----
----				for w=1 to NameTokens.count do
----				(
----					word = NameTokens[w]
----					append newName word
----
----					if w <  NameTokens.count  then append newName "\\\\"
----				)
----
----				nameString = newName
----
----			)
----
----
------ 		Print ("DEBUG ----- showObjectNames: " + nameString )
----
------ 		gw.text o.pos nameString color:yellow
----		gw.text o.center nameString color:yellow
----
----
------ 		gw.text o.pos (o.modifiers[1].name as string) color:yellow
----
------ 		if o.modifiers.count > 0 then
------ 		(
----		--for m in o.modifiers do	gw.text  [o.pos.x,o.pos.y,(mdZpos -= 140)] "SHIT" color:yellow
------ 		gw.text  [o.pos.x,o.pos.y,(mdZpos -= 140)] "SHIT" color:yellow
------ 		)
----
----	)
----	gw.enlargeUpdateRect #whole
----	gw.updateScreen()
--)
--

/** CHECKBUTTON DOES NOT WORK, UI CREATE NORMAL BUTTON
  *
  */
macroscript selection_name_show_in_viewport
category:	"Selection"
buttonText:	"Show Names"
icon:	"control:checkbutton"
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
(

	fn GW_displayObjectNames =
	(
	  gw.setTransform (matrix3 1)
	  for o in objects where not o.isHiddenInVpt do
		gw.text o.pos (o as string) color:yellow
	  gw.enlargeUpdateRect #whole
	)

	if EventFired.val then
		unregisterRedrawViewsCallback showObjectNames
	else
			registerRedrawViewsCallback GW_displayObjectNames

	format "EventFired.val	= % \n" EventFired.val

--format "Control	= % \n" (classOf EventFired.Control)
	--format "EventFired.Control.state	= % \n" EventFired.Control.state

	--registerRedrawViewsCallback showObjectNames
	--showObjectNames()
	--global showObjectNamesCallback = true

)


/**  SUFFIX TEXT
  *
  */
macroscript selection_remove_suffix_text
category:	"Selection"
buttonText:	"[remove suffix text]"
tooltip:	"RegEx of suffix to remove"
icon:	"control:editText|across:2|width:256"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(
	format "EventFired	= % \n" EventFired
	--search_text = ROLLOUT_selection.search_in_name.text


	if EventFired.val == " " then
		EventFired.control.text = "[-_]|LEFT|RIGHT|\d+"

	--format "search_text	= % \n" search_text

)

/**
  *
  */
macroscript selection_remove_numbered_suffix
category:	"Selection"
buttonText:	"Remove suffix"
tooltip:	"Remove suffix from object name"
icon:	"across:2|align:#right"
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
(
	filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Object Name.mcr" ) -- DEV

	undo "Remove suffix" on
	(
		suffix_text = ROLLOUT_selection.ET_remove_suffix_text.text

		for obj in selection do
			obj.name = ( dotNetObject "System.Text.RegularExpressions.Regex" ("("+suffix_text+")$")  ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase  ).Replace obj.name ""
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
--category:	"Selection"
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
--category:	"Selection"
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
--category:	"Selection"
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
--category:	"Selection"
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
--category:	"Selection"
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
