clearListener(); print("Cleared in:\n"+getSourceFileName())

--filein( getFilenamePath(getSourceFileName()) + "/../vertSelector.ms" )	--"./../vertSelector.ms"


fn createFaceNormalTestShape =
(
	delete objects

	ln = line();
	splIdx = addNewSpline ln;
		addKnot ln splIdx #corner #curve [0,10,0];
		addKnot ln splIdx #corner #curve [0,20,0];
		addKnot ln splIdx #corner #curve [10,10,0];
		addKnot ln splIdx #corner #curve [0,0,0];
		addKnot ln splIdx #corner #curve [-10,-10,0];
		addKnot ln splIdx #corner #curve [0,-20,0];
		addKnot ln splIdx #corner #curve [0,-10,0];


	updateShape ln;
	convertToSplineShape ln;
	--ln.wireColor = (color 228 184 153);
	ln.name = uniqueName "face-normal-test-shape";
	select ln;
	return ln;

)


obj = createFaceNormalTestShape()

--obj	= selection[1]

modPanel.addModToSelection (Extrude amount: 10 ) ui:on

modPanel.addModToSelection (Normalmodifier flip:on ) ui:on

macros.run "Modifier Stack" "Convert_to_Poly"

/** Get face angles
 */
function getFaceAngles =
(

	/** Is cross less then zero
	 */
	function isCrossMinus cross_prod = cross_prod.x < 0 or cross_prod.y < 0 or cross_prod.z < 0

	faces_angles	= #()

	--format "\n"; print ".getFaceAngles()"
	for i = 1 to (faces = polyop.getNumFaces obj ) - 1 do
	(
		format "\n--------------------\n"
		format "FACE: %\n" i

		face_A = i
		face_B = i + 1

		normal_A = normalize ( polyop.getFaceNormal obj face_A)
		normal_B = normalize ( polyop.getFaceNormal obj face_B)

		local _dot_prod	= dot normal_A normal_B

		--x = 1
			--format "TEST: %\n" ( _dot_prod as integer  != x )
		angle_raw = acos(dot normal_A normal_B)

		cross_prod	= cross(normal_B)(normal_A)

		angle_A_B = case of
			(
				(isCrossMinus cross_prod): angle_raw + 180
				(cross_prod == [0,0,0] ):	180 -- _dot_prod == 1.0 ALWAYS RETURN FALSE !?! -- workaround is used cross product
				(_dot_prod < 0 ):	180 - angle_raw
				default:	angle_raw
			)


		append faces_angles angle_A_B

		format "_dot_prod: %\n" _dot_prod
		format "cross_prod: %\n" cross_prod
		format "angle_A_B: %\n" angle_A_B
	)

	faces_angles --return
)

faces_angles = getFaceAngles()

expected_anlges = #( 45, 90, 180, 270, 315 )

for i = 1 to expected_anlges.count do
	format "\nFaces % % : ANGLE: % TEST: %\n" i (i +1) faces_angles[i] ( faces_angles[i] == expected_anlges[i] )


--/** Prepre ene
-- */
--function prepareScene vertex_selection:false =
--(
--	--format "\n"; print ".prepreEne()"
--	delete objects
--
--	--obj	= Sphere()
--	--obj	= Teapot radius:10 segs:8  pos:[ 0, 0, 50 ]
--	obj	= Teapot radius:10 segs:64  pos:[ 0, 0, 50 ]
--
--	--obj = Plane width:20 length:20 pos:[ 50, 20, 50 ] widthsegs:4 lengthsegs:4
--
--	--obj = Plane width:100 length:100 pos:[ 50, 20, 50 ] widthsegs:100 lengthsegs:100
--	--obj = Plane width:50 length:50 pos:[ 50, 20, 50 ] widthsegs:50 lengthsegs:50
--	--obj = Plane width:60 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10
--	--obj = Plane width:40 length:30 pos:[ 50, 20, 50 ] widthsegs:40 lengthsegs:30
--
--
--	--obj = Plane width:30 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10
--	--obj = Plane width:20 length:20 pos:[ 50, 20, 50 ] widthsegs:4 lengthsegs:4
--
--	select obj
--
--	--modPanel.addModToSelection (Noisemodifier scale:5 strength:[0,0,10] ) ui:on
--
--	--rotate obj ( angleaxis 180 [1,0,0])
--
--	macros.run "Modifier Stack" "Convert_to_Poly"
--
--	--if vertex_selection then
--	--(
--	--	subObjectLevel = 1
--	--
--	--	try( obj.EditablePoly.SetSelection #Vertex #{ 1..(getNumVerts obj.mesh/2)} )catch()
--	--)
--
--	--obj = selection[1]
--)
--
--
--prepareScene()
----prepareScene vertex_selection:true
--
--
--obj = objects[1]
--
--
--
--timer_polyop = timeStamp()
--face_normals = for i = 1 to polyop.getNumFaces obj  collect polyop.getFaceNormal obj i
--format "face_normals: %\n" face_normals.count
--format "\n polyop: % ms\n" (( timeStamp()) - timer_polyop)
--
--
----/* THIS IS VERY SLOW
----
----*/
----timer_polyop = timeStamp()
----face_normals = for i = 1 to getNumFaces obj.mesh  collect getFaceNormal obj.mesh i
----format "face_normals: %\n" face_normals
----format "\n polyop obj.mesh: % ms\n" (( timeStamp()) - timer_polyop)
--
--
----
----timer_polyop = timeStamp()
----verts_normals = for i = 1 to meshop.getNumVerts obj.mesh  collect getNormal obj.mesh i
----
----format "verts_normals: %\n" verts_normals.count
----
----format "\n polyop obj.mesh: % ms\n" (( timeStamp()) - timer_polyop)
----
