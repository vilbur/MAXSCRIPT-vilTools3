

/** Wait when modifier stack will be ready after selection has been changed
 */
function keepEditPolyCallback =
(
	print "Start: keepEditPolyCallback()"
	callbacks.addScript #modPanelObjPostChange "keepEditPoly()" id:#keepEditPoly
)


/** Wait for modifier change callback
 */
function keepEditPolyKill =
(
	print "Kill: keepEditPolyKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#keepEditPoly)catch()
)


/** Activate first Edit Poly modifier in stack from top
 */
function activateFirstEditPoly =
(
	max modify mode

	print "Callback: activateFirstEditPoly()"
format "modPanel.getCurrentObject() = % \n" (modPanel.getCurrentObject())
	if( selection.count > 1 and ( modPanel.getCurrentObject() ) != undefined ) then
	(
		for _modifier in selection[1].modifiers do 
			format "_modifier = % \n" _modifier
		
	)
)
