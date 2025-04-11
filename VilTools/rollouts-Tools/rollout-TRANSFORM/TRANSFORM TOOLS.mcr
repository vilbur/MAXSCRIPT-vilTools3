
global SAVED_TRANSFORMS_OF_SELECTION = Dictionary #string

/**
 */
macroscript	_transform_type_in_close
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Close dialog"
--icon:	"MENU:true"
(
	on execute do
	(
		hwndMove = windows.getChildHWND 0 "Move Transform Type-In"

		UIAccessor.CloseDialog hwndMove[1]
	)

)
/**
 *
 */
macroscript	_transfrom_save_load_transforms
category:	"_Transform-Tools"
buttontext:	"Save\Load Trans"
toolTip:	"Save Tranforms - Ctrl: Load"
icon:	"tooltip:Save transform of selected objects.\n\nCTRL: Load Transfroms"
(
	on execute do
	(
		for obj in selection do
			if not keyboard.controlPressed then
				SAVED_TRANSFORMS_OF_SELECTION[ (getHandleByAnim  obj) as string ] = obj.transform

		else
			undo "Restore Transforms" on
				if ( transform_saved = SAVED_TRANSFORMS_OF_SELECTION[ (getHandleByAnim  obj) as string ] ) != undefined then
					obj.transform = transform_saved

	)
)


/**
 *
 */
macroscript	_transfrom_get_object_dimensions
category:	"_Transform-Tools"
buttontext:	"Get Dimensions"
toolTip:	"Open Transform Randomizer Rollout"
--icon:	"#(path, index)"
(
	on execute do
	if( selection.count > 0 ) then
	(
		obj = selection[1]

		bBox = (obj.max - obj.min) -- collect BBox to variable

		bBox = case units.SystemType of -- convert to milimeters
		(
			#centimeters:	bBox * 10
			#meters:	bBox * 1000
			#kilometers:	bBox * 1000000
			default:	bBox -- mnilimeters or non metric units
		)


		bBox = case units.MetricType of -- convert to dispaly units
		(
			#centimeters:	bBox / 10
			#meters:	bBox / 1000
			#kilometers:	bBox / 1000000
			default:	bBox -- mnilimeters or non metric units
		)


		--format "%;%;%\n" bBox[1] bBox[2] bBox[3]
		--format "\nDIMENSIONS COPIED TO CLIPBOARD"

		/* COPY TO CLIPBOARD IN REVERSE ORDER, THAT WILL APPEAR IN ORDEX X,Y,Z */
		setclipboardText ( substituteString ( bBox.z as string ) "." "," )
		sleep 0.2
		--setclipboardText ( bBox.y as string )
		setclipboardText ( substituteString ( bBox.y as string ) "." "," )
		sleep 0.2
		--setclipboardText ( bBox.x as string )
		setclipboardText ( substituteString ( bBox.x as string ) "." "," )

		units_type = case units.MetricType of

		(
			#millimeters:	" mm"
			#centimeters:	" cm"
			#meters:	" m"
			#kilometers:	" km"
			default:	" units"
		)


		messageBox ("DIMESIONS COPIED TO CLIPBOARD\n\nOBJECT: "+obj.name +"\n\nX:	"+ bBox.x as string + units_type + "\nY:	" + bBox.y as string + units_type + "\nZ:	" + bBox.z as string + units_type   ) title:"DIMENSIONS"
	)
	else
		messageBox "NOTHING SELECTED" title:"Get Dimensions"

)
/**
 */
macroscript	_transform_type_in
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Mini Transform Type In\n\nDOUBLECLICK: Change window Postion"
--icon:	"MENU:true"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/Mini-Transform-Type-In.ms" )
)

/*------------------------------------------------------------------------------
	DONT AFFECT CHILDREN
--------------------------------------------------------------------------------*/
/**
 */
macroscript	_transform_randomizer
category:	"_Transform"
buttontext:	"Randomizer"
toolTip:	"Open Transform Randomizer Rollout"
--icon:	"MENU:true"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Random-Transform/random_transform_v1.ms" )
)