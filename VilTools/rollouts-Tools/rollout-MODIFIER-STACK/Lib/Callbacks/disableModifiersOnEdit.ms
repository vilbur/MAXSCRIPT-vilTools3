/** Callbacks on selection change

  * Disable modifiers above current modifier
 */
function disableModifiersOnEdit =
(
	format "\n"; print "disableModifiersOnEdit()"


	new_level = (callbacks.notificationParam())[1]
	old_level = (callbacks.notificationParam())[2]

	format "new_level	= % \n" new_level
	format "old_level	= % \n" old_level

	/** Toggle modifiers
	 */
	function toggleModifiers state =
	(
		for obj in selection do
		(
			index_current	= modPanel.getModifierIndex obj ( modPanel.getCurrentObject() )

			format "index_current	= % \n" index_current
			for _modifier in obj.modifiers do
			(
				--format "_modifier	= % \n" _modifier
				index = modPanel.getModifierIndex obj _modifier
				format "_modifier	= % \nindex	= % \n\n" _modifier index

				if index < index_current then
					_modifier.enabled = state
			)
		)
	)


	if new_level != 0 then
		toggleModifiers false

	else
		toggleModifiers true


)

