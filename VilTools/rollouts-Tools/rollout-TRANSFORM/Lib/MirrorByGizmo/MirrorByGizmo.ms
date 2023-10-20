

/** Mirror		 by gizmo
 */
struct MirrorByGizmo_v
(
	/* construct */
	objects_to_mirror,

	coord_center	= GetCoordCenter(), --  #LOCAL|#SELECTION|#SYSTEM -- #system is used as world "WORLD"

	mirror_axis,

	clone_type,

	/* properties */


	selection_center,

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
		this.clone_type = clone_type

		this.mirror_axis = toolMode.axisConstraints

		objects_to_mirror = this.getObjectsWithouGroupMembers( selection )

		mirrored_objects = #()

		selection_center = selection.center


		/* MIRROR EACH OBJECT  */
		--if coord_center != #SELECTION then
		for obj in objects_to_mirror do
			append (mirrored_objects)(this.mirrorObj (obj))

		mirrored_objects --return
	),

	/** Mirror obj
	  *
	  */
	function mirrorObj obj =
	(
		format "\n"; print "MirrorByGizmo_v.mirrorObj()"


		format "coord_center:	% \n" coord_center
		format "selection_center:	% \n" selection_center

		/** Get axis index
		  *
		  */
		function getAxisIndex = for i = 1 to ( axises_string = this.mirror_axis as string ).count collect findItem #( #X, #Y, #Z ) (axises_string[i] as name )

		mirror_tm = case mirror_axis of
		(
			#X:[-1, 1, 1]
			#Y:[ 1,-1, 1]
			#Z:[ 1, 1,-1]

			#XY:[-1,-1, 1]
			#YZ:[ 1,-1,-1]
			#ZX:[-1, 1,-1]
		)

		axises = #( #X, #Y, #Z )

		maxOps.cloneNodes obj cloneType:this.clone_type newNodes:&nll

		mirrored_obj = nll[1]

		mirrored_tm = mirrored_obj.transform * ( ScaleMatrix mirror_tm ) -- mirror by WORLD axis

		if coord_center != #SYSTEM then -- #LOCAL -- set mirrored positions to original positions
			mirrored_tm.pos = obj.pos

		if coord_center == #SELECTION then -- flip mirrored positions by selection center
		(
			offset = selection_center + (selection_center - obj.transform.pos)

			for axis in getAxisIndex() do
				case axis of
				(
					1: ( mirrored_tm.pos.x = offset.x )
					2: ( mirrored_tm.pos.y = offset.y )
					3: ( mirrored_tm.pos.z = offset.z )
				)
		)

		mirrored_obj.transform = mirrored_tm

		mirrored_obj --return
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
	function getObjectsWithouGroupMembers _objects =
	(
		mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

		children = #()

		groups_closed = for o in ( _selection = _objects as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

		getAllChildren groups_closed &children

		for o in _objects where findItem children o == 0 collect o --return
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
