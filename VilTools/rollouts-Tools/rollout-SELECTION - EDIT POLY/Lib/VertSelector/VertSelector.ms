filein( getFilenamePath(getSourceFileName()) + "/../MeshDataGetter/MeshDataGetter.ms" )	--"./../MeshDataGetter/MeshDataGetter.ms"

/** Get lowest verts in grid


	IMPORTANT:
		  DIFFERENT METHODS CAN RETURN DIFFERENT BitArray ON SAME SELECTION e.g.: #{1..157090} and #{1..930, 932..157091} -- vertext index 931 is missing and array is larger

		  In polyop methods is one vertex index missing in middle of BitArray

			Noticed on model imported from Zbrush

		  SOLUTION: REXPORT OBJECT, xform and attach to new object doesnt help

		  A) 'getVertSelection obj.mesh'	returns #{1..1000}
		  B) 'polyop.getVertSelection obj'	returns #{1..930, 932..1001}


 */
struct VertSelector_v
(
	/* construct */
	obj,

	/* properties */
	--resolution = 5,
	resolution = 10,

	points_grid 	= #(), -- 2DMatrix of verts which share same cell in grid points_grid[X_CELL][Y_CELL]
	sel_modified 	= #{}, -- modified selection for selecting
	round_grid	= #( #(), #(), #() ), -- 3D matrix of points positions rounded into 3 grid - round_grid[AXIS][CELL][VERT]

	/* dependency */
	MeshDataGetter,

	/* reference */
	verts_data,	-- MeshDataGetter.verts_data
	face_data,	-- MeshDataGetter.face_data

	/* inhered */

	/** Select lowest
	 */
	function getLowestVerts =
	(
		format "\n"; print "VertSelector_v.selectLowestInts()"

		MeshDataGetter.VertNormalLimits.z = [ 135, 180 ]

		verts_data = MeshDataGetter.getVertexData verts:#ALL_OR_SELECTED positions:true normals:true

		this._getVertsInGrid()

		this.sel_modified = copy verts_data[#VERTS]

		--for x = 1 to points_grid.count do
		--	for y = 1 to points_grid[x].count do
		--		this._filterOnlyMinZVerts (points_grid[x][y])

		--gc()
	),


	/*
		1) Loop each vert
		2) Get Faces of vert
		3) Get dot product of each pair from cache
		4) Get new dot product if not exist in cache
		5) If any or average angle is out of limit (dont know yet)
		6) Then remove this vert from selection
	*/
	function getConcaveVerts =
	(
		format "\n"; print "VertSelector_v.getConcaveVerts()"
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
		)

		function isCrossMinus cross_prod = cross_prod.x < 0 or cross_prod.y < 0 or cross_prod.z < 0

		faces_angles = Dictionary #integer

		this.sel_modified = #{}

		all_verts = #{1..(getNumVerts obj.mesh)}
		verts_sel	= getVertSelection obj.mesh


		verts_data = MeshDataGetter.getVertexData normals:true
		face_data = MeshDataGetter.getFacesData()

		faces_of_verts = (polyop.getFacesUsingVert obj  verts_data[#VERTS]) as Array

		faces_normals  = for face in faces_of_verts collect polyop.getFaceNormal obj face

		for vert in verts_data[#VERTS] where (faces_of_vert = polyop.getFacesUsingVert obj vert).numberSet > 1 do
		(
			vert_normal =  MeshDataGetter.getVertNormal vert

			faces_angles_of_vert = #()
			faces_angles_tested = #{}
			format "\n-----------------------\nVERT: %\n" vert


			/* Get dot product for each pair oof faces */
			for face_A in faces_of_vert do
			(
				normal_A = faces_normals[dataIndexFaceNormal(face_A)]
				--normal_A = faces_normals[ findItem ( faces_of_verts) face_A ]
				edges_A	= polyop.getEdgesUsingFace obj face_A
				--format "\nface_A: %\n" face_A

				for face_B in faces_of_vert where face_A != face_B and not faces_angles_tested[face_A * face_B] do -- block to test same pair again
				--for face_B in faces_of_vert where face_A != face_B  do
				(
					edges_B	= polyop.getEdgesUsingFace obj face_B

					if (edges_A*edges_B).numberSet > 0 then -- do not test faces wihtout shared edge
					(
						normal_B = faces_normals[ findItem ( faces_of_verts) face_B ]

						local _dot_prod	= dot normal_A normal_B

						angle_raw = acos(dot normal_A normal_B)

						cross_prod	= cross(normal_B)(normal_A)

						angle_A_B = case of
							(
								(isCrossMinus cross_prod): angle_raw + 180
								(cross_prod == [0,0,0] ):	180 -- _dot_prod == 1.0 ALWAYS RETURN FALSE !?! -- workaround is used cross product
								(_dot_prod < 0 ):	180 - angle_raw
								default:	angle_raw
							)

						format "\n"
						format "angle_raw: %\n" angle_raw
						format "_dot_prod: %\n" _dot_prod
						format "cross_prod: %\n" cross_prod
						format "ANGLE % %: %\n"  face_A face_B angle_A_B

						faces_angles_tested[face_A * face_B] = true

						append faces_angles_of_vert angle_A_B
					)
				)
			)

			convex_angles  = for angle_A_B in faces_angles_of_vert where angle_A_B < 180 collect angle_A_B
			concave_angles = for angle_A_B in faces_angles_of_vert where angle_A_B > 180 collect angle_A_B

			format "\nconvex_angles: % \nconcave_angles: %\n\n" convex_angles concave_angles

			if convex_angles.count > concave_angles.count then
			(
				format "VERT IS CONVEX\n\n"
				--this.sel_modified[vert] = true
			)
			else if convex_angles.count < concave_angles.count then
			(
				format "VERT IS CONCAVE\n\n"

				this.sel_modified[vert] = true
			)

			else
				format "VERT IS FLAT\n\n"

		)

		--gc()
	),

	/** Get verts by normal
	 */
	function getVertsByNormal =
	(
		--format "\n"; print "VertSelector_v.getVertsByNormal()"
		this._getVertsToProcess normals:true

		--normal_limit = 0
		--normal_limit = 0.25
		--normal_limit = -0.8
		--format "VERTS LOOP: %\n" verts_process
		--verts_arr = verts_process as Array
		--if verts_process.count > 1 then
		this.sel_modified = this._filterVertsByNormal(verts_process)


		--for vert in verts_arr do
				--format "vert: % NORMAL: %\n" vert (MeshDataGetter.getNormal(vert))


		--verts_arr --return
	),

	/** Get checker apttern of selection
	 */
	function getCheckerSelection invert_sel:false =
	(
		format "\n"; print "VertSelector_v.getCheckerSelection()"
		--this._getVertsToProcess()

		/** Is even
		 */
		function isEven n =  ( mod n 2 ) == 0


		--this._getVertsToProcess normals:false
		verts_data = MeshDataGetter.getVertexData positions:true

		timer_getVertsInGrid = timeStamp()
		this._getVertsInGrid()
		format "\n getVertsInGrid: % ms\n" (( timeStamp()) - timer_getVertsInGrid)

		this.sel_modified = #{}

		for x = 1 to round_grid[1].count where (slice_x = round_grid[1][x]).count > 0 do
		(
			for y = 1 to round_grid[2].count where (slice_y = round_grid[2][y]).count > 0 do
			(
				test_X = ( not isEven(x) and isEven(y))
				test_Y = ( not isEven(y) and isEven(x))

				for z = 1 to round_grid[3].count where (slice_z = round_grid[3][z]).count > 0 do
				(
					if     (isEven(z) and    (test_X or test_Y)) \
					or (not isEven(z) and not (test_X or test_Y)) then
						this.sel_modified +=( slice_x * slice_y * slice_z)

					/* DEBUG
						this.sel_modified = slice_x
						this.sel_modified = slice_y
						this.sel_modified = slice_z
					*/

				)
			)
		)

		--for x = 1 to round_grid[1].count do
		--(
		--
		--
		--
		--)

		--format "TEST: %\n" this.round_grid[1][3]
		--format "TEST: %\n" this.round_grid[2][3]
		--format "TEST: %\n" this.round_grid[3][11]


		--this.sel_modified =  round_grid[ 1 ][ 1 ]
		----this.sel_modified =  round_grid[ 2 ][ 1 ]
		----this.sel_modified =  round_grid[ 3 ][ 1 ]

		--this.sel_modified =  round_grid[ 1 ][ 2 ]
		--this.sel_modified *=  round_grid[ 2 ][ 1 ]
		--this.sel_modified *=  round_grid[ 3 ][ 1 ]


		--this.sel_modified =  round_grid[ 1 ][ 1 ] * round_grid[ 2 ][ 1 ]
		--this.sel_modified =  round_grid[1][3] * round_grid[2][3] * round_grid[3][11]
		--
		--a = #{ 1..10 }
		--b = #{ 5..100 }
		--c = #{ 5..10 }
		--reuslt = a*b*c
		--format "reuslt: %\n" reuslt
		--
			--for y = 1 to round_grid[2].count do
			--(
			--	if  (( mod x 2 ) == 0 and ( mod y 2 ) != 0) \ -- if cell is odd on X and even on Y
			--	or (( mod x 2 ) != 0 and ( mod y 2 ) == 0)   -- or vice versa
			--	then
			--	(
			--
			--
			--		this.sel_modified +=  round_grid[1][y]
			--
			--
			--	)
			--)

		--format "INVERT_SEL: %\n" invert_sel
		--this.sel_modified = if invert_sel then verts_process - sel_modified else sel_modified --return

		this.sel_modified
		--return
	),

	/** Select sinlge vert per face island

		Point with lowest position on Z
	 */
	function getSingleVertPerFaceIsland =
	(
		format "\n"; print "VertSelector_v.getSingleVertPerFaceIsland()"

		verts_data = MeshDataGetter.getVertexData verts:#SELECTION positions:true


		--if  verts_data[#VERTS].numberSet == 0 then
		--	return false

		this.sel_modified = copy verts_data[#VERTS]

		/* LOOP EACH ISLAND OF VERTS */
		for verts_island in (verts_islands = this._sortVertsByIslands()) do
		(
			format "VERTS_ISLAND: %\n" verts_island

			this._filterOnlyMinZVerts (verts_island *  verts_data[#VERTS])
		)

		gc()
	),


	/** Select final selection
	 */
	function selectVerts =
	(
		format "\n"; print "VertSelector_v.selectVerts()"
		--if this.sel_modified.isEmpty then
			--this.sel_modified = deepCopy verts_data[#VERTS]
		format "this.sel_modified: %\n" this.sel_modified

		if not this.sel_modified.isEmpty then
		(
			max modify mode

			subObjectLevel = 1

			_mod = modPanel.getCurrentObject()

			_mod.SetSelection #Vertex #{}

			if classOf _mod == Edit_Poly then
				_mod.Select #Vertex this.sel_modified

			else if classOf _mod  == Editable_Poly then
				_mod.SetSelection #Vertex this.sel_modified
		)
	),

	private

	/**  Left only single lowest vert of verts
	  *   Verts above are removed from selection
	 */
	function _filterOnlyMinZVerts verts =
	(
		--format "\n"; print "VertSelector_v._SelectOnlyMinZVerts()"
		verts_to_remove = copy verts

		/* REMOVE LOWEST VERT FORM VERTS */
		if ( lowest_vert = this._getMinZposVert(verts) ) != undefined then
			verts_to_remove[lowest_vert] = false

		/* REMOVE OTHER VERTS FROM SELECTION */
		for vert in verts_to_remove do
			this.sel_modified[vert] = false
	),

	/** Get vert with min z pos
	  *
	  * @param BitArray verts
	 */
	function _getMinZposVert verts =
	(
		--format "\n"; print "VertSelector_v.getMinZposVert()"
		verts_arr = verts as Array

		/* GET LOWEST POINT IN CELL */
		if verts_arr.count > 1 then
		(
			z_positions = for vert in verts_arr collect MeshDataGetter.getPosition(vert) axis:#Z

			if ( index = findItem z_positions (amin z_positions) ) > 0 then
				verts_arr[index] --return
		)
		else
			verts_arr[1] --return

			--verts_arr[1] --return
	),


	/** Filter verts by normal
	 */
	function _filterVertsByNormal verts =
	(
		--format "\n"; print "VertSelector_v._filterVertsByNormal()"
		(for vert in verts where (MeshDataGetter.getNormal(vert)).z < normal_limit collect vert) as BitArray
	),




	/** Get ace islands by verts
	  *
	  * @param BitArray verts which faces will be sorted by islands
	  *
	  * @return #( #{..} ) array of vertex ids, each array are verts of one island
	 */
	function _sortVertsByIslands =
	(
		format "\n"; print "VertSelector_v.getAceIslandsByVerts()"

		function facesShareVerts verts1 verts2 = not ( verts1 * verts2 ).isEmpty

		tested_pairs	= #{} -- store stringified array of face id used in loop already
		verts_islands	= #() -- #( #{ veret_ids } ) array of bitarrays of verts sorted by island the occupy
		--face_islands	= #() -- #( #{ faces_ids } ) array of bitarrays of faces sorted by island the occupy
		verts_per_faces	= #()


		faces_by_verts = ( polyop.getFacesUsingVert obj  verts_data[#VERTS]) as Array

		verts_per_faces = for face_id in faces_by_verts collect polyop.getVertsUsingFace obj #{face_id}

		timer_start = timeStamp()

		for f = 1 to faces_by_verts.count do
		(
			face_joined = true

			for i = 1 to verts_islands.count do
				if facesShareVerts (verts_islands[i]) (verts_per_faces[f]) then
				(
					verts_islands[i] +=  verts_per_faces[f]

					/* CURENTLY NOT NEEDED, GET FACE IDS BY ISLAND */
					--append face_islands[i] faces_by_verts[f]

					face_joined = false
				)

			if face_joined then
			(
					/* CURENTLY NOT NEEDED, GET FACE IDS BY ISLAND */
				--append face_islands #(faces_by_verts[f])

				append verts_islands verts_per_faces[f]
			)

		)

		verts_islands --return
	),

	/** Check selection ingerity
	 */
	function _checkSelectionIngerity mesh_sel polyop_sel =
	(
		--format "\n"; print "VertSelector_v._checkSelectionIngerity()"

		if mesh_sel[mesh_sel.count] 1= polyop_sel[polyop_sel.count] then
			messageBox ("Object '"+obj.name+"' needs to be rexported.\n\nVertex needs to be reindexed" )title:"VertSelector_v"
	),


	/** Get point in grid

		return 2 matrix of cells on XY grid
			#(
				#( #{x1y1}, #{x1y2} )
				#( #{x2y1}, #{x2y2} )
				#( #{x3y1}, #{x3y2} )
			)
	 */
	function _getVertsInGrid =
	(
		--format "\n"; print "VertSelector_v._getVertsInGrid()"
		/** Get cell by position
		 */
		function cellByPos vert_pos_on_axis axis_origin =
		(
			((( vert_pos_on_axis - axis_origin ) / this.resolution) as integer ) + 1
		)

		fn roundPoint3 p3 dp =
		(
			--format "p3: %\n" p3
			local tempArr = #(p3.x,p3.y,p3.z)
			local mult = 10.00^(dp as float)
			local rp3Arr = for c in tempArr collect ((floor ((c * mult)+0.5)) / mult)
			point3 rp3Arr[1] rp3Arr[2] rp3Arr[3]
		)



		verts_arr = verts_data[#VERTS] as Array

		pos_by_axis = MeshDataGetter.getPositionsSplitByAxis()

		min_pos = #( amin pos_by_axis[1], amin pos_by_axis[2], amin pos_by_axis[3])

		/* FILL MATRIX
			round_grid[AXIS][CELL][VERT]
		*/
		for i = 1 to verts_arr.count do
		(
			vert	= verts_arr[i]
			vert_pos	= verts_data[#POSITIONS][i]

			for axis = 1 to 3 do
			(
				level = cellByPos(vert_pos[axis])(min_pos[axis])

				if (round_grid[axis][level]) == undefined then
					round_grid[axis][level] = #{}

				/* SET VERT TO BITARRAY OF CELL */
				round_grid[axis][level][vert] = true
			)
		)

		--gc()

		--format "POINTS_GRID: %\n" points_grid

		points_grid --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "VertSelector.onCreate()"
		MeshDataGetter 	= MeshDataGetter_v( obj )
	)
)
