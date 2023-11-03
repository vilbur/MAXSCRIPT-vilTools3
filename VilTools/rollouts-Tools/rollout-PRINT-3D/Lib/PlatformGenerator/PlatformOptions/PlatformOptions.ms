
/** Platform options
 */
struct PlatformOptions_v
(
	/* properties */
	units_multiplier = 1,

	/* options */
	bar_width 	= 1.0	* units_multiplier,

	base_height	= 1.0	* units_multiplier,
	base_extrude	= 4	* units_multiplier,

	extrude_top	= 0.25	* units_multiplier,

	chamfer_base	= bar_width / 2,
	chamfer_top	= bar_width / 4,


	private


	/**
	 */
	on create do
	(
	)
)