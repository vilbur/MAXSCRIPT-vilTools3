/** Activate first top Edit Poly modifier in stack 
 */
function activateFirstEditPoly =
(
	print "Callback: activateFirstEditPoly()"

	for _modifier in selection[1].modifiers do
		if( classOf _modifier == Edit_Poly ) then 
			return modPanel.setCurrentObject _modifier

)