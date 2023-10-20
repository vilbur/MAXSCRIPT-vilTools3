

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
		for source_obj in objects_to_mirror do
		(
			mirrored_obj = this.mirrorObj (source_obj)

			this._saveMirrorSetupToObjProps (source_obj) (mirrored_obj)

			append (mirrored_objects)(mirrored_obj)
		)

		mirrored_objects --return
	),

	/** Mirror source_obj
	  *
	  */
	function mirrorObj source_obj =
	(
		--format "\n"; print "MirrorByGizmo_v.mirrorObj()"

		/** Get axis index
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

		maxOps.cloneNodes source_obj cloneType:this.clone_type newNodes:&nll

		mirrored_obj = nll[1]

		mirrored_tm = mirrored_obj.transform * ( ScaleMatrix mirror_tm ) -- mirror by WORLD axis

		if coord_center != #SYSTEM then -- #LOCAL -- set mirrored positions to original positions
			mirrored_tm.pos = source_obj.pos

		if coord_center == #SELECTION then -- flip mirrored positions by selection center
		(
			offset = selection_center + (selection_center - source_obj.transform.pos)

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

	/** Get mirrored objects
	  *
	  */
	function getMirroredObjects object_set =
	(
		--format "\n"; print "MirrorByGizmo_v.getMirroredObjects()"
		for obj in object_set where getUserProp obj "mirror_setup" != undefined collect obj
	),

	/** Restore mirrors
	  *
	  * @param ObjectSet mirrored_objects obejcts with userprop "mirror_setup"
	  */
	function restoreMirrors mirrored_objects =
	(
		format "\n"; print "MirrorByGizmo_v.restoreMirrors()"
		format "mirrored_objects:	% \n" mirrored_objects
		for  mirrored_object in mirrored_objects where (mirror_setup = getUserProp mirrored_object "mirror_setup") != undefined do
			--format "mirrored_object:	% \n" mirrored_object
			this._restoreObject (mirrored_object) (execute mirror_setup)
	),

	private


	/** Restore object
	  *
	  */
	function _restoreObject mirrored_object mirror_setup =
	(
		format "\n"; print "MirrorByGizmo_v._restoreObject()"
		format "mirrored_object:	% \n" mirrored_object
		format "mirror_setup:	% \n" mirror_setup
		if (source_obj = getAnimByHandle mirror_setup[#source] ) != undefined  then
		(

			for key in mirror_setup.keys where key != #source do
				setProperty this key mirror_setup[key]

			delete mirrored_object

			remirrored = this.mirrorObj (source_obj)

		)

		remirrored --return
	),



	/** Save mirror setup to source_obj props
	  *
	  */
	function _saveMirrorSetupToObjProps source_obj mirrored_obj =
	(
		--format "\n"; print "MirrorByGizmo_v.saveMirrorSetupToObjProps()"
		setup = Dictionary()

		setup[#source]	= getHandleByAnim source_obj
		setup[#clone_type]	= clone_type
		setup[#mirror_axis]	= mirror_axis
		setup[#coord_center]	= coord_center

		setUserProp mirrored_obj "mirror_setup" (setup as string )
	),

	/** Replace name
	 */
	function replaceSideName source_obj =
	(
		--format "\n"; print ".replaceSideName()"
		--format "source_obj.name	= % \n" source_obj.name
		ignore_case = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase
		--RegEx = dotNetObject "System.Text.RegularExpressions.Regex"
		matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches source_obj.name "(LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP)" ignore_case
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
			source_obj.name	= ( dotNetObject "System.Text.RegularExpressions.Regex" (current_side+"\d+") ignore_case ).Replace source_obj.name other_side -- replace name E.G.: foo-Left001 >>> foo-Right
		)

		if source_obj.children.count > 0 then
			for child in source_obj.children do
				replaceSideName(child)
	),


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
