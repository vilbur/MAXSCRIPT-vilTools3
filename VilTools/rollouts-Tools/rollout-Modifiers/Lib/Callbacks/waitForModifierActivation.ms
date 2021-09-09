







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

		DynamicModifyPanel.activate()
		
		waitForSelectionChangedCallback()
		waitForModifierChangeCallback()
	)
)