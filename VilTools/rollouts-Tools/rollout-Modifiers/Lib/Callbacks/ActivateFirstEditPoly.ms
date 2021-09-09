

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
		Edit_Polys_modifiers= for _modifier in selection[1].modifiers where classOf _modifier == Edit_Poly collect _modifier
		format "Edit_Poly_modifiers.count = % \n" Edit_Poly_modifiers.count
		
		if( Edit_Poly_modifiers.count > 0 ) then
			modPanel.setCurrentObject Edit_Poly_modifiers[1]
		
	)
)