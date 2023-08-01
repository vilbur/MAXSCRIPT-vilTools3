/** Load modifiers defaults when modifier is added
  *
  * Callback is fired on paste when copy, but is suspeneded while modiifer has not default values

 */
function loadModifierDefaults =
(
	--clearListener()
	--print "loadModifierDefaults()"


	/** Test if modifier has default values
	 *
	 */
	function isAddedNewModifier _modifier =
	(
		--format "\n"; print "loadModifierDefaults.ms.isAddedNewModifier()"
		--format "_modifier	= % \n" _modifier

		default_modifier = execute( (classOf _modifier) as string + "()" )

		current_values =  for prop in getPropNames _modifier collect (getProperty _modifier prop)

		default_values = for prop in getPropNames default_modifier collect (getProperty default_modifier prop)

		(with printAllElements on current_values ) as string == (with printAllElements on default_values) as string  --return
		--return true
	)

	max modify mode


	if isAddedNewModifier ( _modifier = (callbacks.notificationParam())[2] ) then
	(
		print "loadModifierDefaults()"
		ModStackPreset = ModStackPreset_v(_modifier)

		if ModStackPreset.hasPreset( _modifier.name ) then
			ModStackPreset.loadPreset( _modifier.name )
	)

)