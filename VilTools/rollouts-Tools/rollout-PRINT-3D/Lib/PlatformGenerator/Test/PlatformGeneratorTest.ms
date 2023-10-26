--clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../PlatformGenerator.ms" )	-- "./../PlatformGenerator.ms"


/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "PlatformGeneratorTest.ms.prepareScene()"
	delete objects

	segments = 1
	--segments = 4
	--segments = 9
	--segments = 20
	segments = 31
	--segments = 50

	_Plane = Plane length:(40 * segments ) width:(40 * segments ) pos:[0, 0, 100] widthsegs:segments lengthsegs:segments backfacecull:on isSelected:on

	Rotate _Plane ( angleaxis 180 [1,0,0])

	modPanel.addModToSelection (Edit_Poly ()) ui:on

	subObjectLevel = 1

	--_Plane.modifiers[#Edit_Poly].Select #Vertex #{4}
	--_Plane.modifiers[#Edit_Poly].Select #Vertex #{2..3}

)


prepareScene()

PlatformGenerator 	= PlatformGenerator_v( selection[1] )

platform_obj = PlatformGenerator.generate()

--select platform_obj

--
--try(
--
--	macros.run "_Material-Types" "material_assign_idmat"
--)catch()
