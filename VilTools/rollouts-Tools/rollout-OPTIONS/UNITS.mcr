/**
 */
macroscript	_options_units
category:	"Units"
buttontext:	"Set Custom Units"
tooltip:	"Set Custom Display Units\n\n1|10 millimeters"
icon:	"ACROSS:2"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\UNITS.mcr"

		units.DisplayType = #CUSTOM

		units.CustomUnit = #MILLIMETERS

		units.CustomValue = case units.CustomValue  of
		(
			1:	10
			--10:	100
			--100:	1000
			default:	1
		)

		unit_name = if units.CustomUnit == #MILLIMETERS  then
			case units.CustomValue  of
			(
				1.0: 	"1 mm"
				10.0: 	"1 cm"
				default:	units.CustomValue as string + " " +  units.CustomUnit as string
			)

		format "1 CUSTOM UNIT == % \n" ( unit_name )
	)
)


/*
	"./../../../CallBacks/filePostOpen/checkWorldUnits.ms"
*/ 
macroscript	_options_units_check_on_file_open
category:	"_3D-Print"
buttontext:	"CHECK UNITS ON FILE OPEN"
tooltip:	"_options_units"
icon:	"ACROSS:2|control:checkbox|AUTORUN:true"
(
	/* https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5A4580C6-B5CF-12104-898B-9313D1AAECD4 */
	--on isEnabled return selection.count > 0

	on execute do
	(
		try(
			if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then 
				CALLBACKMANAGER.start "checkWorldUnits"
			else
				CALLBACKMANAGER.kill "checkWorldUnits"
			
		)catch()
	)
	
)
