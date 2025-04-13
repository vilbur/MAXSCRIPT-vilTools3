
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
		format "classOf Hud_v:    %\n" (classOf Hud_v)
		format "classOf HUD_DATA: %\n" (classOf HUD_DATA)
		format "classOf toggleHudCallback:  %\n" (classOf toggleHudCallback)
		format "classOf hudMaxInfoCallback: %\n" (classOf hudMaxInfoCallback)
		
		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			HUD = Hud_v callback: hudMaxInfoCallback
		
			toggleHudCallback #MAX_INFO data:HUD
		)
		else
			toggleHudCallback #MAX_INFO
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
		format "classOf Hud_v:    %\n" (classOf Hud_v)
		format "classOf HUD_DATA: %\n" (classOf HUD_DATA)
		format "classOf toggleHudCallback:  %\n" (classOf toggleHudCallback)
		format "classOf hudMaxInfoCallback: %\n" (classOf hudMaxInfoCallback)
		
		if EventFired == undefined or ( EventFired != undefined and EventFired.get #val ) then
		(
			HUD = Hud_v callback: hudObjectInfoCallback
		
			toggleHudCallback #OBJ_INFO data:HUD
		)
		else
			toggleHudCallback #OBJ_INFO
	)
)


