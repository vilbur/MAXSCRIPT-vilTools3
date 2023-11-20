
/**
 */
macroscript	_options_units
category:	"Units"
buttontext:	"Scale Units"
tooltip:	"Scale Custom Display Units\n\n1|10|100|1000 millimeters"
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



		format "1 UNIT == % \n" ( unit_name )
	)

	--/** Convert to display units
	--  */
	--function convertToDisplayUnits val  =
	--(
	--	val = case units.SystemType of -- convert to milimeters
	--	(
	--		#centimeters:	val * 10
	--		#meters:	val * 1000
	--		#kilometers:	val * 1000000
	--		default:	val -- millimeters or non metric units
	--	)
	--
	--	val = case units.MetricType of -- convert to dispaly units
	--	(
	--		#centimeters:	val / 10
	--		#meters:	val / 1000
	--		#kilometers:	val / 1000000
	--		default:	val -- millimeters or non metric units
	--	)
	--	val --return
	--)

)

