



/** Wait for modifier change callback
 */
function waitModifierChangeCallback =
(
	print "Start: waitModifierChangeCallback()"
	callbacks.addScript #modPanelObjPostChange "saveModifierChange()" id:#saveModifierChange
)

/** Wait for modifier change callback
 */
function waitModifierChangeKill =
(
	print "Kill: waitModifierChangeKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#saveModifierChange)catch()
)




/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function saveModifierChange =
(
	print "Callback: saveModifierChange()"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
		DynamicModifyPanel.saveModifier _modifier
)