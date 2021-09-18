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