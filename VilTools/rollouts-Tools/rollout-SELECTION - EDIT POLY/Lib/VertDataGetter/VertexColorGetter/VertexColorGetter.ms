/** Vertex color getter
 */
struct VertexColorGetter_v
(
	/* construct */
	obj,

	/* properties */
	vertex_colors 	= Dictionary #string,


	/* dependency */
	MeshVertToColorVertexConvert,


	/* reference */
	/* inhered */


	/** Get vertex colors
	 */
	function getVertexColors verts_to_get_colors  =
	(
		format "\n"; print "VertexColorGetter_v.getVerticalColors()"
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
			while hasDictValue this.vertex_colors ( (color_of_vert = getvertcolor obj.mesh map_verts[i]) as string )  do
				i += 1

			color_of_vert --return
		)

		/** White verts exists
		 */
		function whiteVertsExists = hasDictValue this.vertex_colors ( white as string )

		local color_of_vert

		local white_clr = white as string

		/* IF VERTEX COLORS EXISTS */
		if  (getNumCPVVerts obj.mesh != 0) then
		(
			--format "START verts_to_get_colors	= % \n" verts_to_get_colors
			--format "verts_to_get_colors.numberSet	= % \n" verts_to_get_colors.numberSet

			MeshVertToColorVertexConvert.get_single_vert = false

			while not verts_to_get_colors.isEmpty do
			(
				mesh_vert = (verts_to_get_colors as Array )[1]

				map_verts_of_mesh_vert = makeUniqueArray (MeshVertToColorVertexConvert.meshVertsToMapVerts (mesh_vert) flat:true )

				color_of_vert = _searchNewVertexColor (map_verts_of_mesh_vert)

				mesh_verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color

				this.vertex_colors[ color_of_vert as string ] = mesh_verts_by_color

				verts_to_get_colors -= mesh_verts_by_color

			)

			/* REMOVE MULTI COLORED VERTS FROM WHITE - (if one of vert colors is not white, then vert is not white) */
			if whiteVertsExists() then
				for clr in this.vertex_colors.keys  where clr != white_clr do
					this.vertex_colors[white_clr] -= vertex_colors[clr]
		)
		--else
			--vertex_colors[ obj.wirecolor as string ] = verts_to_get_colors

		vertex_colors --return
	),


	private


	/**
	 */
	on create do
	(
		--format "\n"; print "VertexColorGetter.onCreate()"
		MeshVertToColorVertexConvert	= MeshVertToColorVertexConvertor_v(obj)
	)

)
