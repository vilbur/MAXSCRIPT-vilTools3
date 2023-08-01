/**

 */
function activatePolySelectModifier =
(
	--print "ACTIVATEPOLYSELECTMODIFIER()"
	curr_mod = modPanel.getCurrentObject()
	--format "curr_mod	= % \n" curr_mod

	if ( curr_mod = modPanel.getCurrentObject() ) != undefined and classOf curr_mod != Poly_Select then
	(
		max prev mod

		CALLBACKMANAGER.remove callback:"activatePolySelectModifier"
	)
)