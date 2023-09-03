clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../UIAccessorWrapper.ms" )	-- "./../UIAccessorWrapper.ms"


/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "errorTest.ms.prepareScene()"
	--delete objects
	--
	----_box	= Box()
	--_sphere	= Sphere pos:[100, 0, 0]
	--
	----addModifier _box  (Poly_Select ())
	----addModifier _box  (Materialmodifier ())
	--select _sphere
	--
	--macros.run "Modifier Stack" "Convert_to_Poly"


	delete objects

	/* CREATE PATH */
	nodePath = SplineShape name:"Path"

 	addNewSpline nodePath

 	--for i = 0 to 50 by 10 do
 		--addKnot nodePath 1 #smooth #curve [random -10 10, i,0]

 	addKnot nodePath 1 #smooth #curve [ 0 , 0 ,0 ]
 	addKnot nodePath 1 #smooth #curve [ 100 , 0 ,0 ]


	/* CREATE SHAPE */
    local nodeShape = splineShape name:"Shape"
	nodeShape = Circle radius:10 pos:[ -100 , 0 ,0 ]

	select nodePath

	--max create mode

	macros.run "Objects Compounds" "Loft"

	--max modify mode
)



prepareScene()


UIAccess = UIAccessorWrapper_v( #CommandPanel )

UIAccess.press "Path Steps"
UIAccess.setVal "Path Steps:" 0


UIAccess.list()