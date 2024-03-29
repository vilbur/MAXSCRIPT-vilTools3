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
MeshDataGetter 	= MeshDataGetter_v( obj )


/*------------------------------------------------------------------------------
	SETUP
--------------------------------------------------------------------------------*/
MeshDataGetter.normals.absolute = true

MeshDataGetter.normals.z = 20	-- get faces 0° - 20°

--MeshDataGetter.normals.z = [ 80, 100 ] 	-- get side faces 80° - 100°

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

--timer_test = timeStamp()
data = MeshDataGetter.getData()
--format "\n test: % ms\n" (( timeStamp()) - timer_test)



/*------------------------------------------------------------------------------
	SELECT RESULT
--------------------------------------------------------------------------------*/
subObjectLevel = 4
obj.EditablePoly.SetSelection #Face data[#FACES]
