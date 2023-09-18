
filein( getFilenamePath(getSourceFileName()) + "/Lib/CircleStack/CircleStack.ms" ) -- "./Lib/CircleStack/circleStack.ms"

/* USE

	"./Lib/CommandPanel/CommandPanel.ms"

*/



/*------------------------------------------------------------------------------
	DELETE MODIFIERS
--------------------------------------------------------------------------------*/

/** DELETE
 */
macroscript	modifiers_delete_selected
category:	"_Modifiers-Remote-Stack"
buttontext:	"Delete"
toolTip:	"Delete Selected modifiers"
icon:	"MENU:true|title:DELETE Selected"
(
	on execute do
	(
		if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
			for obj in selection do
				for selected_modifier in selected_modifiers do
					deleteModifier obj selected_modifier

	)
)

/** DELETE DIABLED MODIFIERS
 */
macroscript	modifiers_delete_disabled_modifiers
category:	"_Modifiers-Remote-Stack"
buttontext:	"Delete Disabled"
toolTip:	"Delete Disabled modifiers"
icon:	"MENU:true"
(
	on execute do
		undo "Delete disabled modifiers" on
		(
			if queryBox "DELETE DISBALED MODIFIERS on seleted objects ?" title:"DELETE MODIFEIRS" then
				for obj in selection do
					for i = obj.modifiers.count to 1 by -1 do
						if not obj.modifiers[i].enabled then
							deleteModifier obj i

		)
)



/*------------------------------------------------------------------------------

	SMART NAVIGATION IN STACK

--------------------------------------------------------------------------------*/

/** SMART REMOTE UP
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_smart_remote_up
category:	"_Modifiers-Remote-Stack"
buttontext:	"Smart UP"
tooltip:	"GO | SELECT | DESELECT mods in stack. \n\nCTRL: On go mode select disabled mods also. \n\nSHIFT: Select mods. \n\nALT: Deselect mods. \n\nCTRL + SHIFT: Select all mods UP"
(
	on execute do
	(
		/** Is pressed
		  *
		  */
		function pressed key = execute ("keyboard."+key as string+"Pressed")


		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		case of
		(

			( pressed #CONTROL and pressed #SHIFT ):	circleStack #UP mode:#ADD_ALL
			( pressed #CONTROL ):	circleStack #UP	which:#ALL
			( pressed #SHIFT ):	circleStack #UP	which:#ALL mode:#ADD
			( pressed #ALT ):	circleStack #DOWN	which:#ALL mode:#REMOVE


			default:	circleStack #UP
		)
	)
)

/** SMART REMOTE DOWN
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_smart_remote_down
category:	"_Modifiers-Remote-Stack"
buttontext:	"Smart Down"
tooltip:	"GO | SELECT | DESELECT mods in stack. \n\nCTRL: On go mode select disabled mods also. \n\nSHIFT: Select mods. \n\nALT: Deselect mods. \n\nCTRL + SHIFT: Select all mods DOWN"
(

	on execute do
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())


		function pressed key = execute ("keyboard."+key as string+"Pressed")


		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		case of
		(
			( pressed #CONTROL and pressed #SHIFT ):	circleStack #DOWN mode:#ADD_ALL
			( pressed #CONTROL ):	circleStack #DOWN	which:#ALL
			( pressed #SHIFT ):	circleStack #DOWN	which:#ALL mode:#ADD
			( pressed #ALT ):	circleStack #UP 	which:#ALL mode:#REMOVE

			default:	circleStack #DOWN
		)
	)
)


--/** ENABLE
-- */
--macroscript	modifiers_enable_selected
--category:	"_Modifiers-Remote-Stack"
--buttontext:	"Enable"
--toolTip:	"Enable selected modifiers"
--icon:	"MENU:true|title:ENABLE"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #SELECTED )( #toggle )
--
--	on AltExecute type do
--		macros.run "_Modifiers-Remote-Stack" "modifiers_enable_all"
--)

--/** ENABLE RIGHTCLICK
-- */
--macroscript	modifiers_enable_all
--category:	"_Modifiers-Remote-Stack"
--buttontext:	"Enable"
--toolTip:	"Enable All modifiers"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #SELECTED )( true )
--)
--
--/** DISABLE
-- */
--macroscript	modifiers_disable_selected
--category:	"_Modifiers-Remote-Stack"
--buttontext:	"Disable"
--toolTip:	"Disable selected modifiers"
--icon:	"MENU:true|title:DISABLE"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #SELECTED )( false )
--
--	on AltExecute type do
--		macros.run "_Modifiers-Remote-Stack" "modifiers_disable_all"
--)
--
--/** DISABLE RIGHTCLICK
-- */
--macroscript	modifiers_disable_all
--category:	"_Modifiers-Remote-Stack"
--buttontext:	"Disable"
--toolTip:	"Disable All modifiers"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #ALL )( false )
--)
