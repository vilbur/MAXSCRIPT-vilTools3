
	/*
		dotNetClass spline DOCUMENTATION: https://help.autodesk.com/view/MAXDEV/2024/ENU/?guid=Max_Developer_Help_cpp_ref_class_bezier_shape_html

	*/

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
	local BezierCornerKnot  = ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").BezierCornerKnot

	local BezierShapeClass = dotNetClass "Autodesk.Max.MaxPlus.BezierShape"


	/*------------------------------------------------------------------------------
		SPLINE FUNCTIONS
	--------------------------------------------------------------------------------*/

	fn vec3point pos = dotNetObject vector3 pos.x pos.y pos.z

	fn getSplineKnot pos inVec outVec knotType = dotNetObject splineKnot knotType curveLine pos inVec outVec

	fn adjustBy angle = if angle < 90 then 0 else 0.23 * (angle - 90) / 90.

	/* Generate Arc spline on given shape
	 * works to 360° but best aproxx
	*/
	function make3PointArc arc_angle: arc_radius: angle_rot:0 pos_z:0 dir: AddKnot: =
	(
		--format "\n"; print "testPlugin.ms.make2PointArc()"

		/** Get points up to 90 degrees
		  */
		function _getArcPoints arc_radius arc_angle pos_z dir =
		(
            --format "\n"; print "testPlugin.ms.make2PointArc()"
            --format "arc_radius:	% \n" arc_radius
            --format "arc_angle:	% \n" arc_angle
            --format "arc_points:	% \n" arc_points

			arc_angle /= 2 -- only 1 half of angle is used for construction

			local bez = arc_angle * kappa / 90 + adjustBy arc_angle
			local radVec = x_axis * Quat ( arc_angle - 90) z_axis * [dir, 1, 0]


			local radX = arc_radius * radVec.x
			local radY = arc_radius * radVec.y
			local radXY = radX - arc_radius * dir * bez * radVec.y
            local radYX = radY + arc_radius * dir * bez * radVec.x


            local point_1 = Dictionary #( #point,[radX, radY, pos_z])  #( #inVec, [radX, radY, pos_z])	#( #outVec, [radXY, radYX, pos_z] )
            local point_2 = Dictionary #( #point,[0., arc_radius, pos_z])  #( #inVec, [(bez * dir * arc_radius), arc_radius, pos_z])	#( #outVec, [(-bez * dir * arc_radius), arc_radius, pos_z] )
            local point_3 = Dictionary #( #point,[-radX, radY, pos_z]) #( #inVec, [-radXY, radYX, pos_z])	#( #outVec, [-radX, radY, pos_z] )


			#( point_1, point_2, point_3 )
		)

		arc_used = ceil ( arc_angle / 90.0 ) as integer

		arc_angle /= arc_used -- dive arc to even parts

		arc_points = _getArcPoints(arc_radius)(arc_angle)(pos_z)(dir)

		--arc_points = this.rotatePointsInSpace( arc_points ) ( -90 + arc_angle/2 + angle_rot ) -- rotate start of arc to "12:00" position
		arc_points = this.rotatePointsInSpace( arc_points ) ( arc_angle/2 + angle_rot ) -- rotate start of arc to "12:00" position

		if arc_used > 1 then
		(
			arcs_next = for i = 1 to arc_used - 1 collect deepCopy arc_points

			for i = 1 to arcs_next.count collect
		    (
				arc_points_rotated = this.rotatePointsInSpace( arcs_next[i] ) ( arc_angle * i )

				/* modify out vector of last point of previous arc */
				arc_points[arc_points.count][#outVec] = arc_points_rotated[1][#outVec]

				/* append 2. and 3. vert to all ponts */
				append arc_points arc_points_rotated[2]
				append arc_points arc_points_rotated[3]
		   )
		)

		arc_points --return
	)


	/** CREATE UP TO 90° ARC FROM BEZIER CURVE
	  *
	  *
	  * ---------------- IMPORTANT --------------------------------
	  *
	  *              GOOD APPROX in angles dividable by 90°
	  *
	  *              NOT SO GOOD in 30°
	  *
	  *              TOTALY WRONG on 45°
	  *
	  * https://spencermortensen.com/articles/bezier-circle/#:~:text=B%C3%A9zier%20curves%20are%20often%20used,with%20a%20cubic%20B%C3%A9zier%20curve.
	  *
	  *
	  * @retrun array of Dictionary #( #point, Point3) #( #inVec, Point3) #( #outVec, Point3)
	  */
	function make2PointArc arc_angle arc_radius angle_rot pos_z dir: AddKnot:  =
	(
		--format "\n"; print "testPlugin.ms.make2PointArc()"

		/** Get points up to 90 degrees
		  */
		function _getArcPoints arc_radius arc_angle pos2z =
		(
            --format "\n"; print "testPlugin.ms.make3PointArc()"
            --format "arc_radius:	% \n" arc_radius
            --format "arc_angle:	% \n" arc_angle
            --format "arc_points:	% \n" arc_points

			/* GET START AND END COORDINATES - Coordinates are elaborated in CCW */
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
			P1 = [ x1, y1, pos_z ]
			V1 = [ x2, y2, pos_z ]

			P2 = [ x4, y4, pos_z ]
			V2 = [ x3, y3, pos_z ]

			/* CCW */
			--local point_1 = Dictionary #( #point,P1) #( #inVec, P1) #( #outVec, V1)
			--local point_2 = Dictionary #( #point,P2) #( #inVec, V2) #( #outVec, P2)

			/* CW */
			local point_1 = Dictionary #( #point,P2) #( #inVec, P2) #( #outVec, V2)
			local point_2 = Dictionary #( #point,P1) #( #inVec, V1) #( #outVec, P1)


			#( point_1, point_2 )
		)


		arc_used = ceil ( arc_angle / 90.0 ) as integer

		arc_angle /= arc_used -- dive arc to even parts

		arc_points = _getArcPoints(arc_radius)(arc_angle)(pos_z)

		arc_points = this.rotatePointsInSpace( arc_points ) ( -90 + arc_angle/2 + angle_rot ) -- rotate start of arc to "12:00" position

		if arc_used > 1 then
		(
			arcs_next = for i = 1 to arc_used - 1 collect deepCopy arc_points

			for i = 1 to arcs_next.count collect
		    (
				arc_points_rotated = this.rotatePointsInSpace( arcs_next[i] ) ( arc_angle * i )

				/* modify out vector of lst point of previous arc */
				arc_points[arc_points.count][#outVec] = arc_points_rotated[1][#outVec]

				/* append second vert to all ponts */
				append arc_points arc_points_rotated[2]
		   )
		)

		arc_points --return
	)

	/** Rotate points in space
	  *
	  */
	function rotatePointsInSpace arc_points angle_rot =
	(
		local rotation_center = [0,0,0]

		angle_rot *= -1 -- rotate in CW direction

		for arc_point in arc_points do
		for key in arc_point.keys do
		(
			transform_mat = TransMatrix rotation_center

			rot_mat = (RotateZMatrix angle_rot ) * transform_mat

			arc_point[key] = arc_point[key] * rot_mat
		)

		arc_points --return
	)

	--/** Convert points to dotnet vectors
	--*
	--*/
	--function getArcKnots arc_points =
	--(
	--	arc_vectors = this.convertoDotNetVectors(arc_points)
	--
	--	arc_knots = for arc_vector in arc_vectors collect
	--		this.getSplineKnot (arc_vector[#point]) (arc_vector[#inVec]) (arc_vector[#outVec]) bezierKnot
	--
	--  arc_knots --return
	--)
	--
	--/** Convert points to dotnet vectors
	--*
	--*/
	--function getLieKnots arc_points =
	--(
	--	arc_vectors = this.convertoDotNetVectors(arc_points)
	--
	--	arc_knots = for arc_vector in arc_vectors collect
	--		this.getSplineKnot (arc_vector[#point]) (arc_vector[#inVec]) (arc_vector[#outVec]) bezierKnot
	--
	--  arc_knots --return
	--)

	/** Convert points to dotnet vectors
	*
	*/
	function getKnots points knot_type =
	(
		vectors = this.convertoDotNetVectors(points)

		knots = for vector in vectors collect
			this.getSplineKnot (vector[#point]) (vector[#inVec]) (vector[#outVec]) knot_type

	  knots --return
	)

	/** Convert points to dotnet vectors
	*
	*/
	function convertoDotNetVectors points =
	(
	  for point in points do
		  for key in point.keys do
			  point[key] = vec3point (point[key])

	  points --return
	)


	--/** createLine arc
	--  *
	--  */
	--function constructArc arc_points AddKnot =
	--(
	--	--format "\n"; print "buildShape.ms.constructArc()"
	--	for arc_point in arc_points do
	--		AddKnot ( getSplineKnot (arc_point[#point]) (arc_point[#inVec]) (arc_point[#outVec]) bezierKnot )
	--)


	--/** Construct arc
	--  *
	--  */
	--function constructArc arc_points AddKnot =
	--(
	--	--format "\n"; print "buildShape.ms.constructArc()"
	--	for arc_point in arc_points do
	--		AddKnot ( getSplineKnot (arc_point[#point]) (arc_point[#inVec]) (arc_point[#outVec]) bezierKnot )
	--)
