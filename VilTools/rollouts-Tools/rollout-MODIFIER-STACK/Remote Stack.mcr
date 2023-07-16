filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )	-- "./Lib/Callbacks/autoEndResult.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )	-- "./Lib/Callbacks/disableModifiersOnEdit.ms"

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionMaxModifyMode.ms" )


/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_stack_smart_circle
category:	"_Modifier-Stack"
buttontext:	"Cyrcle Stack"
toolTip:	"Cyrcle Max modify panel > Edit Poly > Show End Result"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
--icon:	"control:checkbox"
(
	--messageBox "Yupiii" title:"Title"  beep:false
	/**
	 */
	function selectNextEnabledModifier =
	(
		format "\n"; print ".selectNextEnabledModifier()"

		while superClassOf (next_mod = modPanel.getCurrentObject()) == modifier and next_mod.enabled == false do
				macros.run "Ribbon - Modeling" "PreviousModifier"

	)

	_selection = selection

	if selection.count > 0 then
	(
		if( GetCommandPanelTaskMode() != #modify ) then
		(
			max modify mode

			selectNextEnabledModifier()
		)

		else if ( current_mod = modPanel.getCurrentObject() ) != undefined then
		(
			if superClassOf current_mod == modifier then
			(
				--macros.run "Ribbon - Modeling" "PreviousModifier"
				index = modPanel.getModifierIndex _selection[1] current_mod

				try(
					modPanel.setCurrentObject _selection[1].modifiers[index +1]

					selectNextEnabledModifier()

				)catch(
					--format "*** % ***\n" (getCurrentException())
					modPanel.setCurrentObject _selection[1].baseObject
				)

			)
			else /* If baseobject is selected then select first enabled modifier */
			(
				modPanel.setCurrentObject _selection[1].modifiers[1]

				selectNextEnabledModifier()
			)

		)
	)
)


/**
 */
macroscript	modifiers_auto_end_result
category:	"_Modifiers"
buttontext:	"End result"
toolTip:	"Show end result if subobject == 0"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"control:checkbox"
(
	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult

	else

		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()
)

/**
 */
macroscript	modifiers_disable_on_edit
category:	"_Modifiers"
buttontext:	"Disable above on edit"
toolTip:	"Disable modifiers above active modifier when subobject is entered"
icon:	"control:checkbox|enabled:false"
(
	--format "modifier_stack.disable_modifiers.state = % \n" modifier_stack.disable_modifiers.state

	--messageBox "mAKE THIS WORKING" title:"Title"  beep:false

	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "disableModifiersOnEdit()" id:#disableModifiersOnEdit

	else

		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#disableModifiersOnEdit)catch()

)
