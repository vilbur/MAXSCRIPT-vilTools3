filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportSwitcher/ViewportSwitcher.ms" )

/*------------------------------------------------------------------------------
	PERSPECTIVE \ ISO
--------------------------------------------------------------------------------*/
 /**  
 *	
 */
macroscript	main_switch_viewport_perspective
category:	"_Viewports"
buttontext:	"Persp\Iso"
toolTip:	"Perspective view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_persp_user)
)

 /**  
 *	
 */
macroscript	main_switch_viewport_iso
category:	"_Viewports"
buttontext:	"Persp\Iso"
toolTip:	"Isometric view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_iso_user)
)


/*------------------------------------------------------------------------------
	TOP \ BOTTOM
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_top
category:	"_Viewports"
buttontext:	"Top\Bottom"
toolTip:	"Top view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_top)
)

/**  
 *	
 */
macroscript	main_switch_viewport_bottom
category:	"_Viewports"
buttontext:	"Top\Bottom"
toolTip:	"Bottom view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_bottom)
)


/*------------------------------------------------------------------------------
	FRONT \ BACK
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_front
category:	"_Viewports"
buttontext:	"Front\Back"
toolTip:	"Front view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_front)
)
/**  
 *	
 */
macroscript	main_switch_viewport_back
category:	"_Viewports"
buttontext:	"Front\Back"
toolTip:	"Back view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_back)
)

/*------------------------------------------------------------------------------
	LEFT \ RIGHT
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_left
category:	"_Viewports"
buttontext:	"Left\Right"
toolTip:	"Left view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_left)
)

/**  
 *	
 */
macroscript	main_switch_viewport_right
category:	"_Viewports"
buttontext:	"Left\Right"
toolTip:	"Right view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_right)
	
)





