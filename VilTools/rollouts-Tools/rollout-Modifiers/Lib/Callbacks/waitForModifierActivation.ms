

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







/** Select last modifier
 */
function activateLastModifier =
(
	print "Callback: activateLastModifier()"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		print "Callback: activateLastModifier Test true" 
		--waitForSelectionChangedKill()
		--waitForModifierChangeKill()
		waitForModifierActivationKill()

		LastActiveModifier.activate()
		
		waitForSelectionChangedCallback()
		waitForModifierChangeCallback()
	)
)