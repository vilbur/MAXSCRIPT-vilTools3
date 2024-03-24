/** Get lowest verts in grid
 */
struct VertexGridSelector_v
(
	/* construct */
	obj,

	/* properties */
	--resolution = 5,
	resolution = 10,

	verts_to_get 	= #{}, -- source vertex to operate, selection or all verts if nothing selected
	points_grid 	= #(), -- 2DMatrix of verts which share same cell in grid points_grid[X_CELL][Y_CELL]
	sel_modified 	= #{}, -- modified selection for selecting
	verts_positions 	= #{},

	/* dependency */
	/* reference */
	/* inhered */

	/** Select lowest
	 */
	function getLowestVerts =
	(
		--format "\n"; print "VertexGridSelector_v.selectLowestInts()"
		this.getVertsInGrid()

		this.sel_modified = #{}

		for x = 1 to points_grid.count do
			for y = 1 to points_grid[x].count do
			(
				points_in_cell = points_grid[x][y]
				--format "points_in_cell: %\n" points_in_cell

				verts_pos_in_cell = meshop.getVerts obj.mesh points_in_cell node:obj


				z_positions = for pos in verts_pos_in_cell collect pos.z
				--format "z_positions: %\n" z_positions
				z_pos_min = amin z_positions
			--format "z_pos_min: %\n" z_pos_min

				if (index	= findItem z_positions (amin z_positions)) > 0 then
				(
					--lowest_vert = #{( vertex_sel as Array )[index]}
					lowest_vert = ( points_in_cell as Array )[index]

					sel_modified[lowest_vert] = true
					--format "verts_to_get: %\n" points_in_cell

				)

			)

		--this.selectVerts (sel_modified)


	),

	/** Get checker apttern of selection
	 */
	function getCheckerSelection invert_sel:false =
	(
		format "\n"; print "VertexGridSelector_v.getCheckerSelection()"
		this.getVertsInGrid()

		this.sel_modified = #{}

		for x = 1 to points_grid.count do
			for y = 1 to points_grid[x].count do
			(
				if  (( mod x 2 ) == 0 and ( mod y 2 ) != 0) \ -- if cell is odd on X and even on Y
				or (( mod x 2 ) != 0 and ( mod y 2 ) == 0)   -- or vice versa
				then
					this.sel_modified +=  points_grid[x][y]
			)

		this.sel_modified = if invert_sel then verts_to_get - sel_modified else sel_modified --return
	),

	/** Select ngle vert per face island
	 */
	function getSingleVertPerFaceIsland =
	(
		--format "\n"; print "VertexGridSelector_v.selectNgleVertPerFaceIsland()"
		this.getVertsInGrid()

		this.sel_modified = copy verts_to_get

		verts_to_get	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active

		if verts_to_get.numberSet == 0 then
			return false

		tested_pairs = #()
		face_islands = #() -- #( #{ faces_ids } ) array of bitarrays of faces sorted by island the occupy
		verts_per_faces = #()


		face_sel = polyop.getFacesUsingVert obj verts_to_get

		face_ids = face_sel as Array

		verts_per_faces = for face_id in face_sel collect polyop.getVertsUsingFace obj #{face_id}

		/** Is not same array
		 */
		function isNotSameArray arr1 arr2     = not ( arr1 -  arr2 ).isEmpty
		function faceShareVerts verts1 verts2 = not ( verts1 * verts2 ).isEmpty
		function faceShareFaces verts1 verts2 = not ( verts1 * verts2 ).isEmpty


		for f = 1 to face_ids.count do
		(
			foreign_faces = #{face_ids[f]}

			 for v = 1 to face_ids.count do
			 (
				test_key = ( sort#(f,v) ) as string

				if findItem tested_pairs test_key == 0 then
				(

					if isNotSameArray(verts_per_faces[f])(verts_per_faces[v]) and \
						 faceShareVerts (verts_per_faces[f])(verts_per_faces[v]) do
							foreign_faces[face_ids[v]] = true

					appendIfUnique tested_pairs test_key
				)
			 )

			islands_matching = for i = 1 to face_islands.count where faceShareFaces (face_islands[i]) (foreign_faces) collect i

			if islands_matching.count > 0 then
				for i in islands_matching do
					face_islands[i] += foreign_faces
			else
				append face_islands foreign_faces
		)


		for face_island in face_islands do
		(
			verts_of_island = polyop.getVertsUsingFace obj face_island

			island_and_sel_verts = (verts_of_island * verts_to_get) as Array

			/* remove other verts on island from selection */
			if island_and_sel_verts.count > 1 then
				for i = 2 to island_and_sel_verts.count do
					this.sel_modified[island_and_sel_verts[i]] = false

		)


	),

	/** Get point in grid

			return 2 matrix of cells on XY grid
			#(
				#( #{x1y1}, #{x1y2} )
				#( #{x2y1}, #{x2y2} )
				#( #{x3y1}, #{x3y2} )
			)

	 */
	function getVertsInGrid =
	(
		format "\n"; print "VertexGridSelector_v.getVertsInGrid()"
		fn roundPoint3 p3 dp =
		(
			local tempArr = #(p3.x,p3.y,p3.z)
			local mult = 10.00^(dp as float)
			local rp3Arr = for c in tempArr collect ((floor ((c * mult)+0.5)) / mult)
			point3 rp3Arr[1] rp3Arr[2] rp3Arr[3]
		)

		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}

		verts_to_get = if vertex_sel.isEmpty then verts_all else vertex_sel

		verts_to_get_arr = verts_to_get as Array

		verts_positions = meshop.getVerts obj.mesh verts_to_get node:obj

		/* ROUND POSTIONS TO TENS - [111.1589,12.856,85.5896] >>> [110,10,90] */
		pos_round = for pos in verts_positions collect roundPoint3 pos 0

		x_positions = for pos in pos_round collect pos.x
		y_positions = for pos in pos_round collect pos.y
		z_positions = for pos in pos_round collect pos.z

		x_min = amin x_positions
		x_max = amax x_positions
		y_min = amin y_positions
		y_max = amax y_positions

		--format "x_min: %\n" x_min
		--format "x_max: %\n" x_max
		--format "y_min: %\n" y_min
		--format "y_max: %\n" y_max

		x_size = x_max - y_min
		y_size = y_max - y_min

		counter_x = 0


		this.points_grid = for x = x_min to x_max by resolution collect
			for y = y_min to y_max by resolution collect #{} -- bitAarray to store verts which occupy cell of grid

		for i = 1 to verts_positions.count do
		(
			index_x = ((( verts_positions[i].x - x_min ) / resolution) as integer) + 1
			index_y = ((( verts_positions[i].y - y_min ) / resolution) as integer) + 1

			index_vert = verts_to_get_arr[i]

			points_grid[index_x][index_y][index_vert] = true
		)

		/* MARGE LAST TOP SQUARES - verts from last cell are on border of verts, they belongs to last cell */
		for x = 1 to points_grid.count where points_grid[x].count > 1 do
		(
			last_cell_y = points_grid[x].count

			 points_grid[x][last_cell_y - 1 ] += points_grid[x][last_cell_y]

			deleteItem  points_grid[x] last_cell_y
		)

		/* MARGE LAST RIGHT SQUARE - verts from last cell are on border of verts, they belongs to last cell */
		if (x_max = points_grid.count) > 1 and (y_max = points_grid[1].count ) > 1 then
			for row = 1 to y_max  do
				points_grid[x_max - 1][row] += points_grid[x_max][row]

		deleteItem  points_grid points_grid.count

		points_grid --return
	),

	/** Select final selection
	 */
	function selectVerts =
	(
		format "\n"; print "VertexGridSelector_v.selectVerts()"
		format "this.sel_modified.isEmpty: %\n" this.sel_modified.isEmpty
		if this.sel_modified.isEmpty then
			this.sel_modified = deepCopy verts_to_get


		subObjectLevel = 1
		_mod = modPanel.getCurrentObject()
		_mod.SetSelection #Vertex #{}

		if classOf _mod == Edit_Poly then
			_mod.Select #Vertex this.sel_modified

		else if classOf _mod  == Editable_Poly then
			_mod.SetSelection #Vertex this.sel_modified

	),

	private

	/**
	 */
	on create do
	(
		--format "\n"; print "VertexGridSelector.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
