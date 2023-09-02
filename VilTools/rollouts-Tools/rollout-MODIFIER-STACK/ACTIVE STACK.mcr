
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
icon:	"control:checkbutton|MENU:true|across:1"
(
	on IsChecked do AUTO_END_RESULT != undefined

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
)


/*------------------------------------------------------------------------------
	KEEP ACTIVE NODIFIER
--------------------------------------------------------------------------------*/

global KEEP_ACTIVE_NODIFIER
global ROLLOUT_modifier_stack

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


	case which of
	(
		#EditPoly:
		(
			activateFirstEditPoly()

			onSelectionChangedModPanel ("activateFirstEditPoly")

			ROLLOUT_modifier_stack.CBXBTN_edit_poly.state	= true
		)

		#Unwrap:
		(
			activateFirstUnwrap()

			onSelectionChangedModPanel ("activateFirstUnwrap")

			ROLLOUT_modifier_stack.CBXBTN_unwrap.state	= true
		)

		#LastModifier:
		(
			saveLastModifierStart()

			onSelectionChangedModPanel ("activateLastModifier")

			ROLLOUT_modifier_stack.CBXBTN_last_modifier.state	= true
		)
	)

)

/*
*
*/
macroscript	modifiers_keep_active_edit_poly
category:	"_Modifier-Stack"
buttonText:	"Edit Poly"
tooltip:	"Select Edit Poly modifier when object is selected"
icon:	"control:checkbutton|MENU:true|across:3"
(

	on execute do
		--format "EventFired:	% \n" EventFired
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #EditPoly then undefined else #EditPoly)
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == undefined then #EditPoly )
		keepActiveModifier ( if EventFired == undefined or (EventFired != undefined and EventFired.val ) then #EditPoly )


	--on IsChecked do KEEP_ACTIVE_NODIFIER == #EditPoly

)
/*
*
*/
macroscript	modifiers_keep_active_last_modifier
category:	"_Modifier-Stack"
buttonText:	"Last Modifier"
tooltip:	"Select last modifier when object is selected"
icon:	"control:checkbutton|MENU:true|autorun:true"
(

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		format "EventFired:	% \n" EventFired


		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\Callbacks\activateLastModifier.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\Callbacks\saveLastModifier.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierStackRemote\ModifierStackRemote.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierStackRemote\ModifierStack\ModifierStack.ms"
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #LastModifier then undefined else #LastModifier)
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == undefined then #LastModifier )
		keepActiveModifier ( if EventFired == undefined or (EventFired != undefined and EventFired.val ) then #LastModifier )
	)


	--on IsChecked do KEEP_ACTIVE_NODIFIER == #LastModifier
)
/*
*
*/
macroscript	modifiers_keep_active_unwrap
category:	"_Modifier-Stack"
buttonText:	"Unwrap"
tooltip:	"Select last modifier when object is selected"
icon:	"control:checkbutton|MENU:true"
(

	on execute do
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #Unwrap then undefined else #Unwrap)
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == undefined then #Unwrap )
		keepActiveModifier ( if EventFired == undefined or (EventFired != undefined and EventFired.val ) then #Unwrap )

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
