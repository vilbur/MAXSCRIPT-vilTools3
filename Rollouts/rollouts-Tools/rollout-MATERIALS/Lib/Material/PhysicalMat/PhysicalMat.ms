/** Physical material
  *
  * 
  *
 */
struct PhysicalMat_v
(
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	
	
	/** Set texture file
	 */
	function setTextureFile mat file_path map_name =
	(
		format "\n"; print "PhysicalMat_v.setTextureFile()"

		setProperty mat (this._convertMapType(map_name)) (Bitmaptexture filename:file_path)
		
		this.showTextureInViewPort(mat)(map_name)(true)
	),
	

	/** Show textures in view port
	 */
	function showTextureInViewPort mat map_name state =
	(
		format "\n"; print "PhysicalMat_v.showTexturesInViewPort()"
		
		map_slot = getProperty mat (this._convertMapType(map_name))
		--format "map_slot	= % \n" map_slot
		try ( showTextureMap mat map_slot state ) catch()
	),
	
	private
	
	/** Convert map type from standart material to physical E.G.: #diffuseMap >>> #base_color_map
	  *
	  * Wrapper for front end user friendly codin
	  *
	 */
	function _convertMapType map_name =
	(
		--format "\n"; print "PhysicalMat_v.convertMapType()"
		
		case map_name of
		(
			#diffuseMap:	#base_color_map
			default:	map_name
		)
		
	),
	
	
	on create do
	(
		--print "PhysicalMat_v.onCreate()"
	)
)