filein( getFilenamePath(getSourceFileName()) + "/../EPolyRingLoop.ms" )	-- "./../EPolyRingLoop.ms"

/** Prepare scene
  *
  */
function testEditablePoly =
(
	--format "\n"; print "EditPolyRingLoopTest.ms.testEditablwePoly()"

	delete objects
	_plane = plane width:100 length:100 widthsegs:10 lengthsegs:10 isSelected:on

	macros.run "Modifier Stack" "Convert_to_Poly"

	subObjectLevel = 2

	--_plane.SetSelection #Edge #{100}


	--ep = Edit_Poly()--create an Edit_Poly modifier
	--addModifier obj ep--add modifier to the plane
	--max modify mode--switch to modify mode
	--select obj--select theplane
	--subObjectLevel = 2--switch to Edge mode
	--ep.select #Edge #{1}--select first edge
	--ep.ButtonOp #SelectEdgeLoop--select Loop using the first edge
	--ep.RingSelect 3 true false--shift the selection by 3

)



testEditablePoly()


(EditPolyRingLoop_v()).selectLoopRing #loop #up #move
