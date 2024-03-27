filein( getFilenamePath(getSourceFileName()) + "/MeshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms" )	--"./MeshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms"

if VERTEX_DATA_CACHE == undefined then -- DEV
	global VERTEX_DATA_CACHE = Dictionary #integer -- store vertex normals VERTEX_DATA_CACHE[sliderTime]["obj pointer"][#transform|#verts|#positions|#normals]



/**
 */
struct VertDataGetter_v
(
	/* construct */
	obj,

	/* properties */
	vertex_count,
	cache_data,

	verts 	= #{}, -- source vertex to operate, selection or all verts if nothing selected
	positions 	= #(),
	normals	= #(),
	colors 	= Dictionary #string,

	face_normals 	= #(),
	--points_grid 	= #(), -- 2DMatrix of verts which share same cell in grid points_grid[X_CELL][Y_CELL]
	--sel_modified 	= #{}, -- modified selection for selecting

	get_normal_method_limit = 7000, -- vertex count where Edit_Normals modifier if faster for getting normals
	/* dependency */
	MeshVertToColorVertexConvert,

	/* reference */
	/* inhered */

	/** Get data
	 */
	function getData positions:true colors:true normals:true =
	(
		format "\n"; print "VertDataGetter_v.getData()"
		format "this.verts: %\n" this.verts


		verts_data = Dictionary #( #VERTS, verts )

		this._setVertsPositions()

		--if positions then
		--	verts_data[#POSITIONS] = this.positions
		--
		--
		--if colors then
		--	verts_data[#COLORS] = this.getVertexColors()

		if normals then
		(
			--this._setCacheData()
			this._setVertexNormals()


		--	verts_data[#NORMALS] =
		)


		verts_data --return
	),

	/** Get verts possitions
	 */
	function getVertsPositions =
	(
		--format "\n"; print "VertDataGetter_v.getVertsSitions()"
		for vert in verts collect  this.positions[vert]
	),

	/** Get vertex colors
	 */
	function getVertexColors =
	(
		--format "\n"; print "VertDataGetter_v.getVertexColors()"
		this._setVertexColors()

		colors --return
	),

	private

	/** Get vertex normals
	 */
	function _getVertexNormals verts_get =
	(
		format "\n"; print "VertDataGetter_v._setVertexNormals()"
		if vertex_count < get_normal_method_limit then
			this._getVertNormalsByFaceNormal(verts_get)--return
		else
			this._getVertNormalsByModifier(verts_get)--return
	),

	/** set vert normals by modifier
	 */
	function _getVertNormalsByModifier verts_get =
	(
		format "\n"; print "MeshVertexGetter_v._getVertNormalsByModifier()"
		--this.normals = for vert in verts collect ( getnormal obj.mesh vert )

		verts_get = verts_get as Array

		sub_object_level = subObjectLevel

		EditNormalsModifier = Edit_Normals()

		addModifier obj EditNormalsModifier

		_normals = for i = 1 to verts_get.count collect
		(
			normal_averaged	= [0,0,0]
			normals_per_vertex	= #{}

			vert = verts_get[i]

			EditNormalsModifier.ConvertVertexSelection #{vert} (normals_per_vertex)

			for normal in normals_per_vertex as Array do normal_averaged += EditNormalsModifier.getNormal(normal) node:obj

			normalize normal_averaged
		)

		--normals = for vert in verts collect (EditNormalsModifier.getNormal(vert)) * obj.transform

		deleteModifier obj EditNormalsModifier

		subObjectLevel = sub_object_level

		_normals --return
	),

	/** Set vert normals by face normal
	 */
	function _getVertNormalsByFaceNormal verts_get =
	(
		format "\n"; print "VertDataGetter_v._getVertNormalsByFaceNormal()"
		/* get vert normal by averaging normals of their faces
		*/
		function getVertNormal faces_of_vert =
		(
			average_normal = point3 0 0 0

			for face_id in faces_of_vert do average_normal += this.face_normals[face_id]

			normalize average_normal
		)

		this._setFaceNormals()

		for vert in (verts_get as Array ) collect getVertNormal( polyop.getFacesUsingVert obj vert)
	),

	/** Get verts to ocess

	/** Set verts positions
	 */
	function _setVertsPositions =
	(
		--format "\n"; print "VertDataGetter_v._setVertsPositions()"
		this.positions = meshop.getVerts obj.mesh verts node:obj
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
		format "\n"; print "VertexGridSelector_v._setVertsToProcess()"
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active

		format "vertex_sel: %\n" vertex_sel
		format "this._getAllVerts(): %\n" (this._getAllVerts())

		/* CHECK INDEXES OF VERTS NEEDED */
		--this._checkSelectionIngerity (vertex_sel as Array ) ( ( polyop.getVertSelection obj ) as Array )

		/* PROCESS ALL OR ONLY SELECTED VERTS */
		this.verts = if vertex_sel.isEmpty then this._getAllVerts() else vertex_sel

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
	function _setVertexColors =
	(
		--format "\n"; print "MeshVertexGetter_v._setVertexColors()"
		/** Loop map verts of single mesh vert
		  *
		  * Test if vertex color is new
		  *
		  * @retrun color of map vertex
		 */
		function _searchNewVertexColor map_verts =
		(
			--format "\n"; print "MeshVertexGetter_v._searchNewVertexColor()"
			local color_of_vert

			i = 1
			while hasDictValue this.colors ( (color_of_vert = getvertcolor obj.mesh map_verts[i]) as string )  do
				i += 1

			color_of_vert --return
		)

		/** White verts exists
		 */
		function whiteVertsExists = hasDictValue this.colors ( white as string )

		local color_of_vert

		local white_clr = white as string

		/* IF VERTEX COLORS EXISTS */
		if  (getNumCPVVerts obj.mesh != 0) then
		(
			MeshVertToColorVertexConvert.get_single_vert = false

			while not verts.isEmpty do
			(
				mesh_vert = (verts as Array )[1]

				map_verts_of_mesh_vert = makeUniqueArray (MeshVertToColorVertexConvert.meshVertsToMapVerts (mesh_vert) flat:true )

				color_of_vert = _searchNewVertexColor (map_verts_of_mesh_vert)

				mesh_verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color

				this.colors[ color_of_vert as string ] = mesh_verts_by_color

				verts -= mesh_verts_by_color
			)

			/* REMOVE MULTI COLORED VERTS FROM WHITE - (if one of vert colors is not white, then vert is not white) */
			if whiteVertsExists() then
				for clr in this.colors.keys  where clr != white_clr do
					this.colors[white_clr] -= colors[clr]
		)
	),

	/** Set cache data

	   VERTEX_DATA_CACHE[sliderTime]["obj pointer"][#TRANSFORM|#VERTS|#POSITIONS|#NORMALS]

	 */
	function _setVertexNormals =
	(
		format "\n"; print "VertDataGetter_v._setVertexNormals()"


		--fn transformChanged	verts_data =  verts_data[#transform] != this.obj.transform
		--fn vertsSelChanged	verts_data =  ( verts_data[2] - this.verts_to_get ).isEmpty == false
		--fn positionChanged	verts_data = ( with PrintAllElements on verts_data[3] as string == this.positions as string )
		--fn normalsChanged		verts_data =  verts_data[4].count != this.verts_to_get.numberSet

		function dataIndex vertex_index = findItem this.verts vertex_index

		function cacheDataIndex cache_data vertex_index = findItem cache_data[#VERTS] vertex_index

		cache_data = this._getCacheData()
		format "this.verts: %\n" this.verts
		format "this.positions: %\n" this.positions
		verts_new	= verts - cache_data[#VERTS]
		verts_in_cache	= verts * cache_data[#VERTS]
		format "verts_new: %\n" verts_new
		format "verts_in_cache: %\n" verts_in_cache
		 --for vert in verts_in_cache do
			--format "vert: %\n" dataIndex(vert)


		pos_current = for vert in verts_in_cache collect this.positions [dataIndex(vert)]
		pos_cache	  = for vert in verts_in_cache collect cache_data[#positions][dataIndex(vert)]

		verts_update_chache = (for i = 1 to verts_in_cache.count where pos_cache[i] != pos_current[i] collect verts_in_cache[i]) as BitArray
		format "verts_update_chache: %\n" verts_update_chache
		verts_update = verts_update_chache + verts_new
		format "verts_update: %\n" verts_update

		normals_new = this._getVertexNormals ( verts_update )


		if cache_data[#NORMALS].count > 0 then
		(
			for vert in verts_update do
			(
				cache_data[#VERTS][vert] = true -- add vertex to chache

				cache_index = findItem cache_data[#VERTS] vert -- get its index in chache

				vertex_normal = normals_new[cache_index]


				if verts_update_chache[vert] then
					/* UPDATE OLD */
					cache_data[#NORMALS][cache_index] = vertex_normal
				else
					/* INSERT NEW NORMAL */
					insertItem vertex_normal cache_data[#NORMALS] cache_index
			)
		)
		else
		(
			cache_data[#VERTS]   = verts_new
			cache_data[#NORMALS] = normals_new
		)


		cache_data[#POSITIONS] = meshop.getVerts obj.mesh cache_data[#VERTS] node:obj

		format "CACHE_DATA: %\n" cache_data
		format "this.verts: %\n" this.verts
		format "cache_data[#VERTS]: %\n" cache_data[#VERTS]

		VERTEX_DATA_CACHE[sliderTime as integer ][getHandleByAnim obj as string ] = cache_data

		/* DEBUG */
		cache_data_test = VERTEX_DATA_CACHE[sliderTime as integer ][getHandleByAnim obj as string ]
		--for key in cache_data_test.keys where (cache_data_test[key] as Array ).count != cache_data_test[#VERTS].numberSet do
			--format "VertDataGetter_v._setVertexNormals() CACHE DATA COUNT IS NOT CONSISTENT: %\n" key
		format "this.verts: %\n" this.verts

		for key in cache_data_test.keys do
			format "%: %\n" key (cache_data_test[key] as Array ).count
	),

	/** Set new cache
	 */
	function _getCacheData =
	(
		--format "\n"; print "VertDataGetter_v._setNewChache()"
		object_pointer = (getHandleByAnim obj) as string

		time_key = sliderTime as integer

		if VERTEX_DATA_CACHE[ time_key ] == undefined then
			VERTEX_DATA_CACHE[ time_key ] = Dictionary #string


		if VERTEX_DATA_CACHE[ time_key ][object_pointer] == undefined then
			VERTEX_DATA_CACHE[ time_key][object_pointer] = Dictionary #( #VERTS, #{} )  #( #POSITIONS, #()	)  #( #NORMALS,	#())

		VERTEX_DATA_CACHE[time_key][object_pointer] --return
	),

--	/** Data index
--	  *
--	  * @return integer acces indexto this.positions|this.colors|this.normals
--	*/
--   function dataIndex vertex_index =
--   (
--	   format "\n"; print "VertDataGetter_v.dataIndex()"
--	   format "this.verts: %\n" this.verts
--	   format "vertex_index: %\n" vertex_index
--	   format "index: %\n" (findItem this.verts vertex_index)
--
--	   findItem this.verts vertex_index
--   ),

	/**
	 */
	on create do
	(
		format "\n"; print "VertDataGetter.onCreate()"
		this.vertex_count = getNumVerts obj.mesh

		this._setVertsToProcess()

		this._setVertsPositions()

		MeshVertToColorVertexConvert	= MeshVertToColorVertexConvertor_v(obj)

		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
