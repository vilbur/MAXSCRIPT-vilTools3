/** Methods for Edit_Poly modifier
 */
struct EditPoly_v
(
	_mod,
	_selection,
	
	/** Weld
	 */
	function weld treshold =
	(
		format "\n"; print "EditPoly_v.weld()"
		_mod.weldVertexThreshold = treshold
		
		macros.run "Editable Polygon Object" "EPoly_Weld"

	),
	
	
	/** Remove subobject
	 */
	function remove =
	(
		print("EditPoly_v.remove()")
		format "_mod	= % \n" _mod
		for obj in selection do
		(
			case subObjectLevel of
			(
				1:( for_remove = #RemoveVertex )
				2:( for_remove = #RemoveEdgeRemoveVertices )
				--3:( for_remove = #RemoveVertex )
				4:( _mod.ConvertSelection #Face #Edge; for_remove = #RemoveEdgeRemoveVertices )
			)
			
			if( for_remove != undefined ) then
				_mod.ButtonOp for_remove
		)
	),
	
	/** Face count
	 */
	function count sub_obj =
	(
		print("EditPoly_v.count()")

		_counts = #()
		
		for obj in _selection do
			append _counts (
				case sub_obj of
				(
					(1):	polyop.getNumVerts obj
					(2):	polyop.getNumEdges obj
					(4):	polyop.getNumFaces obj
				)
			)
		
		_counts --return	
	),
	
	/**  
	 */
	on create do
	(
		print("EditPoly_v.onCreate()")
		_selection = selection
	)
)
