filein( getFilenamePath(getSourceFileName()) + "/../../ModifyStack/ModifyStack.ms" )

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
		edit_poly_indexes = (ModifyStack_v nodes: selection ).getIndexesOfInstances ( Edit_Poly )

		first_edit_poly_index = edit_poly_indexes[1]
		
		if edit_poly_indexes.count > 0 then 
			for i = 1 to (first_edit_poly_index - 1 ) do
				max prev mod
	)
	
	/** Single object
	 */
	function singleObject =
	(
		--format "\n"; print "singleObject()"
		for _modifier in selection[1].modifiers do
			if( classOf _modifier == Edit_Poly ) then 
				return modPanel.setCurrentObject _modifier node:selection[1]
	)
	
	if (classOf ( modPanel.getCurrentObject() )) == Edit_Poly then
		return true
	
	if selection.count == 1  then
		singleObject()
	else
		multipleObjects()
 
)