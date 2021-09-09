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


/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function onModifierChanged =
(
	print "Callback: onModifierChanged()"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
		LastActiveModifier.saveModifier _modifier
)
