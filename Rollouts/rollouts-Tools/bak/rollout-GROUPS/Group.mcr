filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupAttacher/GroupAttacher.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

/*------------------------------------------------------------------------------
	CREATE GROUP
--------------------------------------------------------------------------------*/

global group_options

/**
 *
 */
macroscript	group_create_with_setup
category:	"_Group"
buttontext:	"Create"
--toolTip:	"Group Setup Dialog"
icon:	"across:5|Menu:_Group|title:Group setup|tooltip:Create Group\n"
(
	--clearListener()
	--filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr" ) -- DEV
	--filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

		/** loop wirecolors of group members
		  *
		  * If members has only one color, then random color is selected
		 */
		function circleColorsOfColorPicker =
		(
			if  group_options.colors.count > 1 then
			(
				group_options.current_color = if group_options.current_color <  group_options.colors.count then group_options.current_color + 1 else 1

				group_options.members_color_picker.color = group_options.colors[group_options.current_color]
			)
			else
				group_options.members_color_picker.color = (Color_v()).randomize hue:5 brightness:#(128, 255)	saturation:#(128, 255)

			selection.wirecolor = group_options.members_color_picker.color
		)

	/*
		TODO WITH ROLLOUT:
			1) Edit text group name
			2) Color picker: Wire color for group
			3) Checkbox: wire color for group members
			4) Checkbox: Rename members by group
	*/

	if selection.count > 0 then
		(
			/* DIALOG */
			Dialog 	    = Dialog_v ("GROUP OPTIONS") ini:(getSourceFileName())

			Dialog.addLocal "colors" (makeUniqueArray (for obj in selection where not isGroupHead obj collect obj.wirecolor))
			Dialog.addLocal "current_color" 1

			/* CONTROLS */
			_Controls   = Dialog.Controls()

			_MembersName_label	= _Controls.control #label "Members name" across:2 width:148 offset:[0, 8]

			_GroupName_label	= _Controls.control #label "Group name" across:2 width:148 offset:[0, 8]

			_MembersName	= _Controls.control #EditText "[Members name text]" across:2 width:148 ini:false value:( ( dotNetObject "System.Text.RegularExpressions.Regex" @"[0-9-_]+$" ).Replace selection[1].name "" ) tooltip:"Members Name"

			_GroupName	= _Controls.control #EditText "[Group name text]" across:2 width:148  tooltip:"Group Name" tooltip:"'{MEMBER NAME}-GROUP' is used if empty"

			_ColorPicker	= _Controls.control #ColorPicker "[Members color picker]"	across:2 params:#(#color, selection[1].wirecolor ) ini:false tooltip:"Color of Group\nHotkey: Ctrl"

			_ColorPicker_label	= _Controls.control #label "Members color" across:2 align:#left offset:[-96, 4]

			_AddToLayer	= _Controls.control #checkbox "Add to layer"	across:1 tooltip:"Add group to 1st object layer"

			_AlignTransform	= _Controls.control #checkbox "Align transform"	across:1 tooltip:"Align group pivot and transformation by 1st object"

			_RelinkHierarchy	= _Controls.control #checkbox "Relink hierarchy"	across:1 tooltip:"Relink group hierarchy by 1st object"

			Button_OK	= _Controls.control #button "Ok"	across:2 height:48 tooltip:"Hotkey:Enter\n\nDialog is not closed when Enter preesed"
			Button_Cancel	= _Controls.control #button "Cancel"	across:2 height:48

			/* EVENT METHODS */
			params = ""

			creator_params = #(
				"group_name:	ROLLOUT_group_options.ET_group_name_text.text",
				"member_name:	ROLLOUT_group_options.ET_members_name_text.text",
				"add_to_layer:	ROLLOUT_group_options.CBX_add_to_layer.checked",
				--"relink_hierarchy:	ROLLOUT_group_options.CBX_relink_hierarchy.checked"
				"align_transform:	ROLLOUT_group_options.CBX_align_transform.checked"
			)

			for param in creator_params do params += param + " "

			--callback_submit	= "GroupCreator_v params:#( group_options.group_name.text, group_options.Rename_members.checked, group_options.add_to_layer.checked, group_options.align_transform.checked, group_options.relink_hierarchy.checked );"
			callback_submit	= "GroupCreator_v "+ params +";"
			callback_close	= " try( destroyDialog "+ Dialog.id as string  +" )catch()"
			callback_get_color	= "group_options.members_color_picker.color = (Color_v()).randomize hue:5 brightness:#(128, 255)	saturation:#(128, 255)"
			callback_set_color	= "selection.wirecolor = val"

			/* EVENTS */
			_ColorPicker.Events.add	#changed ("selection.wirecolor = val")

			Button_OK.Events.add	#pressed (callback_submit + callback_close)
			Button_Cancel.Events.add 	#pressed (callback_close)

			/* HOTKEYS */
			Dialog.HotKey #(#escape)	callback_close

			Dialog.HotKey #(#Enter)	(callback_submit)

			Dialog.HotKey #(#control)	"undo \"Set color to group members\" on circleColorsOfColorPicker()"

			/* DIALOG CREATE */
			Dialog.create width:320 height:240

			--Dialog.register()

			_MembersName.focus()

			Dialog.sendKey("^a")
			--format "Dialog.id	= % \n" Dialog.id
			--execute (callback_submit + callback_close) -- DEV
		)
	else
		messageBox "Nothing selected" title:"NOTHING SELECTED"

)

