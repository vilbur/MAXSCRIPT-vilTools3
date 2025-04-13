
/**
 */
macroscript	_viewport_hud_info
category:	"_Viewports-HUD"
buttontext:	"Viewport Info"
--icon:	"control:checkbutton|MENU:true|autorun:true|across:2"
icon:	"control:checkbutton|MENU:true|autorun:true|across:2"
(
	on execute do
	(
		is_hud_on = HUD_DATA[#MAX_INFO] != undefined
		
		if not is_hud_on then
		(
			HUD = Hud_v callback: hudMaxInfoCallback
		
			toggleHudCallback #MAX_INFO data:HUD
		)
		else
			toggleHudCallback #MAX_INFO
		
		/* TOGGLE BUTTON if executed from menu*/ 
		try( ROLLOUT_viewports.CBTN_viewport_ivnfo.state = not is_hud_on )catch()
	)
)

/** OBJECT INFO
 */
macroscript	_viewport_hud_info_object
category:	"_Viewports-HUD"
buttontext:	"Object Info"
tooltip:	"Show info about selected objetcs in viewport"
icon:	"control:checkbutton|MENU:true|autorun:true"
(
	on execute do
	(
		is_hud_on = HUD_DATA[#OBJ_INFO] != undefined
		
		if not is_hud_on then
		(
			HUD = Hud_v callback: hudObjectInfoCallback
		
			toggleHudCallback #OBJ_INFO data:HUD
		)
		else
			toggleHudCallback #OBJ_INFO

		/* TOGGLE BUTTON if executed from menu*/ 
		try( ROLLOUT_viewports.CBTN_object_info.state = not is_hud_on )catch()
	)
)