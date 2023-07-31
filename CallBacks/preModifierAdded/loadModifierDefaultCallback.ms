/** DISABLE LOAD DEFAULTS ON MODIFIER COPY
  *
  */
global LOAD_MODIFIER_DEFAULTS = true


/**
 */
function loadModifierDefaultsKill =
(
	print "Kill: loadModifierDefaults()"
	try( callbacks.removeScripts #preModifierAdded id:#loadModifierDefaults )catch(format "!!!!! ERROR IN TRY %\n\n" (getCurrentException()))
)


/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function loadModifierDefaultsCallback =
(
	print "Start: loadModifierDefaults()"

	loadModifierDefaultsKill()

	try( callbacks.addScript #preModifierAdded "loadModifierDefaults()" id:#loadModifierDefaults )catch(format "!!!!! ERROR IN TRY %\n\n" (getCurrentException()))
)

/**
 */
function loadModifierDefaults =
(
	--clearListener()
	--print "loadModifierDefaults()"

	--format "LOAD_MODIFIER_DEFAULTS	= % \n" LOAD_MODIFIER_DEFAULTS

	if LOAD_MODIFIER_DEFAULTS then
	(
		LOAD_MODIFIER_DEFAULTS = false

		max modify mode

		/** ADD POLY SELECT MODIFIER IF CONTROL IS PRESSED
		  *
		  */
		if keyboard.controlPressed then
			activatePolySelectModifierCallback()

		obj	= (callbacks.notificationParam())[1]
		_modifier	= (callbacks.notificationParam())[2]

		--if obj != undefined then
			--format "obj	= % \n" obj.name

		--format "_modifier	= % \n" _modifier

		default_modifier = execute( (classOf _modifier) as string + "()" )

		current_values =  for prop in getPropNames _modifier collect (getProperty _modifier prop)

		default_values = for prop in getPropNames default_modifier collect (getProperty default_modifier prop)

		format "current_values	= % \n" current_values
		format "default_values	= % \n" default_values

		if (modifier_is_max_default = (with printAllElements on current_values) as string == (with printAllElements on default_values) as string) then
		(
			print "loadModifierDefaults()"

			ModStackPreset = ModStackPreset_v(_modifier)

			if ModStackPreset.hasPreset( _modifier.name ) then
				ModStackPreset.loadPreset( _modifier.name )
		)

		LOAD_MODIFIER_DEFAULTS = true
	)
	else
		ADDMODIFIER_CALLBACK = true
)