/*------------------------------------------------------------------------------
	UNGROUP
--------------------------------------------------------------------------------*/

/**  Ungroup selected groups
 *
  *  Even if selected object is in opened group
 */
macroscript	group_ungroup
category:	"_Group"
buttontext:	"Ungroup"
toolTip:	"Ungroup selection"
icon:	"Menu:_Group|title:Ungroup"
(
	undo "Ungroup selected" on
	(
		actionMan.executeAction 0 "40143" -- Close group

		actionMan.executeAction 0 "40141"  -- Groups: Ungroup
	)
)

/*------------------------------------------------------------------------------
	OPEN GROUP
--------------------------------------------------------------------------------*/

/**  Open all Groups in hierarchy
 *
 */
macroscript	group_open
category:	"_Group"
buttontext:	"Open"
toolTip:	"Open selected groups"
--icon:	"Menu:_Group|title:Close Group"
--icon:	"id:group_open_hierarchy"
(
	--undo "Groups Open" on
	--(
	--
	--)
	actionMan.executeAction 0 "40142"  -- Groups: Group Open
)

/**  Open all Groups in hierarchy
 *
 */
macroscript	group_open_recursively
category:	"_Group"
buttontext:	"Open"
toolTip:	"Open all groups in hierarchy"
--icon:	"Menu:_Group|title:Close Group"
--icon:	"id:group_open_hierarchy"
(
	actionMan.executeAction 0 "63561"  -- Groups: Group Open Recursively
)


/*------------------------------------------------------------------------------
	CLOSE GROUP
--------------------------------------------------------------------------------*/

/**  Open 1st Groups in hierarchy
 *
 *	Function is overkilled with modes, mode is not used, but let it as is for future
 */
macroscript	group_close
category:	"_Group"
buttontext:	"Close"
toolTip:	"Close selected groups"
icon:	"id:group_close"
--icon:	"Menu:_Group|title:Close Group"
(
	actionMan.executeAction 0 "40143"  -- Groups: Group Close
)

/**  Close all Groups in hierarchy
 *
 */
macroscript	group_close_hierarchy
category:	"_Group"
buttontext:	"Close"
toolTip:	"Close all groups in hierarchy"
--icon:	"Menu:_Group|title:Close Group"
icon:	"id:group_close"
(
	undo "Groups Close" on
	(
		_selection	= for o in selection collect o
		--format "_selection	= % \n" _selection
		for o in selection where isGroupHead o do setGroupOpen o false

		select _selection
	)
)

/*------------------------------------------------------------------------------
	OPEN\CLOSE TOGGLE
--------------------------------------------------------------------------------*/

/**  Open 1st Groups in hierarchy
 *
 *	Function is overkilled with modes, mode is not used, but let it as is for future
 */
