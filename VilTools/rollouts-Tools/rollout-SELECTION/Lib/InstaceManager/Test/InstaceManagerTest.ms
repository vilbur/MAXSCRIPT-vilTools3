clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../InstaceManager.ms" )	-- "./../InstaceManager.ms"


--global instances
--global references
--global instances_of_refs

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

/* GET AL ISNTANCES AND REFERENCES */
--select ((InstaceManager_v()).getInstancesAndReferences( $Original ))
--select ((InstaceManager_v()).getInstancesAndReferences( objects ))
--select ((InstaceManager_v()).getInstancesAndReferences( $Copy1 ))

/* GET ISNTANCE */
--select ((InstaceManager_v()).getInstances( $Original ))
--select ((InstaceManager_v()).getInstances( $Reference1 ))

select ((InstaceManager_v()).getInstancesOrReferences( $Original ) #INSTANCE )



--/* GET REFERENCE */
--select ((InstaceManager_v()).getReferences( $Original ))

--select  $ReferenceOfInstance2
--select ((InstaceManager_v()).getReferences( $Reference1 ))
--select ((InstaceManager_v()).getReferences( $ReferenceOfInstance1 ))
--select ((InstaceManager_v()).getReferences( $InstanceOfReference1 ))

select ((InstaceManager_v()).getInstancesOrReferences( $Original ) #REFERENCE )

--select $ReferenceOfInstance1
--select ((InstaceManager_v()).getReferences( $ReferenceOfInstance1 ))

--select ((InstaceManager_v()).getReferences( $ReferenceOfInstance1 ))


/* GET REFERENCE OF MULTIPLE OBJECTS */
--select ((InstaceManager_v()).getInstances ( $Reference* ))


/* FILTER UNIQUE */
--select ((InstaceManager_v()).filterUnique( objects ))

--select ((InstaceManager_v()).filterUnique( $Instance* ))


/* FILTER REFERENCES */
--select ((InstaceManager_v()).filterReference ( objects ))
--select ((InstaceManager_v()).filterReference ( $*Inst* ))


/* FILTER ISNTANCES */
--select ((InstaceManager_v()).filterInstance ( objects ))
--select ((InstaceManager_v()).filterInstance ( $*Inst* ))
