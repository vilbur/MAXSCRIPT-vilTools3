filein( getFilenamePath(getSourceFileName()) + "/Lib/viewportChangeCallback/viewportChange.ms" )


 /**  
 *	
 */
macroscript	main_rotate_top_view
category:	"_Viewports"
buttontext:	"Rotate Top View"
tooltip:	"Keep top view rotated by 90°"
icon:	"type:checkbox|columns:6"
(
	if( EventFired.value ) then
		viewportChangeCallback()
	else
		viewportChangeKill()
)