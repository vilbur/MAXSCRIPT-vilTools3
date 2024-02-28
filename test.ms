clearListener(); print("Cleared in:"+getSourceFileName())

--vec = normalize [-0.969054,-0.139916,-0.203365]


 --macros.run "_3D-Print" "_print_support_generate_points"

--macros.run "_3D-Print" "_print_support_generator"

--props_data = Dictionary()
--
--
--
--for prop in getPropNames (_mod = modPanel.getCurrentObject()) where findItem properties prop > 0 do
--	if ( val = getProperty _mod prop ) != undefined then
--		props_data[prop] = val
--
--
--format "props_data	= % \n" props_data
--
--


-- With a mesh object with the Unwrap UVW modifier...
--
--obj = selection[1]
--
---- Not sure if the following is required, I imagine it is.
--
--max modify mode
--modPanel.setCurrentObject obj.Unwrap_UVW
--
---- Take the index of the first selected map (UV) vertex.
--
--selectedMapVertices = ( unwrap.getSelectedVertices obj ) as array
--mapVertexIndex = selectedMapVertices[1]
--
---- Identify the first of all the map faces using this map vertex.
--
--mapFacesUsingVertex = ( meshop.getMapFacesUsingMapVert obj 1 #( mapVertexIndex ) ) as array
--mapFaceIndex = mapFacesUsingVertex[1] -- This map face index is the same as the corresponding mesh face index.
--
---- Get the corresponding mesh vertex from the face.
--
--mapFaceMapVertices = meshop.getMapFace obj 1 mapFaceIndex
--
--local triangleVertexOrder = -1
--if ( mapFaceMapVertices[1] == mapVertexIndex ) do triangleVertexOrder = 1
--if ( mapFaceMapVertices[2] == mapVertexIndex ) do triangleVertexOrder = 2
--if ( mapFaceMapVertices[3] == mapVertexIndex ) do triangleVertexOrder = 3
--
---- Finally, get the real mesh vertex that corresponds to the map vertex.
--
--meshVertexIndex = ( getFace obj mapFaceIndex )[triangleVertexOrder]
--
---- The world position of the vertex is the following.
--
--in coordsys world
--(
--	position = getVert obj meshVertexIndex
--)
--





--fn averageColor colors =
--(
--	local sum = Point3 0 0 0
--	for c in colors do sum += c
--	sum / colors.count
--)
--
--fn unifyVC obj =
--(
--	local meshCopy = copy obj.mesh
--	local vertexColors = for v = 1 to meshCopy.numVerts collect #()
--	for f = 1 to meshCopy.numFaces do
--	(
--		local vertIndices = getFace meshCopy f
--		local vertColorIndices = getVCFace meshCopy f
--		for v = 1 to 3 do append vertexColors[vertIndices[v]] (getVertColor meshCopy vertColorIndices[v])
--	)
--	setNumCPVVerts meshCopy meshCopy.numVerts
--	defaultVCFaces meshCopy
--	for v = 1 to vertexColors.count do setVertColor meshCopy v (averageColor vertexColors[v])
--	local objCopy = convertTo (copy obj isSelected:true showVertexColors:on) Mesh
--	objCopy.mesh = meshCopy
--	delete meshCopy
--	return objCopy
--)
--
--if selection.count > 0 and canConvertTo selection[1] Mesh do unifyVC selection[1]
--
--








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
