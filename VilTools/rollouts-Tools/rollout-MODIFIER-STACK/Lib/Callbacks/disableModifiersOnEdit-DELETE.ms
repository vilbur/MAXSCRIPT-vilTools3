/** Callbacks on selection change
  *
  * Disable modifiers above current modifier
 */
function disableModifiersOnEdit =
(
	format "\n"; print "disableModifiersOnEdit()"


	subobj_old = (callbacks.notificationParam())[1]
	subobj_new = (callbacks.notificationParam())[2]

	format "subobj_old	= % \n" subobj_old
	format "subobj_new	= % \n" subobj_new

	/** Toggle modifiers
	 */
	function toggleModifiers state =
	(
		for obj in selection do
		(
			index_current	= modPanel.getModifierIndex obj ( modPanel.getCurrentObject() )

			format "index_current:	% \n" index_current

			if index_current > 1 then
				for i = 1 to index_current - 1 do
					obj.modifiers[i].enabled = state

		)
	)

	if subobj_old == 0 then
		toggleModifiers false

	else if subobj_new == 0 then
		toggleModifiers true


)
