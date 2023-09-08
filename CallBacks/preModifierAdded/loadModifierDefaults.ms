/** Load modifiers defaults when modifier is added
  *
  * Callback is fired on paste when copy, but is suspeneded while modiifer has not default values
  *
 */
function loadModifierDefaults =
(
	-- print "loadModifierDefaults()"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModStackPreset\ModStackPreset.ms"

	obj	= (callbacks.notificationParam())[1]
	_modifier = (callbacks.notificationParam())[2]

	ModStackPreset = ModStackPreset_v( _modifier )

	if ModStackPreset.modIsAddedNew(obj) then -- avoid execute on modifier copy
	(
		if ModStackPreset.hasPreset() then
			ModStackPreset.loadPreset()

		_modifier.name = (ModifierRenamer_v(_modifier)).generateName()
	)
)