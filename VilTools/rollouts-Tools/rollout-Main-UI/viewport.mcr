filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportSwitcher/ViewportSwitcher.ms" )

/*------------------------------------------------------------------------------
	PERSPECTIVE \ ISO
--------------------------------------------------------------------------------*/
 /**  
 *	
 */
macroscript	main_switch_viewport_perspective
category:	"_Main"
buttontext:	"Persp\Iso"
toolTip:	"Perspective view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_persp_user
)

 /**  
 *	
 */
macroscript	main_switch_viewport_iso
category:	"_Main"
buttontext:	"Persp\Iso"
toolTip:	"Isometric view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_iso_user
)


/*------------------------------------------------------------------------------
	TOP \ BOTTOM
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_top
category:	"_Main"
buttontext:	"Top\Bottom"
toolTip:	"Top view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_top
)

/**  
 *	
 */
macroscript	main_switch_viewport_bottom
category:	"_Main"
buttontext:	"Top\Bottom"
toolTip:	"Bottom view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_bottom
)


/*------------------------------------------------------------------------------
	FRONT \ BACK
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_front
category:	"_Main"
buttontext:	"Front\Back"
toolTip:	"Front view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_front
)
/**  
 *	
 */
macroscript	main_switch_viewport_back
category:	"_Main"
buttontext:	"Front\Back"
toolTip:	"Back view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_back	
)

/*------------------------------------------------------------------------------
	LEFT \ RIGHT
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_left
category:	"_Main"
buttontext:	"Left\Right"
toolTip:	"Left view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_left
)

/**  
 *	
 */
macroscript	main_switch_viewport_right
category:	"_Main"
buttontext:	"Left\Right"
toolTip:	"Right view"
--icon:	"type:checkbox|columns:6"
(
	ViewportSwitcher_v switch:#view_right
	
)





