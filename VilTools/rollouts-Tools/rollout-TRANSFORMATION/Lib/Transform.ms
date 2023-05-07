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
		tramsform	= #( 0, 0, 0 )

		axis_index = this._getAxisIndex(axis)
	
		tramsform[axis_index]	= 1
		tramsform_p3	= [tramsform[1], tramsform[2], tramsform[3]]
		
		Rotate $ ( angleaxis _angle tramsform_p3)
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
	
	function test =
	(
		messagebox "Transform.test()"
	)
)
