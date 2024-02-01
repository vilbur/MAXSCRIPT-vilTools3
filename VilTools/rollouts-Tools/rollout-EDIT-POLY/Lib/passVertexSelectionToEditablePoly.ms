/** Pass vertex selection to editable poly
  *
  * 1) Get selected verts in modifier like Edit Poly|Poly Select
  * 2) Find same vertex by position in Editable Poly baseobject
  *
  * #return BitArray of vertex indexes of Editable Poly Baseobject
 */
function passVertexSelectionToEditablePoly =
(
	--format "\n"; print ".passVertexSelectionToEditablePoly()"
	obj = selection[1]

	vertex_sel = (getVertSelection obj.mesh) as Array

	verts_all	= #{1..( getNumVerts obj.mesh)} as Array
	verts_all_base	= #{1..( polyop.getNumVerts obj.baseobject)} as Array

	verts_sel_pos = #()

	verts_baseobjects = #()

	verts_pos_baseobjects = polyop.getVerts obj.baseobject verts_all_base node:obj

	if vertex_sel.count > 0 then
	(
		verts_sel_pos  = polyop.getVerts obj vertex_sel node:obj

		for vert_pos in verts_sel_pos where (index = findItem verts_pos_baseobjects (vert_pos)) > 0 do
			append verts_baseobjects index
	)
	verts_baseobjects as BitArray --return
)
