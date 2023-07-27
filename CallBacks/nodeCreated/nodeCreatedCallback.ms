/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function nodeCreatedSetDefaultPropertiesCallback =
(
	print "Start: nodeCreatedSetDefaultProperties()"
	try( callbacks.addScript #nodeCreated "nodeCreatedSetDefaultProperties()" id:#nodeCreatedSetDefaultProperties )catch()
)


/**
 */
function nodeCreatedSetDefaultPropertiesKill =
(
	print "Kill: nodeCreatedSetDefaultProperties()"
	try( callbacks.removeScripts #nodeCreated id:#nodeCreatedSetDefaultProperties )catch()
)


/**
 */
function nodeCreatedSetDefaultProperties =
(
	clearListener()

	print "nodeCreatedSetDefaultProperties()"

	--modObject = (callbacks.notificationParam())

	--format "modObject	= % \n" modObject
	--format "classOf modObject	= % \n" (classOf modObject)



	--default_modifier = execute( (classOf modObject) as string + "()" )
	--
	--current_values =  for prop in getPropNames modObject collect (getProperty modObject prop)
	--
	--default_values = for prop in getPropNames default_modifier collect (getProperty default_modifier prop)

	--format "current_values	= % \n" current_values
	--format "default_values	= % \n" default_values
	--format "modifier_is_max_default: %\n\n" modifier_is_max_default

	--if (modifier_is_max_default = (with printAllElements on current_values) as string == (with printAllElements on default_values) as string) then
	--(
		--default_preset_name = (classOf modObject) as string -- name of default preset is name class of modifier E.G.: "MeshSmooth"
		--format "default_preset_name	= % \n" default_preset_name

		--ModStackPreset = ModStackPreset_v(modObject)
		--
		--preset_name = ModStackPreset.getPresetName()
		----format "ModifierPreset.getPresetName()	= % \n" (ModifierPreset.getPresetName())
		----
		--if ModStackPreset.hasPreset( preset_name ) then
		--	ModStackPreset.loadPreset( preset_name )
	--)

)