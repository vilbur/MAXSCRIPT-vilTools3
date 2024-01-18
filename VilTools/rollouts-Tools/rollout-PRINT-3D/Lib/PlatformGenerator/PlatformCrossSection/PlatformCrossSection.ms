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
	Options,	--PlatformOptions_v(),

	/** Create
	  *
	  */
	function create =
	(
		format "\n"; print "PlatformCrossSection_v.create()"

		this.filterEditSplineObjects()

		if platforms.count < 2 then
			return false

		format "platforms.count:	% \n" platforms.count
		for i = 1 to platforms.count where platforms[i + 1] != undefined do
		(
			format "\ni:	% \n" i
			--format "platform:	% \n" platforms[i]

			platform	= platforms[i]
			platform_next	= platforms[i + 1]

			num_knots	= ( numKnots platform )
			num_knots_next	= ( numKnots platform_next )

			end_point_index = if num_knots_next > 3 then 2 else 1 --get 1. or 2. point from top

			format "num_knots:	% \n" num_knots
			format "num_knots_next:	% \n" num_knots_next

			point_start	= getKnotPoint platform	1 (num_knots - 1)	-- get 2. point from bottom
			point_end	= getKnotPoint platform_next	1 end_point_index	-- get 1. or 2. point from top

			format "point_start:	% \n" point_start
			format "point_end:	% \n" point_end

			_distance = this.getPointDistance (copy point_start) (copy point_end)

			if _distance < this.Options.cross_section_max then
			(

				point_start.z	= (point_start.z / 4 ) * 3
				point_end.z	= (point_start.z / 4 )



				addNewSpline platform
				format "point_start:	% \n" point_start
				format "point_end:	% \n" point_end

				addKnot platform 2 #corner #line point_start
				addKnot platform 2 #corner #line point_end

				setMaterialID platform 2 1 this.Options.mat_ids[#CROSS] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

				updateShape platform


			)
			--format "_distance:	% \n" _distance

			--format "Options.cross_section_max:	% \n" Options.cross_section_max

		)

		--for i = 1 to PlatformObjects.count do
		--(
		--	PlatformObject = PlatformObjects[i]
		--
		--	platform = PlatformObject.generatePlatform()
		--
		--	addNewSpline platform
		--
		--	if (PlatformObject_next = PlatformObjects[i + 1]) != undefined then
		--	(
		--		pos_next	= copy PlatformObject_next.verts_positions[PlatformObject_next.verts_positions.count]
		--
		--		num_knots	= ( numKnots platform ) - 1
		--
		--		pos_current	= getKnotPoint platform 1 num_knots
		--
		--		format "distance:	% \n" (distance pos_next pos_current)
		--
		--		if distance pos_next pos_current < 20  then
		--
		--		(
		--			pos_next.z = (pos_next.z / 4 ) * 3
		--
		--			addKnot platform 2 #corner #line pos_current
		--			addKnot platform 2 #corner #line pos_next
		--
		--			setMaterialID platform 2 1 mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>
		--
		--
		--		)
		--
		--	)
		--
		--	--platform_next	= platforms[i + 1].baseobject
		--	--
		--	--num_knots_next	= numKnots platform_next
		--	--
		--	--
		--	--pos	= getKnotPoint PlatformObject.platform 1 1
		--	--pos_next	= getKnotPoint platform_next 1 1
		--	--
		--	--
		--	--addKnot platform 1 #corner #line pos
		--	--addKnot platform 1 #corner #line pos_next
		--	--
		--	--updateShape platform
		--
		--
		--
		--)
		--)

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
		format "\n"; print "PlatformCrossSection_v.filterEditSplineObjects()"

		platforms = for platform in platforms where classOf platform.baseobject == SplineShape collect platform

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
