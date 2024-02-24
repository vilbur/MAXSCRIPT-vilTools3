/** Mesh vert to color vertex convertor
 */
struct MeshVertToColorVertexConvertor_v
(
	/* construct */
	obj,

	get_single_vert,

	/* properties */

	/* dependency */
	/* reference */
	/* inhered */
	/** Get Color per vertex indexes verts by geo vert
	 */
	function meshVertsToMapVerts verts =
	(
		--format "\n"; print "MeshVertToColorVertexConvertor_v.meshVertsToMapVerts()"
		/** Get faces using by given vert
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

			--faces_of_vertex_pattern =  this._getFacesUsingVert (vert)
			faces_of_vertex_pattern =  getFacesUsingVert obj (vert)
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

					found = faces_of_vertex_pattern.count == faces_of_vert.count and (with PrintAllElements on faces_of_vertex_pattern as string == faces_of_vert as string )

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
	),

	/** Map verts to mesh verts
	 */
	function mapVertsToMeshVerts map_verts =
	(
		--format "\n"; print "MeshVertToColorVertexConvertor_v.mapVertsToMeshVerts()"

		mesh_verts = #{}
		map_faces_all = #()

		for map_face_index = 1 to getNumFaces obj.mesh do
			append map_faces_all  ( getVCFace obj.mesh map_face_index )

		--format "map_faces_all	= % \n" map_faces_all

		for map_vert in map_verts do
		(
			map_faces_of_vert = meshop.getMapFacesUsingMapVert obj.mesh 0 map_vert

			verts_of_faces = meshop.getVertsUsingFace obj.mesh map_faces_of_vert

			face_id = (map_faces_of_vert as Array )[1]

			map_verts_of_face = getVCFace obj.mesh face_id
			geo_verts_of_face = (meshop.getVertsUsingFace obj.mesh face_id) as Array
			--format "\n--------------------------\n\nFACE_ID = % \n" face_id
			--format "map_verts_of_face	= % \n" map_verts_of_face
			--format "geo_verts_of_face	= % \n" geo_verts_of_face

			for i = 1 to 3 where map_verts_of_face[i] == map_vert do
				mesh_verts[ geo_verts_of_face[i] ] = true
			--	--geovertex_index = i



		)
		
		gc()	--Garbage Collection.

		mesh_verts --return
	),


	private

	/**
	 */
	on create do
	(
		--format "\n"; print "MeshVertToColorVertexConvertor.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
