/** Select invalid faces
 *
 */
macroscript	maxtoprint_select_faces_degenerated
category:	"_Epoly-Selection"
buttontext:	"DEGENERATED"
toolTip:	"Select faces which verts are in line"
--icon:	"tooltip:CTRL: Reset selection"
(
	on execute do
	(
		/* Select faces which verts are in line
		*/
		
		function selectDegeneratedFaces src_obj =
		(
			
			function isDegeneratedFace src_obj face_verts =
			(
			
				if face_verts.count == 3 then
				(
					p0 = polyop.getVert src_obj face_verts[1]
					p1 = polyop.getVert src_obj face_verts[2]
					p2 = polyop.getVert src_obj face_verts[3]
				)
				else if face_verts.count == 4 then
				(
					p0 = polyop.getVert src_obj face_verts[1]
					p1 = polyop.getVert src_obj face_verts[2]
					p2 = polyop.getVert src_obj face_verts[3]
				)
				else
				(
					continue
				)
		
				-- compute triangle area via cross product
				v1 = p1 - p0
				v2 = p2 - p0
				
				area = length (cross v1 v2) * 0.5
		
				area < 1e-5 --return
			)
			
			
			if isValidNode src_obj and isKindOf src_obj Editable_Poly then
			(
				face_count = polyop.getNumFaces src_obj
				face_vert_map = #()
				face_list = #()
				vert_map = Dictionary #INTEGER -- maps [original vert index] -> [new vert index]
				
				invalid_faces = #{}
				
				new_obj = editable_mesh name:(uniquename"EPoly") pos:src_obj.pos --create an empty EMesh
				convertTo new_obj Editable_Poly --convert to Editable_Poly
		   
				for f = 1 to face_count do
				(
					face_verts = polyop.getFaceVerts src_obj f
					
					if isDegeneratedFace src_obj face_verts then
						invalid_faces[f] = true
				)
		
		
				if invalid_faces.numberSet > 0 then
				(
					subObjectLevel = 4
					
					obj.SetSelection #Face #{}
					obj.SetSelection #Face invalid_faces
				)
			)
		
		)
		
		selectDegeneratedFaces selection[1]

	)
)
