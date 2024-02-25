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

	/** Create or update helper
	 */
	function createOrUpdateHelper  =
	(
		format "\n"; print "HelperObject_v.createOrUpdateHelper()"
		--format "\n"; print "PlatformObject_v.generatePointHelper()"
		points_created	= #()

		/*------------------------------------------------------------------------------
			GENERATE POINTS
		--------------------------------------------------------------------------------*/
		if not isValidNode point_helper then
			for i = 1 to this.points_positions.count do
			(
				vert_pos = this.points_positions[i]

				_point = Point pos:vert_pos size:(this.Options.bar_width) wirecolor:(this._shiftWirecolor(copy this.wirecolor)(i)) Box:(i==1) showLinks:true -- shift wirecolor slightly , to group each level of point selectabel by wirecolor

				/*------------------------------------------------------------------------------
					!!!!!!! ALL POINTS ARE LINKED TO FIRST OF SOURCEOBEJCT

					Should be improved to respect EACH source object
				--------------------------------------------------------------------------------*/
				/* IF FIRST TOP POINT OF PLATFORM */
				if i == 1 then
					this.point_helper = _point

				_point.parent = if i == 1 then source_obj else points_created[points_created.count]

				this._addToLayer (this.source_obj) (_point)

				append points_created _point
			)

		point_helper --return first point

	),


	private

	/** Add vert pos
	  *
	  */
	function _setPointPositions vert_pos =
	(
		--format "\n"; print "PlatformObject_v._setPointPositions()"

		local normal = this.normal * source_obj.transform - source_obj.pos
		--local normal = this.normal

		/* USE ONLY VERTICES FACING DOWN OR SIDE - dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up ) */
		if normal.z <= 0 then
		(
			append this.points_positions vert_pos

			normal_length = this.Options.normal_length

			/* ADD ADDITIONAL VERT TO KEEP NORMAL */
			if vert_pos.z > normal_length * 1.5 then -- if platform has enough space verticaly
			(
				--vert_pos = vert_pos + normal_length * normalize( normal )
				vert_pos += normal_length * normalize( normal )
				--format "normal:	% \n" normal

				/* MOVE POINT LITTLE DOWN IF NORMAL IS FACING TO SIDE */
				if normal.z > -0.25 then
					vert_pos.z -= normal_length

				append this.points_positions vert_pos
			)
		)
		else
			format "VERTEX: % NOT USED - VERTEX NORMAL IS FACING UP:  %" vertex_index normal.z

		--format "THIS.VERTS_POSITIONS	= % \n" this.points_positions
	),

	/** Shift wirecolor sligtly
	  * Each level of points has different wirecolor for better selection
	  */
	function _shiftWirecolor wirecolor i =
	(
		--format "\n"; print "PlatformGenerator_v.shiftWirecolor()"
		--format "wirecolor:	% \n" wirecolor
		if wirecolor.r >= i then wirecolor.r -= i
		if wirecolor.g >= i then wirecolor.g -= i
		if wirecolor.b >= i then wirecolor.b -= i
		--format "wirecolor:	% \n" wirecolor

		wirecolor --return
	),

	/** Add to layer
	 */
	function _addToLayer source_obj obj =
	(
		layer_name = source_obj.name + "-platforms"

		if ( layer = LayerManager.getLayerFromName (layer_name) ) == undefined then
			layer = LayerManager.newLayerFromName (layer_name)

		layer.setParent (source_obj.layer)

		layer.addNode obj
	),

	/**
	 */
	on create do
	(
		this._setPointPositions (pos)



	)

)
