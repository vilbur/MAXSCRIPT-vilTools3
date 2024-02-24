clearListener(); print("Cleared in:\n"+getSourceFileName())

delete objects


vert = 1
--vert = 2
--vert = 5

CPV_verts = #{}

_vertex_color = color 0 80 200

obj = Box showVertexColors:true	vertexColorsShaded:true alledges:true -- isSelected:on
--obj = Plane showVertexColors:true	vertexColorsShaded:true alledges:true widthsegs:2 lengthsegs:2

obj = objects[1]

convertTo obj Editable_Poly


/* SET COLOR FOR TESED VERTEX */
polyop.setVertColor obj.baseobject 0 1 _vertex_color


/*
	IMPORTANT:
		THIS  WILL DETACH ONE-PER-ONE relationship between verts

	more colored faces == more datached map faces

*/
for face_id = 1 to polyop.getNumFaces obj.baseobject do
	--format "face_id	= % \n" face_id
	polyop.setFaceColor obj.baseobject 0 face_id _vertex_color


format "NumCPVVerts = % \n" (getNumCPVVerts obj.mesh )

/** Get faces using vert
 */
function getFacesUsingVert obj vert =
(
	--format "\n"; print ".getFacesUsingVert()"
	faces_using_vertex =  meshop.getFacesUsingVert obj.mesh vert

	for face_of_vertex in faces_using_vertex collect meshop.getVertsUsingFace obj.mesh face_of_vertex
)


faces_using_vertex =  meshop.getFacesUsingVert obj.mesh vert
format "faces_using_vertex	= % \n" (faces_using_vertex as Array)

faces_of_vertex_pattern =  getFacesUsingVert obj vert

format "FACES_OF_VERTEX_PATTERN	= % \n" faces_of_vertex_pattern


--map_face_index = (faces_using_vertex as Array)[1]
for map_face_index in faces_using_vertex as Array do
(
	format "\n--------------------------\n\nMAP_FACE_INDEX	= % \n" map_face_index

	map_verts_of_face_p3 = getVCFace obj.mesh map_face_index -- map_verts_of_face is defined by its 3 vertext indexes E.G.: [1,3,4]

	map_verts_of_face = sort #( map_verts_of_face_p3.x as integer , map_verts_of_face_p3.y as integer , map_verts_of_face_p3.z as integer )
	format "map_verts_of_face	= % \n" map_verts_of_face

	geo_verts_of_face = ( meshop.getVertsUsingFace obj.mesh map_face_index) as Array
	format "geo_verts_of_face	= % \n" geo_verts_of_face

	for i = 1 to geo_verts_of_face.count do
	(
		faces_of_vertex =  getFacesUsingVert obj geo_verts_of_face[i]

		format "\n\tfaces_of_vertex %	= % \n" geo_verts_of_face[i] faces_of_vertex

		if faces_of_vertex_pattern.count == faces_of_vertex.count and (with PrintAllElements on faces_of_vertex_pattern as string == faces_of_vertex as string) then
			CPV_verts[ map_verts_of_face[i]] = true
	)

)



/*------------------------------------------------------------------------------

	TEST RESULT

	colors of map vertex must be equal to color of poly vertex

--------------------------------------------------------------------------------*/

format "\n--------------------------\n\nRESULT: CPV_verts	= % \n\n" CPV_verts


for CPV_vert in CPV_verts as Array do
(
	vertex_color_get = getvertcolor obj.mesh CPV_vert
	format "vert: % CPV_vert:%	color:% TEST PASSED: % \n" vert CPV_vert vertex_color_get (vertex_color_get as string ==_vertex_color as string )
)
