
/** Mirror		 by gizmo
 */
struct MirrorByGizmo_v
(
	/* construct */
	objects_to_mirror,

	/* setup */
	coord_center	= GetCoordCenter(), --  #LOCAL|#SELECTION|#SYSTEM -- #system is used as world "WORLD"

	mirror_axis,

	clone_type,

	selection_center,

	/* properties */
	user_prop_key = "mirror_setup",

	/** Mirror by current state of gizmo
	  *
	  * MIRROR BY WORLD: coordsys:#WORLD
	  *
	  *
	  * @param #WOLRD|#PIVOT Mirror by world axis or object pivot
	  *
	 */
	function mirrorObjects objects_to_mirror clone_type =
	(
		format "\n"; print "MirrorByGizmo_v.mirrorObjects()"
		mirrored_objects = #()

		this.objects_to_mirror = objects_to_mirror as Array

		this._getObjectsWithoutGroupMembers()
		--format "\n-----------\nARRAY:objects_to_mirror:\n";  for obj in this.objects_to_mirror do format "obj:	%\n" obj.name

		this.clone_type = clone_type

		this.mirror_axis = toolMode.axisConstraints

		selection_center = selection.center

		/* MIRROR EACH OBJECT  */
		--if coord_center != #SELECTION then
		for source_obj in this.objects_to_mirror do
			append (mirrored_objects)(this.mirrorObj (source_obj))

		mirrored_objects --return
	),

	/** Mirror source_obj
	  *
	  */
	function mirrorObj source_obj =
	(
		format "\n"; print "MirrorByGizmo_v.mirrorObj()"

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

		if coord_center != #SYSTEM then -- if #LOCAL|#SELECTION -- set mirrored positions to original positions
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

		this._saveMirrorSetupToObjProps (source_obj) (mirrored_obj)

		this._replaceName(mirrored_obj)

		mirrored_obj --return
	),

	private


	/** Save mirror setup to source_obj props
	  *
	  */
	function _saveMirrorSetupToObjProps source_obj mirrored_obj =
	(
		format "\n"; print "MirrorByGizmo_v.saveMirrorSetupToObjProps()"
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
		format "\n"; print "MirrorByGizmo_v.setUserProps()"
		setUserProp obj user_prop_key ( mirror_setup as string )
	),

	/** Replace name
	 */
	function _replaceName mirrored_obj =
	(
		format "\n"; print "MirrorByGizmo_v._replaceName()"
		format "mirrored_obj.name:	% \n" mirrored_obj.name
		--mirrored_obj.name = this._removeSuffixWihtoutDelimeter(mirrored_obj.name)

		orientation_match = this._rxGetMatch (mirrored_obj.name)("(LEFT|RIGHT|FRONT|BACK|BOTTOM|TOP)\d*$")

		if orientation_match.count > 0 then
		(
			other_side = case (current_side = orientation_match[2] ) as name of
			(
				#LEFT:   "Right"
				#RIGHT:  "Left"
				#BACK:   "Front"
				#FRONT:  "Back"
				#TOP:    "Bottom"
				#BOTTOM: "Top"
			)

			mirrored_obj.name = this._rxReplace (mirrored_obj.name) (current_side) (other_side) -- replace orientation keyword with trailing number of copy e.g.: copied-object-right001 >> copied-object-left
		)

		if isGroupHead mirrored_obj then
			for child in this._getGroupMembers (mirrored_obj) do
				child.name = this._rxReplace (this._removeSuffixWihtoutDelimeter(child.name)) (current_side) (other_side)
	),

	--/**  if name match trailing number without delimeter e.g.: object-right001
	--  *		themnremove it e.g.: copied-object-right001 >> copied-object-left
	--  */
	--function _removeSuffixWihtoutDelimeter obj_name =
	--(
	--	format "\n"; print "MirrorByGizmo_v.removeSuffixWihtoutDelimeter()"
	--	format "obj_name:	% \n" obj_name
	--	if (this._rxGetMatch (obj_name)("[A-Z]\d+$")).count > 0 then
	--	  obj_name = this._rxReplace (obj_name) ("\d+$") ("")
	--
	--	 obj_name --return
	--),

	/** Get selection without members of closed group
	 */
	function _getObjectsWithoutGroupMembers =
	(
		/* REMOVE OBJECTS WITH PARENT IN SELECTION E.G.: Remove group members from selection */
		this.objects_to_mirror = for obj in ( this.objects_to_mirror ) where obj.parent == undefined or ( obj.parent != undefined and findItem this.objects_to_mirror obj.parent == 0 ) collect obj
	),


	/** Get group members
	  *
	  */
	function _getGroupMembers _group =
	(
		format "\n"; print "MirrorByGizmo_v._getGroupMembers()"

		children_all = #()

		this.getAllChildren #( _group ) ( children_all )

		children_all --return
	),

	mapped function getAllChildren _node &children = ( join children _node.children;	if _node.children.count > 0 then this.getAllChildren _node.children &children ),


	/** Regex get match
	  */
	function _rxGetMatch _string pattern ignore_case:true =
	(
		--format "\n"; print "MirrorByGizmo_v._rxGetMatch()"
		--format "pattern:	% \n" pattern

		RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

		IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		matches = if ignore_case then RegEx.matches _string pattern IgnoreCase else RegEx.matches _string pattern
		--format "matches:	% \n" matches
		--format "matches.count:	% \n" matches.count
		groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		--format "groups:	% \n" groups
		if groups.count == 1 then groups[1] else groups
	),

	/** Regex replace
	  */
	function _rxReplace _string _search _replace ignore_case:true =
	(
		format "\n"; print "MirrorByGizmo_v._rxReplace()"
		format "_string:	% \n" _string
		format "_search:	% \n" _search

		--match = this._rxGetMatch ( _string )( _search )
		----format "match:	% \n" match
		--
		--if match.count > 0 then
		--(
		--
		--	is_uppercase = (this._rxGetMatch (match[1])("[a-z]") ignore_case:false ).count == 0
		--	is_lowercase = (this._rxGetMatch (match[1])("[A-Z]") ignore_case:false ).count == 0
		--
		--	if is_uppercase then
		--		_replace = toUpper _replace
		--
		--	else if is_lowercase then
		--		_replace = toLower _replace
		--
		--	format "_search:	% \n" _search
		--	format "_replace:	% \n" _replace
		--	format "is_uppercase:	% \n" is_uppercase
		--	format "is_lowercase:	% \n" is_lowercase
		--
			RegExReplace = ( dotNetObject "System.Text.RegularExpressions.Regex" _search ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase )
		--
			RegExReplace.Replace _string _replace
		--)
		--else
		--	_string
	),

	/**
	 */
	on create do
	(
		format "\n"; print "MirrorByGizmo.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
