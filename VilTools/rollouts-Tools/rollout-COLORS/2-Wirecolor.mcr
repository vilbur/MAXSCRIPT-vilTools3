
/*------------------------------------------------------------------------------
	RANDOM WIRECOLOR
--------------------------------------------------------------------------------*/

macroscript	wirecolor_random
category:	"_Wirecolor"
buttontext:	"Random color"
toolTip:	"Same random color for selected objects.\n\nCtrl+LMB: Different random color for each selected object"
icon:	"MENU:&Random color|across:4|tooltip:Random wirecolor to selected object\n\nCTRL: Random color per object"
(
	--(Wirecolor_v()).randomize brightness:128
	--(Wirecolor_v()).randomize brightness:#(64, 255)

	--(Wirecolor_v()).randomize saturation:128
	--(Wirecolor_v()).randomize saturation:#(64, 255)

	--(Wirecolor_v()).randomize brightness:128	saturation:128
	--(Wirecolor_v()).randomize brightness:#(64, 255)	saturation:#(64, 255)

	--(Wirecolor_v()).randomize hue:10 brightness:128	saturation:164
	--(Wirecolor_v()).randomize hue:10 brightness:#(64, 255)	saturation:#(64, 255)

	/* https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5A4580C6-B5CF-4104-898B-9313D1AAECD4 */
	on isVisible return subObjectLevel==undefined or subObjectLevel == 0

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
buttontext:	"Select by wirecolor"
toolTip:	"Select by wirecolor"
icon:	"MENU:&Select by wirecolor"
(
	on isVisible return subObjectLevel==undefined or subObjectLevel == 0

	on execute do
	(

		fn compareNames obj_1 obj_2 = stricmp obj_1.name obj_2.name

		selection_colors = #()

		for o in selection do appendIfUnique selection_colors o.wirecolor


		--objects_by_color = (for o in objects where findItem selection_colors o.wirecolor > 0 and o.isNodeHidden == false and o.layer.on == true  collect o)

		--objects_by_name = qsort objects_by_color compareNames

		--for obj in objects_by_name do format "obj.name:	% \n" obj.name
		select (for o in objects where findItem selection_colors o.wirecolor > 0 and o.isNodeHidden == false and o.layer.on == true  collect o)

	)

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
	on isVisible return subObjectLevel==undefined or subObjectLevel == 0

	on execute do
	undo "Wirecolor By Last" on
	(
		for o in selection do o.wirecolor = selection[ selection.count ].wirecolor
	)
)

/** COLLAPSE SELECTED LAYERS
 */
macroscript	_layers_wirecolor_by_layer
category:	"_Layers-Wirecolor"
buttontext:	"By Layer"
tooltip:	"Toggle wirecolor by OBJECT \ LAYER\n\nALT IN MENU: Toggle all objects in layers"
icon:	"across:4|MENU:Wirecolor BY LAYER"
(
	/* Toggle colorByLayer based on majority state
	   If more objects are true -> set all to false
	   If more objects are false -> set all to true */
	function toggleColorByLayer objs: apply_to_all_objects_in_layers:false =
	(
		true_count = 0
		false_count = 0
		
		if objs == unsupplied then
		(
			objs = ( if selection.count > 0 then selection else objects ) as Array
			
			/* GET ALL OBJECTS FROM LAYERS */ 
			if apply_to_all_objects_in_layers then
			(
				LayersManager = LayersManager_v()
		
				selected_layers = LayersManager.getSelectedOrCurrent()
					
				objs = LayersManager.getObjectsInLayers(selected_layers)
			)
		)
		
		/* HOW MANY OBJS HAS false\true */ 
		for o in objs do
			case o.colorByLayer of
			(
				true:  true_count  += 1
				false: false_count += 1
			)
		
		/* TOGGLE to other state fo majority of objects */ 
		target_state = false_count > true_count
		
		for o in objs do
		(
			/* TOGGLE WIRECOLOR IN WIEPORT */ 
			o.colorByLayer = target_state
		 
		 
			/* TOGGLE "RENDER BY LAYER" ( this is toggling icon in layers manager ) */ 
			o.renderByLayer = target_state
		)
		format "% objects has set colorByLayer to: %\n" objs.count target_state
	)
	
	/* TEST */
	on execute do
		toggleColorByLayer()
		
		
	on altExecute type do
		toggleColorByLayer apply_to_all_objects_in_layers:true
		
)
