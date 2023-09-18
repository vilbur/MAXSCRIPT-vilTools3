/*
*/
macroscript	selection_link_to_last
category:	"_Selection-Object"
buttontext:	"Edit Properties"
toolTip:	"Edi object properties"
icon:	"MENU:true"
(

)


/** Mass prop change callback
  *
  */
function massPropChangeCallback val inspin prop baseobject =
(
	--format "\n"; print "test.ms.massPropChangeCallback()"
	for obj in selection where hasProperty obj prop  do
		setProperty obj prop val
)

/*
*/
macroscript	selection_properties
category:	"_Selection-Object"
buttontext:	"Edit Mod Properties"
toolTip:	"Edi current mod properties"
icon:	"MENU:true"
(
	on execute do
		if( selection.count > 0 ) then
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\OBJECT.mcr"
			max modify mode

			--if ( curr_mod = modPanel.getCurrentObject() ) == undefined then
			--(

				curr_mod = selection[1].baseobject

				classbase = classOf selection[1].baseobject
			--
			--	_objects = for obj in selection where obj.baseobject == curr_mod collect obj
			--
			--)
			--else

			_objects = for o in selection where classOf o.baseobject == classOf curr_mod  collect o

			obj_props = getPropNames curr_mod

			/** Get prop vlue
			  *
			  */
			function getPropValue _objects prop =
			(
				--format "\n"; print "test.ms.getPropValue()"
				format "\n"
				--format "_objects:	% \n" _objects
				--values = makeUniqueArray (for obj in _objects where hasProperty obj prop collect getProperty obj prop)
				values = makeUniqueArray (for obj in _objects where hasProperty obj prop collect getProperty obj prop)
				format "values:	% \n" values
				values[1] --return
			)

			/* DIALOG */
			Dialog = Dialog_v ("Edit "+  curr_mod as string +" Props ") --ini:(getSourceFileName())

			/* CONTROLS */
			_Controls   = Dialog.Controls() --group:"Controls"


			for prop in obj_props do
			(
				val = getProperty curr_mod prop

				control_type = case classOf val of
				(
					integer:	#spinner
					float:	#spinner
					BooleanClass:	#checkbox
					default:	undefined
				)

				if control_type != undefined then
				(

					title = prop as string

					val = getPropValue _objects prop

					spinner_type =  ((classof val) as string ) as name

					params = if control_type == #spinner then #( #type, spinner_type, #range, [0, 1000, val] ) else #()
					--params = #()


					--format "prop:	% \n" prop
					--format "class:	% \n" (classOf val)
					--format "val:	% \n" val
					--format "params:	% \n" params
					/* CONTROLS */
					_Control = _Controls.control control_type title across:1 params:params value:val --align:#left

					_Control.Event #changed "massPropChangeCallback" params:#( prop , classOf curr_mod )
				)
			)

			/* DIALOG CREATE */
			Dialog.create height:undefined
		)
)
