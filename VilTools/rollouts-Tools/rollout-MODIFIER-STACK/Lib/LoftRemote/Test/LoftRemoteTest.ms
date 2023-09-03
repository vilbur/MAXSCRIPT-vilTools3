clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../LoftRemote.ms" )	-- "./../LoftRemote.ms"



/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "LoftRemoteTest.ms.prepareScene()"
	delete objects

	/* CREATE PATH */
	_path = SplineShape name:"LoftPath"

 	addNewSpline _path

 	--for i = 0 to 50 by 10 do
 		--addKnot _path 1 #smooth #curve [random -10 10, i,0]

 	addKnot _path 1 #smooth #curve [ 0 , 0 ,0 ]
 	addKnot _path 1 #smooth #curve [ 100 , 0 ,0 ]


	/* CREATE SHAPE */
    --global _shape = splineShape name:"Shape"
	ShapeFirst  = Circle name:"ShapeFirst"	radius:3	pos:[ -100 , 0 ,0 ] wirecolor:red
	ShapeSecond = Circle name:"ShapeSecond"	radius:15	pos:[ -70 , 0 ,0 ]  wirecolor:green
	ShapeSecond = Circle name:"ShapeThird"	radius:70	pos:[ -30 , 0 ,0 ]  wirecolor:blue

)

max modify mode

prepareScene()


LoftRemote 	= LoftRemote_v()

--LoftRemote.setMethod(3)
--LoftRemote.setMethod(#STEPS)



LoftRemote.setPath	($LoftPath)

LoftRemote.setShape 	($ShapeFirst)	pos:0
LoftRemote.setShape	($ShapeSecond)	pos:50
LoftRemote.setShape	($ShapeThird)	pos:100


LoftRemote.create()

--LoftRemote.UIAccess.list()



--LoftRemote 	= LoftRemote_v path_steps:0
--LoftRemote.createLoft ($Path) #($ShapeFirst, $ShapeSecond )
