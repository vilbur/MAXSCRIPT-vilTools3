clearListener(); print("Cleared in:\n"+getSourceFileName())

filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VERTEX-COLOR\Lib\meshVertToColorVertexConvertor\MeshVertToColorVertexConvertor.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MeshDataGetter.ms" )	--"./../MeshDataGetter.ms"

/**
  */
function createSourceMesh segments:8 vertex_selection:#{}  =
(
	format "\n"; print "MeshVertexGetterTest.ms.createSourceMesh()"
	delete objects

	obj = Sphere radius:15 pos:[0,0, 50 ] segments:segments isSelected:on --showVertexColors:true	vertexColorsShaded:true -- diameter 3 cm

	macros.run "Modifier Stack" "Convert_to_Poly"
)



/*--------------------------------------------------------------------
	PREPARE TEST OBJECTS
--------------------------------------------------------------------------------*/
--createSourceMesh()
createSourceMesh segments:16
--createSourceMesh segments:64
--createSourceMesh segments:128
--createSourceMesh segments:1024


obj = selection[1]


/*------------------------------------------------------------------------------
	SET INSTANCE
-------------------------------------------------------------------------------*/
global MeshDataGetter 	= MeshDataGetter_v( obj )


/*------------------------------------------------------------------------------
	SETUP
--------------------------------------------------------------------------------*/


--MeshDataGetter.VertNormalLimits.z = [ 80, 100 ] 	-- get side faces 80° - 100°

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

/** Select verts on bottom
 */
function selectVertsOnBottom =
(
	--format "\n"; print ".selectVertsOnBottom()"
    MeshDataGetter.VertNormalLimits.z = [ 135, 180 ]	-- get faces 0° - 20°

	--timer_test = timeStamp()
	verts_data = MeshDataGetter.getVertexData()
	--format "\n test: % ms\n" (( timeStamp()) - timer_test)
	subObjectLevel = 1
	obj.EditablePoly.SetSelection #Vertex verts_data[#VERTS]
)
selectVertsOnBottom()



/** SELECT FACES TOP AND BOTTOM
 */
function selectFacesTopAndBottom =
(
    MeshDataGetter.FaceNormalLimits.z = 45	-- get faces 0° - 20°
	MeshDataGetter.FaceNormalLimits.absolute = true

	face_data = MeshDataGetter.getFacesData()
	format "FACE_DATA: %\n" face_data
	--format "\n test: % ms\n" (( timeStamp()) - timer_test)
	subObjectLevel = 4
	obj.EditablePoly.SetSelection #Face face_data[#FACES]
	--format "\n"; print ".selectFacesTopAndBottom()"
)

--selectFacesTopAndBottom()



--/*------------------------------------------------------------------------------
--	SELECT RESULT
----------------------------------------------------------------------------------*/
--subObjectLevel = 4
--obj.EditablePoly.SetSelection #Face verts_data[#FACES]
