filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )	-- "./Lib/Callbacks/autoEndResult.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )	-- "./Lib/Callbacks/disableModifiersOnEdit.ms"

/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_stack_smart_circle
category:	"_Modifier-Stack"
buttontext:	"Circle Stack"
toolTip:	"Circle Max modify panel > Edit Poly > Show End Result"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
--icon:	"control:checkbox"
(
	/**
	 */
	function selectNextEnabledModifier modifiers index =
	(
		--format "\n"; print ".selectNextEnabledModifier()"
		index_next = index + 1

		while index_next <= modifiers.count and modifiers[index_next].enabled == false do
			index_next += 1

		/* GO DOWN ISTACK n TIMES TO NEXT ENABLED MODIFIER */
		if index_next <= modifiers.count then
			for i = 1 to index_next - index do
				max prev mod
		else /* SELECT FIRST MODIFIER */
			for i = 1 to modifiers.count do
				max next mod
	)

	if selection.count > 0 then
	(
		modifiers = if selection.count > 1 then (InstancedModifierFinder( selection )).getInstancedModifiers() else selection[1].modifiers

		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		if modifiers.count > 1 and ( current_mod = modPanel.getCurrentObject() ) != undefined then
		(
			index_current = if superClassOf current_mod == modifier then findItem modifiers current_mod else 0

			if selection.count == 1 and index_current == modifiers.count then
				modPanel.setCurrentObject $.baseObject -- select baseobject if last modifier is active

			else if selection.count == 1 and index_current == 0 then
				modPanel.setCurrentObject$.modifiers[1] -- select first modifier if baseobject is active

			else
				selectNextEnabledModifier( modifiers )( index_current )
		)
	)
)


/**
 */
macroscript	modifiers_auto_end_result
category:	"_Modifier Stask"
buttontext:	"End result"
toolTip:	"Show end result if subobject == 0"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"control:checkbox|offset:[16,0]"
(
	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult

	else

		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()
)

/**
 */
macroscript	modifiers_disable_on_edit
category:	"_Modifier Stask"
buttontext:	"Disable above on edit"
toolTip:	"Disable modifiers above active modifier when subobject is entered"
icon:	"control:checkbox|enabled:false|offset:[16,0]"
(
	--format "modifier_stack.disable_modifiers.state = % \n" modifier_stack.disable_modifiers.state

	--messageBox "mAKE THIS WORKING" title:"Title"  beep:false

	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "disableModifiersOnEdit()" id:#disableModifiersOnEdit

	else

		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#disableModifiersOnEdit)catch()

)