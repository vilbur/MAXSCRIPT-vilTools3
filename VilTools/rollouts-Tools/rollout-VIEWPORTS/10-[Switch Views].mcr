filein( getFilenamePath(getSourceFileName()) + "/Lib/ViewportSwitcher/ViewportSwitcher.ms" )

/*------------------------------------------------------------------------------
	PERSPECTIVE  \  ISO
--------------------------------------------------------------------------------*/
 /**  
 *	
 */
macroscript	main_switch_viewport_perspective
category:	"_Viewports"
buttontext:	"PERSP \ USER"
toolTip:	"Perspective view"
icon:	"width:92|height:32|border:false"
(
	(ViewportSwitcher_v()).toggle(#view_persp_user)
)

 /**  
 *	
 */
macroscript	main_switch_viewport_iso
category:	"_Viewports"
buttontext:	"PERSP \ USER"
toolTip:	"Isometric view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_iso_user)
)


/*------------------------------------------------------------------------------
	TOP  \  BOTTOM
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_top
category:	"_Viewports"
buttontext:	"TOP \ BOTTOM"
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
buttontext:	"TOP \ BOTTOM"
toolTip:	"Bottom view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_bottom)
)


/*------------------------------------------------------------------------------
	FRONT  \  BACK
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_front
category:	"_Viewports"
buttontext:	"FRONT \ BACK"
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
buttontext:	"FRONT \ BACK"
toolTip:	"Back view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_back)
)

/*------------------------------------------------------------------------------
	LEFT  \  RIGHT
--------------------------------------------------------------------------------*/

/**  
 *	
 */
macroscript	main_switch_viewport_left
category:	"_Viewports"
buttontext:	"LEFT \ RIGHT"
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
buttontext:	"LEFT \ RIGHT"
toolTip:	"Right view"
--icon:	"control:checkbox|columns:6"
(
	(ViewportSwitcher_v()).toggle(#view_right)
	
)





