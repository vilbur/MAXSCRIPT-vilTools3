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
			this._createBeams (supports[i]) (supports[i + 1])

		beams_created --return
	),

	private

	/** Create beams
	 */
	function _createBeams support_A support_B =
	(
		--format "\n"; print "BeamGenerator_v._createBeams()"
		beams_created = #()

		supports_order = #( support_A, support_B )

		for i = 1 to 2 do
		(
			if i == 2 then -- reverse array
				supports_order = for i = supports_order.count to 1 by -1 collect supports_order[i]

			new_beam = this._createBeam (supports_order[1])(supports_order[2])

			if new_beam != undefined then
			(
				this._addToGroup (new_beam) (support_A)

				/* COPY MODIFIERS OF PARENT SUPPORT NAME WHICH NAME IS MATCHING: "*BAR*" */
				for i = support_A.modifiers.count to 1 by -1 where matchPattern support_A.modifiers[i].name pattern:"*BAR*" do
					addModifier new_beam support_A.modifiers[i]

				append beams_created (new_beam)

				Options.setProp new_beam #this (getHandleByAnim new_beam)

				Options.setProp new_beam #beam_supports #( getHandleByAnim supports_order[1], getHandleByAnim supports_order[2] )
			)
		)
	),

	/** Create beam
	 */
	function _createBeam support_1 support_2 =
	(
		format "\n"; print "BeamGenerator_v._createBeam()"

		/** Get top sition
		 */
		--function getPositionTop    pos = (pos.z *= 3 / 4.0; pos) --return
		--function getPositionBottom pos = (pos.z *= 2.0;    pos) --return
		--function getPositionTop    pos = pos --return
		--function getPositionBottom pos = pos --return
		--function getPositionBottom pos point_bottom point_top = (pos.z += (distance point_bottom point_top) / 4; pos) --return
		--function getPositionTop 	pos point_bottom point_top = (pos.z -= (distance point_bottom point_top) / 4; pos) --return

		/** Get beam postion on top and bottom
		 */
		function getBeamPosition direction modify_point distance_point =
		(
			--format "\n"; print "BeamGenerator_v.getBeamS()"

			increment = (distance modify_point distance_point) / this.Options.connect -- Divide by 0|1|3 this.Options.connect:radiobuttons items:#('END', 'MIDDLE', 'QUATER')


			if direction == #BOTTOM then
				modify_point.z += increment
			else
				modify_point.z -= increment

			modify_point --return
		)


		num_knots_1	= ( numKnots support_1 )
		num_knots_2	= ( numKnots support_2 )

		segments_1 = num_knots_1 - 1
		segments_2 = num_knots_2 - 1

		i_bottom_1 = if segments_1 == 1 then 2 else num_knots_1 - 1 -- get second point or second point from end ( above ground point )
		i_bottom_2 = if segments_2 == 1 then 2 else num_knots_2 - 1



		point_bottom_1	= getKnotPoint support_1	1 i_bottom_1	-- get 2. point from bottom
		point_bottom_2	= getKnotPoint support_2	1 i_bottom_2	-- get 2. point from bottom
		point_top_1	= getKnotPoint support_1	1 (i_bottom_1 - 1)	-- get 1. or 2. point from top
		point_top_2	= getKnotPoint support_2	1 (i_bottom_2 - 1)	-- get 1. or 2. point from top
		format "point_bottom_1: %\n" point_bottom_1
		format "point_top_1: %\n" point_top_1
		format "point_top_2: %\n" point_top_2
--		point_bottom_1 = point_bottom_1 / 10
--		point_top_1 = point_top_1 / 10
--		point_top_2 = point_top_2 / 10
--format "\n"

		format "point_bottom_1: %\n" point_bottom_1
		format "point_top_1: %\n" point_top_1
		format "point_top_2: %\n" point_top_2

		beam_start	= getBeamPosition #BOTTOM (point_bottom_1)(point_top_1)

		beam_end_top	= getBeamPosition #TOP(point_top_2)(point_bottom_2)

		if same_height and ( point_top_first_support = getBeamPosition #TOP(point_top_1)(point_bottom_1)).z < beam_end_top.z then
			beam_end_top.z = point_top_first_support.z

		distance_between_points = this.getPointDistance (copy beam_start) (copy beam_end_top )

		--if beam_start.z > this.Options.beams_min_height and  distance_between_points < this.Options.beams_max_distance then
			beam_obj = this._drawLine (support_1) (beam_start) (beam_end_top)

		beam_obj --return
	),



	/** Draw line
	 */
	function _drawLine support_A start_point end_point =
	(
		--format "\n"; print "BeamGenerator_v.drawLine()"
		cross_spline_id = 1 -- index of spline

		beam_obj = SplineShape name:(support_A.name + "-beam")


		beam_obj.parent	= support_A
		beam_obj.wirecolor	= support_A.wirecolor


		addNewSpline beam_obj
		format "start_point:	% \n" start_point
		format "end_point:	% \n" end_point

		addKnot beam_obj cross_spline_id #corner #line start_point
		addKnot beam_obj cross_spline_id #corner #line end_point

		setMaterialID beam_obj cross_spline_id 1 this.Options.mat_ids[#BEAM] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>
		--setMaterialID beamV_obj cross_spline_id 1 6

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
		point_1.z = point_2.z = 0

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
				(
					format "\n\n"
					format "obj.parent: %\n" obj.parent

					obj = obj.parent
				)
				obj.parent --return
			)
		)

		--format "\n"; print "SupportGenerator_v.addToGroup()"
		if ( _group = _findGroup point_helper ) != undefined then
			attachNodesToGroup support _group
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
