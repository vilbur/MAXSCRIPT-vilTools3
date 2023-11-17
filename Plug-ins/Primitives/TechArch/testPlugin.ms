plugin simpleSpline simpleSplineTest
name:	"Simple Spline Test"

classID:	#(0x6709bad7, 0x547659ab)
category:	"Splines"
(
	--local twoPi = double 2 * pi
	local obj

	local initialized	= true

	local vector3	    = dotNetClass "Autodesk.Max.MaxPlus.Point3"
	local splineKnot	= dotNetClass "Autodesk.Max.MaxPlus.SplineKnot"
	local cornerKnot	= ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").CornerKnot
	local bezierKnot = ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").BezierKnot
	local smoothKnot	= ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+KnotType").AutoKnot
	local curveLine	= ( dotNetClass "Autodesk.Max.MaxPlus.SplineKnot+LineType").CurveLineType

	local BezierShapeClass = dotNetClass "Autodesk.Max.MaxPlus.BezierShape"

	fn vec2 x y = dotNetObject vector3 x y 0

	fn vec3 x y z = dotNetObject vector3 x y z

	fn vec3point pos = dotNetObject vector3 pos.x pos.y pos.z

	fn getSplineKnot pos inVec outVec knotType = dotNetObject splineKnot knotType curveLine pos inVec outVec

    parameters main rollout:params
	(

	)

	on attachedToNode _node  do
	(
		print "TechArch.attachedToNode()"

		 format "_node.pos:	% \n" _node.pos

		--_node.name = uniqueName "TechHelix"

		this.obj = _node
	)

	/** create 90° arc from bezier curve
	  * https://spencermortensen.com/articles/bezier-circle/#:~:text=B%C3%A9zier%20curves%20are%20often%20used,with%20a%20cubic%20B%C3%A9zier%20curve.
	  *
	  */
	function createArcOnX =
	(
		format "\n"; print "testPlugin.ms.createArcOnX()"


		fn makeArcShape angle radius dir AddKnot =
		(
			points = Dictionary()

			fn adjustBy angle =
				if angle < 90 then 0 else 0.23 * (angle - 90) / 90.

			kappa = 4 * ( sqrt 2 - 1) / 3


			local bez = angle * kappa / 90 + adjustBy angle
			local radVec = x_axis * Quat ( angle - 90) z_axis * [dir, 1, 0]


			local radX = radius * radVec.x
			local radY = radius * radVec.y
			local radXY = radX - radius * dir * bez * radVec.y
			local radYX = radY + radius * dir * bez * radVec.x


            points[#p1]	= [radX, radY, 0]
            points[#p1_in]	= [radX, radY, 0]
            points[#p1_out]	= [radXY, radYX, 0]


            points[#p2]	= [0., radius, 0]
            points[#p2_in]	= [(bez * dir * radius), radius, 0]
            points[#p2_out]	= [(-bez * dir * radius), radius, 0]

            points[#p3]	= [-radX, radY, 0]
            points[#p3_in]	= [-radXY, radYX, 0]
            points[#p3_out]	= [-radX, radY, 0]


			for key in points.keys do
			(
				angle_rot = -45
				sel_center = [0,0,0]

				transform_mat = TransMatrix sel_center
				rot_mat = ( RotateZMatrix angle_rot) * transform_mat
				points[key] = vec3point (vertex_position * rot_mat )
			)

            AddKnot ( getSplineKnot (points[#p1]) (points[#p1_in]) (points[#p1_out]) bezierKnot )
            AddKnot ( getSplineKnot (points[#p2]) (points[#p2_in]) (points[#p2_out]) bezierKnot )
            AddKnot ( getSplineKnot (points[#p3]) (points[#p3_in]) (points[#p3_out]) bezierKnot )

		)

		shapeWrapper = BezierShapeClass._CreateWrapperFromFPValue BezierShape

		shapeWrapper.NewShape()

		spline = shapeWrapper.NewSpline()

		makeArcShape 45 50 -1 spline.AddKnot


		shapeWrapper.UpdateSels()
		shapeWrapper.InvalidateGeomCache()

		updateShape
	)

	/** create 90° arc from bezier curve
	  * https://spencermortensen.com/articles/bezier-circle/#:~:text=B%C3%A9zier%20curves%20are%20often%20used,with%20a%20cubic%20B%C3%A9zier%20curve.
	  *
	  */
	function create90Arc =
	(
		format "\n"; print "testPlugin.ms.create90Arc()"

		shapeWrapper = BezierShapeClass._CreateWrapperFromFPValue BezierShape

		shapeWrapper.NewShape()

		spline = shapeWrapper.NewSpline()


		r = 50
		k = 0.5522847498 -- k = ((sqrt 2) - 1 ) * ( 4.0 / 3 ) -- https://hansmuller-flex.blogspot.com/2011/04/approximating-circular-arc-with-cubic.html



		P0 = vec2 0 r
		P1 = vec2 (r*k) r
		P2 = vec2 r (r*k)
		P3 = vec2 r 0


		spline.AddKnot (getSplineKnot P0 P0 P1 bezierKnot)
		spline.AddKnot (getSplineKnot P3 P2 P3 bezierKnot)

		shapeWrapper.UpdateSels()
		shapeWrapper.InvalidateGeomCache()

		updateShape
	)


	fn rebuildShape =
	(
		format "\n"; print "simpleSplineTest.ms.rebuildShape()"

		shapeWrapper = BezierShapeClass._CreateWrapperFromFPValue BezierShape

		shapeWrapper.NewShape()

		spline = shapeWrapper.NewSpline()

		vert1 = vec3 0 0 0
		vert2 = vec3 0 100 0
		pos3 = vec3 100 100 0

		spline.AddKnot (getSplineKnot vert1 vert1 pos1 smoothKnot)
		spline.AddKnot (getSplineKnot vert2 vert2 pos2 smoothKnot)
		spline.AddKnot (getSplineKnot pos3 pos3 pos3 smoothKnot)

		shapeWrapper.UpdateSels()
		shapeWrapper.InvalidateGeomCache()
		updateShape
	)

	rollout params "Parameters"
	(

	)

	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: nodeTM.translation = worldPoint
			)
		)
		on mouseMove click do
		(
			case click of
			(
			--	2: radius = (gridDist.y^2+gridDist.x^2)^.5
				3: #stop
			)
		)
	)

	on create do initialized = false
	on postCreate do initialized = true

	on buildShape do
	(
		if initialized do
		--(
			--create90Arc()
			createArcOnX()
			--rebuildShape()
		--	changed = false
		--)
		--OK
	)
)

clearListener(); print("Cleared in:\n"+getSourceFileName())
delete objects

simpleSplineTest()
--simpleSplineTest  pos:[ 50, 50, 0]

--format "\n----------------------------------\n"
select objects

--macros.run "_Modifiers-Spline" "epoly_tools_Edit_Spline"
