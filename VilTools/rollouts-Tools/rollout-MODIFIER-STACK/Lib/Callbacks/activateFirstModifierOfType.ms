filein( getFilenamePath(getSourceFileName()) + "/../InstancedModifierFinder/InstancedModifierFinder.ms" )	--"./../InstancedModifierFinder/InstancedModifierFinder.ms"

/** Activate first top modifier in stack of given class
 */
function activateFirstModifierOfType class_of_modifier =
(
	--print "Callback: activateFirstModifierOfType()"
	
	/** Multiple objects
	 */
	function multipleObjects class_of_modifier =
	(
		--format "\n"; print "multipleObjects()"
		edit_poly_indexes = ( InstancedModifierFinder_v nodes: selection ).getIndexesOfInstances ( class_of_modifier )

		first_edit_poly_index = edit_poly_indexes[1]
		
		if edit_poly_indexes.count > 0 then 
			for i = 1 to (first_edit_poly_index - 1 ) do
				max prev mod
	)
	
	/** Single object
	 */
	function singleObject class_of_modifier =
	(
		--format "\n"; print "singleObject()"
		for _modifier in selection[1].modifiers do
			if( classOf _modifier == class_of_modifier ) then 
				return modPanel.setCurrentObject _modifier node:selection[1]
	)
	
	if (classOf ( modPanel.getCurrentObject() )) == class_of_modifier then
		return true
	
	if selection.count == 1  then
		singleObject(class_of_modifier)
	else
		multipleObjects(class_of_modifier)
 
)