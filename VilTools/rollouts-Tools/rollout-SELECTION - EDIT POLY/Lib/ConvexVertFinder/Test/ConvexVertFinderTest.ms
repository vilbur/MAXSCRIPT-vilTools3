clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ConvexVertFinder.ms" )	--"./../ConvexVertFinder.ms"

test_scene = "convex-verts-test.max"

if maxFileName != test_scene then
	loadMaxFile ( getFilenamePath(getSourceFileName()) + "/" + test_scene ) quiet:true


obj = if selection.count > 0 then  selection[1] else objects[1]


ConvexVertFinder = ConvexVertFinder_v( obj )

/*------------------------------------------------------------------------------
	--OPTIONS
--------------------------------------------------------------------------------*/
mode = #CONVEX
--mode = #CONCAVE
--mode = #FLAT
--mode = #BORDER


/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/
verts = ConvexVertFinder.getVerts #{1..( getNumVerts obj.mesh)} mode:mode -- DEFAULT mode:#CONVEX

format "verts: %\n" verts
/*------------------------------------------------------------------------------
	SELECT RESULT
--------------------------------------------------------------------------------*/



max modify mode
subObjectLevel = 1
obj.EditablePoly.SetSelection #Vertex #{}
obj.EditablePoly.SetSelection #Vertex verts
