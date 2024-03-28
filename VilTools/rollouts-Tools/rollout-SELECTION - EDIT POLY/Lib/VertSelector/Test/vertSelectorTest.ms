clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../VertSelector.ms" )	--"./../VertSelector.ms"

/**
  */
function createSourceMesh segments:8 vertex_selection:#{} test_shifted_pivot:false obj:#PLANE vertex_color: =
(
	format "\n"; print "MeshVertexGetterTest.ms.createSourceMesh()"
	delete objects

	segment_size = 10

	--obj = Plane length:( segment_size * segments ) width:( segment_size * segments ) pos:[ 0, 0, 300 ] widthsegs:segments lengthsegs:segments backfacecull: off
	obj = Sphere radius:20 pos:[0,0, 50 ] segments:segments showVertexColors:true	vertexColorsShaded:true -- diameter 3 cm

	--obj = Plane width:20 length:20 pos:[ 50, 20, 50 ] widthsegs:4 lengthsegs:4

	--obj = Plane width:100 length:100 pos:[ 50, 20, 50 ] widthsegs:100 lengthsegs:100
	--obj = Plane width:50 length:50 pos:[ 50, 20, 50 ] widthsegs:50 lengthsegs:50
	--obj = Plane width:60 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10
	--obj = Plane width:40 length:30 pos:[ 50, 20, 50 ] widthsegs:40 lengthsegs:30


	--obj = Plane width:30 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10
	--obj = Plane width:20 length:20 pos:[ 50, 20, 50 ] widthsegs:4 lengthsegs:4

	select obj

	modPanel.addModToSelection (Noisemodifier scale:5 strength:[0,0,10] ) ui:on

	Rotate obj ( AngleAxis 180 [1,0,0]) -- rotate object upside down

	macros.run "Modifier Stack" "Convert_to_Poly"

	if vertex_selection.count > 0 then
	(
		subObjectLevel = 1

		if vertex_color != unsupplied then
			polyop.setVertColor obj 0 vertex_selection vertex_color


		--polyop.setVertColor obj 0 vertex_selection.count red -- color last vertex in red color

		--obj.EditablePoly.SetSelection #Vertex vertex_selection
	)

	--modPanel.addModToSelection (Edit_Poly ()) ui:on
)



/*--------------------------------------------------------------------
	PREPARE TEST OBJECTS
--------------------------------------------------------------------------------*/
--createSourceMesh()
 --createSourceMesh vertex_selection:#{2..3} vertex_color:green
  createSourceMesh vertex_selection:#{1..100}  vertex_color:orange segments:64
  --createSourceMesh vertex_selection:#{1..100}  vertex_color:orange segments:120
  --createSourceMesh vertex_selection:#{1..100}  vertex_color:orange segments:128
  --createSourceMesh vertex_selection:#{1..100}  vertex_color:orange segments:256





/*------------------------------------------------------------------------------
	SET CLASS INSTANCE
--------------------------------------------------------------------------------*/
VertSelector 	= VertSelector_v( objects[1] ) resolution:10


VertSelector.resolution = 5

--for points_in_square in VertSelector.points_grid do
--	format "points_in_square: %\n" points_in_square




--/* SELECT LOWES VERTS ON OBJECT\SELECTION */
--VertSelector.getLowestVerts();	VertSelector.selectVerts()



/* LEFT ONLY LOWEST VERT IF MULTIPLE VERTS ARE ON ISLAND OF FACES */
--VertSelector.getSingleVertPerFaceIsland();--VertSelector.selectVerts()
--
--/* GET VERTEX IN CHECK BOARD PATTERN */
VertSelector.getCheckerSelection invert_sel:false;  VertSelector.selectVerts()


/*------------------------------------------------------------------------------

	TEST OF GETTING CELLS OF VERTS BY POSITION

------------------------------------------------------------------------------*/
--
--VertSelector.getVertsInGrid()
--
--format "points_grid: %\n"	VertSelector.points_grid
--format "CELLS ON X: %\n"	VertSelector.points_grid.count
--format "CELLS ON Y: %\n"	VertSelector.points_grid[1].count
--
--points_grid = VertSelector.points_grid
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
