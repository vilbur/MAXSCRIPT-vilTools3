filein( getFilenamePath(getSourceFileName()) + "/Lib/Wirecolor/Wirecolor.ms" )

/*------------------------------------------------------------------------------
	RANDOM WIRECOLOR
--------------------------------------------------------------------------------*/

macroscript	wirecolor_random
category:	"_Wirecolor"
buttontext:	"Random color"
toolTip:	"Same random color for selected objects.\n\nCtrl+LMB: Different random color for each selected object"
icon:	"MENU:true|tooltip:Random wirecolor to selected object\n"
(
	--(Wirecolor_v()).randomize brightness:128
	--(Wirecolor_v()).randomize brightness:#(64, 255)

	--(Wirecolor_v()).randomize saturation:128
	--(Wirecolor_v()).randomize saturation:#(64, 255)

	--(Wirecolor_v()).randomize brightness:128	saturation:128
	--(Wirecolor_v()).randomize brightness:#(64, 255)	saturation:#(64, 255)

	--(Wirecolor_v()).randomize hue:10 brightness:128	saturation:164
	--(Wirecolor_v()).randomize hue:10 brightness:#(64, 255)	saturation:#(64, 255)

	on execute do
	(
		max create mode

		Wirecolor = Wirecolor_v()

		undo "Random Wirecolor" on
		(

			if keyboard.controlPressed then
				Wirecolor.mode = #per_object

			Wirecolor.randomize hue:128 brightness:#(64, 255)	saturation:#(64, 255) -- random hue
		)
	)

	on altExecute type do
	(
		macros.run "_Wirecolor" "wirecolor_random_menu"
	)
)

/*
*/
macroscript	wirecolor_random_menu
category:	"_Wirecolor"
buttontext:	"Random color"
toolTip:	"Color menu"
--icon:	"MENU:true"
(
	_Color 	= Color_v()

	color_names = for i = 1 to (Color_v()).hues.count collect _Color.hues[i][1] as string

	Menu = RcMenu_v name:"ModifierPresetMenu"

	for color_name in color_names do
		Menu.item (color_name) ( "(Wirecolor_v()).randomize col:#"+color_name + " hue:5 brightness:#(128, 255)	saturation:#(128, 255)" )

	popUpMenu (Menu.create())
)


/*------------------------------------------------------------------------------
	SELECT BY WIRECOLOR
--------------------------------------------------------------------------------*/

/*
*/
macroscript	wirecolor_select_only_visible
category:	"_Wirecolor"
buttontext:	"Select"
toolTip:	"Select by wirecolor"
icon:	"MENU:tooltip"
(
	fn compareNames obj_1 obj_2 = stricmp obj_1.name obj_2.name

	selection_colors = #()

	for o in selection do appendIfUnique selection_colors o.wirecolor


	--objects_by_color = (for o in objects where findItem selection_colors o.wirecolor > 0 and o.isNodeHidden == false and o.layer.on == true  collect o)

	--objects_by_name = qsort objects_by_color compareNames

	--for obj in objects_by_name do format "obj.name:	% \n" obj.name
	select (for o in objects where findItem selection_colors o.wirecolor > 0 and o.isNodeHidden == false and o.layer.on == true  collect o)

)


/*------------------------------------------------------------------------------
	WIRECOLOR BY LAST OBJECT
--------------------------------------------------------------------------------*/

macroscript	wirecolor_by_last
category:	"_Wirecolor"
buttontext:	"Color By Last"
toolTip:	"Set wirecolor of selected obejct by last obejct in selection"
icon:	"MENU:true"
(
	undo "Wirecolor By Last" on
	(
		for o in selection do o.wirecolor = selection[ selection.count ].wirecolor
	)
)
