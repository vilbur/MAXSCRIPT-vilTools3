global GLOBAL_SELECTION_MODIFIERS = #( #(), #() )



/** modPanelObjPostChange 
 *	
 */
function modPanelObjPostChangeCallback =
(
	print "modPanelObjPostChangeCallback()"
	--print ( modPanel.getCurrentObject() )
	if ( ( cutrent_obj = modPanel.getCurrentObject() ) != undefined ) then
	(
		
		LastActiveModifier.add selection[1] cutrent_obj
		--print "modPanelObjPostChangeCallback()"
		format "LastActiveModifier = % \n" LastActiveModifier
	)
	
	--	print ("Modifier "+ cutrent_obj as string +" Selected")		
	--
	--else
	--	print "Modifier Unselected"		
)
