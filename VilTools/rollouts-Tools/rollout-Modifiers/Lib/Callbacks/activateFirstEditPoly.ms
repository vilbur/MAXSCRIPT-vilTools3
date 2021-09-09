

/** Wait when modifier stack will be ready after selection has been changed
 */
function activateFirstEditPolyCallback =
(
	print "Start: activateFirstEditPolyCallback()"
	callbacks.addScript #modPanelObjPostChange "activateFirstEditPoly()" id:#activateFirstEditPoly
)


/** Wait for modifier change callback
 */
function activateFirstEditPolyKill =
(
	print "Kill: activateFirstEditPolyKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#activateFirstEditPoly)catch()
)


/** Activate first Edit Poly modifier in stack from top
 */
function activateFirstEditPoly =
(
	print "Callback: activateFirstEditPoly()"
	max modify mode
	if( selection.count > 0 ) then
	(
		waitModifiyStackReadyKill()
		
		for _modifier in selection[1].modifiers do
		(
			if( classOf _modifier != Edit_Poly and ROLLOUT_modifiers.CHECKBOX_disable_modifiers.state ) then
					_modifier.enabled = false
			
			else if( classOf _modifier == Edit_Poly ) then 
				return modPanel.setCurrentObject _modifier
			
		)
		
	)
)