clearListener(); print("Cleared in:\n"+getSourceFileName())

delete objects


vert = 1
--vert = 2
--vert = 5


_vertex_color = color 0 80 200

--obj = Box showVertexColors:true	vertexColorsShaded:true alledges:true -- isSelected:on
--obj = Plane showVertexColors:true	vertexColorsShaded:true alledges:true widthsegs:2 lengthsegs:2
obj = Sphere radius:50  isSelected:on segs:32


convertTo obj Editable_Poly


/* SET COLOR FOR TESED VERTEX */
polyop.setVertColor obj.baseobject 0 1 _vertex_color


/*
	IMPORTANT:
		THIS  WILL DETACH ONE-PER-ONE relationship between verts

	more colored faces == more datached map faces

*/
for face_id = 1 to polyop.getNumFaces obj.baseobject do
	polyop.setFaceColor obj.baseobject 0 face_id _vertex_color

format "NumCPVVerts = % \n" (getNumCPVVerts obj.mesh )


/** Get Color per vertex indexes verts by geo vert
 */
function getCPVvertsByGeoVert obj verts =
(
	--format "\n"; print ".getVvertsByGeoVert()"

	/** Get faces using vert
	 */
	function getFacesUsingVert obj vert =
	(
		--format "\n"; print ".getFacesUsingVert()"
		faces_using_vertex =  meshop.getFacesUsingVert obj.mesh vert

		for face_of_vertex in faces_using_vertex collect meshop.getVertsUsingFace obj.mesh face_of_vertex
	)

	local CPV_verts_all = #()

	for vert in verts do
	(
		CPV_verts = #()

		faces_of_vertex_pattern =  getFacesUsingVert obj vert
		--format "FACES_OF_VERTEX_PATTERN	= % \n" faces_of_vertex_pattern

		faces_using_vertex =  ( meshop.getFacesUsingVert obj.mesh vert) as Array
		--format "faces_using_vertex	= % \n" (faces_using_vertex as Array )

		f = 1

		--map_face_index = (faces_using_vertex as Array)[1]
		for map_face_index in faces_using_vertex do
		(

			--format "\n--------------------------\n\nMAP_FACE_INDEX	= % \n" map_face_index
			map_verts_of_face_p3 = getVCFace obj.mesh map_face_index -- map_verts_of_face is defined by its 3 vertext indexes E.G.: [1,3,4]

			map_verts_of_face = sort #( map_verts_of_face_p3.x as integer , map_verts_of_face_p3.y as integer , map_verts_of_face_p3.z as integer )
			--format "map_verts_of_face	= % \n" map_verts_of_face

			geo_verts_of_face = ( meshop.getVertsUsingFace obj.mesh map_face_index) as Array
			--format "geo_verts_of_face	= % \n" geo_verts_of_face

			found = false
			v = 1
			--for v = 1 to geo_verts_of_face.count do
			while v <= geo_verts_of_face.count and not found do
			(
				faces_of_vertex =  getFacesUsingVert obj geo_verts_of_face[v]
				--format "\n\tfaces_of_vertex %	= % \n" geo_verts_of_face[v] faces_of_vertex

				if faces_of_vertex_pattern.count == faces_of_vertex.count and (with PrintAllElements on faces_of_vertex_pattern as string == faces_of_vertex as string) then
				(
					append CPV_verts  map_verts_of_face[v]

					found = true
					--format "FOUND	= % \n" found
				)

				v += 1
			)

		)


		append CPV_verts_all CPV_verts
	)
	CPV_verts_all --return
)



/*------------------------------------------------------------------------------

	TEST ALL VERTS

	colors of map vertex must be equal to color of poly vertex

--------------------------------------------------------------------------------*/

timer_start = timeStamp()

obj = objects[1]

vertex_count = getNumVerts obj.mesh

CPV_verts_all = getCPVvertsByGeoVert obj #{1..(vertex_count)}

format "\n**************************\n\nTEST ALL MESH VERTS:\n\n"

format "Vertex Count	Test = % \n" (CPV_verts_all.count == vertex_count)

format "CPV_verts_all	= % \n" CPV_verts

format "\n--------------------------\n\nTEST ALL MESH VERTS:\n\n"

for CPV_verts in CPV_verts_all do
(
	vertex_color_get = getvertcolor obj.mesh CPV_verts[1]

	--format "TEST PASSED: %  >>> vert: %	color:%	CPV_verts:%\n" (vertex_color_get as string ==_vertex_color as string ) vert vertex_color_get CPV_verts
)

format "\nProcessing took % ms" (( timeStamp()) - timer_start)










