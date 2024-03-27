--
--
--
--   theObj = selection[1]
--   convertToMesh theObj --convert to EMesh
--   theMeshCount = theObj.numfaces --get the number of faces in the object
--   selArray = #() --init. an array to collect faces
--   for f = 1 to theMeshCount do --loop through all faces
--   (
--
--	tm = (eulerAngles 45 4 0 )as matrix3
--
--     --in coordsys ( inverse ( viewport.GetTM() ) ) theFN = getFaceNormal theObj f
--     in coordsys (  tm ) theFN = getFaceNormal theObj f
--
--     if theFN.z < 0 then append selArray f -- if Z is negative, add to array
--   )
--
--   subObjectLevel = 3 --go to Face SO level
--
--   setFaceSelection theObj selArray --set the face selection in the EMesh
--   --max modify mode --go to modify mode
--   --select theObj --select the mesh
--   --modPanel.addModToSelection (deleteMesh()) --add a delete mesh, preserving the SO selection
--
--
--






   theObj = selection[1]
   --convertToMesh theObj --convert to EMesh
   theMeshCount = polyop.getNumFaces theObj --get the number of faces in the object
   selArray = #() --init. an array to collect faces
   for f = 1 to theMeshCount do --loop through all faces
   (

	tm = ( eulerAngles 0 0 0 ) as matrix3

     --in coordsys ( inverse ( viewport.GetTM() ) ) theFN = getFaceNormal theObj f
     --in coordsys (  Matrix3 0 ) theFN = polyop.getFaceNormal theObj f
     theFN = polyop.getFaceNormal theObj f

     --if theFN.z < 0 then append selArray f -- if Z is negative, add to array
     --if theFN.z < -0.25 then append selArray f -- if Z is negative, add to array
     --if theFN.z < -0.5 then append selArray f -- if Z is negative, add to array
     if theFN.z < -0.85 then append selArray f -- if Z is negative, add to array
   )

   subObjectLevel = 4 --go to Face SO level
	theObj.EditablePoly.SetSelection #Face (selArray as BitArray )

   --setFaceSelection theObj selArray --set the face selection in the EMesh
   --max modify mode --go to modify mode
   --select theObj --select the mesh
   --modPanel.addModToSelection (deleteMesh()) --add a delete mesh, preserving the SO selection




