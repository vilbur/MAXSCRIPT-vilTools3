clearListener(); print("Cleared in:\n"+getSourceFileName())

--delete objects


vert = 1
--vert = 5

CPV_verts = #{}

vertex_color_set = red

--obj = Box showVertexColors:true	vertexColorsShaded:true alledges:true -- isSelected:on
--obj = Plane showVertexColors:true	vertexColorsShaded:true alledges:true widthsegs:2 lengthsegs:2

obj = objects[1]

convertTo obj Editable_Poly


polyop.setVertColor obj.baseobject 0 vert red


--polyop.setFaceColor  obj.baseobject 0 1 red -- THIS LINE WILL UNSYNC VERTEX AND CPV COUNT

--addModifier obj (meshsmooth ())

face_ids =  meshop.getFacesUsingVert obj.mesh vert


format "face_ids	= % \n" (face_ids as Array)


face_id = (face_ids as Array)[1]

--for face_id in face_ids as Array do
(
	format "\n--------------------------\nface_id	= % \n" face_id


	face_map_verts_p3 = getVCFace obj.mesh face_id
	format "FACE_MAP_VERTS_P3	= % \n" face_map_verts_p3

	face_map_verts = #{ face_map_verts_p3.x, face_map_verts_p3.y, face_map_verts_p3.z }

	format "face_map_verts	= % \n" face_map_verts



	for face_map_vert in face_map_verts as Array do
	(
		format "\n"
		format "face_map_vert	= % \n" face_map_vert

		faces_foreign = meshop.getMapFacesUsingMapVert obj.mesh 0 face_map_vert
		format "faces_foreign	= % \n" (faces_foreign as array )

		for face_foreign in faces_foreign do
		(
			format "face_foreign	= % \n" face_foreign
			foregin_map_verts = getVCFace obj.mesh face_foreign

			format "FOREGIN_MAP_VERTS	= % \n" (foregin_map_verts  )

			if face_map_verts_p3 == foregin_map_verts then
				CPV_verts[face_map_vert] = true

		)

	)

)



/*------------------------------------------------------------------------------

	TEST RESULT

	colors of map vertex must be equal to color of poly vertex

--------------------------------------------------------------------------------*/

format "CPV_verts	= % \n" CPV_verts


for CPV_vert in CPV_verts as Array do
(
	vertex_color_get = getVertColor obj.mesh CPV_vert

	format "vert: % CPV_vert:%	color:% TEST PASSED: % \n" vert CPV_vert vertex_color_get (vertex_color_get==vertex_color_set)
)

