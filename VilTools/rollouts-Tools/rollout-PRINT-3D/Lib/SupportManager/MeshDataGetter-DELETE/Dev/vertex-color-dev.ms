
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

/** Get Color per vertex indexes verts by geo vert
 */
function meshVertsToMapVerts obj verts get_single_vert:true =
(
	--format "\n"; print ".getVvertsByGeoVert()"
	/** Get faces using by giveen vert
	  *
	  * Each face is defined by map verts
	 */
	function getFacesUsingVert obj vert =
	(
		/* GET ALL FACES USED BY VERTEX */
		faces_of_vertex =  meshop.getFacesUsingVert obj.mesh vert

		/* GET ALL VERTS USED BY FACES in faces_of_vertex */
		all_verts_of_faces = for face_id in faces_of_vertex collect meshop.getVertsUsingFace obj.mesh face_id

		all_verts_of_faces --return
	)

	/**
	 */
	function getMapVertsOface obj map_face_index =
	(
		--format "\n"; print ".verts_of_face()"
		map_verts_of_face_p3 = getVCFace obj.mesh map_face_index -- map_verts_of_face is defined by its 3 vertext indexes E.G.: [1,3,4]

		sort #( map_verts_of_face_p3.x as integer , map_verts_of_face_p3.y as integer , map_verts_of_face_p3.z as integer )
	)

	if superClassOf verts == Number then
		verts = #{verts}

	local CPV_verts_all	= #()

	local faces_of_vert_cache   	= Dictionary (#integer)
	local map_verts_of_face_cache = Dictionary (#integer)
	local mesh_verts_of_face_cache = Dictionary (#integer)

	for vert in verts do
	(
		CPV_verts = #()

		faces_of_vertex_pattern =  getFacesUsingVert obj vert
		--format "FACES_OF_VERTEX_PATTERN	= % \n" faces_of_vertex_pattern

		map_faces = faces_using_vertex =  ( meshop.getFacesUsingVert obj.mesh vert) as Array
		--format "faces_using_vertex	= % \n" (faces_using_vertex as Array )

		 if get_single_vert then
			map_faces = #((faces_using_vertex as Array )[1])


		--map_face_index = (faces_using_vertex as Array)[1]
		for map_face_index in map_faces do
		(
			--format "\n--------------------------\n\nMAP_FACE_INDEX = % \n" map_face_index

			/* SET TO CHACHE */
			if map_verts_of_face_cache[map_face_index] == undefined then
				map_verts_of_face_cache[map_face_index] =  getMapVertsOface obj map_face_index

			/* GET FROM CHACHE */
			map_verts_of_face = map_verts_of_face_cache[map_face_index]

			/* DEV - NOT USE CACHE */
			------map_verts_of_face =  getMapVertsOface obj map_face_index


			/* SET TO CHACHE */
			if mesh_verts_of_face_cache[map_face_index] == undefined then
				mesh_verts_of_face_cache[map_face_index] =  ( meshop.getVertsUsingFace obj.mesh map_face_index) as Array

			/* GET FROM CHACHE */
			mesh_verts_of_face = mesh_verts_of_face_cache[map_face_index]

			/* DEV - NOT USE CACHE */
			------mesh_verts_of_face =  ( meshop.getVertsUsingFace obj.mesh map_face_index) as Array


			v = 1
			found = false

			/* LOOP EACH GEOMETRY VERTEX OF FACE and find which vert share same faces as faces_of_vertex_pattern ( it means that it is the same geometry vert ) */
			while v <= mesh_verts_of_face.count and not found do
			(
				vert_mesh = mesh_verts_of_face[v]

				/* SAVE TO CACHE */
				if faces_of_vert_cache[vert_mesh] == undefined then
					faces_of_vert_cache[vert_mesh] =  getFacesUsingVert obj vert_mesh

				/* GET FROM CHACHE */
				faces_of_vert = faces_of_vert_cache[vert_mesh]


				/* DEV - NOT USE CACHE */
				------faces_of_vert = getFacesUsingVert obj vert_mesh

				found = faces_of_vertex_pattern.count == faces_of_vert.count and (with PrintAllElements on faces_of_vertex_pattern as string == faces_of_vert as string)

				/* APPEND map verts to sinlge array or to 2D matrix by its face  */
				if found then
					append ( if get_single_vert then CPV_verts_all else CPV_verts )  map_verts_of_face[v]

				v += 1
			)

		)

		if CPV_verts.count > 0 then
			append CPV_verts_all CPV_verts

	)

	free	faces_of_vert_cache
	free	map_verts_of_face_cache
	free	mesh_verts_of_face_cache

	gc()	--Garbage Collection.

	CPV_verts_all --return
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


	CPV_verts_all = meshVertsToMapVerts obj verts get_single_vert:get_single_vert


	/*------------------------------------------------------------------------------
		PRINT RESULTS
	--------------------------------------------------------------------------------*/
	format "\n**************************\n\nTEST ALL MESH VERTS:\n\n"

	format "Vertex Count	Test = % \n" (CPV_verts_all.count == vertex_count)

	format "CPV_verts_all	= % \n" CPV_verts_all

	format "\n--------------------------\n\nTEST ALL MESH VERTS:\n\n"

	format "\nGet % takes % ms\n" vertex_count (( timeStamp()) - timer_start)

	for CPV_verts in CPV_verts_all as Array do
	(
		--format "CPV_verts	= % \n" CPV_verts
		--vertex_color_get = getvertcolor obj.mesh CPV_verts[1]

		--format "TEST PASSED: %  >>> vert: %	color:%	CPV_verts:%\n" (vertex_color_get as string ==_vertex_color as string ) vert vertex_color_get CPV_verts
	)
