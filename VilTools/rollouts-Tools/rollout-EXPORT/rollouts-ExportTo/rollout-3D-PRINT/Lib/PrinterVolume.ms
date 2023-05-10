/** Printer volume
 */
struct PrinterVolume_v
(
	/* construct */


	/* properties */

	dummy_name = "PRINT DUMMY VOLUME",

	/* dependency */
	/* reference */
	/* inhered */

	/** Create printing volume of 3D printer
	  *
	  * @parameter name 	object_type #box|#plane
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
					--#plane:	Plane	name:dummy_name  xray:true boxmode:true	wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] lengthsegs:1 widthsegs:1
					#plane:	Rectangle	name:dummy_name  wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] cornerRadius:0
				)


				if object_type == #plane then
					this._addPlateHoles(dummy_object)(export_size)

				--freeze dummy_object

				(LayerManager.getLayerFromName( "0")).addNode dummy_object
			)
		)
		else
			delete dummy_object
	),

	/** Volume dimension object
	 */
	function volumeDimensionObject export_size =
	(
		--format "\n"; print "PrinterVolume_v.volumeDimensionObject()"
		dimension_objects = #()

		volume_size = this._getPrinterSize() / export_size / 2

		dummy_object = Box name:dummy_name length:10 width:10 height:10 pos:[ volume_size[2], volume_size[1], 0] pivot:[0,0,0] isSelected:on

		modPanel.addModToSelection ( symmetry PlanarX:true PlanarY:true PlanarZ:false) ui:on

		dummy_object --return
	),

	private

	/** Add plate holes
	 */
	function _addPlateHoles dummy_object export_size =
	(
		format "\n"; print "PrinterVolume_v._addPlateHoles()"

		holes_position = this._getHolesPositon() / export_size

		circle_shape = Circle radius:3 pos:[ holes_position[2], holes_position[1], 0] pivot:[0,0,0] isSelected:on

		convertToSplineShape dummy_object

		convertToSplineShape circle_shape

		/* MIRROR and attach */
		circle_shape_copy = copy circle_shape

		circle_shape_copy.transform = circle_shape_copy.transform * ( Matrix3 [-1,0,0] [0,1,0] [0,0,1] [0,0,0])

		addAndWeld circle_shape circle_shape_copy 0

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
		case units.SystemType of
	   (
		   #Millimeters:	[ 120,	192,	250 ]
		   #Centimeters:	[ 12,	19.2,	25 ]
		   #Meters:	[ 0.12,	0.192,	0.250 ]
	   )

	),

	/** Get printer size
	 */
	function _getHolesPositon =
	(
		--format "\n"; print "PrinterVolume_v.getPrinterSize()"
		case units.SystemType of
	   (
		   #Millimeters:	[ 40,  60 ]
		   #Centimeters:	[ 4,   6 ]
		   #Meters:	[ 0.4, 0.6 ]
	   )

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
