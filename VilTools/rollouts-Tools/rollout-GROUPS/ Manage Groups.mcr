filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupAttacher/GroupAttacher.ms" ) -- "./Lib/GroupAttacher/GroupAttacher.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" ) -- "./Lib/GroupCreator/GroupCreator.ms"

/*------------------------------------------------------------------------------
	CREATE GROUP
--------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	group_quick_create
category:	"_Group"
buttontext:	"Create Group"
--icon:	"across:5|width:72|Menu:true|title:Create group|tooltip:Create Group"
icon:	"across:5|width:72|Menu:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-GROUPS\ Manage.mcr"

	format "EventFired = % \n" EventFired

	GroupCreator = GroupCreator_v align_pivot:false

	on execute do (
		try (
			GroupCreator.createGroup()
		)
		catch()
	)

	on AltExecute type do (
		try (
			-- instantiate the object
			_dotNet = dotNetObject "MaxCustomControls.RenameInstanceDialog" "Default text"
			_dotNet.text ="Title"

			DialogResult = _dotNet.Showmodal()

			--test if the ok button was pressed
			dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)
			--get the new text string
			entered_string = _dotNet.InstanceName

			format "entered_string	= % \n" entered_string

		)
		catch()
	)



)

global GROUP_OPTIONS

/**
 *
 */
macroscript	group_create_with_setup
category:	"_Group"
buttontext:	"Create Setup"
--toolTip:	"Group Setup Dialog"
icon:	"across:5|width:72|Menu:true|title:Create group setup|tooltip:Create Group"
(
	--clearListener()
	--filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr" ) -- DEV
	--filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

	format "EventFired = % \n" EventFired
		/** loop wirecolors of group members
		  *
		  * If members has only one color, then random color is selected
		 */
		function circleColorsOfColorPicker =
		(
			if  GROUP_OPTIONS.colors.count > 1 then
			(
				GROUP_OPTIONS.current_color = if GROUP_OPTIONS.current_color <  GROUP_OPTIONS.colors.count then GROUP_OPTIONS.current_color + 1 else 1

				GROUP_OPTIONS.members_color_picker.color = GROUP_OPTIONS.colors[GROUP_OPTIONS.current_color]
			)
			else
				GROUP_OPTIONS.members_color_picker.color = (Color_v()).randomize hue:5 brightness:#(128, 255)	saturation:#(128, 255)

			selection.wirecolor = GROUP_OPTIONS.members_color_picker.color
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
				"group_name:	GROUP_OPTIONS.group_name_text.text",
				"member_name:	GROUP_OPTIONS.members_name_text.text",
				"add_to_layer:	GROUP_OPTIONS.add_to_layer.checked",
				"relink_hierarchy:	GROUP_OPTIONS.relink_hierarchy.checked",
				"align_pivot:	GROUP_OPTIONS.align_pivot.checked"
			)

			for param in creator_params do params += param + " "

			--callback_submit	= "GroupCreator_v params:#( GROUP_OPTIONS.group_name.text, GROUP_OPTIONS.Rename_members.checked, GROUP_OPTIONS.add_to_layer.checked, GROUP_OPTIONS.align_pivot.checked, GROUP_OPTIONS.relink_hierarchy.checked );"
			callback_submit	= "(GroupCreator_v "+ params +").createGroup();"
			callback_close	= " try( destroyDialog "+ Dialog.id as string  +" )catch()"
			callback_get_color	= "GROUP_OPTIONS.members_color_picker.color = (Color_v()).randomize hue:5 brightness:#(128, 255)	saturation:#(128, 255)"
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
icon:	"id:group_open_hierarchy"
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
icon:	"id:group_open_hierarchy"
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
toolTip:	"Close groups"
icon:	"id:group_close|Menu:toolTip"
(
	actionMan.executeAction 0 "40143"  -- Groups: Group Close
)

/**  Close all Groups in hierarchy
 *
 */
macroscript	group_close_hierarchy
category:	"_Group"
buttontext:	"Close"
toolTip:	"Close groups in tree"
icon:	"id:group_close|Menu:toolTip"
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
icon:	"across:4|menu:true"
(

	clearListener()
	--format "EventFired = % \n" EventFired
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-GROUPS\ Manage Groups.mcr"

	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms")

	with undo "attach to group" on
	(
		--with redraw off
		--(
			GroupAttacher 	= GroupAttacher_v()
--
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
toolTip:	"Detach selected objects from groups"
icon:	"menu:true"
(
	--actionMan.executeAction 0 "40144"  -- Groups: Group Detach
	format "EventFired = % \n" EventFired

	with undo "Detach from groups" on

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

--/**
-- *
-- */
--macroscript	group_detach_to_parent
--category:	"_Group"
--buttontext:	"Detach"
--toolTip:	"Detach to parent group"
----icon:	"#(path, index)"
--(
--	--clearListener()
--	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms")
--
--	with undo "Detach to parent group" on
--	(
--		selected_nodes = for obj in selection where not isGroupHead obj collect obj
--
--		for _node in selected_nodes do
--			if _node.parent.parent != undefined then
--				_node.parent = _node.parent.parent
--			else
--				_node.parent = undefined
--
--		redrawViews()
--	)
--)

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
icon:	"menu:true"
(
	format "EventFired = % \n" EventFired
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
icon:	"menu:true"
(

	--clearListener()

	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")

	format "EventFired = % \n" EventFired

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
