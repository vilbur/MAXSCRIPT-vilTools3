

global LAST_ACTIVE_MODIFIER = Dictionary ( #string ) -- KEY: Obejct pointer VALUE: last active modifier pointer

/**
 */
function activateLastModifier =
(
	--print "activateLastModifier"
	if selection.count == 1 then
	(
		saveLastModifierKill() -- kill callback before mod change

		obj = selection[1]
		key = (getHandleByAnim obj) as string

		if ( mod_handle = LAST_ACTIVE_MODIFIER[key] ) != undefined then
		(
			_mod =  getAnimByHandle mod_handle

			if _mod != undefined and ( modifier_index = modPanel.getModifierIndex obj _mod ) != undefined and modifier_index > 1 then -- do not set if modifier is first
				modPanel.setCurrentObject _mod node:obj
		)

		saveLastModifierStart()

	)

)