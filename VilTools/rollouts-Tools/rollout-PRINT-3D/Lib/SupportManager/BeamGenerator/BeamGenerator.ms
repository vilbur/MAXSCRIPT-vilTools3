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
		format "\n"; print "BeamGenerator_v.create()"
		format "Options	= % \n" Options

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

			append beams_created (new_beam)

			setUserPropVal new_beam "BeamGenerator" #( getHandleByAnim supports_order[1], getHandleByAnim supports_order[2] )
		)


	),

	/** Create beam
	 */
	function _createBeam support_A support_B =
	(
		--format "\n"; print "BeamGenerator_v._createBeam()"
		num_knots	= ( numKnots support_A )
		num_knots_B	= ( numKnots support_B )

		point_bottom	= getKnotPoint support_A	1 (num_knots - 1)	-- get 2. point from bottom
		point_top	= getKnotPoint support_B	1 (num_knots_B - 2)	-- get 1. or 2. point from top

		distance_between_points = this.getPointDistance (copy point_bottom) (copy point_top)

		if point_top.z > this.Options.beams_min_height and  distance_between_points < this.Options.beams_max_distance then
		(
			point_bottom.z	+= (point_top.z / 4 )

			point_top.z	= (point_top.z / 4 ) * 3

			beam_obj = this._drawLine support_A point_bottom point_top
		)

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
		--format "point_bottom:	% \n" point_bottom
		--format "point_top:	% \n" point_top

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


	/** Get distance between points in 2D from top view
	  */
	function getPointDistance point_1 point_2 =
	(
		--format "\n"; print "BeamGenerator_v.getPointDistance()"
		point_1.z = 0
		point_2.z = 0

		distance point_1 point_2 --return
	),

	/** Filter edit spline objects
	  *
	  */
	function filterEditSplineObjects =
	(
		for platform in supports where superClassOf platform.baseobject == shape collect platform
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
