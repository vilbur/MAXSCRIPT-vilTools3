/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function loadModifierDefaultsCallback =
(
	print "Start: loadModifierDefaults()"
	try( callbacks.addScript #preModifierAdded "loadModifierDefaults()" id:#loadModifierDefaults )catch()
)


/**
 */
function loadModifierDefaulstKill =
(
	print "Kill: loadModifierDefaults()"
	try( callbacks.removeScripts #preModifierAdded id:#loadModifierDefaults )catch()
)


/**
 */
function loadModifierDefaults =
(
	clearListener()
	_modifier = (callbacks.notificationParam())[2]

	default_modifier = execute( (classOf _modifier) as string + "()" )

	current_values =  for prop in getPropNames _modifier collect (getProperty _modifier prop)

	default_values = for prop in getPropNames default_modifier collect (getProperty default_modifier prop)

	--format "current_values	= % \n" current_values
	--format "default_values	= % \n" default_values
	--format "modifier_is_max_default: %\n\n" modifier_is_max_default

	if (modifier_is_max_default = (with printAllElements on current_values) as string == (with printAllElements on default_values) as string) then
	(
		default_preset_name = (classOf _modifier) as string -- name of default preset is name class of modifier E.G.: "MeshSmooth"
		--format "default_preset_name	= % \n" default_preset_name

		ModifierPreset = ModifierPreset_v(_modifier)

		if ModifierPreset.hasPreset( default_preset_name ) then
			ModifierPreset.loadPreset(default_preset_name)
	)

)