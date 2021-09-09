/** Wait for selection change callback
 */
function waitForSelectionChangedCallback =
(
	print "Start: waitForSelectionChangedCallback()"
	callbacks.addScript #selectionSetChanged "onSelectionChangedWaitForStack()" id:#onSelectionChangedWaitForStack
)

/** Kill callback
 */
function waitForSelectionChangedKill =
(
	print "Kill: waitForSelectionChangedKill()"
	try(callbacks.removeScripts #selectionSetChanged   id:#onSelectionChangedWaitForStack)catch()	
)





/** Wait when modifier stack will be ready after selection has been changed
 */
function waitForModifierActivationCallback =
(
	print "Start: waitForModifierActivationCallback()"
	callbacks.addScript #modPanelObjPostChange "activateLastModifier()" id:#activateLastModifier
)

/** Wait for modifier change callback
 */
function waitForModifierActivationKill =
(
	print "Kill: waitForModifierActivationKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#activateLastModifier)catch()
)




/** Wait for modifier change callback
 */
function waitForModifierChangeCallback =
(
	print "Start: onModifierChanged()"
	callbacks.addScript #modPanelObjPostChange "onModifierChanged()" id:#onModifierChanged
)

/** Wait for modifier change callback
 */
function waitForModifierChangeKill =
(
	print "Kill: waitForModifierChangeKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#onModifierChanged)catch()
)
