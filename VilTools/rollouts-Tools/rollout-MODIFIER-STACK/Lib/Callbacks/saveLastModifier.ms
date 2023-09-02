

/*------------------------------------------------------------------------------
	SAVE MODIFIER
--------------------------------------------------------------------------------*/

/**
 */
function saveLastModifierStart =
(
	--print "Start: saveLastModifierStart()"
	callbacks.addScript #modPanelObjPostChange "saveLastModifier()" id:#saveLastModifier
)

/**
 */
function saveLastModifierKill =
(
	--print "Kill: saveLastModifierKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#saveLastModifier)catch()
)

/** Save active mod for object
 */
function saveLastModifier =
(

	if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
	(
		print "Callback: saveLastModifier()"
		pointers = sort(for obj in selection where obj.modifiers.count > 0 collect (getHandleByAnim obj))

		pointer_key = ""
		for pointer in pointers do pointer_key += "_" + pointer as string
		pointer_key = trimLeft(pointer_key) "_"

		LAST_ACTIVE_MODIFIER[pointer_key] = getHandleByAnim curr_mod
	)
)

/* KILL ON STARTUP */
--saveLastModifierKill()