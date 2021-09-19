filein( getFilenamePath(getSourceFileName()) + "/Lib/viewportSwitcher.ms" )

 /**  
 *	
 */
macroscript	main_switch_viewport_perspective
category:	"_Main"
buttontext:	"Perspective"
toolTip:	"Perspective ViewPort"
--icon:	"type:checkbox|columns:6"
(
	
	if( viewport.numViews  == 1 ) then 
		actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
	else
		ViewportSwitcher_v switch:#view_persp_user

)


/**  
 *	
 */
macroscript	main_switch_viewport_left
category:	"_Main"
buttontext:	"Left"
toolTip:	"Left ViewPort"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_left
	
)