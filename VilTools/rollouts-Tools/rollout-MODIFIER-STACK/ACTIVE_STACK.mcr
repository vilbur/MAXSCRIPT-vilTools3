
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstModifierOfType.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstEditPoly.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstUnwrap.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/LastModifierSaver/LastModifierSaver.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/saveLastModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/openUnwrapEditor.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Events/onSelectionChangedModPanel.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )	-- "./Lib/Callbacks/autoEndResult.ms"





/*------------------------------------------------------------------------------
	AUTO END RESULT
--------------------------------------------------------------------------------*/

global AUTO_END_RESULT

macroscript	modifiers_auto_end_result
category:	"_Modifier-Stack"
buttontext:	"Auto End Result"
toolTip:	"Enable\Disable show end result on Enter\Exit subobject"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"control:checkbutton|menu:true"
(

	on execute do
		if AUTO_END_RESULT == undefined then
		(
			callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult

			AUTO_END_RESULT = true
		)
		else
		(
			try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()

			AUTO_END_RESULT = undefined
		)

	on IsChecked do AUTO_END_RESULT != undefined


)


/*------------------------------------------------------------------------------
	KEEP ACTIVE NODIFIER
--------------------------------------------------------------------------------*/

global KEEP_ACTIVE_NODIFIER

function keepActiveModifier which =
(
	print "keepActiveModifier"
	format "which:	% \n" which

	KEEP_ACTIVE_NODIFIER = which

	onSelectionChangedModPanelKill ("onNewModPanelKill")
	onSelectionChangedModPanelKill ("activateFirstUnwrap")
	onSelectionChangedModPanelKill ("activateLastModifier")

	saveLastModifierKill()


	ROLLOUT_modifier_stack.CBXBTN_edit_poly.state	= false
	ROLLOUT_modifier_stack.CBXBTN_unwrap.state	= false
	ROLLOUT_modifier_stack.CBXBTN_last_modifier.state	= false


	if( which == #EditPoly ) then
	(
		activateFirstEditPoly()

		onSelectionChangedModPanel ("activateFirstEditPoly")

		ROLLOUT_modifier_stack.CBXBTN_edit_poly.state	= true
	)
	else if( which == #Unwrap ) then
	(
		activateFirstUnwrap()

		onSelectionChangedModPanel ("activateFirstUnwrap")

		ROLLOUT_modifier_stack.CBXBTN_unwrap.state	= true
	)

	else if( which == #LastModifier ) then
	(
		saveLastModifierStart()

		onSelectionChangedModPanel ("activateLastModifier")

		ROLLOUT_modifier_stack.CBXBTN_last_modifier.state	= true
	)

)

/*
*
*/
macroscript	modifiers_keep_active_edit_poly
category:	"_Modifier-Stack"
buttonText:	"Edit Poly"
tooltip:	"Select Edit Poly modifier when object is selected"
icon:	"control:checkbutton|menu:true"
(

	on execute do
		format "EventFired:	% \n" EventFired
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #EditPoly then undefined else #EditPoly)


	--on IsChecked do KEEP_ACTIVE_NODIFIER == #EditPoly

)
/*
*
*/
macroscript	modifiers_keep_active_last_modifier
category:	"_Modifier-Stack"
buttonText:	"Last Modifier"
tooltip:	"Select last modifier when object is selected"
icon:	"control:checkbutton|menu:true"
(

	on execute do
		keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #LastModifier then undefined else #LastModifier)


	--on IsChecked do KEEP_ACTIVE_NODIFIER == #LastModifier
)
/*
*
*/
macroscript	modifiers_keep_active_unwrap
category:	"_Modifier-Stack"
buttonText:	"Unwrap"
tooltip:	"Select last modifier when object is selected"
icon:	"control:checkbutton|menu:true"
(

	on execute do
		keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #Unwrap then undefined else #Unwrap)


	--on IsChecked do KEEP_ACTIVE_NODIFIER == #Unwrap
)


/*------------------------------------------------------------------------------
	SAME FUNCTION AS KEEP_ACTIVE_NODIFIER, BUT RADIOBUTTONS
--------------------------------------------------------------------------------*/
----/*
----*
----*/
----macroscript	modifiers_activate_modifier
----category:	"_Modifier-Stack"
----buttonText:	"Keep active modifier"
----tooltip:	"select first modifier when object is selected"
----icon:	"control:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|unselect:true|align:#left"
------icon:	"control:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')"
----(
----	onSelectionChangedModPanelKill ("onNewModPanelKill")
----	onSelectionChangedModPanelKill ("activateFirstUnwrap")
----	onSelectionChangedModPanelKill ("activateLastModifier")
----
----	saveLastModifierKill()
----	--format "EventFired.val	= % \n" EventFired.val
----	if( EventFired.val == 1 ) then
----	(
----		activateFirstEditPoly()
----
----		onSelectionChangedModPanel ("activateFirstEditPoly")
----
----	)
----	else if( EventFired.val == 2 ) then
----	(
----		activateFirstUnwrap()
----
----		onSelectionChangedModPanel ("activateFirstUnwrap")
----	)
----
----	else if( EventFired.val == 3 ) then
----	(
----		saveLastModifierStart()
----
----		onSelectionChangedModPanel ("activateLastModifier")
----	)
----)