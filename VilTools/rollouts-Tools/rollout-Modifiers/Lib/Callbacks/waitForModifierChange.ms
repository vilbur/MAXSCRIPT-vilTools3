



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
		DynamicModifyPanel.saveModifier _modifier
)
