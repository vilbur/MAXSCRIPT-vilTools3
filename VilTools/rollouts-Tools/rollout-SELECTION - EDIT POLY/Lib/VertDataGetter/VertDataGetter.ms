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

	get_normal_method_limit = 7000, -- vertex count where Edit_Normals modifier if faster for getting normals
	/* dependency */
	MeshVertToColorVertexConvert,

	/* reference */
	/* inhered */

	/** Get data
	 */
	function getData verts: positions:true colors:true normals:true =
	(
		format "\n"; print "VertDataGetter_v.getData()"
		--format "positions: %\n" positions
		--format "colors: %\n" colors
		--format "normals: %\n" normals

		this._setVertsToProcess(verts)
		--format "VERTS: %\n" this.verts

		if positions then
			this._setVertsPositions()

		if colors then
			this._setVertexColors()

		timer_normals = timeStamp()

		if normals then
			this._setVertexNormals()
		--format "\n normals: % ms\n" (( timeStamp()) - timer_normals)

		--format "NORMALS: %\n" this.normals
		this._getVertsData #( #POSITIONS, #COLORS, #NORMALS ) #( positions, colors, normals ) --return
	),

	/** Get position
	 */
	function get prop vert =
	(
		--format "\n"; print "VertDataGetter_v.get()"
		--format "prop: %\n" prop
		--format "vert: %\n" vert
		--format "index: %\n" (this.dataIndex(vert))
		--format "data: %\n" (getProperty this prop)

		(getProperty this prop)[this.dataIndex(vert)] -- get value from E.G.: this[#POSITIONS][data_index]
	),

	/** Get position

	  * @param #X|#Y|#Z axis
	 */
	function getPosition vert axis: =
	(
		--format "\n"; print "VertDataGetter_v.getPosition()"
		if ( pos = positions[this.dataIndex(vert)] ) != undefined and axis != unsupplied then
			getProperty pos axis
		else
			pos
	),

	/*
	  * @param #X|#Y|#Z axis
	 */
	function getNormal vert =
	(
		--format "\n"; print "VertDataGetter_v.getPosition()"
		this.normals[this.dataIndex(vert)] --return
	),
	/* Get index of data by vertex number in this.positions|normlas|colors|
	*
	* Bitarray way to accomplish : findItem (this.verts_arr) vertex_index
	*
	*/
	function dataIndex vertex_index =
	(
		--format "\n"; print "VertDataGetter_v.dataIndex()"
		--format "vertex_index: %\n" vertex_index
		--format "verts: %\n" verts
		--format "-verts: %\n" -verts
		missing = -verts - #{vertex_index..(vertex_count)} -- find how many indexes is false before vertex_index
		--format "missing: %\n" missing
		--format "missing.numberSet: %\n" missing.numberSet

		vertex_index - missing.numberSet
	),

	private

	/** Get verts data
	 */
	function _getVertsData props get_prop =
	(
		--format "\n"; print "VertDataGetter_v._getVertsData()"
		verts_data =  Dictionary #( #VERTS, this.verts )


		for i = 1 to props.count where get_prop[i] do
			verts_data[props[i]] = getProperty this props[i]

		verts_data --return
	),




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
			--format "map_verts: %\n" map_verts
			--format "this.colors: %\n" this.colors
			--format "COLOR: %\n" (getvertcolor obj.mesh map_verts[1])
			local color_of_vert

			i = 1
			while map_verts[i] != undefined and hasDictValue this.colors ( (color_of_vert = getvertcolor obj.mesh map_verts[i]) as string )  do
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

			verts_get_colors = copy verts

			while not verts_get_colors.isEmpty do
			(
				mesh_vert = ( verts_get_colors as Array )[1]

				map_verts_of_mesh_vert = makeUniqueArray (MeshVertToColorVertexConvert.meshVertsToMapVerts (mesh_vert) flat:true )

				color_of_vert = _searchNewVertexColor (map_verts_of_mesh_vert)

				mesh_verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color

				this.colors[ color_of_vert as string ] = mesh_verts_by_color

				verts_get_colors -= mesh_verts_by_color
			)

			/* REMOVE MULTI COLORED VERTS FROM WHITE - (if one of vert colors is not white, then vert is not white) */
			if whiteVertsExists() then
				for clr in this.colors.keys  where clr != white_clr do
					this.colors[white_clr] -= colors[clr]
		)
	),

	/** Set vertex normals
		Normals are stored in chache, because its time consuming to get then on high vertex count


	   VERTEX_DATA_CACHE[sliderTime]["obj pointer"][#TRANSFORM|#VERTS|#POSITIONS|#NORMALS]

	 */
	function _setVertexNormals =
	(
		format "\n"; print "VertDataGetter_v._setVertexNormals()"
		/* Get index of data by vertex number in chache
		* Bitarray way to accomplish : findItem (this.verts_arr) vertex_index
		*/
		function cacheDataIndex vertex_index =
		(
			--format "\n"; print "VertDataGetter_v.normalIndex()"
			vertex_count_in_cache = this.cache_data[#VERTS].count

			missing = -verts - #{vertex_index..(vertex_count)} -- find how many indexis is false before vertex_index

			index = vertex_index - missing.numberSet
			--format "index: %\n" index
			index --return
		)
		--function normalIndex vertex_index = findItem (this.verts_arr) vertex_index
		function normalIndex normals_arr verts_get_normals  vertex_index =
		(
			missing = -verts_get_normals - #{vertex_index..(vertex_count)} -- find how many indexis is false before vertex_index

			normals_arr[ vertex_index - missing.numberSet ]
		)

		verts_update_chache = #{}

		if this.positions.count == 0 then	this._setVertsPositions()

		this.cache_data = this._getCacheData()

		verts_new	= verts - cache_data[#VERTS] -- verts which are not in cache yet
		verts_in_cache	= verts * cache_data[#VERTS] -- verts in chache already

		--format "verts: %\n" verts
		--format "cache_data[#VERTS]: %\n" cache_data[#VERTS]
		--format "VERTS_NEW: %\n" verts_new
		/* GET CURRENT  AND CACHE VERTS POSITIONS */
		timer_TEST = timeStamp()
		for vert in verts_in_cache do
		(
			--vert	= verts_in_cache[i]

			pos_current = (this.positions [this.dataIndex(vert)])
			pos_cache   = (cache_data[#positions][cacheDataIndex(vert)])

			if pos_cache != pos_current then
				verts_update_chache[vert] = true
		)
		--format "\n TEST: % ms\n" (( timeStamp()) - timer_TEST)


		verts_get_normals = verts_update_chache + verts_new
		--format "VERTS_GET_NORMALS: %\n" verts_get_normals

		/* UPDATE NORMAL IF VERT CHANGE ITS POSITION */
		if verts_get_normals.numberSet > 0 then
		(
			normals_update    = this._getVertexNormals ( verts_get_normals )

			for vert in verts_get_normals do
			(
				--vertex_normal = normals_update[findItem (verts_get_normals as Array ) vert]
				--format "VERT: %\n" vert
				vertex_normal = normalIndex (normals_update)(verts_get_normals)(vert)
				--format "VERT: %\n" vert

				--format "VERTEX_NORMAL: %\n" vertex_normal
				this.cache_data[#VERTS][vert] = true -- add vertex to chache

				if not verts_update_chache[vert] then
					insertItem vertex_normal cache_data[#NORMALS] (cacheDataIndex(vert))

				else
					this.cache_data[#NORMALS][cacheDataIndex(vert)] = vertex_normal
			)

			/* SET VERTEX POSTIONS */
			this.cache_data[#POSITIONS] = meshop.getVerts obj.mesh cache_data[#VERTS] node:obj

			/* UPDATE CAHCE GLOBAL VARIABLE */
			VERTEX_DATA_CACHE[ sliderTime as integer ][getHandleByAnim obj as string ] = this.cache_data

		)

		this.normals = for vert in verts collect this.cache_data[#NORMALS][cacheDataIndex(vert)]
	),

	/** Get vertex normals
	 */
	function _getVertexNormals verts_get =
	(
		format "\n"; print "VertDataGetter_v._getVertexNormals()"
		if vertex_count < get_normal_method_limit then
			this._getVertNormalsByFaceNormal(verts_get)--return
		else
			this._getVertNormalsByModifier(verts_get)--return
	),

	/** set vert normals by modifier
	 */
	function _getVertNormalsByModifier verts_get =
	(
		--format "\n"; print "MeshVertexGetter_v._getVertNormalsByModifier()"
		--this.normals = for vert in verts collect ( getnormal obj.mesh vert )

		--verts_get = verts_get as Array

		sub_object_level = subObjectLevel

		EditNormalsModifier = Edit_Normals()

		addModifier obj EditNormalsModifier

		--_normals = for i = 1 to verts_get.count collect
		_normals = for vert in verts_get collect
		(
			--format "\n----------\n"
			--format "vert: %\n" vert

			normal_averaged	= [0,0,0]
			normals_per_vertex	= #{}

			--vert = verts_get[i]

			EditNormalsModifier.ConvertVertexSelection #{vert} (normals_per_vertex) -- cast normals ids of vertex to normals_per_vertex BitArray
			--format "normals_per_vertex: %\n" normals_per_vertex
			for normal in normals_per_vertex do normal_averaged += EditNormalsModifier.getNormal(normal) node:obj

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
		--format "\n"; print "VertDataGetter_v._getVertNormalsByFaceNormal()"
		--format "verts_get: %\n" verts_get
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

	--/** Update cache nornal
	-- */
	--function _updateNormalInCache update_or_insert vert vertex_normal =
	--(
	--	--format "\n"; print "VertDataGetter_v._updateNormalInCache()"
	--	--format "verts_update_chache: %\n" verts_update_chache
	--	this.cache_data[#VERTS][vert] = true -- add vertex to chache
	--
	--	if update_or_insert then
	--		/* UPDATE OLD */
	--		this.cache_data[#NORMALS][cache_index] = vertex_normal
	--	else
	--		/* INSERT NEW NORMAL */
	--		insertItem vertex_normal cache_data[#NORMALS] cache_index
	--),

	/** Get data from chache
	  * Create blank data for object if not exists
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
	/*
	 */
	function _setVertsToProcess verts_to_get =
	(
		--format "\n"; print "VertexGridSelector_v._setVertsToProcess()"
		this.verts =  if verts_to_get == unsupplied then
		(
			vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active

			/* CHECK INDEXES OF VERTS NEEDED */
			--this._checkSelectionIngerity (vertex_sel as Array ) ( ( polyop.getVertSelection obj ) as Array )

			/* PROCESS ALL OR ONLY SELECTED VERTS */
			if vertex_sel.isEmpty then this._getAllVerts() else vertex_sel
		)
		else
			verts_to_get

		--format "this.verts: %\n" this.verts
		--this.verts_arr = this.verts as Array
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "VertDataGetter.onCreate()"
		this.vertex_count = getNumVerts obj.mesh

		MeshVertToColorVertexConvert	= MeshVertToColorVertexConvertor_v(obj)

		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)