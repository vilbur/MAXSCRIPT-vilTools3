clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../LoftRemote.ms" )	-- "./../LoftRemote.ms"



/** Prepare scene
  *
  */
function prepareScene path_segments shapes_count path_steps =
(
	--format "\n"; print "LoftRemoteTest.ms.prepareScene()"
	delete objects

	/* CREATE PATH */
	loftPath = SplineShape name:"LoftPath" steps:path_steps

 	addNewSpline loftPath


 	for i = 0 to (path_segments * 100) by 100 do
 		addKnot loftPath 1 #smooth #curve [random -100 100, i, 0]

	select loftPath
 	--addKnot loftPath 1 #smooth #curve [ 0 , 0 ,0 ]
 	--addKnot loftPath 1 #smooth #curve [ 100 , 0 ,0 ]

	/* CREATE SHAPE */
    for i = 1 to shapes_count do
		selectmore (Circle name:( "Shape_"+i as string )	radius:( random 1 50  )	pos:[ ( i * 10 ) , 0 ,0 ] )


)

max modify mode


path_steps    = 6
path_segments = 20

shapes_count = 2
--shapes_count = 3
shapes_count = 10


prepareScene( path_segments )( shapes_count )( path_steps )


LoftRemote 	= LoftRemote_v()

LoftRemote.setMethod

--LoftRemote.setMethod(3)
LoftRemote.setMethod(#STEPS)  -- default steps count is intepolation of path
--LoftRemote.setMethod(#PERCENTAGE)
--LoftRemote.setMethod(#DISTANCE)


LoftRemote.setPath	( selection[1] )

for i = 1 to shapes_count do
	LoftRemote.setShape ( selection[ i + 1 ]  )	--pos:0

--LoftRemote.setShape 	($ShapeFirst)	pos:0
--LoftRemote.setShape	($ShapeSecond)	pos:50
--LoftRemote.setShape	($ShapeThird)	pos:100


--LoftRemote.setShape	($ShapeSecond)	--pos:50
--LoftRemote.setShape	($ShapeThird)	--pos:100


LoftRemote.create()

--LoftRemote.UIAccess.list()



--LoftRemote 	= LoftRemote_v path_steps:0
--LoftRemote.createLoft ($Path) #($ShapeFirst, $ShapeSecond )
