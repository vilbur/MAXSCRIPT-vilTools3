clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../vertexGridSelector.ms" )	--"./../vertexGridSelector.ms"



/** Prepre ene
 */
function prepareScene vertex_selection:false =
(
	--format "\n"; print ".prepreEne()"
	delete objects

	--obj	= Sphere()
	obj	= Teapot radius:10 segs:8  pos:[ 0, 0, 50 ]
	--obj	= Teapot radius:10 segs:64  pos:[ 0, 0, 50 ]

	--obj = Plane width:20 length:20 pos:[ 50, 20, 50 ] widthsegs:4 lengthsegs:4

	--obj = Plane width:100 length:100 pos:[ 50, 20, 50 ] widthsegs:100 lengthsegs:100
	--obj = Plane width:50 length:50 pos:[ 50, 20, 50 ] widthsegs:50 lengthsegs:50
	--obj = Plane width:60 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10
	--obj = Plane width:40 length:30 pos:[ 50, 20, 50 ] widthsegs:40 lengthsegs:30


	--obj = Plane width:30 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10
	--obj = Plane width:20 length:20 pos:[ 50, 20, 50 ] widthsegs:4 lengthsegs:4

	select obj

	--modPanel.addModToSelection (Noisemodifier scale:5 strength:[0,0,10] ) ui:on

	--rotate obj ( angleaxis 180 [1,0,0])

	macros.run "Modifier Stack" "Convert_to_Poly"

	if vertex_selection then
	(
		subObjectLevel = 1

		try( obj.EditablePoly.SetSelection #Vertex #{ 1..(getNumVerts obj.mesh/2)} )catch()
	)

	--obj = selection[1]
)


prepareScene()
--prepareScene vertex_selection:true



/*------------------------------------------------------------------------------
	SET CLASS INSTANCE
--------------------------------------------------------------------------------*/
VertexGridSelector 	= VertexGridSelector_v( objects[1] ) resolution:10


VertexGridSelector.resolution = 5

--for points_in_square in VertexGridSelector.points_grid do
--	format "points_in_square: %\n" points_in_square




--/* SELECT LOWES VERTS ON OBJECT\SELECTION */
VertexGridSelector.getLowestVerts();	VertexGridSelector.selectVerts()



/* LEFT ONLY LOWEST VERT IF MULTIPLE VERTS ARE ON ISLAND OF FACES */
--VertexGridSelector.getSingleVertPerFaceIsland();--VertexGridSelector.selectVerts()
--
--/* GET VERTEX IN CHECK BOARD PATTERN */
--VertexGridSelector.getCheckerSelection invert_sel:false;  VertexGridSelector.selectVerts()
/*------------------------------------------------------------------------------

	TEST OF GETTING CELLS OF VERTS BY POSITION

------------------------------------------------------------------------------*/
--
--VertexGridSelector.getVertsInGrid()
--
--format "points_grid: %\n"	VertexGridSelector.points_grid
--format "CELLS ON X: %\n"	VertexGridSelector.points_grid.count
--format "CELLS ON Y: %\n"	VertexGridSelector.points_grid[1].count
--
--points_grid = VertexGridSelector.points_grid
--
--
--format "points_grid[1][1]: %\n" points_grid[1][1]
--format "points_grid[1][2]: %\n" points_grid[1][2]
--
----format "points_grid[2][1]: %\n" points_grid[2][1]
----format "points_grid[2][2]: %\n" points_grid[2][2]
--
--
--
--_mod = modPanel.getCurrentObject()
--
--
--subObjectLevel = 1
--_mod.SetSelection #Vertex (points_grid[1][1])
--_mod.SetSelection #Vertex (points_grid[ 1 ][ 2 ])
--_mod.SetSelection #Vertex (points_grid[ 2 ][ 2 ])
--_mod.SetSelection #Vertex (points_grid[ 3 ][ 2 ])
