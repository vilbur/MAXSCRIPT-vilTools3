
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstModifierOfType.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstEditPoly.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstUnwrap.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/LastModifierSaver/LastModifierSaver.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionChangedModPanel.ms" )


/*------------------------------------------------------------------------------
	AUTO END RESULT
--------------------------------------------------------------------------------*/

global AUTO_END_RESULT

macroscript	modifiers_auto_end_result
category:	"_Modifier-Stack"
buttontext:	"SHOW END RESULT AUTO"
toolTip:	"Enable\Disable show end result on Enter\Exit subobject"
icon:	"control:checkbox|MENU:true|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(
	on IsChecked do AUTO_END_RESULT != undefined

	on execute do
	(
		format "AUTO_END_RESULT: %\n" AUTO_END_RESULT
		if AUTO_END_RESULT == undefined or ( EventFired != undefined and EventFired.val ) then
		--if AUTO_END_RESULT == undefined then
		(
			CALLBACKMANAGER.start "autoEndResult" --"./../../../CallBacks/modPanelSubObjectLevelChanged/autoEndResult.ms"

			AUTO_END_RESULT = true
		)
		else
		(
			CALLBACKMANAGER.kill "autoEndResult"

			AUTO_END_RESULT = undefined
		)
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

	CALLBACKMANAGER.kill ("activateFirstEditPoly")
	CALLBACKMANAGER.kill ("activateFirstUnwrap")
	CALLBACKMANAGER.kill ("activateLastModifier")

	CALLBACKMANAGER.kill("saveLastModifier")


	ROLLOUT_modifier_stack.CBTN_unwrap.state	= false
	ROLLOUT_modifier_stack.CBTN_edit_poly.state	= false
	ROLLOUT_modifier_stack.CBTN_last_modifier.state	= false


	case which of
	(
		#EditPoly:
		(
			activateFirstEditPoly()

			CALLBACKMANAGER.start ("activateFirstEditPoly")

			ROLLOUT_modifier_stack.CBTN_edit_poly.state	= true
		)

		#LastModifier:
		(
			CALLBACKMANAGER.start("saveLastModifier")

			CALLBACKMANAGER.start ("activateLastModifier")

			ROLLOUT_modifier_stack.CBTN_last_modifier.state	= true
		)

		#Unwrap:
		(
			activateFirstUnwrap()

			CALLBACKMANAGER.start ("activateFirstUnwrap")

			ROLLOUT_modifier_stack.CBTN_unwrap.state	= true
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
icon:	"control:checkbutton|MENU:true|autorun:true|across:3|offset:[0,4]"
(

	on execute do
		--format "EventFired:	% \n" EventFired
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == #EditPoly then undefined else #EditPoly)
		--keepActiveModifier (if KEEP_ACTIVE_NODIFIER == undefined then #EditPoly )
		keepActiveModifier ( if EventFired == undefined or ( EventFired != undefined and EventFired.val != undefined and EventFired.val ) then #EditPoly )


	--on IsChecked do KEEP_ACTIVE_NODIFIER == #EditPoly

)

/*
*
*/
macroscript	modifiers_keep_active_last_modifier
category:	"_Modifier-Stack"
buttonText:	"Last Modifier"
tooltip:	"Select last modifier when object is selected"
-- AUTORUN TEMPORARY DISABLED, IT IS FIRED UP ON HelperGenerator_v.generatePointHelpers reset_verts:true
icon:	"control:checkbutton|MENU:true|autorun:true"
(

	on execute do
	(
		print("print in:"+getSourceFileName())
		format "EventFired:	% \n" EventFired

		format "EventFired == undefined or ( EventFired != undefined and EventFired.val != undefined and EventFired.val ):	% \n" (EventFired == undefined or ( EventFired != undefined and EventFired.val != undefined and EventFired.val ))
		format "EventFired != undefined and EventFired.val != undefined and EventFired.val:	% \n" (EventFired != undefined and EventFired.val != undefined and EventFired.val)

		keepActiveModifier ( if EventFired == undefined or ( EventFired != undefined and EventFired.val != undefined and EventFired.val ) then #LastModifier )
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
icon:	"control:checkbutton|MENU:true|autorun:true"
(

	on execute do
		keepActiveModifier ( if EventFired == undefined or ( EventFired != undefined and EventFired.val != undefined and EventFired.val ) then #Unwrap )

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
