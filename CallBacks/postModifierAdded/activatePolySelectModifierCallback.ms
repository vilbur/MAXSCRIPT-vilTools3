
/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function activatePolySelectModifierCallback =
(
	print "Start: activatePolySelectModifier()"
	try( callbacks.addScript #postModifierAdded "activatePolySelectModifier()" id:#activatePolySelectModifier )catch()
)


/**
 */
function activatePolySelectModifierKill =
(
	print "Kill: activatePolySelectModifier()"
	try( callbacks.removeScripts #postModifierAdded id:#activatePolySelectModifier )catch()
)

/** Activate poly select test
 */
function activatePolySelectTest =
(
	format "\n"; print ".ACTIVATEPOLYSELECTTEST()"
	modPanel.setCurrentObject $.modifiers[2]

)

/**

 */
function activatePolySelectModifier =
(
	print "activatePolySelectModifier()"

	obj	= (callbacks.notificationParam())[1]
	_modifier	= (callbacks.notificationParam())[2]

	format "classOf _modifier	= % \n" (classOf _modifier)
	format "ON_MOD_PANEL_CHANGED_CALLBACKS	= % \n" ON_MOD_PANEL_CHANGED_CALLBACKS

	if classOf _modifier != Poly_Select  then
	(
		global LOAD_MODIFIER_DEFAULTS = false

		current_index = modPanel.getModifierIndex obj _modifier

		Poly_Select_Modifier = Poly_Select name:("Select "+_modifier.name) ui:on

		format "obj	= % \n" obj
		format "Poly_Select_Modifier	= % \n" Poly_Select_Modifier
		format "current_index	= % \n" current_index

		addModifier obj Poly_Select_Modifier before:current_index

		--modPanel.setCurrentObject Poly_Select_Modifier node:obj ui:true
		--modPanel.setCurrentObject obj.modifiers[current_index +1] node:obj ui:true
		--modPanel.setCurrentObject obj.modifiers[2]
	  --macros.run "Ribbon - Modeling" "PreviousModifier"

		--loadModifierDefaultsCallback()
		LOAD_MODIFIER_DEFAULTS = true

		try(callbacks.removeScripts #modPanelObjPostChange id:#activatePolySelectTest)catch()

		callbacks.addScript #modPanelObjPostChange "activatePolySelectTest()" id:#activatePolySelectTest

	)
	else
	(
		print "ACTIVATE POLY SELECT"
		/* THIS NOT WORK, it should wait then stack is ready */
		--sleep 2
		--modPanel.setCurrentObject _modifier
		--modPanel.setCurrentObject $.modifiers[2]

		activatePolySelectModifierKill()
	)





)
