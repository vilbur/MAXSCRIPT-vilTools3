filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupAttacher/GroupAttacher.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )

/**  Open\Close Group
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

/**  
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

/** Create group callback
 */
function createGroupCallback params =
(
	format "\n"; print ".createGroupCallback()"
	format "params	= % \n" params

	params_keys = #(#group_name, #Color_picker,  #Colorize_members, #Rename_members)

)

/**  
 *	
 */
macroscript	group_create_with_setup
category:	"_Group"
buttontext:	"Create"
toolTip:	"Create Group with setup - SETUP DOESN'T WORK YET"
icon:	"Menu:_Group|title:Group setup"
(
	filein( getFilenamePath(getSourceFileName()) + "/Group.mcr" )
	/*
		TODO WITH ROLLOUT:
			1) Edit text group name
			2) Color picker: Wire color for group
			3) Checkbox: wire color for group momebers
			4) Checkbox: Rename memebers by group
	*/

	if selection.count >= 2 do
		undo "Create Group" on
		(
			/* DIALOG */ 
			Dialog 	    = Dialog_v ("Group options") ini:(getSourceFileName())

			/* CONTROLS */ 
			_Controls   = Dialog.Controls()

			_GroupName	= _Controls.control #EditText "[Group name]" 	across:2 width:164

			_ColorPicker	= _Controls.control #ColorPicker "[Color picker]"	across:2 offset:[48,0] params:#(#color, ( color 0 0 128 ))

			_colorize	= _Controls.control #checkbox "Colorize members"	across:1
			_RenameMembers	= _Controls.control #checkbox "Rename members"	across:1
			
			Button_OK	= _Controls.control #button "Ok"	across:2
			Button_Cancel	= _Controls.control #button "Cancel"	across:2
			
			/* EVEMTS */ 
			fn_callback_cancel = "try( destroyDialog "+ Dialog.RolloutMain.id as string  +" )catch()"

			callback = "GroupCreator_v params:#(group_options.group_name.text, group_options.Color_picker.color,  group_options.Colorize_members.checked, group_options.Rename_members.checked )"

			Button_OK.Events.add #pressed (callback +";"+ fn_callback_cancel)
			Button_Cancel.Events.add #pressed (fn_callback_cancel)
			
			_GroupName.Events.add #entered (callback )

			
			/* HOTKEYS */ 
			Dialog.HotKey #(#esc)	fn_callback_cancel
			Dialog.HotKey #(#enter)	fn_callback_cancel
			Dialog.HotKey #(#return)	fn_callback_cancel
			Dialog.HotKey #(#space)	group_options.Color_picker.color = random

			/* DIALOG CREATE */
			Dialog.create width:256

			--GroupCreator_v()
		)
)

/**  
 *	
 */
macroscript	group_create
category:	"_Group"
buttontext:	"Create"
toolTip:	"Create Quick Group"
icon:	"Menu:_Group"
(

	undo "Create Group" on
	(
		GroupCreator_v()
	)
)

/**  Ungroup selected groups
  *  Even if selected object is in opened group
 *	
 */
macroscript	group_ungroup
category:	"_Group"
buttontext:	"Create"
toolTip:	"Ungroup selection"
icon:	"Menu:_Group|title:Ungroup"
(
	undo "Ungroup selected" on
	(
		actionMan.executeAction 0 "40143" -- Close group

		actionMan.executeAction 0 "40141"  -- Groups: Ungroup
	)
)

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
	GROUPS SHOW\HIDE
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

