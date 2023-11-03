clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../PlatformGenerator.ms" )	-- "./../PlatformGenerator.ms"


/**
  */
function createTestPlane segments:1 vertex_selection:#{} =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createTestPlane()"
	delete objects

	_Plane = Plane length:( 10 * segments ) width:( 10 * segments ) pos:[0, 0, 10] widthsegs:segments lengthsegs:segments backfacecull:on isSelected:on

	Rotate _Plane ( angleaxis 180 [1,0,0])

	modPanel.addModToSelection (Edit_Poly ()) ui:on
	format "vertex_selection.count:	% \n" vertex_selection.count
	if vertex_selection.count > 0 then
	(
		subObjectLevel = 1

		_Plane.modifiers[#Edit_Poly].Select #Vertex vertex_selection
	)

)


createTestPlane segments:1
--createTestPlane segments:31
--createTestPlane segments:1 vertex_selection:#{3..4}


PlatformGenerator 	= PlatformGenerator_v( selection[1] )
--PlatformGenerator 	= PlatformGenerator_v( selection[1] )

platform_obj = PlatformGenerator.generate()