macroscript	group_open_toggle
category:	"_Group"
buttontext:	"Open\Close"
toolTip:	"Open\Close toggle selected groups"
--icon:	"id:group_open"
icon:	"Menu:_Group|title:Open\Close Group Toggle"
(
	--clearListener()
	--filein(@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")

	groups = #()

	for obj in selection do if isGroupHead obj then appendIfUnique groups obj else if isGroupMember obj then appendIfUnique groups obj.parent
	--groups = for obj in selection where isGroupHead obj collect obj

	for _group in groups do format "_group	= % \n" _group.name

	if groups.count > 0 then
	(
		state = isOpenGroupHead groups[1]

		--for _group in groups do
		--	setGroupOpen _group (not state)
		for _group in groups do
		(
			select _group

			if state then
				actionMan.executeAction 0 "40143"  -- Groups: Group Close
			else
				actionMan.executeAction 0 "40142"  -- Groups: Group Open
		)

		print ("GROUPS "+ (for _group in groups collect _group.name) as string +" HAS BEEN " + (if state then "CLOSED" else "OPENED"))
	)

	--clearSelection()
	--
	select groups
	--
	--completeRedraw()

)
/*------------------------------------------------------------------------------
	ATTACH
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	group_attach_to_groups
category:	"_Group"
buttontext:	"Attach"
toolTip:	"Attach selected objects to group\n\nWorks with instanced groups also."
icon:	"across:4"
(
	clearListener()
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms")

	with undo "attach_to_groups" on
	(
		--with redraw off
		--(
			GroupAttacher 	= GroupAttacher_v()

			GroupAttacher.attachSelectionToGroups()
		--)

		--redrawViews()
	)
)
/*------------------------------------------------------------------------------
	ATTACH
--------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	group_detach
category:	"_Group"
buttontext:	"Detach"
toolTip:	"Detach from group"
--icon:	"#(path, index)"
(
	actionMan.executeAction 0 "40144"  -- Groups: Group Detach
)

/**
 *
 */
macroscript	group_detach_to_parent
category:	"_Group"
buttontext:	"Detach"
toolTip:	"Detach to parent group"
--icon:	"#(path, index)"
(
	--clearListener()
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms")

	with undo "Detach to parent group" on
	(
		selected_nodes = for obj in selection where not isGroupHead obj collect obj

		for _node in selected_nodes do
			if _node.parent.parent != undefined then
				_node.parent = _node.parent.parent
			else
				_node.parent = undefined

		redrawViews()
	)
)

/*------------------------------------------------------------------------------
	HIDE GROUP
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	group_hide
category:	"_Group"
buttontext:	"Hide"
toolTip:	"Hide group helpers"
--icon:	"#(path, index)"
(
	for obj in objects where isGroupHead(obj) and obj.layer.on do hide obj

)

/*------------------------------------------------------------------------------
	UNHIDE GROUP
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	group_unhide_helper
category:	"_Group"
buttontext:	"Unhide"
toolTip:	"Unhide group helpers"
--icon:	"#(path, index)"
(
	--clearListener()
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")

	hidden_groups = for _group in objects where isGroupHead _group and _group.isHidden and _group.layer.on collect _group

	for _group in hidden_groups do
	(
		visible_childs = for child in _group.children where not child.isHidden collect child

		if visible_childs.count != 0 then
			 unhide _group
	)
)

/**
 *
 */
macroscript	group_unhide_group_and_children
category:	"_Group"
buttontext:	"Unhide"
toolTip:	"Unhide group helpers and children"
--icon:	"#(path, index)"
(
	--clearListener()
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")

	macros.run "_Group" "group_unhide_helper"

	visible_groups = for _group in objects where isGroupHead _group and not _group.isHidden and _group.layer.on collect _group

	for _group in visible_groups do
		for child in _group.children where child.isHidden do
			 unhide child
)

/**
 *
 */
macroscript	group_delete_empty_groups
category:	"_Group"
buttontext:	"Empty Groups"
toolTip:	"Select\Delete Empty Groups"
--icon:	"#(path, index)"
(
	empty_groups_names = ""

	empty_groups = for g in objects where isGroupHead g and g.children.count == 0 collect g

	for g in empty_groups do empty_groups_names += g.name + "\n"

	if queryBox ("Delete these empty groups ?\n\n"+empty_groups_names) title:"DELETE EMPTY GROUPS"  beep:false then
		delete empty_groups
	else
		select empty_groups

)

/**
 *
 */
macroscript	group_rename_members
category:	"_Group"
buttontext:	"Rename members"
toolTip:	"Rename members of group by group name"
--icon:	"#(path, index)"
(
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")

	groups = for g in selection where isGroupHead g and g.children.count > 0 collect g


	if groups.count > 0 then
	(

		if queryBox "Rename group memeners ?" title:"RENAME MEMENERS" then
			for _group in groups do
			(
				--decimal_count = case of -- GET RIGHT NUMBER OF DECILAMS E.G.: 001
				--(
				--	(_group.children.count>100): 3
				--	(_group.children.count>10):  2
				--	default: 1
				--)
				decimal_count = if (_group.children.count>100) then 3 else 2

				for i = 1 to _group.children.count where not isGroupHead _group.children[i] do
				(
					increment_number = i as string

					if increment_number.count < decimal_count then
						for x = 1 to decimal_count - increment_number.count do
							increment_number = "0" + increment_number

					_group.children[i].name = toLower _group.name + "-" + increment_number
				)
			)

	)
	else
		messageBox "Select any group to rename" title:"Title"  beep:false
)

/**
 *
 */
macroscript	group_convert_to_object
category:	"_Group"
buttontext:	"To Object"
toolTip:	"Merge selected groups to objects"
--icon:	"#(path, index)"
(
	groups = for g in selection where isGroupHead g and g.children.count > 0 collect g

	GroupToObjectBaker_v groups:groups
)





