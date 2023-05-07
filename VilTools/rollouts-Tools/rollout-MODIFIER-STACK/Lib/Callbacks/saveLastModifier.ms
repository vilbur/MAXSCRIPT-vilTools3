

/*------------------------------------------------------------------------------
	SAVE MODIFIER
--------------------------------------------------------------------------------*/

/** 
 */
function saveLastModifierStart =
(
	print "Start: saveLastModifierStart()"
	callbacks.addScript #modPanelObjPostChange "saveLastModifier()" id:#saveLastModifier
)

/** 
 */
function saveLastModifierKill =
(
	print "Kill: saveLastModifierKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#saveLastModifier)catch()
)

/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function saveLastModifier =
(
	--print "Callback: saveLastModifier()"
	if  modPanel.getCurrentObject() != undefined then
		LAST_MODIFIER_SAVER.saveModifier()
)

/* KILL ON STARTUP */ 
saveLastModifierKill()