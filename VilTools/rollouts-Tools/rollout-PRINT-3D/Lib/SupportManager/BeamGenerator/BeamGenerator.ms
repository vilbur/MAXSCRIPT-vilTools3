/** Beam generator
 */
struct BeamGenerator_v
(
	/* construct */
	supports,

	/* properties */

	/* dependency */
	/* reference */
	/* inhered */
	Options,	--SupportOptions_v()

	/** Create cross section between supports
	  *
	  *
	  */
	function create _supports =
	(
		format "\n"; print "BeamGenerator_v.create()"

		this.supports = _supports

		beams_created = #()

		this.filterEditSplineObjects()

		if supports.count < 2 then
			return false

		max create mode

		--format "supports.count:	% \n" supports.count
		for i = 1 to supports.count where supports[i + 1] != undefined do
		(
			format "\ni:	% \n" i


			platform_A	= supports[i]
			num_knots	= ( numKnots platform_A )

			platform_B	= supports[i + 1]
			num_knots_B	= ( numKnots platform_B )

			--top_point_index = if num_knots_B <= 3 then 1 else 2 --get 1. or 2. point from top

			--format "num_knots:	% \n" num_knots
			--format "num_knots_B:	% \n" num_knots_B

			point_bottom	= getKnotPoint platform_A	1 (num_knots - 1)	-- get 2. point from bottom
			point_top	= getKnotPoint platform_B	1 (num_knots_B - 2)	-- get 1. or 2. point from top

			--format "point_bottom:	% \n" point_bottom
			--format "point_top.z:	% \n" point_top.z

			distance_between_platforms = this.getPointDistance (copy point_bottom) (copy point_top)
			format "distance_between_platforms:	% \n" distance_between_platforms
			format "this.Options.beams_max_distance:	% \n" this.Options.beams_max_distance

			--if point_top.z > this.Options.cross_section_min_height and distance_between_platforms < this.Options.beams_max_distance then
			if point_top.z > this.Options.cross_section_min_height and  distance_between_platforms < this.Options.beams_max_distance then
			(

				point_bottom.z	+= (point_top.z / 4 )

				point_top.z	= (point_top.z / 4 ) * 3

				cross_spline_id = 1 -- index of spline

				beam_obj = SplineShape name:(platform_A.name + "-cross")


				setUserPropVal beam_obj "source_platforms" #( getHandleByAnim platform_A, getHandleByAnim platform_B )

				beam_obj.parent	= platform_A
				beam_obj.wirecolor	= platform_A.wirecolor


				addNewSpline beam_obj
				--format "point_bottom:	% \n" point_bottom
				--format "point_top:	% \n" point_top

				addKnot beam_obj cross_spline_id #corner #line point_bottom
				addKnot beam_obj cross_spline_id #corner #line point_top

				setMaterialID beam_obj cross_spline_id 1 this.Options.mat_ids[#CROSS] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>
				--setMaterialID beam_obj cross_spline_id 1 6

				updateShape beam_obj

				beam_obj.pivot = beam_obj.center

				for i = platform_A.modifiers.count to 1 by -1 do
					addModifier beam_obj platform_A.modifiers[i]

				append beams_created beam_obj
			)

		)

		beams_created --return
	),

	private

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
