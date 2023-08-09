/** Circle stack
  *
  */
function circleStack direction =
(
	--format "\n"; print "circleStack.ms.circleStack()"

	/**
	 */
	function selectPreviousEnabledModifier modifiers index =
	(
		if selection.count == 1 and index == modifiers.count then
			modPanel.setCurrentObject $.baseObject -- select baseobject if last modifier is active

		else if selection.count == 1 and index == 0 then
			modPanel.setCurrentObject $.modifiers[1] -- select first modifier if baseobject is active

		else
		(
			index_next = index + 1

			/* FIND NEXT MODIFIER */
			while index_next <= modifiers.count and modifiers[index_next].enabled == false do
				index_next += 1

			/* GO DOWN ISTACK n TIMES TO NEXT ENABLED MODIFIER */
			if index_next <= modifiers.count then
				for i = 1 to index_next - index do
					max prev mod
			else /* SELECT FIRST MODIFIER */
				for i = 1 to modifiers.count do
					max next mod
		)
	)

	/**
	 */
	function selectNextEnabledModifier modifiers index =
	(
		if selection.count == 1 and index == 1 then
			modPanel.setCurrentObject $.baseObject -- select baseobject if last modifier is active

		else
		(
			index_next = index - 1

			/* FIND PREVIOUS MODIFIER */
			while index_next >= 1 and modifiers[index_next].enabled == false do
				index_next -= 1

			format "index_next:	% \n" index_next
			format "index - index_next:	% \n" (index - index_next)

			/* GO UP ISTACK n TIMES TO NEXT ENABLED MODIFIER */
			if index_next != 0 then
				for i = 1 to index - index_next  do
					max next mod
			else /* SELECT FIRST MODIFIER */
				for i = 1 to modifiers.count do
					max prev mod

		)
	)


	if selection.count > 0 then
	(
		modifiers = if selection.count > 1 then (InstancedModifierFinder( selection )).getInstancedModifiers() else selection[1].modifiers

		if modifiers.count > 1 and ( current_mod = modPanel.getCurrentObject() ) != undefined then
		(
			index_current = if superClassOf current_mod == modifier then findItem modifiers current_mod else 0

			if direction == #down then
				selectPreviousEnabledModifier( modifiers )( index_current )

			else
				selectNextEnabledModifier( modifiers )( index_current )

		)
	)

)