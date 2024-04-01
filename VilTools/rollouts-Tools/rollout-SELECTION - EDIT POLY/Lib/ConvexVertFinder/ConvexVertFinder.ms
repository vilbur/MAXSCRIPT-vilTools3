/** Convex vert finder
 */
struct ConvexVertFinder_v
(
	/* construct */
	obj,

	/* required */
	/* properties */
	verts_types = #( #CONVEX, #CONCAVE, #FLAT, #CORNER ),

	verts_by_type  = Dictionary(), --  #( #CONVEX, #{} ) #( #CONCAVE, #{} ) #( #FLAT, #{} )  #( #CORNER, #{} )     -- store verts by angle

	_angles_by_vert = Dictionary(), --  #( #CONVEX, #() ) #( #CONCAVE, #() ) #( #FLAT, #() )  #( #CORNER, boolean ) -- store angles of single vert

	faces_angles_tested = Dictionary #integer,


	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Get verts


	 */
	function getVerts verts mode:#CONVEX =
	(
		--format "\n"; print "ConvexVertFinder_obj.getVerts()"
		for vert in verts do
		(
			format "\n-----------------------\nVERT: %\n" vert

			angles_by_vert = deepCopy this._angles_by_vert
			faces_of_vert = polyop.getFacesUsingVert obj vert

			for face_A in faces_of_vert where faces_of_vert.numberSet > 1 do
			(
				--normal_A = faces_normals[dataIndexFaceNormal(face_A)]
				normal_A = normalize ( polyop.getFaceNormal obj face_A )

				for face_B in faces_of_vert where face_A != face_B  do -- block to test same pair again
				(

					--if ( angle_of_faces = faces_angles_tested[face_A * face_B] ) == undefined then       -- GET TESTED IF TESTED ALREADY
					angle_of_faces =  this._getFacesAngle (face_A) (face_B) (normal_A) ( this._getFaceCenter face_A )

					angle_type = case of
					(
						(angle_of_faces < 180):	#CONVEX
						(angle_of_faces > 180):	#CONCAVE
						default:	#FLAT
					)

					append angles_by_vert[angle_type] angle_of_faces

				) -- end loop face B
			) -- end loop face A

			/* GET CORNER VERT - if vert has only 1 face */
			--if faces_of_vert.numberSet == 1 then  -- if vert has only 1 face
			angles_by_vert[#CORNER] = faces_of_vert.numberSet == 1

			this._saveVertByType (vert) (angles_by_vert)

		) -- END LOOP VERTS

		verts_by_type[mode] --return
	),


	private



	/** Find angle between faces
	 */
	function _getFacesAngle face_A face_B normal_A face_center_A =
	(
		--format "\n"; print "ConvexVertFinder_obj._getFacesAngle()"
		vector_faces_centres = normalize ( face_center_A - (this._getFaceCenter face_B) )

		normal_B = normalize ( polyop.getFaceNormal obj face_B )

		dot_faces  = dot normal_A normal_B
		dot_center = dot vector_faces_centres normal_A

		angle_raw    = acos(dot_faces)
		angle_center = acos(dot_center)

		--format "dot_faces: %\n" dot_faces
		--format "dot_center: %\n" dot_center
		--format "angle_center: %\n" angle_center
		--format "\nangle_raw: %\n" angle_raw
		--format "\n"

		/* CONCAVE: ( dot_center > 0 )  CONVEX: ( dot_center < 0 ) */
		angle_final = case of
		(
			(dot_center > 0 and (dot_faces < 0 or  dot_faces == 1)):  abs(180 - angle_raw)

			(dot_center < 0 and dot_faces >= 0 ):	 abs(180 + angle_raw) ---- if dot_faces >= 0 then --??? dont know if its needed actualy

			default: angle_raw
		)

		format "ANGLE_FINAL: %\n" angle_final

		/* MAK PAIR OF FACES AS TESTED  */
		faces_angles_tested[face_A * face_B] = angle_final

		angle_final --return
	),

	/** Save vert by type
	 */
	function _saveVertByType vert angles_by_vert =
	(
		format "\n"; print "ConvexVertFinder_obj._saveVertByType()"
		--format "vert: %\n" vert
		format "angles_by_vert: %\n" angles_by_vert

		convex_angles  = angles_by_vert[#CONVEX].count
		concave_angles = angles_by_vert[#CONCAVE].count

		vert_type = case of
		(
			(angles_by_vert[#CORNER] ):	#CORNER
			(convex_angles > concave_angles):	#CONVEX
			(convex_angles < concave_angles):	#CONCAVE
			default:	#FLAT
		)

		format "vert_type: %\n" vert_type
		verts_by_type[vert_type][vert] = true
		--format "verts_by_type: %\n" verts_by_type

	),

	/* Get index of verts_data by vertex number in this.positions|normlas|colors|
	*
	* Bitarray way to accomplish : findItem (this.verts_arr) face_id
	*/
	function dataIndexFaceNormal face_id =
	(
		--format "\n"; print "VertDataGetter_v.dataIndexVert()"
		--missing = -face_data[#FACES] - #{face_id..(face_data[#FACES].numberSet)} -- find how many indexes is false before vertex_index

		--face_id - missing.numberSet

		 findItem this.face_data[#FACES] face_id
	),

	/** Get face center
	 */
	function _getFaceCenter face_id =
	(
		--format "\n"; print "VertSelector_v._getFaceCenter()"
		if ( face_center = polyop.getSafeFaceCenter obj face_id ) == undefined then
			face_center = polyop._getFaceCenter obj face_id

		face_center --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ConvexVertFinder.onCreate()"

		/* PREFILL DICTIONARIES WITH KEYS AND EMPTY VALUES */
		for vert_type in verts_types do this.verts_by_type[vert_type] = #{}

		for vert_type in verts_types where vert_type != #CORNER do this._angles_by_vert[vert_type] = #()

	)
)
