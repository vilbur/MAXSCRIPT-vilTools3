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

		for i = 1 to this.points_positions.count do
		(
			_point = Point name:(this._getName(i)) pos:this.points_positions[i] size:(this.Options.bar_width * 2) wirecolor:wirecolor Box:(i==1) showLinks:true

			/* SET FIRST TOP POINT OF SUPPORT AS MAIN POINT HELPER */
			if i == 1 then
				this.point_helper = _point
			else
				this._alignToVector (_point) (points_created[i - 1].pos) (_point.pos)


			/* LINK FIRST POINT TO SOURCE OBJECT, OTHER POINTS ARE LINKED IN CHAIN  */
			_point.parent = if i == 1 then source_obj else points_created[points_created.count]

			this._addToLayer (this.source_obj) (_point)

			this._saveUserDataToPointHelper()

			append points_created _point
		)

		point_helper --return first point

	),

	private

	/** Add vert pos
	  *
	  */
	function _setPointsPositions vert_pos =
	(
		--format "\n"; print "HelperObject_v._setPointsPositions()"

		if this.normal != undefined then
		(
			local _normal = this.normal * source_obj.transform - source_obj.pos
			--format "\nVERTEX: % NORMAL:  %" vertex_index normal.z


			/* USE ONLY VERTICES FACING DOWN OR SIDE - dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up ) */
			if _normal.z <= 0 then
			(
				append this.points_positions vert_pos

				normal_length = this.Options.normal_length

				/* ADD SECOND VERT TO KEEP NORMAL */
				if vert_pos.z > normal_length * 1.5 then -- if platform has enough space verticaly
				(
					--vert_pos = vert_pos + normal_length * normalize( _normal )
					--format "VECTOR	= % \n" (normalize( _normal ))
					vert_pos += normal_length * normalize( _normal ) -- MOVE POSITION ALONG NORMAL
					--format "_normal:	% \n" _normal

					/* MOVE POINT LITTLE DOWN IF NORMAL IS FACING TO SIDE */
					if _normal.z > -0.25 then
						vert_pos.z -= normal_length

					append this.points_positions vert_pos
				)
			)
			else
				format "\nVERTEX: % NOT USED - VERTEX NORMAL IS FACING UP:  %" vertex_index _normal.z
		)
		else
			format "ERROR: % \n" this


		--format "THIS.VERTS_POSITIONS	= % \n" this.points_positions
	),

	/** Get name
	 */
	function _getName index =
	(
		--format "\n"; print "HelperObject_v._getName()"
		source_obj.name + "-point-" + vertex_index as string + "-" + index as string
	),

	/** Add to layer
	 */
	function _addToLayer source_obj obj =
	(
		layer_name = source_obj.name + "-support"

		if ( layer = LayerManager.getLayerFromName (layer_name) ) == undefined then
			layer = LayerManager.newLayerFromName (layer_name)

		layer.setParent (source_obj.layer)

		layer.addNode obj
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

	/**
	 */
	on create do
	(
		this._setPointsPositions (pos)
	)
)