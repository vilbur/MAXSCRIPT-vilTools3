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
macroscript	group_uppercase_selected
category:	"_Group"
buttontext:	"Uppercase"
toolTip:	"Uppercase names of selected groups"
--icon:	"#(path, index)"
(
	--filein (@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-GROUPS\Group.mcr")
	for _group in selection where isGroupHead _group do
		_group.name = toUpper _group.name

)
