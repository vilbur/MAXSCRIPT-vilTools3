
/** Transform
 */
struct Transform_v
(
	/** Rotate selection
	  *
	  * @param	integer	_angle	of rotation
	  * @param	#x|#y|#z	axis	of rotation
	 */
	function rotateSelection _angle axis:(( toolMode.axisconstraints as string )[1] as name ) =
	(
		--format "\n"; print "NodeList_v.rotateSelection()"

		if (_selection = for o in selection collect o).count > 0 then
		(
			tramsform	= #( 0, 0, 0 )

			axis_index = this._getAxisIndex(axis)

			tramsform[axis_index]	= 1
			tramsform_p3	= [tramsform[1], tramsform[2], tramsform[3]]

			all_children = this.getAllChildren(_selection)

			about _selection[1] Rotate (all_children + _selection) ( angleaxis _angle tramsform_p3)
		)
	),

	/** Get active axis
	 */
	function _getAxisIndex axis =
	(
		--format "\n"; print "Transform_v.getActiveAxis()"
		--axis	= ( toolMode.axisconstraints as string )[1] as name

		case axis of
			(
				#X: 1
				#Y: 2
				#Z: 3
			)
	),

	/** Select child nodes
	 */
	function getAllChildren _objects =
	(
		--format "\n"; print "NodeList_v.selectChildNodes()"
		all_children	= #()

		for export_node in _objects do
			all_children += this._getAllChildren(export_node)

		all_children --return
	),

	/**  Get all nested children
	  */
	function _getAllChildren obj &arr:#() =
	(
		for child in obj.children do
		(
			append arr child

			this._getAllChildren child arr:arr
		)
		arr
	),


	--/** Rotate selection
	-- */
	--function rotateSelection _angle =
	--(
	--	tramsform	= #( 0, 0, 0 )
	--	axises	= #( "x", "y", "z" )
	--	axis_active	= toLower ( toolMode.axisconstraints as string )[1]
	--
	--	axis_i	= findItem axises axis_active
	--
	--	tramsform[axis_i]	= 1
	--	tramsform_p3	= [tramsform[1], tramsform[2], tramsform[3]]
	--
	--	rotate $ ( angleaxis _angle tramsform_p3)
	--),

	/*------------------------------------------------------------------------------
		PRIVATE
	--------------------------------------------------------------------------------*/
	/**
	 */
	on create do
	(
	)
)
