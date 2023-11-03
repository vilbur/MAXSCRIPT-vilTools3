clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../PlatformGenerator.ms" )	-- "./../PlatformGenerator.ms"


global 	display_units = case units.SystemType of
	(
	   #Centimeters:	10.0
	   #Meters:	1000.0
	   default:	1.0
	)


/**
  */
function createTestPlane segments:1 vertex_selection:#{} =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createTestPlane()"
	delete objects

	_Plane = Plane length:( 5 * segments / display_units ) width:( 10 * segments ) pos:[0, 0, 30.0 / display_units ] widthsegs:segments lengthsegs:segments backfacecull:on isSelected:on

	Rotate _Plane ( AngleAxis 180 [1,0,0])

	modPanel.addModToSelection (Edit_Poly ()) ui:on
	format "vertex_selection.count:	% \n" vertex_selection.count
	if vertex_selection.count > 0 then
	(
		subObjectLevel = 1

		_Plane.modifiers[#Edit_Poly].Select #Vertex vertex_selection
	)

)

/** Create test line
  *
  */
function createTestSpline =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createTestSpline()"
	delete objects



	_Circle = Circle radius:( 15 / display_units ) pos:[0,0, 30.0 / display_units ] isSelected:on -- diameter 3 cm

	normalize_mod = Normalize_Spline2 NormalizeType:1 numKnots: 10

	modPanel.addModToSelection (normalize_mod) ui:on

	--format "classOf obj:	% \n" (classOf _Circle)
	--format "superClassOf obj:	% \n" (superClassOf _Circle)
	--
	--convertTo $ SplineShape
	--
	--format "classOf obj:	% \n" (classOf _Circle)
	--format "superClassOf obj:	% \n" (superClassOf _Circle)

)

/* TEST EDIABLE POLY */
--createTestPlane segments:1
--createTestPlane segments:31
--createTestPlane segments:1 vertex_selection:#{3..4}

/* TEST EDIABLE SPLINE */
createTestSpline()


--PlatformGenerator 	= PlatformGenerator_v( selection[1] ) 	 bind_to_parent:true
PlatformGenerator 	= PlatformGenerator_v( selection[1] ) export_size:0.1

platform_obj = PlatformGenerator.generate()

