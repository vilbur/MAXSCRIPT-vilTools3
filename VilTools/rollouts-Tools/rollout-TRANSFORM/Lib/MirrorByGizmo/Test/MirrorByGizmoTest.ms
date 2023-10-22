clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MirrorByGizmo.ms" )	-- "./../MirrorByGizmo.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../MirrorRestore/MirrorRestore.ms" )	-- "./../../MirrorRestore/MirrorRestore.ms"

/** Create objects
  *
  */
function createObjects pos count =
(
	--format "\n"; print "MirrorByGizmoTest.ms.createObjects()"
	nodes = #()

	delete objects

	--for i = 1 to 3 do
	for i = 1 to count do
	--for i = 1 to 1 do
	(
		pos.y += 100

		obj = Teapot pos:pos
		--obj = Sphere pos:pos
		--obj = Box pos:pos

		obj.name += "-Top"

		obj.wirecolor = color  ( random 64 255 ) ( random 64 255 )  ( random 64 255 )

		--obj.pivot = [ -50, 50, -10 ]
		--obj.pivot += [ 0, 0, -10 ]
		--obj.pivot += [ 0, 0, 0 ]

		append nodes ( obj )
	)

	nodes --return
)

/** Mirror each object
  *
  */
function mirrorEachObject =
(
	select objects

	/** MIRROR EACH OBJECT BY ITS OWN PIVOT
	  *
	  */
	SetCoordCenter #LOCAL -- IMPORTANT

	toolMode.axisConstraints = #Z
	--toolMode.axisConstraints = #X

	--(MirrorByGizmo_v()).mirrorObjects( selection )(#INSTANCE)
	mirrored_objects = (MirrorByGizmo_v()).mirrorObjects( selection )(#COPY)

	select mirrored_objects
)


/** MIRROR SELECTION BY WORLD
  * 	 Use Transform Coordinate Center D2-4E34-98D0-490B6BBC3D0C
  */
function mirrorSelectionByWorld =
(
	--select objects

	for obj in selection do obj.name += "-Back"

	toolMode.axisConstraints = #Y

	SetCoordCenter #SYSTEM  -- IMPORTANT https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-7FAE565D-05

	--mirrored_objects = (MirrorByGizmo_v()).mirrorObjects( selection )(#INSTANCE)
	mirrored_objects = (MirrorByGizmo_v()).mirrorObjects( selection )(#COPY)

	mirrored_objects.wirecolor = green
)



/** MIRROR SELECTION BY SHARED PIVOT
  *
  */
function mirrorBySelectionCenter =
(
	--select objects

	for obj in selection do obj.name += "-Left"

	toolMode.axisConstraints = #XY
	--toolMode.axisConstraints = #YZ
	--toolMode.axisConstraints = #Y
	--toolMode.axisConstraints = #X

	SetCoordCenter #SELECTION  -- IMPORTANT  https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-7FAE565D-05D2-4E34-98D0-490B6BBC3D0C

	--(MirrorByGizmo_v()).mirrorObjects( selection )(#INSTANCE)
	mirrored_objects = (MirrorByGizmo_v()).mirrorObjects( selection )(#COPY)

	select mirrored_objects
)


/*------------------------------------------------------------------------------
	CREATE TEST OBEJCTS
--------------------------------------------------------------------------------*/

--createObjects [-100, 0, 0] 1
--createObjects [-100, 0, 0] 2

/*------------------------------------------------------------------------------
	MIRROR TEST
--------------------------------------------------------------------------------*/
--mirrorEachObject()
--mirrorSelectionByWorld()
--mirrorBySelectionCenter()

/*------------------------------------------------------------------------------
	RESTORE MIRRORS
--------------------------------------------------------------------------------*/
(MirrorRestore_v()).restoreMirrors( objects )




