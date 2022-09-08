/** Connect vertices
 */
struct ConnectVertices_v
(
	/* construct */
	source_splines,
	
	/* properties */
	spline_obj,
	connect_spline,
	select_splines = #(),
	select_knots   = #(),
	new_knots      = #(),

	/* dependency */
	/* reference */
	/* inhered */
	
	/** Connect
	 */
	function connect =
	(
		format "\n"; print "ConnectVertices_v.connect()"
		format "source_splines	= % \n" source_splines
		--if source_splines.count == 1 then
		--(
		--	if classOf ( modPanel.getCurrentObject() ) == SplineShape then 
		--		this._connectSpline()
		--		
		--	else if classOf ( modPanel.getCurrentObject() ) == Edit_Spline then 
		--		this._connectEditSplineModifier()
		--)
		--else if source_splines.count == 2 then 
		--	this._connectMultipleSplines()
		--_mod = modPanel.getCurrentObject())
		spline_obj = source_splines[1]
		
		if classOf (_mod = modPanel.getCurrentObject()) == SplineShape then 
			this._connectSpline()
			
		else if classOf _mod == Edit_Spline then 
			this._connectEditSplineModifier()
		
	),
	
	
	private
	
	/** Connect spline
	 */
	function _connectSpline =
	(
		format "\n"; print "ConnectVertices_v._connectSpline()"		
	
		this._connectKnots()
		--knot_count = 0
		--knot_positons = #()
		--
		--select_splines = #()
		--select_knots   = #()
		--new_knots      = #()
		--
		--for s = 1 to ( numSplines spline_obj )
		--	where (local selected_knots = getKnotSelection spline_obj s).count > 0 do
		--	(
		--		append select_splines s
		--		append select_knots   selected_knots
		--		
		--		
		--		join knot_positons (for knot in selected_knots collect getKnotPoint spline_obj s knot)
		--
		--		if (knot_count += selected_knots.count) > 2 do exit
		--	)
		--
		--if knot_count == 2 then
		--(
		--	connect_spline = addNewSpline spline_obj
		--	
		--	append new_knots	(addKnot spline_obj connect_spline #corner #line knot_positons[1])
		--	append new_knots	(addKnot spline_obj connect_spline #corner #line knot_positons[2])
		--	
		--	updateShape spline_obj
	
			for s = 1 to select_splines.count do
				setKnotSelection spline_obj select_splines[s] select_knots[s] 

			setKnotSelection spline_obj connect_spline new_knots
			
			weldSpline spline_obj 0.001
			
			updateShape spline_obj
		
		
		
	),
	
	/** Connect edit line modifier
	 */
	function _connectEditSplineModifier =
	(
		format "\n"; print "ConnectVertices_v.connectEditSplineModifier()"
	),
	
	/** Connect multiple source_splines
	 */
	function _connectMultipleSplines =
	(
		format "\n"; print "ConnectVertices_v._connectMultipleSplines()"
	),
	
	/** Connect knots
	 */
	function _connectKnots =
	(
		format "\n"; print "ConnectVertices_v._connectKnots()"
		knot_count = 0
		knot_positons = #()

		--select_splines = #()

		for s = 1 to ( numSplines spline_obj )
			where (local selected_knots = getKnotSelection spline_obj s).count > 0 do
			(
				append select_splines s
				append select_knots   selected_knots
				
				
				join knot_positons (for knot in selected_knots collect getKnotPoint spline_obj s knot)

				if (knot_count += selected_knots.count) > 2 do exit
			)
	
		if knot_count == 2 then
		(
			connect_spline = addNewSpline spline_obj
			
			append new_knots	(addKnot spline_obj connect_spline #corner #line knot_positons[1])
			append new_knots	(addKnot spline_obj connect_spline #corner #line knot_positons[2])
			
			updateShape spline_obj
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