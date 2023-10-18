/** EditPolyLoop represent edge loop in Edit_Poly
 */
struct EditPolyLoop_v
(
	obj,
	_mod,
	loop,
	_selection	= #(), -- selected edges in loop

	/** Get all edges in loop for edge
	  * @param	integer	_edge	Index of edge
	  * @return	BitArray
	 */
	function getLoopForEdge _edge =
	(
		format "\n"; print "EditPolyLoop_v.addOrRemoveEdgeInLoop()"
		obj	= selection[1]

		_mod.SetSelection	#Edge #{}
		_mod.Select	#Edge #{_edge}
		_mod.ButtonOp	#SelectEdgeLoop

		loop = this._getEdgesInLoop()

		format "LOOP:	% \n" loop
	),

	/** Append to selection
	 */
	function filterSelectionEdges selection_edges =
	(
		format "\n"; print "EditPolyLoop_v.filterSelectionEdges()"
		format "SELECTION_EDGES:	% \n" selection_edges

		if( loop != undefined ) then
			for edge_in_loop in loop where this._isEdgeInSelection selection_edges edge_in_loop do
				append _selection edge_in_loop

		format "_SELECTION:	% \n" _selection
	),
	/** Select loop ring
	 */
	function addOrRemoveEdgeInLoop direction select_mode =
	(
		format "\n"; print "EditPolyLoop_v.addOrRemoveEdgeInLoop()"

		first_or_last_edge = this._getFirstOrLastEdge direction
		format "first_or_last_edge:	% \n" first_or_last_edge
		--print "addOrRemoveEdgeInLoop"
		--print ( "direction = " + direction as string )
		if first_or_last_edge != undefined then
			case select_mode of
			(
				(#select):	this._addNextOrPrevEdgeToSelection 	first_or_last_edge direction
				(#deselect):	this._removeEdgeFromSelection	first_or_last_edge
			)

	),
	/*------------------------------------------------------------------------------
		PRIVATE
	--------------------------------------------------------------------------------*/

	/** Get edge loop
	 */
	function _getEdgesInLoop =
	(
		format "\n"; print "EditPolyLoop_v._getEdgesInLoop()"
		edges_selected	= _mod.GetSelection #Edge

		edge_verts	= polyop.getVertsUsingEdge obj edges_selected
		one_edge_verts	= for v in edge_verts where ( (edges_selected * ( polyop.getEdgesUsingVert obj v)).numberset	== 1) collect v
		this_edge_loop	= #()
		e0	= #{}

		format "ONE_EDGE_VERTS:	% \n" one_edge_verts

		if( one_edge_verts.count == 0 ) then
			return this_edge_loop

		vL1	= #{one_edge_verts[1]}

		--print "------------------"
		--print ( "edge_verts = " + edge_verts as string )
		--print ( (classOf edge_verts) as String )
		--print ( "one_edge_verts = " + one_edge_verts as string )
		----print ( "vL1 = " + vL1 as string )
		----messageBox vL1 beep:false
		--
		for vv in edge_verts do
		(
			e1 = (edges_selected * ( polyop.getEdgesUsingVert obj vL1)) - e0

			if not e1.isEmpty then
			(
				for i in e1 do appendIfUnique this_edge_loop i
				--print ( "vL1 = " + vL1 as string )
				vL1 = ( polyop.getVertsUsingEdge obj e1) - vL1
				e0 = e1
			)
		)
		format "THIS_EDGE_LOOP:	% \n" this_edge_loop

		this_edge_loop --return
	),

	/** Is edge in selection
	 */
	function _isEdgeInSelection selection_edges _edge =
	(
		(findItem selection_edges _edge) != 0 --return
	),

	/** Get first or last edge of selection in loop
	  * @param	#forward|#reverse	direction If #forward then return last edge, if #reverse then return first edge in selection
	  * @return	integer
	 */
	function _getFirstOrLastEdge direction =
	(
		format "\n"; print "EditPolyLoop_v._getFirstOrLastEdge()"
		format "_SELECTION:	% \n" _selection

		if _selection.count > 0 then
			if( direction == #forward ) then
				_selection[_selection.count] --return

			else
				_selection[1] --return
	),

	/** Set next or previous edge in loop selection for edge
	  * @param	integer	_edge
	 */
	function _addNextOrPrevEdgeToSelection _edge direction =
	(
		format "\n"; print "EditPolyLoop_v._addNextOrPrevEdgeToSelection()"
		index_in_loop	= findItem loop _edge
		next_prev_index	= if( direction == #forward )then index_in_loop+1 else index_in_loop-1
		print ( "next_prev_index = " + next_prev_index as string )
		if( next_prev_index > 0 and loop[next_prev_index] != undefined ) then
		(
			if( direction == #forward ) then
				append _selection loop[next_prev_index] --return

			else
				_selection = join #(loop[next_prev_index]) _selection
		)

	),
	/** Remove first or last edge from selection
	  * @param	integer	_edge
	 */
	function _removeEdgeFromSelection _edge =
	(
		deleteItem _selection (findItem _selection _edge)
	),

	function test =
	(
		messagebox "EditPolyRingLoop.test()"
	)
)
