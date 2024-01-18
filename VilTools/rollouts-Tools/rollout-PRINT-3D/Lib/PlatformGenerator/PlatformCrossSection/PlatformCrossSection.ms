/** Platform cross section
 */
struct PlatformCrossSection_v
(
	/* construct */
	platforms,

	/* properties */


	/* dependency */
	/* reference */
	/* inhered */
	Options,	--PlatformOptions_v()

	/** Create cross section between platforms
	  *
	  *
	  */
	function create _platforms =
	(
		format "\n"; print "PlatformCrossSection_v.create()"

		this.platforms = _platforms

		this.filterEditSplineObjects()

		if platforms.count < 2 then
			return false

		--format "platforms.count:	% \n" platforms.count
		for i = 1 to platforms.count where platforms[i + 1] != undefined do
		(
			format "\ni:	% \n" i
			--format "platform:	% \n" platforms[i]

			platform_A	= platforms[i]
			num_knots	= ( numKnots platform_A )

			platform_B	= platforms[i + 1]
			num_knots_B	= ( numKnots platform_B )

			top_point_index = if num_knots_B <= 3 then 1 else 2 --get 1. or 2. point from top

			--format "num_knots:	% \n" num_knots
			--format "num_knots_B:	% \n" num_knots_B

			point_bottom	= getKnotPoint platform_A	1 (num_knots - 1)	-- get 2. point from bottom
			point_top	= getKnotPoint platform_B	1 (top_point_index)	-- get 1. or 2. point from top

			--format "point_bottom:	% \n" point_bottom
			--format "point_top.z:	% \n" point_top.z

			distance_between_platforms = this.getPointDistance (copy point_bottom) (copy point_top)
			format "distance_between_platforms:	% \n" distance_between_platforms
			format "this.Options.cross_section_max:	% \n" this.Options.cross_section_max

			--if point_top.z > this.Options.cross_section_min_height and distance_between_platforms < this.Options.cross_section_max then
			if point_top.z > this.Options.cross_section_min_height and  distance_between_platforms < this.Options.cross_section_max then
			(

				point_bottom.z	+= (point_top.z / 4 )

				point_top.z	= (point_top.z / 4 ) * 3

				cross_spline = 2 -- index of spline

				addNewSpline platform_A
				--format "point_bottom:	% \n" point_bottom
				--format "point_top:	% \n" point_top

				addKnot platform_A cross_spline #corner #line point_bottom
				addKnot platform_A cross_spline #corner #line point_top

				setMaterialID platform_A cross_spline 1 this.Options.mat_ids[#CROSS] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>
				--setMaterialID platform_A cross_spline 1 6

				updateShape platform_A
			)
		)
	),

	private

	/** Get distance between points in 2D from top view
	  */
	function getPointDistance point_1 point_2 =
	(
		--format "\n"; print "PlatformCrossSection_v.getPointDistance()"

		point_1.z = 0
		point_2.z = 0

		distance point_1 point_2 --return
	),

	/** Filter edit spline objects
	  *
	  */
	function filterEditSplineObjects =
	(
		--format "\n"; print "PlatformCrossSection_v.filterEditSplineObjects()"

		--for platform in platforms do
		--(
		--	format "classOf platform:	% \n" (classOf platform.baseobject)
		--	format "superclassOf platform:	% \n" ( superClassOf platform.baseobject)

		--)


		platforms = for platform in platforms where superClassOf platform.baseobject == shape collect platform

	),

	/**
	 */
	on create do
	(
		--format "\n"; print "PlatformCrossSection.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
