/** Prepend poly select modifier if CTRL key is pressed when modiier added or pasted
 *
 */
function prependPolySelectModifier =
(
	--format "\n"; print "!!!!!!!!!!!!!!! prependPolySelectModifier()"

	if not keyboard.controlPressed then
		return false

	obj	= (callbacks.notificationParam())[1]
	_modifier	= (callbacks.notificationParam())[2]

	--format "obj	= % \n" obj.name
	--format "_modifier	= % \n" _modifier
	--format "classOf _modifier	= % \n" (classOf _modifier)

	if classOf _modifier != Poly_Select  then
	(
		format "\n"; print "prependPolySelectModifier()"

		current_index = modPanel.getModifierIndex obj _modifier

		Poly_Select_Modifier = Poly_Select name:("Select "+_modifier.name) ui:on

		addModifier obj Poly_Select_Modifier before:current_index

		CALLBACKMANAGER.add "activatePolySelectModifier"	#modPanelObjPostChange
	)
)