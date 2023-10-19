

/** Mirror by gizmo
 */
struct MirrorByGizmo_v
(
	/* construct */
	/* properties */

	/** Mirror by current state of gizmo
	  *
	  * MIRROR BY WORLD: coordsys:#WORLD
	  *
	  *
	  * @param #WOLRD|#PIVOT Mirror by world axis or object pivot
	  *
	 */
	function mirrorSelection clone_type =
	(
		/* GET CURRENT ACTIVE AXISES */

		objects_to_mirror = this.getSelectionWithouGroupMembers()

		new_instances = #()

		mirror_tm = case toolMode.axisConstraints of
		(
			#X:[-1, 1, 1]
			#Y:[ 1,-1, 1]
			#Z:[ 1, 1,-1]

			#XY:[-1,-1, 1]
			#YZ:[ 1,-1,-1]
			#ZX:[-1, 1,-1]
		)

		for obj in objects_to_mirror do
		(
			maxOps.cloneNodes obj cloneType:clone_type newNodes:&nnl

			_instance = nnl[1]

			append new_instances _instance

			mirrored_transform = _instance.transform * ( ScaleMatrix mirror_tm )

			if GetCoordCenter() == #LOCAL then -- mirro by each object pivot
				mirrored_transform.pos = _instance.transform.pos

			_instance.transform = mirrored_transform

			this.replaceSideName (_instance)
		)

		select new_instances

	),

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
	),

	private

	/** Get selection without members of closed group
	 */
	function getSelectionWithouGroupMembers =
	(
		mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

		children = #()

		groups_closed = for o in ( _selection = selection as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

		getAllChildren groups_closed &children

		for o in selection where findItem children o == 0 collect o --return
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "MirrorByGizmo.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
