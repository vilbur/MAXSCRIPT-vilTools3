filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupAttacher/GroupAttacher.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/GroupCreator/GroupCreator.ms" )


/**  
 *	
 */
macroscript	group_create
category:	"_Group"
buttontext:	"Create"
toolTip:	"Create Group"
--icon:	"#(path, index)"
(
	--undo "Create Group" on
	--(
		GroupCreator_v()
	--)
)
/**  Ungroup selected groups
  *  Even if selected object is in opened group
 *	
 */
macroscript	group_ungroup
category:	"_Group"
buttontext:	"Create"
toolTip:	"Ungroup selection"
--icon:	"#(path, index)"
(
	undo "Ungroup selected" on
	(
		
		
		actionMan.executeAction 0 "40143" -- Close group
		
		actionMan.executeAction 0 "40141"  -- Groups: Ungroup
	)
)



/**  Open\Close Group
 *	
 *	Function is overkilled with modes, mode is not used, but let it as is for future
 */
macroscript	group_open_close_toggle
category:	"_Group"
buttontext:	"Open\Close"
toolTip:	"Open\Close selected groups"
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
(
	actionMan.executeAction 0 "40143"  -- Groups: Group Close
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
buttontext:	"Hide"
toolTip:	"Hide visible group helpers"
--icon:	"#(path, index)"
(
	for obj in objects where isGroupHead(obj) and obj.layer.on do hide obj
)





