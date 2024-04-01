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

	faces_angles = Dictionary #integer, -- #( face_A * face_B,  #( angles ) ) -- store angle between 2 faces

	verts_convexity = #(), -- store convex state of vert: #CONVEX|#CONCAVE|#FLAT|#CORNER -- keys are verts in parameter of "this.getVerts (verts)"

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Get verts

	 * @param BitArray verts to ge their convex or concave state
	 *
	 * @return Arrray
	 *
	 */
	function getConvexityTypes verts =
	(
		--format "\n"; print "ConvexVertFinder_obj.getVerts()"

		this.verts_convexity = #() -- reset for mutliple rounds of same isntance

		for vert in verts do
		(
			--format "\n-----------------------\nVERT: %\n" vert
			angles_by_vert = deepCopy this._angles_by_vert
			faces_of_vert  = polyop.getFacesUsingVert obj vert

			already_tested_faces = #{}

			for face_A in faces_of_vert where faces_of_vert.numberSet > 1 do
			(
				--normal_A = faces_normals[dataIndexFaceNormal(face_A)]
				normal_A = normalize ( polyop.getFaceNormal obj face_A )
				edges_A	 = polyop.getEdgesUsingFace obj face_A

				for face_B in faces_of_vert where face_A != face_B and not already_tested_faces[face_A * face_B] do -- block to test same pair again
				(
					edges_B	= polyop.getEdgesUsingFace obj face_B

					if (edges_A*edges_B).numberSet > 0 then -- do not test faces wihtout shared edge
					(
						/* GET ANGLE FROM CACHE OR GET ANGLE FOR NEW PAIR OF FACES */
						if ( _angle = faces_angles[face_A * face_B] ) == undefined then
							_angle =  this._getFacesAngle (face_A) (face_B) (normal_A) ( this._getFaceCenter face_A )

						/* TESNST CONVEX\CONCAVE */
						angle_type = case of
						(
							(_angle < 180):	#CONVEX
							(_angle > 180):	#CONCAVE
							default:	#FLAT
						)

						already_tested_faces[face_A * face_B] = true

						append angles_by_vert[angle_type] _angle
					)
				) -- end loop face B
			) -- end loop face A

			/* GET CORNER VERT - if vert has only 1 face */
			--if faces_of_vert.numberSet == 1 then  -- if vert has only 1 face
			angles_by_vert[#CORNER] = faces_of_vert.numberSet == 1

			this._saveVertByType (vert) (angles_by_vert)

		) -- END LOOP VERTS

		verts_convexity --return
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

		--format "\n"
		--format "dot_faces: %\n" dot_faces
		--format "dot_center: %\n" dot_center
		--format "angle_center: %\n" angle_center
		--format "\nangle_raw: %\n" angle_raw
		--format "\n"

		/* CONCAVE: ( dot_center > 0 )  CONVEX: ( dot_center < 0 ) */
		angle_final = case of
		(
			(dot_center > 0 and (dot_faces < 0 or  dot_faces == 1)):  abs(180 - angle_raw)

			(dot_center < 0  ):	 abs(180 + angle_raw) ---- if dot_faces >= 0 then --??? dont know if its needed actualy

			default: angle_raw
		)

		--format "ANGLE % % : %\n" face_A face_B angle_final

		/* MAK PAIR OF FACES AS TESTED  */
		faces_angles[face_A * face_B] = angle_final

		angle_final --return
	),

	/** Save vert by type
	 */
	function _saveVertByType vert angles_by_vert =
	(
		--format "\n"; print "ConvexVertFinder_obj._saveVertByType()"
		--format "vert: %\n" vert
		--format "angles_by_vert: %\n" angles_by_vert

		convex_angles  = angles_by_vert[#CONVEX].count
		concave_angles = angles_by_vert[#CONCAVE].count

		vert_type = case of
		(
			(angles_by_vert[#CORNER] ):	#CORNER
			(convex_angles > concave_angles):	#CONVEX
			(convex_angles < concave_angles):	#CONCAVE
			default:	#FLAT
		)

		--format "vert_type: %\n" vert_type
		--verts_by_type[vert_type][vert] = true

		append verts_convexity vert_type
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
