/**
 */
macroscript	_options_units
category:	"Units"
buttontext:	"Set Custom Units"
tooltip:	"Set Custom Display Units\n\n1|10 millimeters"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OPTIONS\UNITS.mcr"

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