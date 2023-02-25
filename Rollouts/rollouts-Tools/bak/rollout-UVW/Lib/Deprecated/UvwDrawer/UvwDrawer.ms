/** Uvw viewer
  
  
  1) Get UV vertices by Geo Vertices
  
  
 */
struct UvwDrawer_v
(
	--__construct = #( #property_name ),

	/* construct */
	obj,

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	map_channel = 1,
	bitmap_size = [256,256],

	/** Draw UVW
	 */
	function drawUVW =
	(
		format "\n"; print "UvwDrawer_v.drawUVW()"
		--obj = selection[1]
		
		if( myBitmap != undefined ) then 
			unDisplay myBitmap
		
		face_count = polyop.getNumMapFaces obj map_channel
		
		--format "face_count	= % \n" face_count
		global myBitmap = bitmap bitmap_size.x bitmap_size.y color:( color 0 0 0 )
		
		for face_id = 1 to face_count do
			this._drawFace (face_id)
		
		display myBitmap
	),

	--private

	function _getOpenUvwEdges =
	(
		format "\n"; print "UvwDrawer_v._getOpenUvwEdges()"
		
		uv_vertices = for i = 1 to (polyop.getnummapverts obj map_channel) collect polyop.getMapVert obj map_channel i
		format "uv_vertices	= % \n" uv_vertices
		
		obj_snapshot = snapshotAsMesh obj

		numTFaces = meshop.getNumMapFaces obj_snapshot map_channel
		numTVerts = meshop.getNumMapVerts obj_snapshot map_channel
	
		facesTVertsIdx = for j = 1 to numTFaces collect (meshop.getMapFace obj_snapshot map_channel j)
	
		emesh = trimesh()
		
		setMesh emesh numverts:numTVerts numfaces:numTFaces
		setMesh emesh faces:facesTVertsIdx
	
		open_edges_obj  =   meshop.getOpenEdges obj_snapshot
		open_edges_mesh = ( meshop.getOpenEdges emesh) - open_edges_obj
		--
		
		for _edge in (open_edges_mesh as array ) do
		(
			verts = meshop.getVertsUsingEdge emesh #{_edge}
			format "_edge	= % \n" _edge 
			format "verts	= % \n" verts	
			
		)
		
		getMapVert 
		--vertexPos = #()
		--
		--shared_faces = meshop.getFacesUsingEdge emesh open_edges_mesh
		--
		--shared_faces = meshop.getFacesUsingEdge obj_snapshot open_edges_obj
		format "open_edges_obj	= % \n" open_edges_obj
		format "open_edges_mesh	= % \n" open_edges_mesh
	
		--this.drawUVW()

	
		delete obj_snapshot
		delete emesh
	
	),
	

	/** Draw face
	 */
	function _drawFace face_id =
	(
		format "\n"; print "UvwDrawer_v.drawFace()"
		bitmapx_1 = bitmap_size.x-1
		bitmapy_1 = bitmap_size.y-1

		vertices_of_face = polyop.getMapFace obj map_channel face_id

		--polyop.getEdgesUsingVert obj

		
		
		for v=1 to vertices_of_face.count do
		(	
			format "vertices_of_face[v]	= % \n" vertices_of_face[v]
			
			
			
			if v < vertices_of_face.count then	
			(
				vert1= polyop.getMapVert obj map_channel vertices_of_face[v]
				vert2= polyop.getMapVert obj map_channel vertices_of_face[v+1]
			)
			else
			(
				vert1= polyop.getMapVert obj map_channel vertices_of_face[v]
				vert2= polyop.getMapVert obj map_channel vertices_of_face[1]																	
			)

			vert1X = vert1.x
			vert1Y = vert1.y
			vert2X = vert2.x
			vert2Y = vert2.y

			this._drawLine myBitmap [vert1X  * bitmapx_1, bitmapy_1 - vert1Y * bitmapy_1] [vert2X * bitmapx_1, bitmapy_1 - vert2Y * bitmapy_1]  #((color 255 255 255))  --DRAWW EVERTHNG
		)
	),

	/**  
	  *	
	  */
	function _drawLine img start end col =
	(
		steep = (abs (end.y - start.y)) > (abs (end.x - start.x))

		if steep then
		(
			swap start.x start.y
			swap end.x end.y
		)

		if start.x > end.x then
		(
			swap start.x end.x
			swap start.y end.y
		)

		delta_x = end.x - start.x
		delta_y = abs (end.y - start.y)
		error = delta_x / 2.0
		y_step = -1
		y = start.y

		if start.y < end.y then
		(
			y_step = 1
		)

		for x in start.x to end.x do
		(
			this._plot img [x, y] steep col
			error -= delta_y
			if error < 0 then
			(
				y += y_step
				error += delta_x
			)
		)
		img --return
	),

	/**  
	  *	
	  */
	function _plot img coord steep col =
	(
		if steep then
			swap coord[1] coord[2]
		
		--setPixels img coord #(col)
		setPixels img coord col
	),

	/**  
	 */
	on create do
	(
		print("UvwDrawer_v.onCreate()")
	)
)