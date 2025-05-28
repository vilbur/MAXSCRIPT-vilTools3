/*
*/
macroscript	selection_convert_to_editable_poly
category:	"_Object-ConvertTo"
buttontext:	"Convert To Editable Poly"
tooltip:	"Convert To Editable Poly"
icon:	"MENU:true"
(
	on isVisible return selection.count > 0 and classof selection[1].baseobject != line

	on execute do
	(
		macros.run "Modifier Stack" "Convert_to_Poly"

		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\CONVERT TO.mcr"
		--
		--for obj in selection where superClassOf obj.baseobject == shape do
		--	case classOf obj.baseobject of
		--	(
		--		line:	macros.run "Modifier Stack" "Convert_to_Spline"
		--		default:	(SplineConvertor_v()).convert(obj)
		--	)
	)
)



/*
*/
macroscript	selection_convert_to_spline
category:	"_Object-ConvertTo"
buttontext:	"Convert To Spline"
tooltip:	"Convert To Ediable Spline"
icon:	"MENU:true"
(
	on isVisible return selection.count > 0 and superClassOf selection[1].baseobject == shape and classof selection[1].baseobject != SplineShape

	on execute do
	(

		for obj in selection where superClassOf obj.baseobject == shape do
			case classOf obj.baseobject of
			(
				line:	macros.run "Modifier Stack" "Convert_to_Spline"
				default:	(SplineConvertor_v()).convert(obj)
			)
	)
)

/*
*/
macroscript	selection_revert_from_spline
category:	"_Object-ConvertTo"
buttontext:	"Revert from Spline"
tooltip:	"Revert from Spline"
icon:	"MENU:true"
(
	on isVisible return  selection.count > 0 and getUserProp selection[1] "original_shape" != undefined

	on execute do
	(
		for obj in selection where getUserProp obj "original_shape" != undefined do
			selectmore ((SplineConvertor_v()).revert(obj))

	)

)
