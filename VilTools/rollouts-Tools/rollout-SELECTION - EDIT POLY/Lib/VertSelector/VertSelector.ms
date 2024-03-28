filein( getFilenamePath(getSourceFileName()) + "/../VertDataGetter/VertDataGetter.ms" )	--"./../VertDataGetter/VertDataGetter.ms"

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

	verts_process 	= #{}, -- source vertex to operate, selection or all verts if nothing selected
	points_grid 	= #(), -- 2DMatrix of verts which share same cell in grid points_grid[X_CELL][Y_CELL]
	sel_modified 	= #{}, -- modified selection for selecting
	--face_normals 	= #(),

	verts_data,
	/* dependency */
	VertDataGetter,

	/* reference */
	/* inhered */

	/** Select lowest
	 */
	function getLowestVerts =
	(
		--format "\n"; print "VertSelector_v.selectLowestInts()"
		this._getVertsInGrid()

		this.sel_modified = copy verts_process
		format "verts_process: %\n" verts_process
		--format "verts_process: %\n" verts_process.numberSet

		for x = 1 to points_grid.count do
			for y = 1 to points_grid[x].count do
				this._filterOnlyMinZVerts (points_grid[x][y])

		gc()
	),

	/** Get checker apttern of selection
	 */
	function getCheckerSelection invert_sel:false =
	(
		format "\n"; print "VertSelector_v.getCheckerSelection()"
		this._getVertsInGrid()

		this.sel_modified = #{}

		for x = 1 to points_grid.count do
			for y = 1 to points_grid[x].count do
			(
				if  (( mod x 2 ) == 0 and ( mod y 2 ) != 0) \ -- if cell is odd on X and even on Y
				or (( mod x 2 ) != 0 and ( mod y 2 ) == 0)   -- or vice versa
				then
					this.sel_modified +=  points_grid[x][y]
			)

		--format "INVERT_SEL: %\n" invert_sel
		this.sel_modified = if invert_sel then verts_process - sel_modified else sel_modified --return
	),

	/** Select sinlge vert per face island

		Point with lowest position on Z
	 */
	function getSingleVertPerFaceIsland =
	(
		format "\n"; print "VertSelector_v.getSingleVertPerFaceIsland()"

		this._getVertsToProcess()
		format "verts_process: %\n" verts_process

		if verts_process.numberSet == 0 then
			return false

		this.sel_modified = copy verts_process

		/* LOOP EACH ISLAND OF VERTS */
		for verts_island in (verts_islands = this._sortVertsByIslands()) do
			this._filterOnlyMinZVerts (verts_island * verts_process)

		gc()
	),


	/** Select final selection
	 */
	function selectVerts =
	(
		format "\n"; print "VertSelector_v.selectVerts()"
		format "this.sel_modified.isEmpty: %\n" this.sel_modified.isEmpty

		format "sel_modified: %\n" sel_modified
		--format "sel_modified: %\n" sel_modified.numberSet

		if this.sel_modified.isEmpty then
			this.sel_modified = deepCopy verts_process


		subObjectLevel = 1
		_mod = modPanel.getCurrentObject()
		_mod.SetSelection #Vertex #{}

		if classOf _mod == Edit_Poly then
			_mod.Select #Vertex this.sel_modified

		else if classOf _mod  == Editable_Poly then
			_mod.SetSelection #Vertex this.sel_modified


	),

	private
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
		fn roundPoint3 p3 dp =
		(
			--format "p3: %\n" p3
			local tempArr = #(p3.x,p3.y,p3.z)
			local mult = 10.00^(dp as float)
			local rp3Arr = for c in tempArr collect ((floor ((c * mult)+0.5)) / mult)
			point3 rp3Arr[1] rp3Arr[2] rp3Arr[3]
		)

		this._getVertsToProcess()

		--verts_process_arr = verts_process as Array
		--format "VERTS_PROCESS: %\n" verts_process
		/* ROUND POSTIONS TO TENS - [111.1589,12.856,85.5896] >>> [110,10,90] */
		pos_round = for vert in verts_process collect roundPoint3 (VertDataGetter.getPosition(vert)) 0

		x_positions = for pos in pos_round collect pos.x
		y_positions = for pos in pos_round collect pos.y
		z_positions = for pos in pos_round collect pos.z

		x_min = amin x_positions
		x_max = amax x_positions
		y_min = amin y_positions
		y_max = amax y_positions

		--x_size = x_max - y_min
		--y_size = y_max - y_min

		this.points_grid = for x = x_min to x_max by resolution collect
			for y = y_min to y_max by resolution collect #{} -- bitAarray to store verts which occupy cell of grid

		for vert in verts_process do
		--for i = 1 to verts_data[#POSITIONS].count do
		(
			vert_position = VertDataGetter.getPosition(vert)

			index_x = ((( vert_position.x - x_min ) / resolution) as integer ) + 1
			index_y = ((( vert_position.y - y_min ) / resolution) as integer ) + 1

			--index_vert = verts_process_arr[i]

			points_grid[index_x][index_y][vert] = true
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

		gc()

		points_grid --return
	),

	/**  Left only single lowest vert of verts
	  *   Verts above are removed from selection
	 */
	function _filterOnlyMinZVerts verts =
	(
		--format "\n"; print "VertSelector_v._SelectOnlyMinZVerts()"

		--(verts as Array )[1] --return

		if ( lowest_vert = this._getMinZposVert(verts) ) != undefined then
		(
			--format "LOWEST_VERT: %\n" lowest_vert
			verts[lowest_vert] = false

		)

		/*  remove verts above from selection */
		for vert in verts do
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

		function normalLimit faces_of_vert =
		(
			average_normal = point3 0 0 0
			--faces_normal = for face_id in faces_of_vert collect this.face_normals[face_id]

			for face_id in faces_of_vert do average_normal += VertDataGetter.face_normals[face_id]

			average_normal = normalize average_normal

			--format "average_normal: %\n" average_normal
			--format "average_normal.z < -0.25: %\n" (average_normal.z < -0.25)

			 --average_normal.z < 0 -- return
			 average_normal.z < 0.25 -- return
			 --average_normal.z < -0.5 -- return
			 --average_normal.z < -0.8 -- return

		)


			format "verts_arr: %\n" verts_arr
		if verts.count > 1 then
			verts_arr = for vert in verts_arr where normalLimit( polyop.getFacesUsingVert obj vert) collect vert

			format "verts_arr: %\n" verts_arr


		/* GET LOWEST POINT IN CELL */
		if verts.count > 1 then
		(
			--verts_arr = for vert in verts_arr where normalLimit( polyop.getFacesUsingVert obj vert) collect VertDataGetter.getPosition(vert) axis:#Z
			--format "verts_arr: %\n" verts_arr

			z_positions = for vert in verts_arr collect VertDataGetter.getPosition(vert) axis:#Z

			if ( index = findItem z_positions (amin z_positions) ) > 0 then
				verts_arr[index] --return
		)
		else
			verts_arr[1] --return

			--verts_arr[1] --return
	),

	/** Get verts to ocess


	 */
	function _getVertsToProcess =
	(
		format "\n"; print "VertSelector_v._getVertsToProcess()"
		verts_data = VertDataGetter.getData()

		verts_process = verts_data[#VERTS]
		--vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		--verts_count	= getNumVerts obj.mesh
		--verts_all	= #{1..(verts_count)}
		--
		--/* CHECK INDEXES OF VERTS NEEDED */
		----this._checkSelectionIngerity (vertex_sel as Array ) ( ( polyop.getVertSelection obj ) as Array )
		--
		--
		--/* VERTEX POSITIONS */
		--this.verts_data[#POSITIONS] = meshop.getVerts obj.mesh verts_all node:obj
		--
		--/* PROCESS ALL OR ONLY SELECTED VERTS */
		--this.verts_process = if vertex_sel.isEmpty then verts_all else vertex_sel
		--
		--
		--face_normals = for f = 1 to polyop.getNumFaces obj collect  polyop.getFaceNormal obj f
	),


	/** Get ace islands by verts
	  *
	  * @param BitArray verts which faces will be sorted by islands
	  *
	  * @return #( #{..} ) array of vertex ids, each array are verts of one island
	 */
	function _sortVertsByIslands =
	(
		--format "\n"; print "VertSelector_v.getAceIslandsByVerts()"
		function facesShareVerts verts1 verts2 = not ( verts1 * verts2 ).isEmpty

		tested_pairs	= #{} -- store stringified array of face id used in loop already
		verts_islands	= #() -- #( #{ veret_ids } ) array of bitarrays of verts sorted by island the occupy
		--face_islands	= #() -- #( #{ faces_ids } ) array of bitarrays of faces sorted by island the occupy
		verts_per_faces	= #()


		faces_by_verts = ( polyop.getFacesUsingVert obj verts_process) as Array

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

	/**
	 */
	on create do
	(
		--format "\n"; print "VertSelector.onCreate()"
		VertDataGetter 	= VertDataGetter_v( obj )
	)
)
