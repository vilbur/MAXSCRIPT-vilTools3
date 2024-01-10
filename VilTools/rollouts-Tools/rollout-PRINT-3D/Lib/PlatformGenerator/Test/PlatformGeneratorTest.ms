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
function createTestPlane export_size segments:1 vertex_selection:#{} =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createTestPlane()"
	delete objects


	segment_size = 10 / display_units  / export_size

	_Plane = Plane length:( segment_size * segments ) width:( segment_size * segments ) pos:[ 0, 0, 30.0 / display_units / export_size ] widthsegs:segments lengthsegs:segments isSelected:on backfacecull: off


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
function createTestSpline export_size =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createTestSpline()"
	delete objects

	_Circle = Circle radius:( 15 / display_units / export_size ) pos:[0,0, 30.0 / display_units / export_size] isSelected:on -- diameter 3 cm

	normalize_mod = Normalize_Spline2 NormalizeType:1 numKnots: 10

	modPanel.addModToSelection (normalize_mod) ui:on
)


/*------------------------------------------------------------------------------
	 DIFFERENT SETUP OF UNITS
--------------------------------------------------------------------------------*/

/* UNITS MILLIMETERS */
--units.SystemType	= #millimeters
--units.MetricType	= #millimeters
--export_size	= 1


/* UNITS MILLIMETERS, DISPLAY CENTIMETERS */
units.SystemType	= #millimeters
units.MetricType	= #centimeters
export_size	= 1

--
--/* BIG OBJECT RESCALED */
--units.SystemType	= #centimeters
--units.MetricType	= #centimeters
--export_size	= 0.01




/*------------------------------------------------------------------------------
	CREATE TEST OBJECTS
--------------------------------------------------------------------------------*/

/* TEST EDIABLE POLY */
--createTestPlane export_size segments:1
createTestPlane export_size segments:4

--createTestPlane export_size segments:31
--createTestPlane export_size segments:2 vertex_selection:#{3..4}

/* TEST EDIABLE SPLINE */
--createTestSpline(export_size)


/*------------------------------------------------------------------------------
	TEST CHANGED POSITION AND PIVOT OF SOURCE OBJECT
--------------------------------------------------------------------------------*/

$.pos.x = 100
$.pos.y = 100

$.pivot.x = 100
$.pivot.y = 100


/*------------------------------------------------------------------------------
	GENERATE PLATFORMS
--------------------------------------------------------------------------------*/

--PlatformGenerator 	= PlatformGenerator_v bind_to_parent:true
PlatformGenerator 	= PlatformGenerator_v export_size:export_size

platform_obj = PlatformGenerator.generate( selection[1] )
