clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../PlatformGenerator.ms" )	-- "./../PlatformGenerator.ms"


/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "PlatformGeneratorTest.ms.prepareScene()"
	delete objects

	_Plane = Plane length:50 width:50 pos:[0, 0, 100] widthsegs:2 lengthsegs:2 backfacecull:on isSelected:on

	Rotate _Plane ( angleaxis 180 [1,0,0])

	modPanel.addModToSelection (Edit_Poly ()) ui:on

	subObjectLevel = 1

	_Plane.modifiers[#Edit_Poly].Select #Vertex #{5}
)


prepareScene()

PlatformGenerator 	= PlatformGenerator_v( selection[1] )

platform_obj = PlatformGenerator.generate()

select platform_obj