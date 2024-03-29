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
 		addKnot loftPath 1 #corner #line [random -100 100, i, 0]

	select loftPath
 	--addKnot loftPath 1 #smooth #curve [ 0 , 0 ,0 ]
 	--addKnot loftPath 1 #smooth #curve [ 100 , 0 ,0 ]
 	for i = 1 to path_segments do
		setMaterialID loftPath 1 i i


	/* CREATE SHAPE */
    for i = 1 to shapes_count do
		selectmore (Circle name:( "Shape_"+i as string )	radius:( random 5 30  )	pos:[ ( i * 10 ) , 0 ,0 ] )


)

max modify mode

--/* SETUP SHAPES */
--path_steps    = 1
--path_segments = 2
--
--shapes_count = 2
----shapes_count = 3
--shapes_count = 3
--
--
--/* SETUP LOFT */

/* SETUP LOFT */

LoftRemote 	= LoftRemote_v()

LoftRemote.setMethod(#STEPS)  -- default steps count is intepolation of path
--
--/* SET SHAPES */
--LoftRemote.setPath	( selection[1] )
--
--for i = 1 to shapes_count do
--	LoftRemote.setShape ( selection[ i + 1 ]  )	--pos:0
--
--
--/* CREATE LOFT */
--LoftRemote.create()
select $Loft001

LoftRemote.setLoft( $Loft001 )

LoftRemote.listOptions()


--LoftRemote.UIAccess.list()



--LoftRemote 	= LoftRemote_v path_steps:0
--LoftRemote.createLoft ($Path) #($ShapeFirst, $ShapeSecond )
