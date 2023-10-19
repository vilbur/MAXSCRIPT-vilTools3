clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MirrorByGizmo.ms" )	-- "./../MirrorByGizmo.ms"


/** Create objects
  *
  */
function createObjects pos wirecolor:green  =
(
	--format "\n"; print "MirrorByGizmoTest.ms.createObjects()"
	nodes = #()

	for i = 1 to 3 do
	(
		pos.y += 100

		append nodes (Teapot pos:pos  wirecolor:wirecolor)
	)

	nodes --return
)


/** MIRROR EACH OBJECT BY ITS OWN PIVOT
  *
  */
function mirrorByPivotPointCenter =
(
	--format "\n"; print "MirrorByGizmoTest.ms.mirrorSelectionByPivot()"
	select (createObjects [-100, 0, 0] wirecolor:green )


	SetCoordCenter #LOCAL -- IMPORTANT

	toolMode.axisConstraints = #Z


	(MirrorByGizmo_v()).mirrorSelection(#INSTANCE)

)


/** MIRROR SELECTION BY WORLD
  *
  * HOW TO SET GIZMO FOR MIRRORING:
  *
  * 	1) Use Transform Coordinate Center https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-7FAE565D-05D2-4E34-98D0-490B6BBC3D0C
  *
  * 	2) Set WORLD Reference Coordinate System https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-0F3E2822-9296-42E5-A572-B600884B07E3
  *
  */
function mirrorByWorld =
(
	--format "\n"; print "MirrorByGizmoTest.ms.mirrorByWorld()"

	select (createObjects [100, 0, 0] wirecolor:blue )

	toolMode.axisConstraints = #X


	SetCoordCenter #SYSTEM  -- IMPORTANT

	--toolMode.coordsys #world

	(MirrorByGizmo_v()).mirrorSelection(#INSTANCE)

)

/** MIRROR SELECTION BY SHARED PIVOT
  *
  */
function mirrorBySelectionCenter =
(
	--format "\n"; print "MirrorByGizmoTest.ms.mirrorSelectionByPivot()"
	nodes = #()

	select (createObjects([-100, 0, 0]))

	select nodes

	SetCoordCenter #SELECTION

)


delete objects

--mirrorByPivotPointCenter()

mirrorByWorld()

--mirrorBySelectionCenter()

