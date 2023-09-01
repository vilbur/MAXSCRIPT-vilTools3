

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
	--print "Callback: saveLastModifier()"

	if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
		for obj in selection where obj.modifiers.count > 0 do
			LAST_ACTIVE_MODIFIER[(getHandleByAnim obj) as string ] = getHandleByAnim curr_mod
)

/* KILL ON STARTUP */
--saveLastModifierKill()