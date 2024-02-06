clearListener(); print("Cleared in:"+getSourceFileName())

fn averageColor colors =
(
	local sum = Point3 0 0 0
	for c in colors do sum += c
	sum / colors.count
)

fn unifyVC obj =
(
	local meshCopy = copy obj.mesh
	local vertexColors = for v = 1 to meshCopy.numVerts collect #()
	for f = 1 to meshCopy.numFaces do
	(
		local vertIndices = getFace meshCopy f
		local vertColorIndices = getVCFace meshCopy f
		for v = 1 to 3 do append vertexColors[vertIndices[v]] (getVertColor meshCopy vertColorIndices[v])
	)
	setNumCPVVerts meshCopy meshCopy.numVerts
	defaultVCFaces meshCopy
	for v = 1 to vertexColors.count do setVertColor meshCopy v (averageColor vertexColors[v])
	local objCopy = convertTo (copy obj isSelected:true showVertexColors:on) Mesh
	objCopy.mesh = meshCopy
	delete meshCopy
	return objCopy
)

if selection.count > 0 and canConvertTo selection[1] Mesh do unifyVC selection[1]





	--if colored_verts_num > 0 then
	--(
		--( modPanel.getCurrentObject()).unhideAll #Vertex

		--verts_white = _getVertsByColor(white)
		--format "VERTS_WHITE	= % \n" verts_white
		--all_colors["white"] = verts_white

	--	colored_verts = verts_all - verts_white
	--
	--	format "COLORED_VERTS	= % \n" COLORED_VERTS
	--
	--	i = 1
	--
	--	while not colored_verts.isEmpty do
	--	(
	--		format "\n\n\n"
	--		format "i	= % \n" i
	--
	--		vert_color = getvertcolor obj.mesh (colored_verts as Array )[1]
	--		format "vert_color	= % \n" vert_color
	--		verts_by_color = this._getVertsByColor (vert_color)
	--		format "verts_by_color	= % \n" verts_by_color
	--
	--
	--		all_colors[ vert_color as string ] = verts_by_color
	--
	--		colored_verts = colored_verts - verts_by_color
	--		format "colored_verts	= % \n" colored_verts
	--
	--		i += 1
	--
	--		if i > 5 then
	--			return all_colors
	--
	--	)
	--)

	--all_colors --return








	--slice_mod = _box.modifiers[#SLICE]
	--
	--obj_TM = _box.objectTransform
	--mod_TM = getModContextTM _box slice_mod
	--
	--
	--slice_TM = final_TM * ( Inverse obj_TM ) * mod_TM
	--
	--
	--slice_mod.slice_plane.transform = slice_TM
	--
	--
	--/* ---------------------------- */
	--
	----slice_mod = copy slice_mod
	----
	----addModifier _sphere slice_mod
	----
	----obj_TM = _sphere.objectTransform
	----mod_TM = getModContextTM _sphere slice_mod
	----
	----
	----slice_TM = final_TM * mod_TM * ( Inverse obj_TM )
	----
	----_sphere.modifiers[#SLICE].slice_plane.transform = slice_TM
	--
	--
	--/* ---------------------------- */
	--
	--
	--addModifier _sphere slice_mod
	--
	--obj_TM = _sphere.objectTransform
	--mod_TM = final_TM * ( Inverse obj_TM ) * (slice_mod.slice_plane.transform )
	----mod_TM = (final_TM ) * ( Inverse obj_TM ) * (slice_mod.slice_plane.transform ) * ( fix )
	--
	----mod_TM.position -= _box.position - _sphere.position
	--
	--
	--setModContextTM _sphere slice_mod mod_TM
	--
	--
	--slice_mod.Slice_Type = 3
	--
	----slice_TM = final_TM * mod_TM * ( Inverse obj_TM )
	--
	--
	--
	--
	--
	--
	--














----_shape = modPanel.getCurrentObject()
--
--
----format "classOf _shape:	% \n" (classOf _shape)
----format "numSplines:	% \n" ( numSplines selection[1] )
--
----
----for spline_i = 1 to numSplines (obj = selection[1]) do
----	for segment_i = 1 to numSegments obj spline_i do
----		setMaterialID  obj spline_i segment_i segment_i
--
--
----Basic start point,
--pCenter = Dummy()
--pCenter.scale = point3 0.05 0.05 0.05
--pCenter.pos = point3 0 0 0
--centerX = pCenter.position.x
--centerY = pCenter.position.y
--centerZ = pcenter.position.z
--
--/*
--HINT: convert to and from
--
--radians = degrees * (pi/180)
--
--degrees = radians * (180/pi)
--
--*/
--
--
----initial vars from formula:r=a+b*theta
--a = 0.0  --this will be replaced in params via centerX and centerY
--b = 1.0  -- this is distance for offset
--t = 0.0  -- this is start angle
--theta = t * (pi/180)
--
--
--end = 1440.0 -- specify max degrees
--
--
--
--
--
--
--
--
--
--for theta =0 to end do
--(
--    r = a + theta * b
--    r *=0.1
--    x = centerX + cos(theta) * r
--    y = centerY + sin(theta) * r
--
--    pt = Dummy()
--    pt.scale = point3 0.1 0.1 0.1
--    pt.pos = point3 x y centerZ
--
--)

--obj = selection[1]
--
--
--	faces	= #{}
--
--	obj_faces	= #{1..( polyop.getNumFaces obj)}
--
--	format "polyop.getNumFaces obj	= % \n" (polyop.getNumFaces obj)
--
--	getElement = polyop.getElementsUsingFace
--
--	elements = for i in obj_faces where obj_faces[i] == true collect
--	(
--		element = getElement obj i
--		obj_faces -= element
--		element
--	)
--
--format "elements.count	= % \n" elements.count
--
--
--	elements --return
--
