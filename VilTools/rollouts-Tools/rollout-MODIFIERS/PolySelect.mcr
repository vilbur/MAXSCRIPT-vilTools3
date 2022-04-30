filein( getFilenamePath(getSourceFileName()) + "/Lib/PolySelect/PolySelect.ms" )

/*
 *
*/	

macroscript	modifier_auto_polyselect
category:	"_Modifiers"  
buttonText:	"PolySelect"
tooltip:	"Auto updating Poly Select modifier"
icon:	"type:checkbox"
(
	clearListener()
	if( EventFired.val ) then
	(
		PolySelect 	= PolySelect_v()
		
	)
	
	
)

/*
 *
*/	

macroscript	modifier_auto_polyselect_select_by_mat
category:	"_Modifiers"  
buttonText:	"Select material"
tooltip:	"Select by material"
--icon:	"type:checkbox"
(
	clearListener()
	PolySelect 	= PolySelect_v()
	
	PolySelect.selectByMaterial()
		
		
	
	
)
	