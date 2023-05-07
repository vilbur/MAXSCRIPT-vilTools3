/** Create line between 2 selected vertices
 *	
 *	WORKS ON:
 *		1) Single Editable spline
 *		2) Single Shape	with Edit Spline modifier
 *		2) Two Shapes	with Edit Spline modifier
 *
 * NOTICE:
 *		Edit spline modifier cannot be remote by maxscript.
 *		This script is workaroud which make new line between selected knots.
 *		This line is will not be attached to original spline by script.
 *		Script on Edit Spline modifier ends with attach tool enabled and new line with green wirecolor 
 *
 */
struct ConnectVertices_v
(
	/* construct */
	source_shapes,
	
	/* properties */
	new_connect_spline,
	select_splines = #(),
	select_knots   = #(),
	new_knots      = #(),
	knot_count	= 0,
	knot_positons	= #(),

	/* dependency */
	/* reference */
	/* inhered */
	
	/** Connect
	 */
	function connect =
	(
		--format "\n"; print "ConnectVertices_v.connect()"
		--format "source_shapes	= % \n" source_shapes
	
		if classOf (_mod = modPanel.getCurrentObject()) == Edit_Spline then 
		(
			if source_shapes.count == 1 then
				this._connectEditSplineModifier()
			
			else if source_shapes.count == 2 then
				this._connectMultipleSplines()
			
		)
		else if classOf _mod == SplineShape then
			this._connectSpline(source_shapes[1])
			
	),
	
	
	private
	
	/** Connect spline
	 */
	function _connectSpline connected_shape =
	(
		--format "\n"; print "ConnectVertices_v._connectSpline()"
		
		this._setKnotsPositions(connected_shape)
		
		this._connectKnots(connected_shape)

		/* WELD */ 
		for s = 1 to select_splines.count do
			setKnotSelection connected_shape select_splines[s] select_knots[s] 

		setKnotSelection connected_shape new_connect_spline new_knots
		
		weldSpline connected_shape 0.001
		
		updateShape conected_shape
	),
	
	/** Connect edit line modifier
	 */
	function _connectEditSplineModifier =
	(
		--format "\n"; print "ConnectVertices_v.connectEditSplineModifier()"
		
		maxOps.cloneNodes #(source_shapes[1]) cloneType:#copy newNodes:&temp_shapes #nodialog
	
		temp_shape = temp_shapes[1]
			
		convertToSplineShape temp_shape
		
		updateShape temp_shape
		
		clearSelection()
		
		select temp_shape
		
		subObjectLevel = 1
		
		connect_line = line name: (temp_shape.name+"-CONNECT-LINE-TO-ATTACH") wirecolor:( color 0 255 0 )

		this._setKnotsPositions(temp_shape)
		
		this._connectKnots(connect_line)
		
		this._deleteTempShapesAndStartAttach(temp_shape)
	),
	
	/** Connect multiple source_shapes
	 */
	function _connectMultipleSplines =
	(
		--format "\n"; print "ConnectVertices_v._connectMultipleSplines()"
		--print "********************************"
		maxOps.cloneNodes source_shapes cloneType:#copy newNodes:&temp_shapes #nodialog
	
		convertToSplineShape temp_shapes[1]
		convertToSplineShape temp_shapes[2]
		
		addAndWeld temp_shapes[1] temp_shapes[2] 0
		
		temp_shape = temp_shapes[1]
		
		connect_line = line name: (source_shapes[1].name+"-CONNECT-"+source_shapes[2].name) wirecolor:( color 0 255 0 )
		
		this._setKnotsPositions(temp_shape)
		
		this._connectKnots(connect_line)

		this._deleteTempShapesAndStartAttach(temp_shape)
	),

	/** Get positions of selected knots to conect
	  *
	  * @param	node SplineShape	object where knots position will be get
	  * 
	  --* @return	array of knot positions	
	 */
	function _setKnotsPositions get_knots_shape =
	(
		--format "\n"; print "ConnectVertices_v._getKnotsPosition()"
		for s = 1 to ( numSplines get_knots_shape )
			where (local selected_knots = getKnotSelection get_knots_shape s).count > 0 do
			(
				append select_splines s
				append select_knots selected_knots
				
				
				join knot_positons (for knot in selected_knots collect getKnotPoint get_knots_shape s knot)

				if (knot_count += selected_knots.count) > 2 do exit
			)
	),

	/** Connect knots
	 */
	function _connectKnots connected_shape =
	(
		--format "\n"; print "ConnectVertices_v._connectKnots()"
		if knot_count == 2 then
		(
			new_connect_spline = addNewSpline connected_shape
			
			append new_knots	(addKnot connected_shape new_connect_spline #corner #line knot_positons[1])
			append new_knots	(addKnot connected_shape new_connect_spline #corner #line knot_positons[2])
			
			updateShape connected_shape
		)
	),
	
	/** Delete temp shapes and start attach
	 */
	function _deleteTempShapesAndStartAttach temp_shape =
	(
		--format "\n"; print "ConnectVertices_v.deleteTempShapesAndStartAttach()"
		delete temp_shape

		clearSelection()

		select source_shapes
		
		subObjectLevel = 1

		splineOps.startAttach ( modPanel.getCurrentObject()  )
	),
	
	/**  
	 */
	on create do
	(
	)
)

/* TEST
   
	(ConnectVertices_v(for o in selection where superClassOf o == shape collect o)).connect()

*/ 