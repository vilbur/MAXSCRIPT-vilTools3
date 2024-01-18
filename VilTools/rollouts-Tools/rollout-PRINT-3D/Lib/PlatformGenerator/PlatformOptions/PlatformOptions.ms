
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
	layer_height = 0.05,

	bottom_layers_count = 15,


	/* options */
	bar_width 	= 1.5, -- default width is 1.5mm

	base_height	= 1.0,
	base_extrude	= 4.0,

	extrude_top	= 0.25,


	chamfer_top_divider = 4,

	chamfer_base,
	chamfer_top,

	cross_section	= false, -- connect columns of platform with cross beams
	cross_section_max	= 10,	-- max distance between platforms

	normal_length = 3,


	display_units = 1, -- correct size of platforms, E.g.: IF MODEL IS MADE IN METERS BUT IT IS PRINTED SCALED DOWN TO MILIMETERS

	mat_ids	= Dictionary #( #TOP, 1 /* READ-ONLY */ ) #( #MIDDLE, 3 ) #( #BASE, 4 ) #( #BOTTOM, 2 /* READ-ONLY */ ) #( #CHMAFER, 5 ) #( #CROSS, 6 ), -- #top and #bottom are read-only and they are default by Edit Spline

	/** Init
	  *
	  */
	function init =
	(
		--format "\n"; print "PlatformOptions_v.init()"

		this._setUnitsMuliplier()

		this._setBaseHeight()

		this._setDimensions()

		this._setChamferValues()
	),

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

		for prop in getPropNames this where ( superClassOf (val = getProperty this prop)) == Number do

			if val != undefined and prop != #export_size  then

				setProperty this prop (val / display_units	/ export_size)
	),

	/** Set base height
	  *
	  */
	function _setBaseHeight =
	(
		--format "\n"; print "PlatformOptions_v._setBaseHeight()"
		base_height = this.bottom_layers_count * this.layer_height
	),


	/** Set chamfer values
	  *
	  */
	function _setChamferValues =
	(
		--format "\n"; print "PlatformOptions_v.setChamferValues()"
		chamfer_base	= base_height / 2

		chamfer_top	= bar_width / 2 / chamfer_top_divider
	),

	/**
	 *
	 */
	on create do
	(
		--format "\n"; print "PlatformGenerator_v.create()"
		--format "\nIMPORTANT\n"
		--format "EXPORT_SIZE:	% \n" export_size
	)
)