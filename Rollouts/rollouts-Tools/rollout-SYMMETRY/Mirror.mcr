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
			#LEFT:   "right"
			#RIGHTR: "left"
			#BACK:   "front"
			#FRONT:  "back"
			#TOP:    "bottom"
			#BOTTOM: "top"
		)
		obj.name	= ( dotNetObject "System.Text.RegularExpressions.Regex" current_side ignore_case ).Replace obj.name other_side
	)

	if obj.children.count > 0 then
		for child in obj.children do
			replaceSideName(child)
)

/** Mirror selection
 */
function mirrorSelection axis =
(
	mirror_tm = case axis of
	(
		#x:[-1,1,1]	
		#y:[1,-1,1]	
		#z:[1,1,-1]	
	)

	undo "Mirror" on
	(
		groups_children = #()

		for o in selection where isGroupHead o do groups_children += o.children

		objects_to_mirror = for o in selection where findItem groups_children o == 0 collect o

		new_instances = #()

		for obj in objects_to_mirror do
		(
			maxOps.cloneNodes obj cloneType:#instance newNodes:&nnl

			_instance = nnl[1]

			append new_instances _instance

			tm=_instance.transform

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
category:	"_Selection"
buttontext:	"Mirror X"
toolTip:	"Mirror instances in world axis"
--icon:	"#(path, index)"
(
	clearListener()
	filein (@"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr")

	mirrorSelection(#x)
)

/**  
  *	
  */
macroscript	selection_mirror_y
category:	"_Selection"
buttontext:	"Mirror Y"
toolTip:	"Mirror instances in world axis"
--icon:	"#(path, index)"
(
	clearListener()
	filein (@"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr")

	mirrorSelection(#y)
)

/**  
  *	
  */
macroscript	selection_mirror_z
category:	"_Selection"
buttontext:	"Mirror Z"
toolTip:	"Mirror instances in world axis"
--icon:	"#(path, index)"
(
	clearListener()
	filein (@"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-SYMMETRY\Mirror.mcr")

	mirrorSelection(#z)
)
