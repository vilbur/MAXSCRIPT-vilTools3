filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupAttacher/GroupAttacher.ms" ) -- "./Lib/GroupAttacher/GroupAttacher.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" ) -- "./Lib/GroupCreator/GroupCreator.ms"

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
icon:	"across:4|MENU:true"
(

	--clearListener()
	----format "EventFired = % \n" EventFired
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-GROUPS\ Manage Groups.mcr"

	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Lib\GroupAttacher\GroupAttacher.ms")

	on execute do
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
	DETTACH
--------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	group_detach
category:	"_Group"
buttontext:	"Detach"
toolTip:	"Detach selected objects from groups"
icon:	"MENU:true"
(
	--actionMan.executeAction 0 "40144"  -- Groups: Group Detach
	on execute do
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

/*------------------------------------------------------------------------------
	CREATE GROUP
--------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	group_quick_create
category:	"_Group"
buttontext:	"Create Group"
--icon:	"across:5|width:72|MENU:true|title:Create group|tooltip:Create Group"
icon:	"across:5|width:72|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-GROUPS\ Manage.mcr"

	--format "EventFired = % \n" EventFired


	on execute do (
		try (
			GroupCreator = GroupCreator_v align_pivot:false

			GroupCreator.createGroup()
		)
		catch()
	)

	on AltExecute type do (
		try (
			-- instantiate the object
			_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" default_text
			_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"

			--_dotNet.text	= title
			_dotNet.ShowModal()

			_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
			_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )
			_string	= _dotNet.InstanceName

			format "_string	= % \n" _string

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
icon:	"across:5|width:72|tooltip:Create Group"
(
	--clearListener()
	--filein( @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr" ) -- DEV
	--filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

	on execute do
	(

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
			_ColorPicker.Event	#changed ("selection.wirecolor = val")

			Button_OK.Event	#pressed (callback_submit + callback_close)
			Button_Cancel.Event 	#pressed (callback_close)

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
icon:	"MENU:true"
(
	on execute do

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
icon:	"MENU:true"
--icon:	"id:group_open_hierarchy"
(
	on execute do
	(
		actionMan.executeAction 0 "40142"  -- Groups: Group Open
	)

	on altExecute type do
	(
		actionMan.executeAction 0 "63561"  -- Groups: Group Open Recursively
	)


)

--/**  Open all Groups in hierarchy
-- *
-- */
--macroscript	group_open_recursively
--category:	"_Group"
--buttontext:	"Open"
--toolTip:	"Open all groups in hierarchy"
----icon:	"MENU:_Group|title:Close Group"
--icon:	"id:group_open_hierarchy"
--(
--	actionMan.executeAction 0 "63561"  -- Groups: Group Open Recursively
--)


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
icon:	"id:group_close|MENU:true"
(
	on execute do
		actionMan.executeAction 0 "40143"  -- Groups: Group Close

	on altExecute type do
		macros.run "_Group" "group_close_hierarchy"

)

/**  Close all Groups in hierarchy
 *
 */
macroscript	group_close_hierarchy
category:	"_Group"
buttontext:	"Close"
toolTip:	"Close groups in tree"
icon:	"id:group_close"
(
	on execute do
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
	on execute do
	(

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
icon:	"MENU:true"
(
	on execute do
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
icon:	"MENU:true"
(
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")

	on execute do
	(
		hidden_groups = for _group in objects where isGroupHead _group and _group.isHidden and _group.layer.on collect _group

		for _group in hidden_groups do
		(
			visible_childs = for child in _group.children where not child.isHidden collect child

			if visible_childs.count != 0 then
				 unhide _group
		)

	)
)

--/**
-- *
-- */
--macroscript	group_unhide_group_and_children
--category:	"_Group"
--buttontext:	"Unhide"
--toolTip:	"Unhide group helpers and children"
----icon:	"#(path, index)"
--(
--	--clearListener()
--	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")
--
--	macros.run "_Group" "group_unhide_helper"
--
--	visible_groups = for _group in objects where isGroupHead _group and not _group.isHidden and _group.layer.on collect _group
--
--	for _group in visible_groups do
--		for child in _group.children where child.isHidden do
--			 unhide child
--)
