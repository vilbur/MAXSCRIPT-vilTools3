filein( getFilenamePath(getSourceFileName()) + "/Lib/PolySelect/PolySelect.ms" )

/*
 *
*/	
macroscript	modifier_auto_polyselect_update_by_mat
category:	"_Modifiers"  
buttonText:	"Update by mat ID"
tooltip:	"Update Poly Select modifiers in stack by material IDs"
--icon:	"control:checkbox"
(
	--clearListener()
	PolySelect 	= PolySelect_v()
	
	PolySelect.updateObject( selection[1] ) 
)
/*
 *
*/	
--macroscript	modifier_auto_polyselect
--category:	"_Modifiers"  
--buttonText:	"PolySelect"
--tooltip:	"Auto updating Poly Select modifier"
--icon:	"control:checkbox"
--(
--	clearListener()
--	if( EventFired.val ) then
--	(
--		PolySelect 	= PolySelect_v()
--		
--	)
--	
--	
--)
