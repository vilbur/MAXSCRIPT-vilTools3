/** Convex vert finder
 */
struct ConvexVertFinder_v
(
	/* construct */
	obj,

	/* required */
	faces_data = Dictionary(),

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
	function getConvexityTypes verts faces_data: =
	(
		format "\n"; print "ConvexVertFinder_obj.getConvexityTypes()"
		this.verts_convexity = #() -- reset for mutliple rounds of same isntance

		faces_of_verts  = polyop.getFacesUsingVert obj verts

		tested_edges	= #{}
		tested_faces	= #{}
		--for i = 1 to faces_of_verts.count do
		timer_CONVEXITY = timeStamp()

		--for i = faces_of_verts.count to 1 by -1 do
		for face_A in faces_of_verts do
		(
			--face_A = faces_of_verts[i]
			normal_A = polyop.getFaceNormal obj face_A


			for edge_of_face in (edges_of_face = polyop.getEdgesUsingFace obj face_A) where not tested_edges[edge_of_face] do
			--for edge_of_face in (edges_of_face = polyop.getEdgesUsingFace obj face_A) do
			(
				verts_of_edge  = polyop.getVertsUsingEdge obj edge_of_face

				--for face_B in (faces_of_edge = polyop.getFacesUsingEdge obj edge_of_face) where face_A != face_B and not tested_faces[face_B] do
				for face_B in (faces_of_edge = polyop.getFacesUsingEdge obj edge_of_face) where face_A != face_B  do
				(
					normal_B = polyop.getFaceNormal obj face_B

					_angle =  this._getFacesAngle (face_A) (face_B) (normal_A) ( normal_B )  ( this._getFaceCenter face_A )

					/* TEST CONVEX\CONCAVE */
					angle_type = case of
					(
						(_angle < 180):	#CONVEX
						(_angle > 180):	#CONCAVE
						default:	#FLAT
					)


					--if angle_type != undefined then
					--(
					--	if (verts_by_type[angle_type] * verts_of_edge).numberSet > 0 then
					--		format "ADDED AGAIN: %\n" verts_of_edge
					--
						verts_by_type[angle_type] += verts_of_edge
					--)

					tested_edges[edge_of_face] = true
					--tested_faces[face_B] = true



				)
			)

		)



		format "\n CONVEXITY: % ms\n" (( timeStamp()) - timer_CONVEXITY)

		this.verts_by_type --return

	),

	function getConvexityTypesByVert verts faces_data: =
	(
		format "\n"; print "ConvexVertFinder_obj.getConvexityTypesByVert()"
		this.verts_convexity = #() -- reset for mutliple rounds of same isntance

		--this._setFaceData (verts)(faces_data)

		--face_normals = this.faces_data[#NORMALS]

		--already_tested_edges = #{}

		timer_CONVEXITY = timeStamp()
		for vert in verts do
		(
			--format "\n-----------------------\nVERT: %\n" vert
			--timer_vert = timeStamp()
			angles_by_vert = copy this._angles_by_vert

			--for edge_of_vert in (edges_of_vert = polyop.getEdgesUsingVert obj vert) do
				--for face in (faces_of_edge = polyop.getFacesUsingEdge obj face_A) do

			if ( faces_of_vert  = polyop.getFacesUsingVert obj vert ).count > 1 then
			(
				for edge_of_vert in (edges_of_vert = polyop.getEdgesUsingVert obj vert) do
				(

					/* GET ANGLE FROM CACHE OR GET ANGLE FOR NEW PAIR OF FACES */
					--if ( angle_type = faces_angles[edge_of_vert] ) == undefined then
					if (faces_of_edge = ( polyop.getFacesUsingEdge obj edge_of_vert) as Array ).count > 1 then
					(


						face_A = faces_of_edge[1]
						face_B = faces_of_edge[2]

						--normal_B = face_normals[this.dataIndexFaceNormal(face_B)]
						--normal_A = face_normals[this.dataIndexFaceNormal(face_A)]

						normal_A = polyop.getFaceNormal obj face_A
						normal_B = polyop.getFaceNormal obj face_B

						_angle =  this._getFacesAngle (face_A) (face_B) (normal_A) ( normal_B )  ( this._getFaceCenter face_A )

						/* TEST CONVEX\CONCAVE */
						angle_type = case of
						(
							(_angle < 180):	#CONVEX
							(_angle > 180):	#CONCAVE
							default:	#FLAT
						)

					)
					else /* IF BORDER EDGE - edge has only 1 face */
						angle_type = #FLAT

					--faces_angles[edge_of_vert] = angle_type

					angles_by_vert[angle_type][edge_of_vert] = true

				)


			)
			else /* GET CORNER VERT - if vert has only 1 face */
				angles_by_vert[#CORNER][1] = true

			this._saveVertByType (vert) (angles_by_vert)

			--format "\n VERT: % % ms\n" vert (( timeStamp()) - timer_vert)
		) -- END LOOP VERTS
		format "\n CONVEXITY: % ms\n" (( timeStamp()) - timer_CONVEXITY)

		this.verts_by_type --return
	),
	/** Get verts

	 * @param BitArray verts to ge their convex or concave state
	 *
	 * @return Arrray
	 *
	 */
	function getConvexityTypesByVertOld verts faces_data: =
	(
		--format "\n"; print "ConvexVertFinder_obj.getVerts()"
		this.verts_convexity = #() -- reset for mutliple rounds of same isntance

		this._setFaceData (verts)(faces_data)

		face_normals = this.faces_data[#NORMALS]

		--already_tested_edges = #{}

		timer_CONVEXITY = timeStamp()
		for vert in verts do
		(
			--format "\n-----------------------\nVERT: %\n" vert
			--timer_vert = timeStamp()
			angles_by_vert = deepCopy this._angles_by_vert


			--for edge_of_vert in (edges_of_vert = polyop.getEdgesUsingVert obj vert) do
				--for face in (faces_of_edge = polyop.getFacesUsingEdge obj face_A) do

			if ( faces_of_vert  = polyop.getFacesUsingVert obj vert ).count > 1 then
			(
				for edge_of_vert in (edges_of_vert = polyop.getEdgesUsingVert obj vert) do
				(


					/* GET ANGLE FROM CACHE OR GET ANGLE FOR NEW PAIR OF FACES */
					if ( angle_type = faces_angles[edge_of_vert] ) == undefined then
					(
						faces_of_edge = ( polyop.getFacesUsingEdge obj edge_of_vert) as Array

						face_A = faces_of_edge[1]
						face_B = faces_of_edge[2]

						normal_B = face_normals[this.dataIndexFaceNormal(face_B)]
						normal_A = face_normals[this.dataIndexFaceNormal(face_A)]

						_angle =  this._getFacesAngle (face_A) (face_B) (normal_A) ( normal_B )  ( this._getFaceCenter face_A )

						/* TEST CONVEX\CONCAVE */
						angle_type = case of
						(
							(_angle < 180):	#CONVEX
							(_angle > 180):	#CONCAVE
							default:	#FLAT
						)

						faces_angles[edge_of_vert] = angle_type
					)

					angles_by_vert[angle_type][edge_of_vert] = true

				)
			)
			else /* GET CORNER VERT - if vert has only 1 face */
				angles_by_vert[#CORNER][1] = true

			this._saveVertByType (vert) (angles_by_vert)

			--format "\n VERT: % % ms\n" vert (( timeStamp()) - timer_vert)
		) -- END LOOP VERTS
		format "\n CONVEXITY: % ms\n" (( timeStamp()) - timer_CONVEXITY)

		verts_convexity --return
	),
	private

	--/** Get face data
	-- */
	--function _setFaceData verts _faces_data =
	--(
	--	--format "\n"; print "ConvexVertFinder_v._setFaceData()"
	--	--format "verts: %\n" verts
	--	--format "_faces_data: %\n" _faces_data
	--	if _faces_data == unsupplied then
	--	(
	--		this.faces_data[#FACES] = polyop.getFacesUsingVert obj verts
	--
	--		this.faces_data[#NORMALS] = for face in this.faces_data[#FACES] collect polyop.getFaceNormal obj face
	--	)
	--	else
	--		this.faces_data = _faces_data
	--
	--),

	/** Find angle between faces
	 */
	function _getFacesAngle face_A face_B normal_A normal_B face_center_A =
	(
		--format "\n"; print "ConvexVertFinder_obj._getFacesAngle()"
		vector_faces_centres = normalize ( face_center_A - (this._getFaceCenter face_B) )



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
		--faces_angles[face_A * face_B] = angle_final

		angle_final --return
	),

	/** Save vert by type
	 */
	function _saveVertByType vert angles_by_vert =
	(
		--format "\n"; print "ConvexVertFinder_obj._saveVertByType()"
		--format "vert: %\n" vert
		--format "angles_by_vert: %\n" angles_by_vert

		convex_angles  = angles_by_vert[#CONVEX].numberSet
		concave_angles = angles_by_vert[#CONCAVE].numberSet

		vert_type = case of
		(
			(angles_by_vert[#CORNER][1] ):	#CORNER
			(convex_angles > concave_angles):	#CONVEX
			(convex_angles < concave_angles):	#CONCAVE
			default:	#FLAT
		)

		--format "vert_type: %\n" vert_type
		verts_by_type[vert_type][vert] = true

		--append verts_convexity vert_type
	),

	/* Get index of verts_data by vertex number in this.positions|normlas|colors|
	*
	* Bitarray way to accomplish : findItem (this.verts_arr) face_id
	*/
	function dataIndexFaceNormal face_id =
	(
		----format "\n"; print "VertDataGetter_v.dataIndexVert()"
		--missing = -faces_data[#FACES] - #{face_id..(faces_data[#FACES].numberSet)} -- find how many indexes is false before vertex_index
		--
		--face_id - missing.numberSet

		 findItem this.faces_data[#FACES] face_id
	),

	/** Get face center
	 */
	function _getFaceCenter face_id =
	(
		--format "\n"; print "VertSelector_v._getFaceCenter()"
		if ( face_center = polyop.getSafeFaceCenter obj face_id ) == undefined then
			face_center = polyop.getFaceCenter obj face_id

		face_center --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ConvexVertFinder.onCreate()"

		/* PREFILL DICTIONARIES WITH KEYS AND EMPTY VALUES */
		for vert_type in verts_types do this.verts_by_type[vert_type]   = #{}
		for vert_type in verts_types do this._angles_by_vert[vert_type] = #{}

		--for vert_type in verts_types where vert_type != #CORNER do this._angles_by_vert[vert_type] = #()

	)
)
