


/**
 */
function activateLastModifier =
(
	if selection.count > 0 then
	(
		print "activateLastModifier"
		pointers = sort(for obj in selection where obj.modifiers.count > 0 collect (getHandleByAnim obj))

		pointer_key = ""
		for pointer in pointers do pointer_key += "_" + pointer as string
		pointer_key = trimLeft(pointer_key) "_"

		saveLastModifierKill()

		if ( mod_handle = LAST_ACTIVE_MODIFIER[pointer_key] ) != undefined then
			(ModifierStackRemote_v()).selectByHandle (mod_handle ) true

		saveLastModifierStart()
	)

)