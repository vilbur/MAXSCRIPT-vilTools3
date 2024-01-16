clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../PlatformGenerator.ms" )	-- "./../PlatformGenerator.ms"


global EXPORT_SIZE

/** Get pos
  *
  */
function getPos val  =
(
	--format "\n"; print "PlatformGeneratorTest.ms.getPos()"
	display_units = case units.SystemType of
	(
	   #Centimeters:	10.0
	   #Meters:	1000.0
	   default:	1.0
	)

	val / display_units / EXPORT_SIZE --return
)

/**
  */
function createSourceMesh segments:1 vertex_selection:#{} test_shifted_pivot:false =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createSourceMesh()"
	delete objects

	segment_size = getPos(10)

	_Plane = Plane length:( segment_size * segments ) width:( segment_size * segments ) pos:[ 0, 0, getPos(30.0) ] widthsegs:segments lengthsegs:segments isSelected:on backfacecull: off


	if test_shifted_pivot then
		$.pos.x = $.pos.y = $.pivot.x = $.pivot.y = 100

	Rotate _Plane ( AngleAxis 180 [1,0,0])

	modPanel.addModToSelection (Edit_Poly ()) ui:on
	--format "vertex_selection.count:	% \n" vertex_selection.count
	if vertex_selection.count > 0 then
	(
		subObjectLevel = 1

		_Plane.modifiers[#Edit_Poly].Select #Vertex vertex_selection
	)
)

/** Create test line
  *
  */
function createSourceSpline =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createSourceSpline()"
	delete objects

	_Circle = Circle radius:( 15 / DISPLAY_UNITS / EXPORT_SIZE ) pos:[0,0, getPos(30.0) ] isSelected:on -- diameter 3 cm

	normalize_mod = Normalize_Spline2 NormalizeType:1 numKnots: 10

	modPanel.addModToSelection (normalize_mod) ui:on
)

/** Create test line
  *
  */
function createSourcePoints =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createSourceSpline()"
	delete objects

	point_A = Point pos:[ 0, 0, getPos(30) ]	name:"point_A" wirecolor:blue

	point_B	= Point pos:[ getPos(30), 0, getPos(30) ]	name:"point_B"
	point_B_child1	= Point pos:[ getPos(30), getPos(10), getPos(15) ] 	name:"point_B_child1"
	point_B_child2	= Point pos:[ getPos(20), getPos(10), getPos(10) ] 	name:"point_B_child2"

	point_B_child1.parent = point_B
	point_B_child2.parent = point_B_child1

	select $point_A
	selectmore $point_B
)

/*------------------------------------------------------------------------------

	 DIFFERENT SETUP OF SCENE UNITS

--------------------------------------------------------------------------------*/

/* UNITS MILLIMETERS */
--units.SystemType	= #millimeters
--units.MetricType	= #millimeters
--EXPORT_SIZE	= 1


/* UNITS MILLIMETERS, DISPLAY CENTIMETERS */
units.SystemType	= #millimeters
units.MetricType	= #centimeters
EXPORT_SIZE	= 1

--
--/* BIG OBJECT RESCALED */
--units.SystemType	= #centimeters
--units.MetricType	= #centimeters
--EXPORT_SIZE	= 0.01


/*------------------------------------------------------------------------------

	PREPARE TEST OBJECTS

--------------------------------------------------------------------------------*/

/* create MESH object as source for platforms */
--createSourceMesh segments:1 test_shifted_pivot:true
--createSourceMesh segments:1
--createSourceMesh segments:4

--createSourceMesh segments:31
--createSourceMesh segments:2 vertex_selection:#{3..4}



/* create SPLINE object as source for platforms */
--createSourceSpline()


/* create POINTS object as source for platforms */
createSourcePoints()


/*------------------------------------------------------------------------------

	RUN TEST - GENERATE PLATFORMS

--------------------------------------------------------------------------------*/

--PlatformGenerator 	= PlatformGenerator_v bind_to_parent:true
PlatformGenerator 	= PlatformGenerator_v EXPORT_SIZE:EXPORT_SIZE

platform_obj = PlatformGenerator.generate( selection )
