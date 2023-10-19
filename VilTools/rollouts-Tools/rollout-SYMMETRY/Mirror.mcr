/*------------------------------------------------------------------------------
	SELECT INTANCES
--------------------------------------------------------------------------------*/
/** Replace name
 */
function replaceSideName obj =
(
	--format "\n"; print ".replaceSideName()"
	--format "obj.name	= % \n" obj.name
	ignore_case = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase
	--RegEx = dotNetObject "System.Text.RegularExpressions.Regex"
	matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches obj.name "(LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP)" ignore_case
	result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
	--format "result	= % \n" result

	if result.count > 0 then
	(
		other_side = case (current_side = result[1][1] ) as name of
		(
			#LEFT:   "Right"
			#RIGHTR: "Left"
			#BACK:   "Front"
			#FRONT:  "Back"
			#TOP:    "Bottom"
			#BOTTOM: "Top"
		)
		obj.name	= ( dotNetObject "System.Text.RegularExpressions.Regex" (current_side+"\d+") ignore_case ).Replace obj.name other_side -- replace name E.G.: foo-Left001 >>> foo-Right
	)

	if obj.children.count > 0 then
		for child in obj.children do
			replaceSideName(child)
)

/** Mirror selection
 */
function mirrorSelection axis =
(

	/** Get selection without members of closed group
	 */
	function getSelectionWithouGroupMembers =
	(
		mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

		children = #()

		groups_closed = for o in ( _selection = selection as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

		getAllChildren groups_closed &children

		for o in selection where findItem children o == 0 collect o --return
	)

	mirror_tm = case axis of
	(
		#x:[-1, 1, 1]
		#y:[1, -1, 1]
		#z:[1, 1, -1]
	)

	undo "Mirror" on
	(
		objects_to_mirror = getSelectionWithouGroupMembers()

		new_instances = #()

		for obj in objects_to_mirror do
		(
			maxOps.cloneNodes obj cloneType:#instance newNodes:&nnl

			_instance = nnl[1]

			append new_instances _instance

			tm = _instance.transform

			mirroredTm=tm*( ScaleMatrix mirror_tm )

			_instance.transform=mirroredTm

			replaceSideName (_instance)
		)
		select new_instances
	)
)

/**
  *
  */
macroscript	selection_mirror_x
category:	"_Mirror"
buttontext:	"Mirror X"
toolTip:	"Mirror instances in world axis.\n\nRename mirrored objects LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP"
icon:	"MENU:true"
(
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"

		undo "Mirror X" on
			mirrorSelection(#X)
	)
)

/**
  *
  */
macroscript	selection_mirror_y
category:	"_Mirror"
buttontext:	"Mirror Y"
toolTip:	"Mirror instances in world axis"
icon:	"MENU:true"
(

	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"

		undo "Mirror Y" on
			mirrorSelection(#Y)
	)
)

/**
  *
  */
macroscript	selection_mirror_z
category:	"_Mirror"
buttontext:	"Mirror Z"
toolTip:	"Mirror instances in world axis"
icon:	"MENU:true"
(
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr"

		undo "Mirror Z" on
			mirrorSelection(#Z)
	)

)
