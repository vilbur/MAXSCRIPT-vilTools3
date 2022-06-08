/** Activate first top Edit Poly modifier in stack 
 */
function activateFirstEditPoly =
(
	print "Callback: activateFirstEditPoly()"
	format "selection	= % \n" (selection as Array )
	obj = selection[1]
	
	for _modifier in obj.modifiers do
		if( classOf _modifier == Edit_Poly ) then 
			return modPanel.setCurrentObject _modifier node:obj
 
)