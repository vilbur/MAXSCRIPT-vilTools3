clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SplineConvertor.ms" )	-- "./../SplineConvertor.ms"

if TEST_RUNS == undefined or (TEST_RUNS != undefined and TEST_RUNS >= 3 )then
	global TEST_RUNS = 1

else
	TEST_RUNS += 1

/** Set scene
  *
  */
function createRectangle =
(
	format "\n"; print "SplineConvertorTest.ms.createRectangle()"

	delete objects

	_Rectangle = Rectangle length:169.642 width:199.701 cornerRadius:0 pos:[-254.395,-79.5328,0] name:"Rectangle" isSelected:true

	addModifier _Rectangle (Edit_Spline name:"Added Edit_Spline 2" )
	addModifier _Rectangle (Edit_Spline name:"Added Edit_Spline 1" )
	addModifier _Rectangle (Edit_Poly   name:"Added Edit_Poly" )

	LayerManager.newLayerFromName "Test Layer"

	layer_test = LayerManager.getLayerFromName "Test Layer"

	layer_test.addNode _Rectangle

	_box = Box parent:_Rectangle

--	_Spline = SplineShape name:"Spline" steps:1
--
-- 	addNewSpline _Spline
--
-- 	for i = 0 to ( 3 * 100) by 100 do
-- 		addKnot _Spline 1 #corner #line [random -100 100, i, 0]

)


format "TEST_RUNS:	% \n" TEST_RUNS

/* RESET TEST */
if TEST_RUNS == 1 then
	delete objects


max modify mode -- just see what is happening



SplineConvertor = SplineConvertor_v()


/* PREPARE SCENE */
if objects.count == 0 then
	createRectangle()

else if classOf $Rectangle.baseobject == Rectangle then
	SplineConvertor.convert( $Rectangle )
else
	SplineConvertor.revert ( $Rectangle )


select $Rectangle*
