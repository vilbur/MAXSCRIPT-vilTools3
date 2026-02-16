/** Standard material
  *
  *
  *
 */
struct StandartMat_v
(

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */

	/** Create standard material
	  *
	  */
	function create _name diffuse: specular: glossiness: opacity: selfIllumination: =
	(
		--format "\n"; print "StandartMat_v.createStandardMaterial()"
		params = Dictionary #( #diffuse, diffuse ) #( #specular, specular ) #( #glossiness, glossiness ) #( #opacity, opacity ) #( #selfIllumination, selfIllumination )

		local mat = Standardmaterial name:_name

		--format "mat:	% \n" mat
		--for param in params where param.value != unsupplied do
		--	setProperty mat ( param.key as string ) param.value
		format "classOf path_or_map: %\n" (classOf path_or_map)

		for param in params where param.value != unsupplied do
		(
					format "classOf param.value: %\n" (classOf param.value)

			if classOf param.value == string then
				this.setTextureFile mat param.value param.key
			else
			try(
				
				setProperty mat ( param.key as string ) param.value
				)catch()
			
		)

		mat --return
	),



	/** Get map slots
	 */
	function getMapSlots prop_list =
	(
		for prop in prop_list where matchPattern prop pattern:@"*alias for maps*" collect
			(trimLeft (filterString prop " ")[1] ".") as name
	),

	/** Set texture file
	 */
	function setTextureFile mat path_or_map map_name =
	(
		format "\n"; print "StandartMat_v.setTextureFile()"
		format "path_or_map: %\n" path_or_map
		format "classOf path_or_map: %\n" (classOf path_or_map)
		format "map_name: %\n" map_name
		--_bitmap = if classOf path_or_map == Bitmaptexture then path_or_map else Bitmaptexture filename:path_or_map

		_bitmap = case classOf path_or_map of
		(
			string: Bitmaptexture filename:path_or_map
			textureMap: path_or_map
			--default: 
		)
		format "_bitmap: %\n" _bitmap
		if _bitmap != undefined then
		(
			
			map_name = map_name as string
			
			if not matchPattern map_name pattern:("*Map") then
				map_name += "Map"
			setProperty mat map_name _bitmap
			
			this.showTextureInViewPort(mat)(map_name)(true)
		)
		
	),

	/** Show textures in view port
	 */
	function showTextureInViewPort mat map_name state =
	(
		format "\n"; print "StandartMat_v.showTexturesInViewPort()"
		map_slot = getProperty mat map_name
		--format "map_slot	= % \n" map_slot
		try ( showTextureMap mat map_slot state ) catch()
		
		redrawViews()
	),


	private


	on create do
	(
		--print "StandartMat_v.onCreate()"
	)
)