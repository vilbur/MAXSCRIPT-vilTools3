clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../meshVertToColorVertexConvertor.ms" )	--"./../meshVertToColorVertexConvertor.ms"



/** Prepare scene
 */
function prepareScene =
(
	--format "\n"; print ".prepareScene()"
	clearListener(); print("Cleared in:\n"+getSourceFileName())

	delete objects

	vert_set_color = 1

	_vertex_color = color 0 80 200

	--obj = Box showVertexColors:true	vertexColorsShaded:true alledges:true -- isSelected:on
	--obj = Plane showVertexColors:true vertexColorsShaded:true alledges:true widthsegs:2 lengthsegs:2

	--obj = Sphere radius:50  isSelected:on segs:4 showVertexColors:true	vertexColorsShaded:true
	--obj = Sphere radius:50  isSelected:on segs:16 showVertexColors:true	vertexColorsShaded:true
	--obj = Sphere radius:50  isSelected:on segs:32 showVertexColors:true	vertexColorsShaded:true
	obj = Sphere radius:50  isSelected:on segs:64 showVertexColors:true	vertexColorsShaded:true

	convertTo obj Editable_Poly


	/* SET COLOR FOR TESED VERTEX */
	polyop.setVertColor obj.baseobject 0 vert_set_color _vertex_color


	/*
		IMPORTANT:
			THIS  WILL DETACH ONE-PER-ONE relationship between verts

		more colored faces == more datached map faces

	*/
	for face_id = 1 to polyop.getNumFaces obj.baseobject do
		polyop.setFaceColor obj.baseobject 0 face_id _vertex_color

	format "NumCPVVerts = % \n" (getNumCPVVerts obj.mesh )

	vertex_count = getNumVerts obj.mesh

)


/*------------------------------------------------------------------------------

	TEST ALL VERTS

	colors of map vertex must be equal to color of poly vertex

--------------------------------------------------------------------------------*/
prepareScene()

/*------------------------------------------------------------------------------
	TEST CONFIGURATION
--------------------------------------------------------------------------------*/
get_single_vert = false
get_single_vert = true
verts	= 1
--verts	= #{1..(vertex_count)}
--verts	= #{1..10}


/*------------------------------------------------------------------------------
	RUN FUNCTION
--------------------------------------------------------------------------------*/
timer_start = timeStamp()

meshVertToColorVertexConvertor = meshVertToColorVertexConvertor_v(obj) get_single_vert:get_single_vert

CPV_verts_all = meshVertToColorVertexConvertor.meshVertsToMapVerts (verts)


/*------------------------------------------------------------------------------
	PRINT RESULTS
--------------------------------------------------------------------------------*/
format "\n**************************\n\nTEST ALL MESH VERTS:\n\n"
--
--format "Vertex Count	Test = % \n" (CPV_verts_all.count == vertex_count)
--
format "CPV_verts_all	= % \n" CPV_verts_all
--
--format "\n--------------------------\n\nTEST ALL MESH VERTS:\n\n"
--
--format "\nGet % takes % ms\n" vertex_count (( timeStamp()) - timer_start)

for CPV_verts in CPV_verts_all as Array do
(
	--format "CPV_verts	= % \n" CPV_verts
	--vertex_color_get = getvertcolor obj.mesh CPV_verts[1]

	--format "TEST PASSED: %  >>> vert: %	color:%	CPV_verts:%\n" (vertex_color_get as string ==_vertex_color as string ) vert vertex_color_get CPV_verts
)


mesh_verts = mapVertsToMeshVerts
mesh_verts = meshVertToColorVertexConvertor.mapVertsToMeshVerts (CPV_verts_all)
