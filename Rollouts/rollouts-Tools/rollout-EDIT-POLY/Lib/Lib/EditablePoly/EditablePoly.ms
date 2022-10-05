/** Methods for Editable_Poly baseobject
 */
struct EditablePoly_v
(
	_mod,
	obj,
	
	/** Weld
	 */
	function weld treshold =
	(
		format "\n"; print "EditablePoly_v.weld()"
		
		obj.weldThreshold = treshold

		macros.run "Editable Polygon Object" "EPoly_Weld"

	),
	
	/** Remove edge with vertices
	  */
	function remove =
	(
		print("EditablePoly_v.remove()")
		if subObjectLevel == 4 then
		(
			_mod.ConvertSelection #Face #Vertex
			subObjectLevel = 1	
		)
		
		if subObjectLevel != 2 then
			_mod.Remove selLevel:#CurrentLevel
			
		else
		(
			edges = polyop.getEdgeSelection obj
			
			if edges.numberset!=0 do
			(
				vertices = #()
				
				for edge in edges do ( join vertices (( polyop.getVertsUsingEdge obj edge ) as Array ) )
				
				theVertsToRemove = vertices as BitArray
				
				for v in theVertsToRemove do ( deleteItem vertices (findItem vertices v) )
				
				_mod.Remove selLevel:#Edge
				
				polyop.setVertSelection obj ( vertices as BitArray )
				
				_mod.Remove selLevel:#Vertex
				
			)
		)
	),
	
	/** Face count
	 */
	function count sub_obj =
	(		
		print("EditablePoly_v.count()")
		case sub_obj of
		(
			(1):	polyop.getNumVerts obj
			(2):	polyop.getNumEdges obj
			(4):	polyop.getNumFaces obj
		)
	),
	
	/**  
	 */
	on create do
	(
		print("EditablePoly_v.onCreate()")
		obj = selection[1]
	)
)
