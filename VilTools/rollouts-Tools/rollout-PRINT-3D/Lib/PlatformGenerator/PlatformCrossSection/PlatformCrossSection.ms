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
			--format "\ni:	% \n" i
			--format "platform:	% \n" platforms[i]

			platform	= platforms[i]
			platform_next	= platforms[i + 1]

			num_knots	= ( numKnots platform )
			num_knots_next	= ( numKnots platform_next )

			end_point_index = if num_knots > 3 then 2 else 1 --get 1. or 2. point from top

			--format "num_knots:	% \n" num_knots
			--format "num_knots_next:	% \n" num_knots_next

			point_start	= getKnotPoint platform	1 (end_point_index)	-- get 2. point from bottom
			point_end	= getKnotPoint platform_next	1 (num_knots_next - 1)	-- get 1. or 2. point from top

			--format "point_start:	% \n" point_start
			--format "point_end:	% \n" point_end

			_distance = this.getPointDistance (copy point_start) (copy point_end)

			if _distance < this.Options.cross_section_max then
			(

				point_start.z	= (point_start.z / 4 ) * 3
				point_end.z	= (point_start.z / 4 )

				cross_spline = 2

				addNewSpline platform
				--format "point_start:	% \n" point_start
				--format "point_end:	% \n" point_end

				addKnot platform cross_spline #corner #line point_start
				addKnot platform cross_spline #corner #line point_end

				setMaterialID platform cross_spline 1 this.Options.mat_ids[#CROSS] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>
				--setMaterialID platform cross_spline 1 6

				updateShape platform


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
