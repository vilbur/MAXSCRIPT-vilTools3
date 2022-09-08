/** Connect vertices
 */
struct ConnectVertices_v
(
	/* construct */
	source_shapes,
	
	/* properties */
	--conected_shape,
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
		format "\n"; print "ConnectVertices_v.connect()"
		format "source_shapes	= % \n" source_shapes
	
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
	function _connectSpline conected_shape =
	(
		format "\n"; print "ConnectVertices_v._connectSpline()"
		
		--conected_shape = source_shapes[1]

		this._setKnotsPositions(conected_shape)
		
		this._connectKnots(conected_shape)

		/* WELD */ 
		for s = 1 to select_splines.count do
			setKnotSelection conected_shape select_splines[s] select_knots[s] 

		setKnotSelection conected_shape new_connect_spline new_knots
		
		weldSpline conected_shape 0.001
		
		updateShape conected_shape
	),
	
	/** Connect edit line modifier
	 */
	function _connectEditSplineModifier =
	(
		format "\n"; print "ConnectVertices_v.connectEditSplineModifier()"
		
		maxOps.cloneNodes #(source_shapes[1]) cloneType:#copy newNodes:&temp_shapes #nodialog
	
		conected_shape = temp_shapes[1]
	
		--conected_shape.name = source_shapes[1].name + "-new-connection"
		
		clearSelection()
		
		select conected_shape
	
		convertToSplineShape conected_shape
		
		updateShape conected_shape
		
		subObjectLevel = 1
		
		connect_line = line name: (connected_shape.name+"-CONNECT-LINE-TO-ATTACH") wirecolor:( color 0 255 0 )

		this._setKnotsPositions(connected_shape)
		
		this._connectKnots(connect_line)
		
		delete connected_shape

		clearSelection()

		select source_shapes
	
		splineOps.startAttach ( modPanel.getCurrentObject()  )
		
	),
	
	/** Connect multiple source_shapes
	 */
	function _connectMultipleSplines =
	(
		format "\n"; print "ConnectVertices_v._connectMultipleSplines()"
		--print "********************************"
		maxOps.cloneNodes source_shapes cloneType:#copy newNodes:&temp_shapes #nodialog
	
		convertToSplineShape temp_shapes[1]
		convertToSplineShape temp_shapes[2]
		
		addAndWeld temp_shapes[1] temp_shapes[2] 0
		
		temp_shape = temp_shapes[1]
		
		connect_line = line name: (source_shapes[1].name+"-CONNECT-"+source_shapes[2].name) wirecolor:( color 0 255 0 )
		
		this._setKnotsPositions(temp_shape)
		
		this._connectKnots(connect_line)

		delete temp_shape
		
		splineOps.startAttach ( modPanel.getCurrentObject()  )
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
	function _connectKnots conected_shape =
	(
		format "\n"; print "ConnectVertices_v._connectKnots()"

		--select_splines = #()
	
		if knot_count == 2 then
		(
			
			new_connect_spline = addNewSpline conected_shape
			
			append new_knots	(addKnot conected_shape new_connect_spline #corner #line knot_positons[1])
			append new_knots	(addKnot conected_shape new_connect_spline #corner #line knot_positons[2])
			
			updateShape conected_shape
		)
	),
	
	/**  
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)
	
)

clearListener()

(ConnectVertices_v(for o in selection where superClassOf o == shape collect o)).connect()


--/** Create line between 2 selected vertices on spline 
-- *	New knots are weld
-- */
--function ConnectVertices_v = 
--(
--	obj = selection[1]
--	
--    if selection.count == 1 and isKindOf obj Shape then
--    (
--		knot_count = 0
--		knot_positons = #()
--
--		select_splines = #()
--		select_knots   = #()
--		new_knots      = #()
--
--        for spline = 1 to ( numSplines obj )
--            where (local selected_knots = getKnotSelection obj spline).count > 0 do
--            (
--				append select_splines spline
--				append select_knots   selected_knots
--				
--				
--                join knot_positons (for knot in selected_knots collect getKnotPoint obj spline knot)
--
--                if (knot_count += selected_knots.count) > 2 do exit
--            )
--	
--        if knot_count == 2 then
--		(
--			index = addNewSpline obj
--			
--			append new_knots	(addKnot obj index #corner #line knot_positons[1])
--			append new_knots	(addKnot obj index #corner #line knot_positons[2])
--            
--			updateShape obj
--
--			for spline = 1 to select_splines.count do
--				setKnotSelection obj select_splines[spline] select_knots[spline] 
--
--			setKnotSelection obj index new_knots
--			
--			weldSpline obj 1
--			
--			updateShape obj
--		)
--        else
--		    messageBox "Exactly 2 vertices have to be selected."
--		
--
--    )
--)