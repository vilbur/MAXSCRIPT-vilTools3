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
	
	
	/** Set texture file
	 */
	function setTextureFile mat file_path map_name =
	(
		format "\n"; print "StandartMat_v.setTextureFile()"

		setProperty mat map_name (Bitmaptexture filename:file_path)
		
		this.showTextureInViewPort(mat)(true)
	),

	/** Show textures in view port
	 */
	function showTextureInViewPort mat map_name state =
	(
		format "\n"; print "StandartMat_v.showTexturesInViewPort()"
		map_slot = getProperty mat map_name
		--format "map_slot	= % \n" map_slot
		try ( showTextureMap mat map_slot state ) catch()
	),
	
	private
	
	
	on create do
	(
		--print "StandartMat_v.onCreate()"
	)
)