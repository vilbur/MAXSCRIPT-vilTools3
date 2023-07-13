

global WIRE_PARAMS_LABELS = undefined


/** Wire params dialog
 */
function wireParamsDialog obj_1 obj_2 =
(
		WIRE_PARAMS_LABELS = #(obj_1, #(), obj_2,#()) -- obj1, obj2, obj1_params, obj2_params

		/* DIALOG */
		dialog_id = "dialog_wire_params"

		Dialog 	    = Dialog_v title:("Wire Params") id:dialog_id --ini:(getSourceFileName() + "/../save-modifier-property.ini")

		_Controls	= Dialog.Controls()
		_Controls_props	= Dialog.Controls group:"Properties saved in preset"
		_Controls_connect	= Dialog.Controls()

		--CheckAllCheckbox = _Controls.control #checkbox "Check\Uncheck all" across:1
		--
		--CheckAllCheckbox.Events.add #changed ("for control in "+dialog_id+".controls do try( control.state = val )catch()")
		WIRE_PARAMS_LABELS[1] = obj_1
		WIRE_PARAMS_LABELS[2] = obj_2

		WIRE_PARAMS_LABELS[3] = ( getPropNames obj_1.baseobject)
		WIRE_PARAMS_LABELS[4] = ( getPropNames obj_2.baseobject)

		Radio_1 = _Controls_props.control #radiobuttons obj_1.name items:WIRE_PARAMS_LABELS[3] columns:1 offset:[16,16] across:2
		Radio_2 = _Controls_props.control #radiobuttons obj_2.name items:WIRE_PARAMS_LABELS[4] columns:1 offset:[16,16] across:2

		ButtonConnect =  _Controls_connect.control #button "Connect" width:128 height:64 across:1

		ButtonConnect.Events.add #pressed ("wireParamsCallback ( "+Radio_1.id+".state ) ( "+Radio_2.id+".state ) title:\"WIRE PARAMETERS \"")

		/* DIALOG CREATE */
		Dialog.create width:512 --pos:#mouse
)

/** Wire params callback
 */
function wireParamsCallback state_1 state_2 =
(
	--format "\n"; print ".wireParamsCallback()"

	--messageBox WIRE_PARAMS_LABELS[1][state_1]
	--messageBox WIRE_PARAMS_LABELS[2][state_2]

	if state_1 != undefined and state_1 != undefined then
	(
		obj_1 = getNodeByName (WIRE_PARAMS_LABELS[1].name)
		obj_2 = getNodeByName (WIRE_PARAMS_LABELS[2].name)
		--obj_2 = WIRE_PARAMS_LABELS[2]

		param_1 = WIRE_PARAMS_LABELS[3][state_1]
		param_2 = WIRE_PARAMS_LABELS[4][state_2]

		format "param_1	= % \n" param_1
		format "param_2	= % \n" param_2
		format "classOf param_1	= % \n" (classOf param_1)
		format "classOf param_2	= % \n" (classOf param_2)

		--global WIRE_PARAMS_LABELS = undefined


		try(
			--paramWire.connect2way obj_1.baseObject[param_1] obj_2.baseObject[param_2] "Height" "Height"

			/*
				THIS NEED MORE LABOR THEN HAS BEEN EXPECTED



			*/
			paramWire.connect2way obj_1.baseObject[param_1] obj_2.baseObject[param_2] "Height_Segments" "Height_Segments"









		)catch(
			format "!!!!! ERROR IN TRY %\n\n" (getCurrentException())
		)



	)

)

/**
 *
 */
macroscript	_animation_wire_params
category:	"_Animation"
buttontext:	"Wire Params"
toolTip:	""
--icon:	"#(path, index)"
(
	clearListener()
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-ANIMATION\Wire-Prameters.mcr"

	if( selection.count == 2 ) then
	(


		--getPropNames selection[1].baseobject

		wireParamsDialog( selection[1] ) ( selection[2] )


	)




)
