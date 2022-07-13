
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstModifierOfType.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstEditPoly.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstUnwrap.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/LastModifierSaver/LastModifierSaver.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/saveLastModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/openUnwrapEditor.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Events/onSelectionChangedModPanel.ms" )


/*
*	
*/	
macroscript	modifiers_activate_modifier
category:	"_Modifiers"  
buttonText:	"Keep active modifier"
tooltip:	"select first modifier when object is selected"
icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|unselect:true|align:#left"
--icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')"
(
	onSelectionChangedModPanelKill ("onNewModPanelKill")
	onSelectionChangedModPanelKill ("activateFirstUnwrap")
	onSelectionChangedModPanelKill ("activateLastModifier")
	saveLastModifierKill()
	--format "EventFired.val	= % \n" EventFired.val
	if( EventFired.val == 1 ) then
	(
		activateFirstEditPoly()
		
		onSelectionChangedModPanel ("activateFirstEditPoly")
		
	)
	else if( EventFired.val == 2 ) then
	(
		activateFirstUnwrap()
		
		onSelectionChangedModPanel ("activateFirstUnwrap")
	)
	
	else if( EventFired.val == 3 ) then
	(
		saveLastModifierStart()
		
		onSelectionChangedModPanel ("activateLastModifier")
	)
)

