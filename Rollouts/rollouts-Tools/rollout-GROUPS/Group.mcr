filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupAttacher/GroupAttacher.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

/*------------------------------------------------------------------------------
	CREATE GROUP
--------------------------------------------------------------------------------*/

/** Create group callback
 */
function createGroupCallback params =
(
	format "\n"; print ".createGroupCallback()"
	format "params	= % \n" params

	params_keys = #(#group_name, #members_color_picker,  #Colorize_members, #Rename_members)

)

/** Callback_test
 */
function callback_test =
(
	format "\n"; print ".callback_test()"
)



global group_options

/**  
 *	
 */
macroscript	group_create_with_setup
category:	"_Group"
buttontext:	"Create"
toolTip:	"Group Setup Dialog"
icon:	"Menu:_Group|title:Group setup|tooltip:Create Group\n"
(
	clearListener()
	filein( @"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr" ) -- DEV
	filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

	
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
	
	--if selection.count > 0 then
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

			_GroupName	= _Controls.control #EditText "[Group name text]" across:2 width:148  tooltip:"Group Name" --value:( toUpper (( dotNetObject "System.Text.RegularExpressions.Regex" @"[0-9-_]+$" ).Replace selection[1].name "" ))

			_ColorPicker	= _Controls.control #ColorPicker "[Members color picker]"	across:2 params:#(#color, selection[1].wirecolor ) ini:false tooltip:"Color of Group\nHotkey: Ctrl"
			
			_ColorPicker_label	= _Controls.control #label "Members color" across:2 align:#left offset:[-96, 4]

			_AddToLayer	= _Controls.control #checkbox "Add to layer"	across:1 tooltip:"Add group to 1st object layer"
			
			_AlignTransform	= _Controls.control #checkbox "Align transform"	across:1 tooltip:"Align group pivot and transformation by 1st object"
			
			_RelinkHierarchy	= _Controls.control #checkbox "Relink hierarchy"	across:1 tooltip:"Relink group hierarchy by 1st object"
			
			Button_OK	= _Controls.control #button "Ok"	across:2 height:48 tooltip:"Enter"
			Button_Cancel	= _Controls.control #button "Cancel"	across:2 height:48 tooltip:"Esc"

			/* EVENT METHODS */
			creator_params = #( "group_options.members_name_text.text", "group_options.group_name_text.text", "group_options.add_to_layer.checked", "group_options.align_transform.checked", "group_options.relink_hierarchy.checked")
			
			--callback_submit	= "GroupCreator_v params:#( group_options.group_name.text, group_options.Rename_members.checked, group_options.add_to_layer.checked, group_options.align_transform.checked, group_options.relink_hierarchy.checked );"
			callback_submit	= "GroupCreator_v params:"+ ( substituteString ( creator_params as string ) "\"" "") +";"
			callback_close	= " try( destroyDialog "+ Dialog.id as string  +" )catch()"
			callback_get_color	= "group_options.members_color_picker.color = (Color_v()).randomize hue:5 brightness:#(128, 255)	saturation:#(128, 255)"
			callback_set_color	= "selection.wirecolor = val"

			
			/* EVENTS */ 
			_ColorPicker.Events.add	#changed ("selection.wirecolor = val")
			
			Button_OK.Events.add	#pressed (callback_submit + callback_close)
			Button_Cancel.Events.add 	#pressed (callback_close)

			
			/* HOTKEYS */ 
			--Dialog.HotKey #(#escape)	callback_close

			Dialog.HotKey #(#Enter)	(callback_submit + callback_close)

			Dialog.HotKey #(#control)	"undo \"Set color to group members\" on circleColorsOfColorPicker()"

			/* DIALOG CREATE */
			Dialog.create width:320 height:196
			
			--Dialog.register()
			
			_MembersName.focus()
			
			Dialog.sendKey("^a")
			format "Dialog.id	= % \n" Dialog.id
			--execute (callback_submit + callback_close)
		)
	--else
		--messageBox "Select at least 2 objects." title:"NOTHING SELECTED"
		
)

/**  
 *	
 */
macroscript	group_create
category:	"_Group"
buttontext:	"Create"
toolTip:	"Quick Group"
icon:	"Menu:_Group"
(

	undo "Create Group" on
	(
		GroupCreator_v()
	)
)

/*------------------------------------------------------------------------------
	OPEN\CLOSE GROUP
--------------------------------------------------------------------------------*/


/**  Open\Close Toggle Group
 *	
 *	Function is overkilled with modes, mode is not used, but let it as is for future
 */
macroscript	group_open_close_toggle
category:	"_Group"
buttontext:	"Open\Close"
toolTip:	"Open\Close selected groups"
icon:	"Menu:_Group|title:Open Group"
(
	/*
		mode = #open
		mode = #toggle
		mode = #close
	*/

	mode = #toggle

	undo "Group Open" on
	(
		selected_groups = #()	
		group_members   = #()

		for o in selection where ( isGroupHead  o == true ) do

		for o in selection where  isGroupMember o == true and not isGroupHead o  do appendIfUnique selected_groups o.parent

		for g in selected_groups do (for ch in g.children do append group_members ch)

		for g in selected_groups where isGroupHead g do
		(

			if mode == #open then
				setGroupOpen g true

			else if  mode == #close then
				setGroupOpen g false

			else if  mode == #toggle do
			(
				if isOpenGroupHead g then
					( setGroupOpen g false)
				else
					( setGroupOpen g true)
			)
		)

		select group_members
	)	
)
/**  Close Group
 *	
 */
macroscript	group_close_selected
category:	"_Group"
buttontext:	"Open\Close"
toolTip:	"Close groups"
icon:	"Menu:_Group|title:Close Group"
(
	actionMan.executeAction 0 "40143"  -- Groups: Group Close
)



--/**  
-- *	
-- */
--macroscript	group_test
--category:	"_Group"
--buttontext:	"Test"
----toolTip:	"Quick Group"
----icon:	"Menu:_Group"
--(
--	filein( @"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr" ) -- DEV
--
--	isKeyDown = (dotNetClass "managedservices.keyboard").isKeyDown
--	keys = dotNetClass "system.windows.forms.keys"
--	--
--	----show keys
--	for key in (getPropNames keys) do 		
--	(
--		hotkey_pressed = ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ key as string ))
--		format "key	= % \nhotkey_pressed	= % \n\n" key hotkey_pressed
--	)
--	
--	
--	
--	--format "hotkey_pressed	= % \n" hotkey_pressed																		 
--)

/*------------------------------------------------------------------------------
	UNGROUP
--------------------------------------------------------------------------------*/

/**  Ungroup selected groups
  *  Even if selected object is in opened group
 *	
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
	ATTACH
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	group_attach_to_groups
category:	"_Group"
buttontext:	"Attach"
toolTip:	"Attach selected objects to all instances of group"
--icon:	"#(path, index)"
(
	GroupAttacher 	= GroupAttacher_v()

	GroupAttacher.attachSelectionToGroups()
)

/*------------------------------------------------------------------------------
	SHOW\HIDE GROUP
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	group_hide
category:	"_Group"
buttontext:	"Hide\Unhide"
toolTip:	"Hide group helpers"
--icon:	"#(path, index)"
(
	for obj in objects where isGroupHead(obj) and obj.layer.on do hide obj
)

/**  
 *	
 */
macroscript	group_unhide
category:	"_Group"
buttontext:	"Hide\Unhide"
toolTip:	"Unhide group helpers"
--icon:	"#(path, index)"
(
	for obj in objects where isGroupHead(obj) and obj.layer.on do unhide obj
)
