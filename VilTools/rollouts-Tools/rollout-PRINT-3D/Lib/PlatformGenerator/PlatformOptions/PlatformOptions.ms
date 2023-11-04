
/** Platform options
  *
  * DEFAULT VALUES ARE IN MILIMETERS
  *
  *
 */
struct PlatformOptions_v
(
	/* construct */
	export_size = 1,

	/* properties */
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

		display_units = case units.SystemType of -- convert to milimeters
		--this.display_units = case units.MetricType of -- convert to dispaly units
		(
			#millimeters:	1
			#centimeters:	10
			#meters:	1000
			#kilometers:	1000000
			default:	1 -- non metric units
		)
	),

	/** Set dimensions
	  *
	  */
	function _setDimensions =
	(
		format "\n"; print "PlatformOptions_v._setDimensions()"
		format "DISPLAY_UNITS:	% \n" display_units
		format "EXPORT_SIZE:	% \n" export_size


		for prop in getPropNames this where prop != #export_size and prop != #display_units do
		(
			format "\n"
			format "prop:	% \n" prop
			val = getProperty this prop
			format "val:	% \n" val

			corrected_val = val / display_units	/ export_size
			format "corrected_val:	% \n" corrected_val

			setProperty this prop corrected_val
		)
	),

	/**
	 *
	 */
	on create do
	(
		format "\n"; print "PlatformGenerator_v.create()"
		format "\nIMPORTANT\n"
		format "EXPORT_SIZE:	% \n" export_size

		this._setUnitsMuliplier()

		this._setDimensions()
	)
)