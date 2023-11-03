
/** Platform options
  *
  * DEFAULT VALUES ARE IN MILIMETERS
  *
  *
 */
struct PlatformOptions_v
(

	/* properties */
	export_size = 1,
	display_units = 1, -- correct size of platforms, E.g.: IF MODEL IS MADE IN METERS BUT IT IS PRINTED SCALED DOWN TO MILIMETERS

	/* options */
	bar_width 	= 1.0, -- default width is 1mm

	base_height	= 1.0,
	base_extrude	= 4.0,

	extrude_top	= 0.25,

	chamfer_base	= bar_width / 2,
	chamfer_top	= bar_width / 4,


	private

	/** Set units muliplier
	  *
	  */
	function _setUnitsMuliplier =
	(
		format "\n"; print "PlatformGenerator_v.setUnitsMuliplier()"
		format "units.MetricType:	% \n" units.MetricType

		--display_units = case units.SystemType of -- convert to milimeters
		this.display_units = case units.MetricType of -- convert to dispaly units
		(
			#centimeters:	10
			#meters:	1000
			#kilometers:	1000000
			default:	1 -- mnilimeters or non metric units
		)

		format "this.display_units :	% \n" this.display_units
		format "bar_width:	% \n" bar_width
	),


	/**
	 */
	on create do
	(
		this._setUnitsMuliplier()

		bar_width 	= bar_width	/ display_units -- default width is 1mm

		base_height	= base_height/ display_units
		base_extrude	= base_extrude	/ display_units

		extrude_top	= extrude_top	/ display_units

		chamfer_base	= chamfer_base	/ display_units
		chamfer_top	= chamfer_top	/ display_units




	)
)