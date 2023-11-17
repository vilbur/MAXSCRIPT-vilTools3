
	local kappa = 4 * ( sqrt 2 - 1) / 3 -- https://hansmuller-flex.blogspot.com/2011/04/approximating-circular-arc-with-cubic.html

	/*------------------------------------------------------------------------------
		SPLINE PROPERTIES
	--------------------------------------------------------------------------------*/
	local vector3	= dotNetClass "Autodesk.Max.MaxPlus.Point3"
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
	function make2PointArc arc_angle: arc_radius: angle_rot: dir: AddKnot:  =
	(
		format "\n"; print "testPlugin.ms.make2PointArc()"

		/** Get points up to 90 degrees
		  */
		function getArcPoints arc_radius arc_angle arc_points =
		(
            format "\n"; print "testPlugin.ms.getArcPoints()"
            format "arc_radius:	% \n" arc_radius
            format "arc_angle:	% \n" arc_angle
            format "arc_points:	% \n" arc_points

			/* GET START AND END COORDINATES */
			x4 = arc_radius * cos(arc_angle/2);
			y4 = arc_radius * sin(arc_angle/2);
			x1 = x4;
			y1 = -y4

			/* GET VECTORS COORDINATES */
			x2 = x1 + kappa * tan(arc_angle/2) * y4;
			y2 = y1 + kappa * tan(arc_angle/2) * x4;
			x3 = x2;
			y3 = -y2;

			/* GET POINTS */
			P0 = [ x1, y1, 0]
			P1 = [ x2, y2, 0]
			P2 = [ x3, y3, 0]
			P3 = [ x4, y4, 0]

			local point_1 = Dictionary #( #point,P0) #( #inVec, P0) #( #outVec, P1)
			local point_2 = Dictionary #( #point,P3) #( #inVec, P2) #( #outVec, P3)


			/* CHAIN ARCS - merge first point and last point of previous arc */
			--if arc_points.count > 0 then
			--	arc_points[arc_points.count][#outVec] = point_1[#outVec]
			--
			--else
				append arc_points point_1 -- first point of first arc

			append arc_points point_2

			arc_points --return
		)


        arc_points = #()
--format "ARC USED:	% \n" (ceil ( arc_angle / 90.0 ))
--
--		/* SPLIT ARC TO MAX 90° SEGMENTS  */
--		for i = 1 to arc_used = ceil ( arc_angle / 90.0 ) do
--			getArcPoints(arc_angle / arc_used)(arc_points)

		arc_points = getArcPoints(arc_radius)(arc_angle)(arc_points)

       format "\n-----------\nARRAY:arc_points:\n"; for arc_point in arc_points do format "arc_point:	%\n" arc_point

		arc_points = this.rotatePointsInSpace ( arc_points ) (angle_rot)



		this.constructArc (arc_points) (AddKnot)

	)

	/* Generate Arc spline on given shape
	 * works to 360° but best aproxx
	*/
	function make3PointArc arc_angle: radius: angle_rot: dir: AddKnot: =
	(
		arc_angle /= 2 -- only 1 half of angle is used for construction

		local bez = arc_angle * kappa / 90 + adjustBy arc_angle
		local radVec = x_axis * Quat ( arc_angle - 90) z_axis * [dir, 1, 0]


		local radX = radius * radVec.x
		local radY = radius * radVec.y
		local radXY = radX - radius * dir * bez * radVec.y
		local radYX = radY + radius * dir * bez * radVec.x


        local point_1 = Dictionary #( #point,[radX, radY, 0])  #( #inVec, [radX, radY, 0])	#( #outVec, [radXY, radYX, 0] )
        local point_2 = Dictionary #( #point,[0., radius, 0])  #( #inVec, [(bez * dir * radius), radius, 0])	#( #outVec, [(-bez * dir * radius), radius, 0] )
        local point_3 = Dictionary #( #point,[-radX, radY, 0]) #( #inVec, [-radXY, radYX, 0])	#( #outVec, [-radX, radY, 0] )


		arc_points = this.rotatePointsInSpace #( point_1, point_2, point_3 ) (angle_rot - arc_angle ) -- remove arc_angle from rotation, then arc starts at "12:00 hour"

		this.constructArc (arc_points) (AddKnot)
	)

	/** Rotate points in space
	  *
	  */
	function rotatePointsInSpace arc_points angle_rot =
	(
		local rotation_center = [0,0,0]

		angle_rot *= -1 -- -1 makes rotation cw

		--format "\n"; print "buildShape.ms.rotatePointsInSpace()"
		for arc_point in arc_points do
		(
			/* ROTATE POINTS IN SPACE */
			for key in arc_point.keys do
            (
                transform_mat	= TransMatrix rotation_center

                rot_mat	= (RotateZMatrix angle_rot ) * transform_mat

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
		--
		--this.make3PointArc arc_angle:90 radius:50 angle_rot:0 dir:1 AddKnot:spline.AddKnot
		--this.make3PointArc arc_angle:90 radius:50 angle_rot:90 dir:1 AddKnot:spline.AddKnot
		--this.make3PointArc arc_angle:90 radius:50 angle_rot:180 dir:1 AddKnot:spline.AddKnot


		--this.make2PointArc arc_angle:45 arc_radius:this.radius angle_rot:0 dir:1 AddKnot:spline.AddKnot
		--this.make2PointArc arc_angle:90 arc_radius:this.radius angle_rot:0 dir:1 AddKnot:spline.AddKnot
		this.make2PointArc arc_angle:180 arc_radius:this.radius angle_rot:0 dir:1 AddKnot:spline.AddKnot


		--this.make2PointArc 90 50 0 -1 spline.AddKnot

		ShapeWrapper.UpdateSels()
		ShapeWrapper.InvalidateGeomCache()

		updateShape
	)
