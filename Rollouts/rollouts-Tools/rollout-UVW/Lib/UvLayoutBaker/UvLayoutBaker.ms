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
	 */
	function bake uv_channel resolution =
	(
		format "\n"; print "UvLayoutBaker_v.bake()"
		
		baked_texture_path = (( pathConfig.GetDir #temp) + "\\UV_TEMPLATE.TGA" )
		
		this._setUnwrapMod()
	
		--format "Unwrap	= % \n" Unwrap
		Unwrap.renderuv_width  = resolution
		Unwrap.renderuv_height = resolution
	
		Unwrap.renderUV (baked_texture_path)
		format "baked_texture_path	= % \n" baked_texture_path

		DOSCommand ("start \"\" \"" +	droplet + "\" \"" +	baked_texture_path +	"\"" )
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
		--format "\n"; print "UvLayoutBaker_v._setUnwrapMod()"
				
		Unwrap	= modPanel.getCurrentObject()
		
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
