clearListener(); print("Cleared in:"+getSourceFileName())

fn round p3 dp =
(
	local tempArr = #(p3.x,p3.y,p3.z)
	local mult = 10.00^(dp as float)
	local rp3Arr = for c in tempArr collect ((floor ((c * mult)+0.5)) / mult)
	point3 rp3Arr[1] rp3Arr[2] rp3Arr[3]
)
--round [111.1589,12.856,85.5896] 3

	--
	--delete objects
	--obj = Plane width:60 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10 isSelected:on
	--
	--modPanel.addModToSelection (Noisemodifier scale:2 strength:[0,0,10] ) ui:on
	--
	----rotate obj ( angleaxis 180 [1,0,0])
	--
	--macros.run "Modifier Stack" "Convert_to_Poly"

	obj = selection[1]

	vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
	verts_count	= getNumVerts obj.mesh
	verts_all	= #{1..(verts_count)}

	verts_positions = meshop.getVerts obj.mesh verts_all node:obj
	--format "verts_positions as Array: %\n" (verts_positions as Array)

	/* ROUND POSTIONS TO TENS - [111.1589,12.856,85.5896] >>> [110,10,90] */
	pos_round = for pos in verts_positions collect round pos -1
	x_positions = for pos in pos_round collect pos.x
	y_positions = for pos in pos_round collect pos.y
	z_positions = for pos in pos_round collect pos.z

	--format "amin x_positions: %\n" (amin x_positions)
	--format "amax x_positions: %\n" (amax x_positions)

	x_size = (amax x_positions) - (amin x_positions)
	y_size = (amax y_positions) - (amin y_positions)

	--x_size /= 10
	--y_size /= 10

	points_grid = #()
--
	--format "x_size: %\n" x_size
	--format "y_size: %\n" y_size

	for x = (amin x_positions) to (amax x_positions) by 10 do
		for y = (amin y_positions) to (amax y_positions) by 10 do
		(
			--format "\n--------------------\n"
			--format "x: %\n" x
			--format "y: %\n" y

			points_in_square = for p = 1 to pos_round.count \
				where pos_round[p].x >= x \
				and pos_round[p].x < x + 10 \
				and pos_round[p].y >= y \
				and pos_round[p].y < y + 10 \
			collect p

		if points_in_square.count > 0 then
			append points_grid points_in_square
	 )

	lowest_verts = #{}

	for points_in_square in points_grid do
	(
		format "points_in_square: %\n" points_in_square

		verts_positions = meshop.getVerts obj.mesh (points_in_square as BitArray )  node:obj

		z_positions = for pos in verts_positions collect pos.z

		z_pos_min = amin z_positions

		index	= findItem z_positions (amin z_positions)

		--lowest_vert = #{( vertex_sel as Array )[index]}
		lowest_vert = ( points_in_square as Array )[index]

		lowest_verts[lowest_vert] = true

	)
		--format "points_in_square: %\n" points_in_square

	subObjectLevel = 1

	if classOf ( _mod = modPanel.getCurrentObject() ) == Edit_Poly then
	(
		_mod.SetSelection #Vertex #{}
		_mod.Select #Vertex lowest_verts

	)

	else fif classOf _mod  == Editable_Poly then
		_mod.SetSelection #Vertex lowest_verts

