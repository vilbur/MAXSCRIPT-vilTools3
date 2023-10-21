

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

	objects_to_mirror_source,

	user_prop_key = "mirror_setup",

	mirror_sources = Dictionary( #string ), -- #( "objectPointerOfSourceObject", #(mirrored_nodes) )

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
		this.objects_to_mirror_source = selection

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

			this.replaceName(mirrored_obj)

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
	function getMirroredObjects _objects =
	(
		--format "\n"; print "MirrorByGizmo_v.getMirroredObjects()"
		if classOf _objects == ObjectSet then
			_objects = _objects as Array


		mirrored_objects = for obj in _objects where this._getMirrorSetupData(obj) != undefined collect obj

		if mirrored_objects.count > 0 then
			mirrored_objects --return
		else
			#() -- fallback
	),

	/** Restore mirrors
	  *
	  * @param ObjectSet mirrored_objects obejcts with userprop user_prop_key
	  */
	function restoreMirrors mirrored_objects =
	(
		--format "\n"; print "MirrorByGizmo_v.restoreMirrors()"
		this._setMirrorSources()

		mirrored_objects = this.getMirroredObjects (mirrored_objects)

		re_mirrored_objects = #()

		for  mirrored_obj in mirrored_objects do
			append (re_mirrored_objects) (this._restoreObject (mirrored_obj))


		if re_mirrored_objects.count == 0 then
			messageBox "Nothing to restore" title:"RESTORE MIRRORED OBJECTS"  beep:false


		mirrored_objects --return
	),

	/** Get source object
	  *
	  */
	function getSourceObjects objects_to_search =
	(
		--format "\n"; print "MirrorByGizmo_v.getSourceObjects()"
		source_objects = #()

		mirrored_objects = this.getMirroredObjects (objects_to_search)

		for mirrored_obj in mirrored_objects do
		(
			mirror_setup = this._getMirrorSetupData (mirrored_obj)

			source_obj = getAnimByHandle mirror_setup[#source]

			if isValidNode source_obj then
				appendIfUnique source_objects source_obj

		)

		source_objects --return
	),


	private


	/** Restore object
	  *
	  */
	function _restoreObject mirrored_obj  =
	(
		--format "\n"; print "MirrorByGizmo_v._restoreObject()"

		/** Replace source object in objects
		  *
		  */
		function replaceSourceInObjects mirrored_pointer remirrored_pointer =
		(
			--format "\n"; print "MirrorByGizmo_v.replaceSourceInObjects()"
			for mirror_source_pointer in mirror_sources.keys where mirror_source_pointer == mirrored_pointer as string do
				for mirrored_obj in mirror_sources[mirror_source_pointer] where isValidNode mirrored_obj do
				(
					mirror_setup = this._getMirrorSetupData (mirrored_obj)

					mirror_setup[#source] = remirrored_pointer

					this._setUserProps (mirrored_obj) (mirror_setup)
				)
		)

		mirror_setup = this._getMirrorSetupData (mirrored_obj)

		if (source_objects = this.getSourceObjects (mirrored_obj) ) != undefined  then
		(

			source_obj = source_objects[1]

			/* CONFIGURE this for restore mirroring */
			for key in mirror_setup.keys where key != #source do
				setProperty this key mirror_setup[key]

			transform_bak	= mirrored_obj.transform
			parent_bak	= mirrored_obj.parent

			mirrored_pointer = getHandleByAnim mirrored_obj

			delete mirrored_obj
			--format "source_obj:	% \n" source_obj
			remirrored_obj = this.mirrorObj (source_obj)

			replaceSourceInObjects (mirrored_pointer) (getHandleByAnim remirrored_obj)

			this._saveMirrorSetupToObjProps (source_obj) (remirrored_obj)

			this.replaceName(remirrored_obj)

			remirrored_obj.transform	= transform_bak
			remirrored_obj.parent	= parent_bak

		)

		remirrored_obj --return
	),

	/** Get mirrored objects in scene
	  *
	  */
	function _setMirrorSources =
	(
		--format "\n"; print "MirrorByGizmo_v._setMirrorSources()"
		mirrored_objects_in_scene = this.getMirroredObjects ( objects )
		--format "mirrored_objects_in_scene:	% \n" mirrored_objects_in_scene
		for obj in mirrored_objects_in_scene do
		(
			mirror_setup = this._getMirrorSetupData(obj)
			--format "mirror_setup:	% \n" mirror_setup
			source_pointer = mirror_setup[#source] as string
			--format "source_pointer:	% \n" source_pointer
			if mirror_sources[source_pointer] == undefined then
				mirror_sources[source_pointer] = #()

			append mirror_sources[source_pointer] obj
		)
		--format "mirror_sources:	% \n" mirror_sources

	),

	/** Get mirror setup data
	  *
	  */
	function _getMirrorSetupData mirrored_obj =
	(
		--format "\n"; print "MirrorByGizmo_v._getMirrorSetupData()"

		mirror_setup = getUserProp mirrored_obj user_prop_key
		--format "mirror_setup:	% \n" mirror_setup
		if mirror_setup != undefined  then
			execute mirror_setup --return
	),


	/** Save mirror setup to source_obj props
	  *
	  */
	function _saveMirrorSetupToObjProps source_obj mirrored_obj =
	(
		--format "\n"; print "MirrorByGizmo_v.saveMirrorSetupToObjProps()"
		mirror_setup = Dictionary()

		mirror_setup[#source]	= getHandleByAnim source_obj
		mirror_setup[#clone_type]	= clone_type
		mirror_setup[#mirror_axis]	= mirror_axis
		mirror_setup[#coord_center]	= coord_center

		this._setUserProps (mirrored_obj) (mirror_setup)
	),

	/** Set user props
	  *
	  */
	function _setUserProps obj mirror_setup =
	(
		--format "\n"; print "MirrorByGizmo_v.setUserProps()"
		setUserProp obj user_prop_key ( mirror_setup as string )
	),

	/** Replace name
	 */
	function replaceName mirrored_obj =
	(
		--format "\n"; print ".replaceName()"
		orientation_match = this._rxGetMatch (mirrored_obj.name)("(LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP)\d*$")
		--format "orientation_match:	% \n" orientation_match

		if orientation_match.count > 0 then
		(
			other_side = case (current_side = orientation_match[2] ) as name of
			(
				#LEFT:   "Right"
				#RIGHTR: "Left"
				#BACK:   "Front"
				#FRONT:  "Back"
				#TOP:    "Bottom"
				#BOTTOM: "Top"
			)

			mirrored_obj.name = this._rxReplace (mirrored_obj.name) (current_side+"\d*") (other_side)
		)

		if mirrored_obj.children.count > 0 then
			for child in mirrored_obj.children do
				this.replaceName(child)
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

	/** Regex get match
	  */
	function _rxGetMatch _string pattern ignore_case:true =
	(
		RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

		IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		matches = if ignore_case then RegEx.matches _string pattern IgnoreCase else RegEx.matches _string pattern

		groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return

		if groups.count == 1 then groups[1] else groups
	),

	/** Regex replace
	  */
	function _rxReplace _string _search _replace ignore_case:true =
	(
		IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		RegExReplace = if ignore_case then ( dotNetObject "System.Text.RegularExpressions.Regex" _search IgnoreCase ) else ( dotNetObject "System.Text.RegularExpressions.Regex" _search )

		RegExReplace.Replace _string _replace
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
