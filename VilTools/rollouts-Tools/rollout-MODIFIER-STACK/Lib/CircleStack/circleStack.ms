/** Circle stack
  *
  */
function circleStack direction =
(
	--format "\n"; print "circleStack.ms.circleStack()"


	/**
	 */
	function selectNextEnabledModifier modifiers index =
	(
		format "\n"; print ".selectNextEnabledModifier()"
		index_next = index + 1

		while index_next <= modifiers.count and modifiers[index_next].enabled == false do
			index_next += 1

		if selection.count > 1 then
		(
			print "SELECT MODIFIER - MUTLIPLE OBJECTS"

			/* GO DOWN ISTACK n TIMES TO NEXT ENABLED MODIFIER */
			if index_next <= modifiers.count then
				for i = 1 to index_next - index do
					max prev mod
			else /* SELECT FIRST MODIFIER */
				for i = 1 to modifiers.count do
					max next mod

		)
		else
		(
			print "SELECT MODIFIER - SINGLE OBJECT"
			modPanel.setCurrentObject selection[1].modifiers[index_next]
		)

	)

	if selection.count > 0 then
	(
		modifiers = if selection.count > 1 then (InstancedModifierFinder( selection )).getInstancedModifiers() else selection[1].modifiers

		if modifiers.count > 1 and ( current_mod = modPanel.getCurrentObject() ) != undefined then
		(
			index_current = if superClassOf current_mod == modifier then findItem modifiers current_mod else 0

			if selection.count == 1 and index_current == modifiers.count then
				modPanel.setCurrentObject $.baseObject -- select baseobject if last modifier is active

			else if selection.count == 1 and index_current == 0 then
				modPanel.setCurrentObject $.modifiers[1] -- select first modifier if baseobject is active

			else
				selectNextEnabledModifier( modifiers )( index_current )
		)
	)

)