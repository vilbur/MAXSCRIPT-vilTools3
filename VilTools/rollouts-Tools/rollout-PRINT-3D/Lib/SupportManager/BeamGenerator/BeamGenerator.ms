/** Beam generator
 */
struct BeamGenerator_v
(
	/* construct */
	supports,

	/* properties */
	same_height	= false, -- Set height of beams on each support

	beams_created = #(),

	cross_instance = false,

	/* dependency */
	/* reference */
	/* inhered */
	Options,	--SupportOptions_v()

	/** Create cross section between supports
	  *
	  *
	  */
	function create _supports cross_instance:cross_instance =
	(
		--format "\n"; print "BeamGenerator_v.create()"
		--format "_supports	= % \n" _supports
		--format "_supports.count	= % \n" _supports.count

		this.supports = _supports

		--beams_created = #()

		this.filterEditSplineObjects()

		if supports.count < 2 then
			return false

		max create mode

		--format "supports.count:	% \n" supports.count
		for i = 1 to supports.count where supports[i + 1] != undefined do
			this._createBeamsBetweenTwoSuppotrts (supports[i]) (supports[i + 1])

		beams_created --return
	),

	private

	/** Create beams
	 */
	function _createBeamsBetweenTwoSuppotrts support_A support_B =
	(
		--format "\n"; print "BeamGenerator_v._createBeamsBetweenTwoSuppotrts()"
		/** Get beam postion on top and bottom
		 */
		function getPosOnLine direction modify_point distance_point =
		(
			--format "\n"; print "BeamGenerator_v.getBeamS()"

			--increment = (distance modify_point distance_point) / this.Options.connect -- Divide by 0|1|3 this.Options.connect:radiobuttons items:#('END', 'MIDDLE', 'QUATER')
			--
			--
			--if direction == #BOTTOM then
			--	modify_point.z += increment
			--else
			--	modify_point.z -= increment
			--
			--modify_point --return
		)

		beams_created = #()

		supports_order = #( support_A, support_B )

		beams_to_generate_count = if this.Options.connect == 2 then 1 else 2 -- do not generate cross beam if middle of supports i connected


		ends_A = this._getSegmentEndPoints(support_A)
		ends_B = this._getSegmentEndPoints(support_B)

		--if same_height then
		--(
		--	/* GET BOTTOM POS WHICH IS UPPER */
		--	pos_z_bottom = if ends_A[#BOTTOM].z > ends_B[#BOTTOM].z then ends_A[#BOTTOM].z else ends_B[#BOTTOM].z
		--
		--
		--	/* GET TOP POS WHICH IS LOWER */
		--	pos_z_top = if ends_A[#TOP].z > ends_B[#TOP].z then ends_A[#TOP].z else ends_B[#TOP].z
		--)


		offset = 30

		length_A = distance ends_A[#BOTTOM] ends_A[#TOP]
		length_B = distance ends_B[#BOTTOM] ends_B[#TOP]

		offset_bottom = length_A / 4
		offset_top = length_B / 4


		pos_bottom  = ends_A[#BOTTOM]	+ ( offset_bottom	* ends_A[#VECTOR]* -1)
		pos_top     = ends_B[#TOP]	+ ( offset_top	* ends_B[#VECTOR]  )

		new_beam = this._drawLine (support_A) (pos_bottom) (pos_top)


		this._addToGroup (new_beam) (support_A)

		/* COPY MODIFIERS OF PARENT SUPPORT NAME WHICH NAME IS MATCHING: "*BAR*" */
		for i = support_A.modifiers.count to 1 by -1 where matchPattern support_A.modifiers[i].name pattern:"*BAR*" do
			addModifier new_beam support_A.modifiers[i]

		append beams_created new_beam

		Options.setProp new_beam #this (getHandleByAnim new_beam)

		--Options.setProp new_beam #beam_supports #( Options.getThisPointer (supports_order[1]), Options.getThisPointer (supports_order[2]) )

		beams_created --return
	),

	/** Get segment ends
	 */
	function _getSegmentEndPoints support =
	(
		--format "\n"; print "BeamGenerator_v.getSegmentEnds()"
		num_knots	= ( numKnots support )

		/* GET INDEX OF USED POINTS */
		index_bottom	= if ( numSegments support 1) == 1 then 2 else num_knots - 1 -- get second point or second point from end ( above ground point )
		index_top	= index_bottom - 1

		/* GET POSITIONS OF POINTS */
		point_bottom	= getKnotPoint support	1 index_bottom	-- get 2. point from bottom
		point_top	= getKnotPoint support	1 index_top	-- get 1. or 2. point from top

		Dictionary #( #BOTTOM, point_bottom ) #( #TOP, point_top ) #( #VECTOR, normalize (point_bottom - point_top) ) --return
	),

	/** Create beam
	 */
	function _createBeam support_1 support_2 =
	(
		format "\n"; print "BeamGenerator_v._createBeam()"

		--/** Get beam postion on top and bottom
		-- */
		--function getPosOnLine direction modify_point distance_point =
		--(
		--	--format "\n"; print "BeamGenerator_v.getBeamS()"
		--
		--	increment = (distance modify_point distance_point) / this.Options.connect -- Divide by 0|1|3 this.Options.connect:radiobuttons items:#('END', 'MIDDLE', 'QUATER')
		--
		--
		--	if direction == #BOTTOM then
		--		modify_point.z += increment
		--	else
		--		modify_point.z -= increment
		--
		--	modify_point --return
		--)

		num_knots_1	= ( numKnots support_1 )
		num_knots_2	= ( numKnots support_2 )

		/* GET BOTTOM POINTS */
		i_bottom_1 = if ( numSegments support_1 1) == 1 then 2 else num_knots_1 - 1 -- get second point or second point from end ( above ground point )
		i_bottom_2 = if ( numSegments support_2 1) == 1 then 2 else num_knots_2 - 1


		/* GET POSITIONS OF POINTS */
		point_bottom_1	= getKnotPoint support_1	1 i_bottom_1	-- get 2. point from bottom
		point_bottom_2	= getKnotPoint support_2	1 i_bottom_2	-- get 2. point from bottom
		point_top_1	= getKnotPoint support_1	1 (i_bottom_1 - 1)	-- get 1. or 2. point from top
		point_top_2	= getKnotPoint support_2	1 (i_bottom_2 - 1)	-- get 1. or 2. point from top


		/* FIND BEAM START & END */
		--beam_start	= getPosOnLine #BOTTOM	(point_bottom_1)(point_top_1)
		--beam_end_top	= getPosOnLine #TOP	(point_top_2)(point_bottom_2)

		/* USE LOWER TOP POINT IF SAME HEIGHT */
		--if same_height and ( point_top_first_support = getPosOnLine #TOP(point_top_1)(point_bottom_1)).z < beam_end_top.z then
		--if same_height then
		--(
		--
		--
		--
		--	beam_end_top.z = point_top_first_support.z
		--)

		/* GET DISTANCE BETWEEN POINTS */
		--distance_between_points = this.getPointDistance (copy beam_start) (copy beam_end_top )
		--distance_between_points = this.getPointDistance (point_bottom_1) (point_bottom_2 )

		/* CHECK MAX DISTANCE BETWEEN POINTS */
		--if distance_between_points < this.Options.max_distance then
			--beam_obj = this._drawLine (support_1) (beam_start) (beam_end_top)

		--beam_obj --return
		 --return
	),



	/** Draw line
	 */
	function _drawLine support_A start_point end_point =
	(
		--format "\n"; print "BeamGenerator_v.drawLine()"
		cross_spline_id = 1 -- index of spline

		beam_obj = SplineShape name:(support_A.name + "-beam") wirecolor:(this._shiftWirecolor(support_A.wirecolor) )

		beam_obj.parent	= support_A
		beam_obj.wirecolor	= support_A.wirecolor

		addNewSpline beam_obj

		addKnot beam_obj cross_spline_id #corner #line start_point
		addKnot beam_obj cross_spline_id #corner #line end_point

		setMaterialID beam_obj cross_spline_id 1 this.Options.mat_ids[#BEAM] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

		updateShape beam_obj

		beam_obj.pivot = beam_obj.center

		--for i = support_A.modifiers.count to 1 by -1 do
		--	addModifier beam_obj support_A.modifiers[i]

		beam_obj --return
	),


	/** Get distance between points in 2D FROM TOP VIEW
	  */
	function getPointDistance point_1 point_2 =
	(
		--format "\n"; print "BeamGenerator_v.getPointDistance()"
		--point_1.z = point_2.z = 0 -- get distance in 2D -- COPY OF PARAMETERS IS NEEDED FOR THIS E.G.: point_1_copy = copy point_1

		distance point_1 point_2 --return
	),

	/** Filter edit spline objects
	  *
	  */
	function filterEditSplineObjects =
	(
		for support in supports where superClassOf support.baseobject == shape collect support
	),
	/** Add to group
	 */
	function _addToGroup support point_helper =
	(
		/** Find group
		 */
		function _findGroup obj =
		(
			--format "\n"; print "SupportGenerator_v.findGroup()"

			if isGroupMember obj then
			(
				while not isGroupHead obj.parent do
					obj = obj.parent

				obj.parent --return
			)
		)

		--format "\n"; print "SupportGenerator_v.addToGroup()"
		if ( _group = _findGroup point_helper ) != undefined then
			attachNodesToGroup support _group
	),

	/** Shift wirecolor sligtly to +1 - Helper points are shifter -1
	  *
	  *
	  *
	  * Each level of points has different wirecolor for better selection
	  */
	function _shiftWirecolor wirecolor =
	(
		--format "\n"; print "PlatformGenerator_v.shiftWirecolor()"
		--format "WIRECOLOR:	% \n" wirecolor
		i = 1

		wirecolor_shifted = copy wirecolor

		if wirecolor_shifted.r <= 254 then wirecolor_shifted.r += i
		if wirecolor_shifted.g <= 254 then wirecolor_shifted.g += i
		if wirecolor_shifted.b <= 254 then wirecolor_shifted.b += i
		--format "WIRECOLOR_SHIFTED:	% \n" wirecolor_shifted

		wirecolor_shifted --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "BeamObject.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
