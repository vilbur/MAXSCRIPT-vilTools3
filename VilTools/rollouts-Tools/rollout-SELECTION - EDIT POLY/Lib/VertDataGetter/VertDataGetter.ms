filein( getFilenamePath(getSourceFileName()) + "/VertexColorGetter/VertexColorGetter.ms" )	--"./VertexColorGetter/VertexColorGetter.ms"


if VERTEX_DATA_CACHE == undefined then -- DEV
	global VERTEX_DATA_CACHE = Dictionary #integer


/**
 */
struct VertDataGetter_v
(
	/* construct */
	obj,

	/* properties */
	vertex_count,
	verts_process 	= #{}, -- source vertex to operate, selection or all verts if nothing selected
	--points_grid 	= #(), -- 2DMatrix of verts which share same cell in grid points_grid[X_CELL][Y_CELL]
	points_grid 	= #(), -- 2DMatrix of verts which share same cell in grid points_grid[X_CELL][Y_CELL]
	--sel_modified 	= #{}, -- modified selection for selecting
	verts_positions 	= #(),
	verts_normals	= #(),
	face_normals 	= #(),
	vertex_colors,

	/* dependency */
	VertexColorGetter,

	/* reference */
	/* inhered */

	/** Get data
	 */
	function getData positions:true colors:true normals:true =
	(
		--format "\n"; print "VertDataGetter_v.getData()"
		verts_data = Dictionary #( #VERTS, verts_process )

		this._setVertsPositions()

		if positions then
			verts_data[#POSITIONS] = this.getVertsPositions()

		if colors then
			verts_data[#COLORS] = this.getVertexColors()

		--if normals then
			--verts_data[#NORMALS] = this.getVertexNormals()


		verts_data --return
	),

	/** Get verts possitions
	 */
	function getVertsPositions =
	(
		--format "\n"; print "VertDataGetter_v.getVertsSitions()"
		for vert in verts_process collect  this.verts_positions[vert]
	),

	/** Get vertex colors
	 */
	function getVertexColors =
	(
		--format "\n"; print "VertDataGetter_v.getVertexColors()"
		--verts_count	= getNumVerts obj.mesh
		--verts_all	= #{1..(verts_count)}
		--vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		--verts_count_VC	= getNumCPVVerts obj.mesh

		vertex_colors = VertexColorGetter.getVertexColors (verts_process)
		--this._setVertexColors verts_to_get_colors:verts_process vertex_colors_exists:(getNumCPVVerts obj.mesh != 0)

		vertex_colors --return
	),

	/** Get vertex normals
	 */
	function getVertexNormals =
	(
		format "\n"; print "VertDataGetter_v.getVertexNormals()"
		timer_get_normals = timeStamp()

		if vertex_count < 7000 then
			this._setVertNormalsByFaceNormal()
		else
			this._setVertNormalsByModifier()

		verts_normals --return


		--format "\n getVertexNormals: % ms\n" (( timeStamp()) - timer_get_normals)
		--format "VERTS_NORMALS: %\n" verts_normals
		--format "\n------------\n"

		/* DEV - timer each method

			timer_normal_by_modifier = timeStamp()
			this._setVertNormalsByModifier()
			format "\n normal_by_modifier: % ms\n" (( timeStamp()) - timer_normal_by_modifier)
			format "VERTS_NORMALS: %\n" verts_normals
			format "\n------------\n"

			timer_normal_by_face_normal = timeStamp()
			this._setVertNormalsByFaceNormal()
			format "\n normal_by_face_normal: % ms\n" (( timeStamp()) - timer_normal_by_face_normal)
			format "VERTS_NORMALS: %\n" verts_normals
			format "\n\n\n"
			--verts_normals --return

		*/
	),

	private

	/** set vert normals by modifier
	 */
	function _setVertNormalsByModifier =
	(
		format "\n"; print "MeshVertexGetter_v._setVertNormalsByModifier()"
		--this.verts_normals = for vert in verts_process collect ( getnormal obj.mesh vert )
		sub_object_level = subObjectLevel

		EditNormalsMod = Edit_Normals()

		addModifier obj EditNormalsMod

		verts_normals = for i = 1 to (verts_process_arr = verts_process as Array ).count collect
		(
			normal_averaged	= [0,0,0]
			normals_per_vertex	= #{}

			vert = verts_process_arr[i]

			EditNormalsMod.ConvertVertexSelection #{vert} (normals_per_vertex)

			for normal in normals_per_vertex as Array do normal_averaged += EditNormalsMod.getNormal(normal) node:obj

			normalize normal_averaged
		)

		--verts_normals = for vert in verts_process collect (EditNormalsMod.getNormal(vert)) * obj.transform

		deleteModifier obj EditNormalsMod

		subObjectLevel = sub_object_level
	),

	/** Set vert normals by face normal
	 */
	function _setVertNormalsByFaceNormal =
	(
		format "\n"; print "VertDataGetter_v._setVertNormalsByFaceNormal()"
		/* get vert normal by averaging normals of their faces
		*/
		function getVertNormal faces_of_vert =
		(
			average_normal = point3 0 0 0

			for face_id in faces_of_vert do average_normal += this.face_normals[face_id]

			normalize average_normal
		)

		this._setFaceNormals()

		for vert in (verts_process as Array ) collect getVertNormal( polyop.getFacesUsingVert obj vert)
	),

	/** Get verts to ocess

	/** Set verts positions
	 */
	function _setVertsPositions =
	(
		--format "\n"; print "VertDataGetter_v._setVertsPositions()"
		this.verts_positions = meshop.getVerts obj.mesh (this._getAllVerts()) node:obj

	),

	/** Set face normals
	 */
	function _setFaceNormals =
	(
		--format "\n"; print "VertDataGetter_v._setFaceNormals()"
		face_normals = for f = 1 to polyop.getNumFaces obj collect  polyop.getFaceNormal obj f
	),

	/*
	 */
	function _setVertsToProcess =
	(
		format "\n"; print "VertexGridSelector_v._getVertsToProcess()"
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active


		/* CHECK INDEXES OF VERTS NEEDED */
		--this._checkSelectionIngerity (vertex_sel as Array ) ( ( polyop.getVertSelection obj ) as Array )

		/* PROCESS ALL OR ONLY SELECTED VERTS */
		verts_process = if vertex_sel.isEmpty then this._getAllVerts() else vertex_sel
	),

	/** Get all verts
	 */
	function _getAllVerts =
	(
		--format "\n"; print "VertDataGetter_v._getAllVerts()"
		#{1..(this.vertex_count)}
	),
	/** Set vertex colors Ditionary
	  *
	  * SINGLE MESH VERT CAN APPEAR IN MULTIPLE COLORS - Each map vert can has its own color
	  *
	  * NOTES:
	  *		1) getvertcolor()	INPUT CPV vertex
	  *		2) getVertsByColor()	RETURN MESH VERTEX
	  *
	  *
	  * KNOWING ISSUE: remove_multi_colored_verts_from_white
	  *				If vertex has mutliple colors, then first is used, include white color.
	  *				Only way to make it work seem to iterate all map verts. THIS IS OVERKIL FOR SUCH SIPMPLE OPARTION ON HIGH VERTEX COUNT OBJECTS... MAX SUCKS !
	  *
	  * @param boolean remove_multi_colored_verts_from_white TRUE: collect first non white color | FALSE: collect all colors for vert ( mesh vert is occuring in muliple colors )
	  *
	  * @return Dictionary of BitArrays of mesh verts sorted by color E.G.: #( "color 255 255 255", #{1..999}  )  #( "color 0 255 255", #{1..3}  )
	  */
	function _setVertexColors verts_to_get_colors: vertex_colors_exists: remove_multi_colored_verts_from_white:false =
	(

	),

	/**
	 */
	on create do
	(
		format "\n"; print "VertDataGetter.onCreate()"
		this.vertex_count = getNumVerts obj.mesh

		this._setVertsToProcess()

		this._setVertsPositions()


		VertexColorGetter	= VertexColorGetter_v(obj)


		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
