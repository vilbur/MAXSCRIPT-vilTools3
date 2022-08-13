filein( getFilenamePath(getSourceFileName()) + "/Lib/UvLayoutBaker/UvLayoutBaker.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../rollout-MATERIALS/Lib/Material/Material.ms" )

/** Render Uv layout
 */
function renderUvLayout_v _output =
(
	--format "\n"; print ".renderLayout()"
	UvLayoutBaker	= UvLayoutBaker_v()
	_Material 	= Material_v()
	
	_bitmaps = _Material.getBitmaps(_Material.getMaterialsOfObjects( selection as Array ))
	--format "_bitmaps	= % \n" _bitmaps
	resolution = if uvw.uv_render_resolution.state == 0 and _bitmaps.count > 0 then -- get resolution of current texture
	(
		--format "_bitmaps[1]	= % \n" _bitmaps[1]
	
		_bitmap = openBitMap _bitmaps[1].filename
		
		[_bitmap.width, _bitmap.height];
	)
	else
	(
		if uvw.uv_render_resolution.state > 0 then
		(
			size = #(256,512,1024, 2048, 4096)[uvw.uv_render_resolution.state]
			
			[size, size] --return
		)
		else
		(
			messageBox "Resolution of UV layout is undefined\n\nPlease set resolution" title:"RESOLUTION ERROR"  beep:true
			
			undefined --return
		)
		
	)
		
	if resolution != undefined then 
		UvLayoutBaker.bake( uvw.uv_bake_channel.state as integer )(resolution)(_output)
	
)

/**  
 */
macroscript	unwrap_render_uv_channel
category:	"_UVW"
buttontext:	"[uv bake channel]"
toolTip:	"UV Channel to render"
icon:	"type:radiobuttons|items:#('Ch 1','Ch2')|across:3|offset:[ -8, 0 ]"
(
	
)

/**  
 */
macroscript	unwrap_render_uv_resolution
category:	"_UVW"
buttontext:	"[uv render resolution]"
toolTip:	"UV layout resolution\nIf unselected then diffuse texture resolution is used"
icon:	"type:radiobuttons|items:#('256','512','1024', '2048', '4096')|unselect:true|offset:[ 32, 0 ]"
(
	
)

/**  
 */
macroscript	unwrap_render_uv_save_defaults
category:	"_UVW"
buttontext:	"D"
toolTip:	"Save render settings of current unwrap"
icon:	"across:3|width:32|offset:[ 48, -4 ]"
(
	--messageBox "Placeholder"
	
	(UvLayoutBaker_v()).saveSettings()
)

/**  
 */
macroscript	unwrap_render_uv_reset_defaults
category:	"_UVW"
buttontext:	"D"
toolTip:	"Reset settings"
--icon:	"across:3|width:32|offset:[ 48, -4 ]"
(
	--messageBox "Placeholder"
	
	if queryBox "Would You like to reset settings ? " title:"Reset setting" then
		(UvLayoutBaker_v()).resetSettings()
)

/*------------------------------------------------------------------------------
	RENDER UV LAYOUT
--------------------------------------------------------------------------------*/
/**  
 *	
 */
macroscript	unwrap_render_uv_photoshop
category:	"_UVW"
buttontext:	"UV Layout"
toolTip:	"To Photoshop"
icon:	"width:96|Tooltip:Render UV Layout"
(
	
	renderUvLayout_v(#photoshop)
)

/**  
 *	
 */
macroscript	unwrap_render_uv_framebuffer
category:	"_UVW"
buttontext:	"UV Layout"
toolTip:	"To Frame buffer"
--icon:	"width:96"
(
	renderUvLayout_v(#framebuffer)
)

/**  
 *	
 */
macroscript	unwrap_render_uv_alpha
category:	"_UVW"
buttontext:	"Alpha"
toolTip:	"Render alpha channel of UV Layout"
(

)

/**  
 *	
 */
macroscript	unwrap_render_uv_mat_id
category:	"_UVW"
buttontext:	"Mat IDs"
toolTip:	"Render material ids of UV Layout"
(

)
