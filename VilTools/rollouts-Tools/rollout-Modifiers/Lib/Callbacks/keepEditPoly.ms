

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


/** Keep edit poly
 */
function keepEditPoly =
(
	print "keepEditPoly()"
)
