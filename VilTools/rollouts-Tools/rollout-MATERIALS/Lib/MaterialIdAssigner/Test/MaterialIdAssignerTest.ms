clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../rollout-SPLINE/Lib/SplineConvertor/SplineConvertor.ms" )	-- "./../../../../rollout-SPLINE/Lib/SplineConvertor/SplineConvertor.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MaterialIdAssigner.ms" )	-- "./../MaterialIdAssigner.ms"


/** Set scene
  *
  */
function createShapes =
(
	format "\n"; print "MaterialIdAssignerTest.ms.createShapes()"

	delete objects

	_Rectangle = Rectangle length:169.642 width:199.701 cornerRadius:0 pos:[-254.395,-79.5328,0] name:"Rectangle" isSelected:true

	--addModifier _Rectangle (Edit_Spline name:"Added Edit_Spline 2" )
	--addModifier _Rectangle (Edit_Spline name:"Added Edit_Spline 1" )
	--addModifier _Rectangle (Edit_Poly   name:"Added Edit_Poly" )


	_Spline = SplineShape name:"Spline" steps:1

 	addNewSpline _Spline


 	for i = 0 to ( 3 * 100) by 100 do
 		addKnot _Spline 1 #corner #line [random -100 100, i, 0]

)

createShapes()

max modify mode -- just see what is happening



MaterialIdAssigner = MaterialIdAssigner_v()

--select($Spline)
--MaterialIdAssigner.setMatId( $Spline ) ( 3 )

select($Rectangle)
MaterialIdAssigner.setMatId( $Rectangle ) ( 3 )
