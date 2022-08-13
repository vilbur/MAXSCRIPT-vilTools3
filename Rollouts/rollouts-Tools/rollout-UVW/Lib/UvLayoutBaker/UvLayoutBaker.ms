/** UV layout render
 */
struct UvLayoutBaker_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	Unwrap,
	
	renderuv_width ,
	
	unwrap_is_temporary,
	
	current_file_path = getFilenamePath(getSourceFileName()),
	
	ini_path = current_file_path + "/unwrap_render_settings.ini",
	droplet  = current_file_path + "\\Droplet\\DropletTest.exe",
	
	props = #(
		#renderuv_force2sided,
		#renderuv_fillColor,
		#renderuv_fillalpha,
		#renderuv_fillmode,
		#renderuv_showoverlap,
		#renderuv_overlapColor,
		#renderuv_edgeColor,
		#renderuv_edgealpha,
		#renderuv_visibleedges,
		#renderuv_invisibleedges,
		#renderuv_seamedges,
		#renderuv_seamColor,
		#renderuv_showframebuffer
	),
	
	/** Bake
	  * 
	  * @param	integer	uv_channel
	  * @param	point2	resolution	of baked layout
	  * @param	name	output	#framebuffer|photoshop 
	 */
	function bake uv_channel resolution _output =
	(
		format "\n"; print "UvLayoutBaker_v.bake()"
		format "resolution	= % \n" resolution
		
		bake_dir = ( pathConfig.GetDir #temp) + "\\UvTemplates"
		
		makeDir bake_dir
		
		baked_texture_path = bake_dir + "\\UV_TEMPLATE.TGA" 
		--baked_texture_path = (( pathConfig.GetDir #temp) + "\\UV_TEMPLATE.TGA" )
		--
		deleteFile baked_texture_path
		
		this._setUnwrapMod()
		
		format "Unwrap	= % \n" Unwrap
		Unwrap.renderuv_width  = resolution.x
		Unwrap.renderuv_height = resolution.y
		
		--Unwrap.renderuv_showframebuffer = _output == #framebuffer
		subObjectLevel = 3

		Unwrap.renderUV (baked_texture_path)
		
		subObjectLevel = 0

		--format "baked_texture_path	= % \n" baked_texture_path
		
		if _output == #photoshop then
		(
			while not doesFileExist baked_texture_path do
				sleep 1
			
			DOSCommand ("start \"\" \"" +	droplet + "\" \"" +	baked_texture_path +	"\"" )
		)
	),

	/** Save settings
	 */
	function saveSettings =
	(
		--format "\n"; print "UvLayoutBaker_v.saveSettings()"
		
		if classOf ( Unwrap = modPanel.getCurrentObject() ) == Unwrap_UVW then
			for prop in props do
				setINISetting ini_path "settings" prop ( (getProperty Unwrap #renderuv_height) as string )
		
		else
			messageBox "Unwrap UVW modifier is not active" title:"ERROR"
	),
	
	/** Reset settings
	 */
	function resetSettings =
	(
		--format "\n"; print "UvLayoutBaker_v.resetSettings()"
		deleteFile ini_path
	),
	
	private
	
	/** Set unwrap mod
	 */
	function _setUnwrapMod =
	(
		format "\n"; print "UvLayoutBaker_v._setUnwrapMod()"
				
		Unwrap	= modPanel.getCurrentObject()
		format "Unwrap	= % \n" Unwrap

		if classOf Unwrap != Unwrap_UVW then
		(
			Unwrap = Unwrap_UVW()
			
			modPanel.addModToSelection Unwrap ui:on
			
			unwrap_is_temporary = true
		)
	
	),
	
	
	/**  
	 */
	on create do
	(
		--print("UvLayoutRender_v.onCreate()")
		--ConstructPropeties test:this
	)
	
)
