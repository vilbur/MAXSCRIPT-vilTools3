/** Add modifier or load preset
 */
function addModifierOrLoadPreset modifier_class =
(
	--format "\n"; print ".addModifierOrLoadPreset()"
	if not ( keyboard.controlPressed or (classOf ( modPanel.getCurrentObject())) != modifier_class )then 
	(
		Menu = RcMenu_v name:"ModifierPresetMenu"
		
		if (presets = (ModifierPreset_v(modifier_class)).getPresets()).count > 0 then
			for preset in presets do
				Menu.item (preset) ("(ModifierPreset_v("+ modifier_class as string +")).loadPreset(\""+preset+"\")")
			
		popUpMenu (Menu.create())
		
	)else
		modPanel.addModToSelection (modifier_class()) ui:on
		
)
