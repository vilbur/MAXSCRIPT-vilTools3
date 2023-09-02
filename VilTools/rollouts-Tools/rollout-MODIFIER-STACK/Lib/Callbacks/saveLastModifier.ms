

/*------------------------------------------------------------------------------
	SAVE CURRENT MODIFIER OF SELECTIOn
--------------------------------------------------------------------------------*/
global LAST_ACTIVE_MODIFIER = Dictionary ( #string ) -- KEY: Obejct pointer VALUE: last active modifier pointer

/**
 */
function saveLastModifierStart =
(
	print "START: saveLastModifierStart()"
	callbacks.addScript #modPanelObjPostChange "saveLastModifier()" id:#saveLastModifier
)

/**
 */
function saveLastModifierKill =
(
	print "KILL: saveLastModifierKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#saveLastModifier)catch()
)

/** Save active mod for object
 */
function saveLastModifier =
(
	if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
	(
		print "CALLBACK: saveLastModifier()"

		pointers = sort(for obj in selection where obj.modifiers.count > 0 collect (getHandleByAnim obj))

		pointer_key = ""
		for pointer in pointers do pointer_key += "_" + pointer as string
		pointer_key = trimLeft(pointer_key) "_"

		LAST_ACTIVE_MODIFIER[pointer_key] = getHandleByAnim curr_mod
	)
)