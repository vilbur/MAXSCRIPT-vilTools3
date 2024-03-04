/** Helper object
 */
struct HelperObject_v
(
	/* construct */
	source_obj,
	vertex_index,
	pos,
	normal,
	wirecolor,

	/* properties */
	point_helper,

	points_positions = #(), -- vertex positions to generate platforms

	/* dependency */
	/* reference */
	/* inhered */
	Options,

	/** Create helper
	 */
	function createHelper =
	(
		--format "\n"; print "HelperObject_v.createOrUpdateHelper()"
		--format "point_helper	= % \n" this.point_helper

		points_created	= #()

		this._setPointsPositions (pos)

		for i = 1 to this.points_positions.count do
		(
			_point = Point name:(this._getName()) pos:this.points_positions[i] size:(this.Options.bar_width * 2) wirecolor:(this._shiftWirecolor(i)) Box:(i==1) Cross:true showLinks:true

			/* SET FIRST TOP POINT OF SUPPORT AS MAIN POINT HELPER */
			if i == 1 then
				this.point_helper = _point
			else
				this._alignToVector (_point) (points_created[i - 1].pos) (_point.pos)


			/* LINK FIRST POINT TO SOURCE OBJECT, OTHER POINTS ARE LINKED IN CHAIN  */
			_point.parent = if i == 1 then source_obj else points_created[points_created.count]

			/* ADD TO LAYER OF SOURCE OBJECT */
			source_obj.layer.addNode _point

			/* SAVE USER PROPS DATA TO OBEJCT */
			this._saveUserDataToPointHelper()

			append points_created _point
		)

		point_helper --return first point

	),

	private

	/** Elaboate position of helper points
	  *
	  */
	function _setPointsPositions vert_pos =
	(
		--format "\n"; print "HelperObject_v._setPointsPositions()"

		/* GET POINT CHAIN BY NORMALS */
		if this.Options.use_normals and this.normal != undefined then
		(
			local _normal = this.normal * source_obj.transform - source_obj.pos
			--local _normal = this.normal
			--format "\nVERTEX: % NORMAL:  %" vertex_index normal.z
			normal_limit = this.Options.normal_limit


			/* if normal_limit is on: THEN USE ONLY VERTICES FACING DOWN OR SIDE - dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up ) */
			if not normal_limit or ( normal_limit and _normal.z <= 0 ) then
			(
				append this.points_positions vert_pos

				local second_vert = copy vert_pos

				local normal_length = this.Options.normal_length

				/* ADD SECOND VERT TO KEEP NORMAL */
				if not normal_limit or ( normal_limit and vert_pos.z > normal_length * 1.5 ) then -- if platform has enough space verticaly
				(
					--vert_pos = vert_pos + normal_length * normalize( _normal )
					--format "VECTOR	= % \n" (normalize( _normal ))
					second_vert += normal_length * normalize( _normal ) -- MOVE POSITION ALONG NORMAL
					--format "_normal:	% \n" _normal

					--/* MOVE POINT LITTLE DOWN IF NORMAL IS FACING TO SIDE */
					--if normal_limit and _normal.z > -0.25   then
					--	vert_pos.z -= normal_length

					if this.Options.keep_down and ( difference = vert_pos.z - vert_pos.z ) < this.Options.keep_down_limit then
						second_vert.z -= this.Options.keep_down_limit - difference



					append this.points_positions second_vert
				)
			)
			else if normal_limit then
				format "\nVERTEX: % NOT USED - VERTEX NORMAL IS FACING UP:  %" vertex_index _normal.z
		)

		/* DO NOT USE NORMALS */
		else if not this.Options.use_normals and this.normal != undefined then
			append this.points_positions vert_pos

		else
			format "ERROR IN: HelperObject_v._setPointsPositions()\n\n GETTING NORMAL OF POINT: %\n\nOBJECT: % \n" source_obj vertex_index

		--format "THIS.VERTS_POSITIONS	= % \n" this.points_positions
	),

	/** Get name
	 */
	function _getName =
	(
		--format "\n"; print "HelperObject_v._getName()"

		name_stripped = substituteString source_obj.name "-source" ""

		name_stripped + "-point-" + vertex_index as string -- + "-" + index as string
	),


	/** Align to ctor
	 */
	function _alignToVector obj p1 p2 =
	(
		--format "\n"; print "HelperObject_v._alignToCtor()"
		--format "obj	= % \n" obj
		--format "% %\n" p1 p2

		dir = normalize (p2 - p1)

		axis = #z

		vec = case axis of
		(
			#x: obj.transform[1]
			#y: obj.transform[2]
			#z: obj.transform[3]
		)

		tm  = obj.transform
		vec = normalize vec
		dir = normalize dir
		rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))

		obj.transform = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos

		if pos == true then
			obj.pos = p1
	),

	/** Set data about source object to first  point
	  *
	  * IMPORTANT: Other point in chain are without user data for easy editation, copy, linking etc.
	  *
	 */
	function _saveUserDataToPointHelper =
	(
		--format "\n"; print "HelperObject_v._saveUserDataToPointHelper()"
		--Options.syncProp source_obj point_helper #source_object destination_key:#pointer_sync

		Options.setProp point_helper #pointer_sync  (( Options.getProp source_obj #source_object ) as IntegerPtr )
		Options.setProp point_helper #this	  ( getHandleByAnim point_helper )
		Options.setProp point_helper #source_vert	  ( vertex_index )
	),
	/** Shift wirecolor sligtly
	  * Each level of points has different wirecolor for better selection
	  */
	function _shiftWirecolor i =
	(
		--format "\n"; print "PlatformGenerator_v.shiftWirecolor()"
		--format "wirecolor:	% \n" wirecolor
		wirecolor_shifted = copy this.wirecolor


		if wirecolor_shifted.r >= i then wirecolor_shifted.r -= i
		if wirecolor_shifted.g >= i then wirecolor_shifted.g -= i
		if wirecolor_shifted.b >= i then wirecolor_shifted.b -= i
		--format "wirecolor_shifted:	% \n" wirecolor_shifted

		wirecolor_shifted --return
	),

	/**
	 */
	on create do
	(
	)
)