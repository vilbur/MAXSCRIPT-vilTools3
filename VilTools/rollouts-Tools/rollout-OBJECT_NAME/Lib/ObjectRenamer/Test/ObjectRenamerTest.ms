clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ObjectRenamer.ms" )

/** Create instances
  *
  */
function cloneNodes count _objects cloneType offset:[0,0,0] =
(
	--format "\n"; print "ObjectRenamerTest.ms.cloneNodes()"
	new_nodes = #()

	--with redraw off
		for i = 1 to count do
			(maxOps.CloneNodes _objects cloneType:cloneType newNodes:&nll offset:[ i * offset.x, i * offset.y, i * offset.z ]; join new_nodes nll)

	new_nodes --return
)

/** Prepare scene
  *
  */
function prepareScene =
(
	delete objects

	_Teapot	= Teapot	pos:[ 0, -100, 0 ]	wirecolor:yellow name:"Original"

	offset_inst = [ 100, 0,0]
	offset_ref = [ 0, 0, 100]

	copies	= cloneNodes	2 #( _Teapot )	#copy	offset:[ 0, 100, 0 ]
	for i = 1 to copies.count do
	(
		copies[i].name = "Copy" + i as string
		copies[i].wirecolor = blue
	)

	instances	= cloneNodes	2 #( _Teapot )	#instance	offset:offset_inst
	for i = 1 to instances.count do
		instances[i].name = "Instance" + i as string


	references	= cloneNodes	3 ( _Teapot )	#reference	offset:offset_ref
	for i = 1 to references.count do
	(
		references[i].name = "Reference" + i as string
		references[i].wirecolor = color ( random 128 255 ) ( random 128 255 ) ( random 128 255 )

	)

	instances_of_refs	= cloneNodes	1 ( references )	#instance	offset:(offset_inst)
	instances_of_refs.wirecolor = color 16 164 16
	for i = 1 to instances_of_refs.count do
		instances_of_refs[i].name = "InstanceOfReference" + i as string


)

prepareScene()


(ObjectRenamer_v("New Name")).rename( objects )