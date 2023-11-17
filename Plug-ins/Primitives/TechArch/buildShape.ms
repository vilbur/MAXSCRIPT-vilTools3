
	local kappa = 4 * ( sqrt 2 - 1) / 3 -- https://hansmuller-flex.blogspot.com/2011/04/approximating-circular-arc-with-cubic.html

	/*------------------------------------------------------------------------------
		SPLINE PROPERTIES
	--------------------------------------------------------------------------------*/
	local vector3     = dotNetClass "Autodesk.Max.MaxPlus.Point3"
	local splineKnot	= dotNetClass "Autodesk.Max.MaxPlus.SplineKnot"
	local cornerKnot	= ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").CornerKnot
	local bezierKnot  = ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").BezierKnot
	local smoothKnot	= ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").AutoKnot
	local curveLine	= ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+LineType").CurveLineType

	local BezierShapeClass = dotNetClass "Autodesk.Max.MaxPlus.BezierShape"



	/*------------------------------------------------------------------------------
		SPLINE FUNCTIONS
	--------------------------------------------------------------------------------*/

	fn vec3point pos = dotNetObject vector3 pos.x pos.y pos.z

	fn getSplineKnot pos inVec outVec knotType = dotNetObject splineKnot knotType curveLine pos inVec outVec

	fn adjustBy angle = if angle < 90 then 0 else 0.23 * (angle - 90) / 90.


	/** create up to 90° arc from bezier curve
	  * https://spencermortensen.com/articles/bezier-circle/#:~:text=B%C3%A9zier%20curves%20are%20often%20used,with%20a%20cubic%20B%C3%A9zier%20curve.
	  *
	  */
	function make2PointArc arc_angle radius angle_rot dir AddKnot =
	(
		format "\n"; print "testPlugin.ms.make2PointArc()"

        P0 =  [0,	radius,	0]
        P1 =  [radius*kappa,	radius,	0]
        P2 =  [radius,	radius*kappa,	0]
        P3 =  [radius,	0,	0]


        local point_1 = Dictionary #( #point,P0)	#( #inVec, P0)	#( #outVec, P1)
        local point_2 = Dictionary #( #point,P3)	#( #inVec, P2)	#( #outVec, P3)


		arc_points = this.rotatePoints #( point_1, point_2 ) (angle_rot)

		this.constructArc (arc_points) (AddKnot)

	)

	/* Generate Arc spline on given shape
	  * works to 360° but best aproxx
	*/
	function make3PointArc arc_angle radius angle_rot dir AddKnot =
	(
		arc_angle /= 2

		local bez = arc_angle * kappa / 90 + adjustBy arc_angle
		local radVec = x_axis * Quat ( arc_angle - 90) z_axis * [dir, 1, 0]


		local radX = radius * radVec.x
		local radY = radius * radVec.y
		local radXY = radX - radius * dir * bez * radVec.y
		local radYX = radY + radius * dir * bez * radVec.x


        local point_1 = Dictionary #( #point,[radX, radY, 0])	#( #inVec, [radX, radY, 0])	#( #outVec, [radXY, radYX, 0] )
        local point_2 = Dictionary #( #point,[0., radius, 0])	#( #inVec, [(bez * dir * radius), radius, 0])	#( #outVec, [(-bez * dir * radius), radius, 0] )
        local point_3 = Dictionary #( #point,[-radX, radY, 0])	#( #inVec, [-radXY, radYX, 0])	#( #outVec, [-radX, radY, 0] )


		arc_points = this.rotatePoints #( point_1, point_2, point_3 ) (angle_rot)

		this.constructArc (arc_points) (AddKnot)
	)

	/** Rotate points in space
	  *
	  */
	function rotatePoints arc_points angle_rot =
	(
		local rotation_center = [0,0,0]

		--format "\n"; print "buildShape.ms.rotatePoints()"
		for arc_point in arc_points do
		(
			/* ROTATE POINTS IN SPACE */
			for key in arc_point.keys do
            (
	transform_mat	= TransMatrix rotation_center
	rot_mat		=  ( RotateZMatrix angle_rot) * transform_mat
	arc_point[key]	= vec3point (arc_point[key] * rot_mat )
            )
		)

		arc_points --return
	)

	/** Construct arc
	  *
	  */
	function constructArc arc_points AddKnot =
	(
		--format "\n"; print "buildShape.ms.constructArc()"
		for arc_point in arc_points do
			AddKnot ( getSplineKnot (arc_point[#point]) (arc_point[#inVec]) (arc_point[#outVec]) bezierKnot )
	)

	/**
	  *
	  */
	function makeArcShape =
	(
		format "\n"; print "testPlugin.ms.makeArcShape()"

		ShapeWrapper = BezierShapeClass._CreateWrapperFromFPValue BezierShape

		ShapeWrapper.NewShape()

		spline = ShapeWrapper.NewSpline()

		--this.make3PointArc 180 50 0 -1 spline.AddKnot
		this.make2PointArc 90 50 0 -1 spline.AddKnot

		ShapeWrapper.UpdateSels()
		ShapeWrapper.InvalidateGeomCache()

		updateShape
	)

