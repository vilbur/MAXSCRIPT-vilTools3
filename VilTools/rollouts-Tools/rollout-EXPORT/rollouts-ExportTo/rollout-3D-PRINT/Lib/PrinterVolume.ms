/** Printer volume
 */
struct PrinterVolume_v
(
	/* construct */


	/* properties */


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
		dummy_name = "PRINT DUMMY VOLUME"

		if (dummy_object = getNodeByName dummy_name) == undefined then
		(

			if ( print_volume_size = this._getPrinterSize() ) != undefined then
			(

				print_volume_size = print_volume_size / export_size

				dummy_object = case object_type of
				(
					#box:	Box	name:dummy_name  xray:true boxmode:true	wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] height:print_volume_size[3]
					#plane:	Plane	name:dummy_name  xray:true boxmode:true	wireColor:(color 0 255 0) length:print_volume_size[1] width:print_volume_size[2] lengthsegs:1 widthsegs:1
				)

				freeze dummy_object

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
		format "\n"; print "PrinterVolume_v.volumeDimensionObject()"
		dimension_objects = #()

		volume_size = this._getPrinterSize()

		volume_size = volume_size / export_size
		--format "print_volume_size	= % \n" print_volume_size

		top_right	=  volume_size
		bottom_left	= volume_size * -1
		bottom_right	= [volume_size[1] * -1, volume_size[2]  ]
		top_left	= [volume_size[1], volume_size[2] * -1 ]

		box_postions	= #(top_right, top_left,	bottom_left,	bottom_right)
		box_names	= #( #print_dummy_top_right, #print_dummy_top_left, #print_dummy_bottom_left, #print_dummy_bottom_right)

		for i = 1 to box_postions.count do
			append dimension_objects (Box name:(box_names[i] as string) length:0 width:0 height:0 pos:[ box_postions[i][2], box_postions[i][1], 0 ])

		dimension_objects --return
	),

	private

	/** Get printer size
	 */
	function _getPrinterSize =
	(
		--format "\n"; print "PrinterVolume_v.getPrinterSize()"
		case units.SystemType of
	   (
		   #Millimeters:	[ 120, 192, 250 ]
		   #Centimeters:	[ 12, 19.2, 25 ]
		   #Meters:	[ 0.12, 0.192, 0.250 ]
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
