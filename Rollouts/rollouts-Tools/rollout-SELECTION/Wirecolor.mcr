filein( getFilenamePath(getSourceFileName()) + "/Lib/Wirecolor/Wirecolor.ms" )

macroscript	wirecolor_random
category:	"_Selection"
buttontext:	"Random color"
toolTip:	"Random wirecolor to selected object"
--icon:	"#(path, index)"
(
	--(Wirecolor_v()).randomize brightness:128
	--(Wirecolor_v()).randomize brightness:#(64, 255)

	--(Wirecolor_v()).randomize saturation:128
	--(Wirecolor_v()).randomize saturation:#(64, 255)

	--(Wirecolor_v()).randomize brightness:128	saturation:128
	--(Wirecolor_v()).randomize brightness:#(64, 255)	saturation:#(64, 255)

	--(Wirecolor_v()).randomize hue:10 brightness:128	saturation:164 
	--(Wirecolor_v()).randomize hue:10 brightness:#(64, 255)	saturation:#(64, 255)

	(Wirecolor_v()).randomize hue:128 brightness:#(64, 255)	saturation:#(64, 255) -- random hue

)

/*
*/ 
macroscript	wirecolor_random_menu
category:	"_Selection"
buttontext:	"Random color"
toolTip:	"Color menu"
--icon:	"#(path, index)"
(
	_Color 	= Color_v()

	color_names = for i = 1 to (Color_v()).hues.count collect _Color.hues[i][1] as string

	Menu = RcMenu_v name:"ModifierPresetMenu"

	for color_name in color_names do
		Menu.item (color_name) ( "(Wirecolor_v()).randomize col:#"+color_name + " hue:5 brightness:#(128, 255)	saturation:#(128, 255)" )

	popUpMenu (Menu.create())
)

/*
*/ 
macroscript	wirecolor_select_by
category:	"_Selection"
buttontext:	"Select by wirecolor"
toolTip:	"Select by wirecolor"
--icon:	"#(path, index)"
(
	selColor=#()		
	for o in selection do appendifunique selColor o.wirecolor

	theObject = modPanel.GetCurrentObject()
	Max create mode

	i=1
	for c in selColor do
	(

		for o in objects where o.wirecolor == selColor[i] and  o.isNodeHidden == false and 	o.layer.on == true do selectmore o

		i=i+1

	)

	max modify mode
)