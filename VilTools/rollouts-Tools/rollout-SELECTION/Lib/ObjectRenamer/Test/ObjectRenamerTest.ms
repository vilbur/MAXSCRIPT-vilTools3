clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ObjectRenamer.ms" )

delete objects


global inst_count = 2

_Teapot	= Teapot	pos:[ 0, -100, 0 ]	wirecolor:green
--_Sphere	= Sphere	pos:[ 0,   0, 0 ]	wirecolor:green
--_Box	= Box	pos:[ 0, 100, 0 ]	wirecolor:blue


/** Create instances
  *
  */
function createInstances _objects cloneType offset:[0,0,0] =
(
	--format "\n"; print "ObjectRenamerTest.ms.createInstances()"
	new_nodes = #()

	with redraw off
		for i = 1 to inst_count do
			(maxOps.CloneNodes _objects cloneType:cloneType newNodes:&nll offset:[ i * offset.x, i * offset.y, i * offset.z ]; join new_nodes nll)

	--format "new_nodes:	% \n" new_nodes.count
	--format "new_nodes:	% \n" new_nodes
	new_nodes --return
)

--
--createInstances (_Teapot)
--createInstances (_Sphere)
--createInstances (_Box)

_Teapot_clones	= createInstances #( _Teapot )	#copy	offset:[ 100,0,0]
_Teapot_clones.wirecolor = color  128 128 128

_Teapot_instances	= createInstances #( _Teapot )	#instance	offset:[ 0,100,0]
_Teapot_instances.wirecolor = color  96 96 96




(ObjectRenamer_v("New Name")).rename( objects )