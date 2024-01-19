clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../PlatformGenerator.ms" )	-- "./../PlatformGenerator.ms"


global EXPORT_SIZE

/** Get pos
  *
  */
function getUnit val  =
(
	--format "\n"; print "PlatformGeneratorTest.ms.getUnit()"
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
function createSourceMesh segments:1 vertex_selection:#{} test_shifted_pivot:false obj:#PLANE vertex_color: =
(
	format "\n"; print "PlatformGeneratorTest.ms.createSourceMesh()"
	delete objects

	segment_size = getUnit(10)

	_obj = case obj of
	(
		#SPHERE:	Sphere radius:(getUnit(15)) pos:[0,0, getUnit(30.0) ] segments:segments -- diameter 3 cm
		#BOX:	Box  pos:[0,0, getUnit(50) ]  lengthsegs:segments widthsegs:segments heightsegs:segments

		DEFAULT:	Plane length:( segment_size * segments ) width:( segment_size * segments ) pos:[ 0, 0, getUnit(30.0) ] widthsegs:segments lengthsegs:segments backfacecull: off
	)

	select _obj

	macros.run "Modifier Stack" "Convert_to_Poly"


	if test_shifted_pivot then
		$.pos.x = $.pos.y = $.pivot.x = $.pivot.y = 100

	Rotate _obj ( AngleAxis 180 [1,0,0]) -- rotate object upside down

	modPanel.addModToSelection (Edit_Poly ()) ui:on
	--modPanel.addModToSelection ( meshsmooth ()) ui:on

	if vertex_selection.count > 0 then
	(
		subObjectLevel = 1

		if vertex_color != unsupplied then
			polyop.setVertColor _obj 0 vertex_selection vertex_color

		_obj.EditablePoly.SetSelection #Vertex vertex_selection
	)
)

/** Create test line
  *
  */
function createSourceSpline =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createSourceSpline()"
	delete objects

	_Circle = Circle radius:( getUnit(30.0) ) pos:[0,0, getUnit(30.0) ] isSelected:on -- diameter 3 cm

	normalize_mod = Normalize_Spline2 NormalizeType:1 numKnots: 10

	modPanel.addModToSelection (normalize_mod) ui:on

	_Circle_child = copy _Circle

	_Circle_child.parent = _Circle

	_Circle_child.pos.z -=  getUnit(10)
	_Circle_child.radius += getUnit(10)

	select _Circle
)

/** Create test line
  *
  */
function createSourcePoints =
(
	--format "\n"; print "PlatformGeneratorTest.ms.createSourceSpline()"
	delete objects

	point_A = Point pos:[ 0, 0, getUnit(30) ]	name:"point_A" wirecolor:blue

	point_B	= Point pos:[ getUnit(30), 0, getUnit(30) ]	name:"point_B"
	point_B_child1	= Point pos:[ getUnit(30), getUnit(10), getUnit(15) ] 	name:"point_B_child1"
	point_B_child2	= Point pos:[ getUnit(20), getUnit(10), getUnit(10) ] 	name:"point_B_child2"

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

--createSourceMesh segments:2
createSourceMesh segments:12 obj:#SPHERE
--createSourceMesh segments:4 obj:#BOX
--createSourceMesh segments:2 vertex_selection:#{3..4}
--createSourceMesh segments:2 vertex_selection:#{2..3} vertex_color:orange
--createSourceMesh segments:12 vertex_selection:#{2..17} obj:#SPHERE vertex_color:orange



/* create SPLINE object as source for platforms  */
--createSourceSpline()


/* create POINTS object as source for platforms */
--createSourcePoints()



/* SELECT SOURCE OBJECTS - IMPORTANT  */
select objects
source_objects = for obj in selection collect obj

/*------------------------------------------------------------------------------

	CREATE INSTANCE

--------------------------------------------------------------------------------*/

--PlatformGenerator 	= PlatformGenerator_v bind_to_parent:true
PlatformGenerator 	= PlatformGenerator_v EXPORT_SIZE:EXPORT_SIZE


/*------------------------------------------------------------------------------

	RUN TEST - GENERATE PLATFORMS

--------------------------------------------------------------------------------*/


--/* GENERATE NEW PALTFROMS */
PlatformGenerator.generate( source_objects )


/* REBUILD EXISTING PALTFROMS */
--PlatformGenerator.rebuild( selection )




/*------------------------------------------------------------------------------

	CROSS SECTION

--------------------------------------------------------------------------------*/

--PlatformCrossSection = PlatformCrossSection_v Options:PlatformGenerator.Options
--
--
--PlatformCrossSection.create( PlatformGenerator.getPlatforms() )


/*------------------------------------------------------------------------------

	GENERATE POINTS FROM SOURCE OBJECT

--------------------------------------------------------------------------------*/


--PlatformGenerator.generatePointHelpers(source_objects)








