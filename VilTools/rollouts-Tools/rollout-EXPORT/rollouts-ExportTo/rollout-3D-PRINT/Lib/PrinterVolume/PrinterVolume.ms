/** Printer volume
 */
struct PrinterVolume_v
(
	/* construct */

	/* properties */

	dummy_name = "PRINT DUMMY VOLUME",

	/* UNITS of dImension: mm */
	printer_size	= [ 120,	192, 250 ],	-- size of print plane, real size of creality LD-006 is 124 X	196
	screw_position	= [ 34,	62 ],	-- position of screws
	screw_radius	= 2,

	fix_position_object_size = 0,
	--fix_position_object_size = 1000,
	fix_position_object_offset = 1000,

	/* dependency */
	/* reference */
	/* inhered */

	/** Create printing volume of 3D printer
	  *
	  * @parameter name 	object_type #box|#Rectangle
	  * @parameter integer	export_size export scale value

	 */
	function createVolume object_type export_size =
	(
		--format "\n"; print "PrinterVolume_v.createVolume()"

		if (dummy_object = getNodeByName dummy_name) == undefined then
		(

			if ( print_volume_size = this._getPrinterSize() ) != undefined then
			(

				print_volume_size = print_volume_size / export_size

				dummy_object = case object_type of
				(
					#box:	Box	name:dummy_name  xray:true boxmode:true	wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] height:print_volume_size[3]
					--#Rectangle:	Plane	name:dummy_name  xray:true boxmode:true	wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] lengthsegs:1 widthsegs:1
					#Rectangle:	Rectangle	name:dummy_name  wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] cornerRadius:0 showFrozenInGray:false
				)

				if object_type == #Rectangle then
					this._addPlateHoles(dummy_object)(export_size)

				dummy_object.render_displayRenderMesh  = false -- disable rendr in viewport

				freeze dummy_object

				this._addToDefaultLayer(dummy_object)

			)
		)
		else
			delete dummy_object
	),

	/** Volume dimension object
	 */
	function fixPositionionObjects export_size =
	(
		--format "\n"; print "PrinterVolume_v.volumeDimensionObject()"
		dimension_objects = #()

		volume_size = this._getPrinterSize() / export_size / 2

		dummy_object = Box name:dummy_name length:fix_position_object_size width:fix_position_object_size height:fix_position_object_size pos:[ volume_size[2]+fix_position_object_offset, volume_size[1]+fix_position_object_offset, 0] pivot:[0,0,0] isSelected:on

		modPanel.addModToSelection ( symmetry PlanarX:true PlanarY:true PlanarZ:false) ui:on

		dummy_object --return
	),

	private

	/** Add plate holes
	 */
	function _addPlateHoles dummy_object export_size =
	(
		format "\n"; print "PrinterVolume_v._addPlateHoles()"
		format "dummy_object	= % \n" dummy_object
		holes_position = this._getHolesPositon() / export_size

		circle_shape = Circle radius:(this.screw_radius / export_size ) pos:[ holes_position[2], holes_position[1], 0] pivot:[0,0,0] isSelected:on

		convertToSplineShape dummy_object

		convertToSplineShape circle_shape

		/* MIRROR X */
		circle_shape_copy = copy circle_shape

		circle_shape_copy.transform = circle_shape_copy.transform * ( Matrix3 [-1,0,0] [0,1,0] [0,0,1] [0,0,0])

		addAndWeld circle_shape circle_shape_copy 0

		/* MIRROR Y */
		circle_shape_copy = copy circle_shape

		circle_shape_copy.transform = circle_shape_copy.transform * ( Matrix3 [1,0,0] [0,-1,0] [0,0,1] [0,0,0])

		addAndWeld circle_shape circle_shape_copy 0

		addAndWeld dummy_object circle_shape 0
	),

	/** Get printer size
	 */
	function _getPrinterSize =
	(
		--format "\n"; print "PrinterVolume_v.getPrinterSize()"
	   this.printer_size * (this._getUnitsDividier()) --return
	),

	/** Get printer size
	 */
	function _getHolesPositon =
	(
		--format "\n"; print "PrinterVolume_v.getPrinterSize()"
		--7x12,5
	   this.screw_position * (this._getUnitsDividier()) --return
	),

	/** Get coeficitien to get size from milimeters
	  *
	  *
	 */
	function _getUnitsDividier =
	(
		--format "\n"; print "PrinterVolume_v._getUnitsDividier()"
		case units.SystemType of
		(
		   #Centimeters:	10
		   #Meters:	1000
		   default:	1
		)
	),

	/** Add to default layer
	 */
	function _addToDefaultLayer dummy_object =
	(
		--format "\n"; print "PrinterVolume_v._addToDefaultLayer()"

		layer_default = LayerManager.getLayerFromName( "0")

		layer_default.on = true

		layer_default.addNode dummy_object

	),

	/**
	 */
	on create do
	(
		--format "\n"; print "PrinterVolume.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)