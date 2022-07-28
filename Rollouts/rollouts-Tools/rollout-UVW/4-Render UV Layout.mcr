filein( getFilenamePath(getSourceFileName()) + "/Lib/UvLayoutBaker.ms" )


/**  
 */
macroscript	unwrap_render_uv_channel
category:	"_UVW"
buttontext:	"[uv bake channel]"
toolTip:	"UV Channel to render"
icon:	"type:radiobuttons|items:#('1','2')|across:3|offset:[ -8, 0 ]"
(
	
)

/**  
 */
macroscript	unwrap_render_uv_resolution
category:	"_UVW"
buttontext:	"[uv render resolution]"
toolTip:	"UV layout resolution\nIf unselected then diffuse texture resolution is used"
icon:	"type:radiobuttons|items:#('256','512','1024', '2048', '4096')|unselect:true|offset:[ 24, 0 ]"
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
	
	(UvLayoutBaker_v()).resetSettings()
)

/**  
 *	
 */
macroscript	unwrap_render_uv
category:	"_UVW"
buttontext:	"UV Layout"
toolTip:	"Render UV Layout"
icon:	"width:96"
(
	UvLayoutBaker 	= UvLayoutBaker_v()
	
	UvLayoutBaker.bake(uvw.uv_bake_channel.state as integer ) (uvw.unwrap_render_uv_resolution.state as integer )
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
