filein( getFilenamePath(getSourceFileName()) + "/../../InstancedModifierFinder/InstancedModifierFinder.ms" )

/** Activate first top Edit Poly modifier in stack 
 */
function activateFirstEditPoly =
(
	--print "Callback: activateFirstEditPoly()"
	max modify mode
	
	/** Multiple objects
	 */
	function multipleObjects =
	(
		--format "\n"; print "multipleObjects()"
		modifiers_in_stack = (InstancedModierFinder_v()).getInstancedModifiers ( selection )

		edit_poly_indexes = for i = 1 to modifiers_in_stack.count where classOf modifiers_in_stack[i] == Edit_Poly collect i 
		
		if edit_poly_indexes.count > 0 then 
			for i = 1 to (edit_poly_indexes[1] - 1 ) do
				max prev mod
	)
	
	/** Single object
	 */
	function singleObject =
	(
		--format "\n"; print "singleObject()"
		for _modifier in selection[1].modifiers do
			if( classOf _modifier == Edit_Poly ) then 
				return modPanel.setCurrentObject _modifier
	)
	
	if (classOf ( modPanel.getCurrentObject() )) == Edit_Poly then
		return true
	
	if selection.count == 1  then
		singleObject()
	else
		multipleObjects()
 
)