clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../PlatformObject/PlatformObject.ms" )	-- "./../../PlatformObject/PlatformObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/../EditablePolyVertexGetter.ms" )	-- "./../EditablePolyVertexGetter.ms"

/**
  */
function createSourceMesh segments:8 vertex_selection:#{} test_shifted_pivot:false obj:#PLANE vertex_color: =
(
	format "\n"; print "PlatformGeneratorTest.ms.createSourceMesh()"
	delete objects

	segment_size = 10

	--_obj = Plane length:( segment_size * segments ) width:( segment_size * segments ) pos:[ 0, 0, 300 ] widthsegs:segments lengthsegs:segments backfacecull: off
	_obj = Sphere radius:15 pos:[0,0, 10 ] segments:segments -- diameter 3 cm

	select _obj

	Rotate _obj ( AngleAxis 180 [1,0,0]) -- rotate object upside down

	macros.run "Modifier Stack" "Convert_to_Poly"

	if vertex_selection.count > 0 then
	(
		subObjectLevel = 1

		if vertex_color != unsupplied then
			polyop.setVertColor _obj 0 vertex_selection vertex_color

		_obj.EditablePoly.SetSelection #Vertex vertex_selection
	)

	modPanel.addModToSelection (Edit_Poly ()) ui:on
)



/*--------------------------------------------------------------------
	PREPARE TEST OBJECTS
--------------------------------------------------------------------------------*/
--createSourceMesh()
-- createSourceMesh vertex_selection:#{2..3} vertex_color:orange


/* SELECT SOURCE OBJECTS - IMPORTANT  */
select objects
source_objects = for obj in selection collect obj


/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

EditablePolyVertexGetter 	= EditablePolyVertexGetter_v PlatformObjectInstance:(PlatformObject_v()) normal_length:10

EditablePolyVertexGetter.getVertsData(source_objects[1])


/*------------------------------------------------------------------------------
	PRINT RESULT
--------------------------------------------------------------------------------*/
for PlatformObject in EditablePolyVertexGetter.PlatformObjects do
	format "PlatformObject:	% \n" PlatformObject
