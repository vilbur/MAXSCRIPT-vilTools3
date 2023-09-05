clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Selection.ms" )	-- "./../Selection.ms"


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

--prepareScene()

/* GET AL ISNTANCES AND REFERENCES */
--select ((Selection_v()).getInstancesAndReferences( $Original ))
--select ((Selection_v()).getInstancesAndReferences( objects ))
--select ((Selection_v()).getInstancesAndReferences( $Copy1 ))

/* GET ISNTANCE */
--select ((Selection_v()).getInstances( $Original ))
--select ((Selection_v()).getInstances( $Reference1 ))


--/* GET REFERENCE */
--select ((Selection_v()).getReferences( $Original ))

--select  $ReferenceOfInstance2
--select ((Selection_v()).getReferences( $Reference1 ))
--select ((Selection_v()).getReferences( $ReferenceOfInstance1 ))
--select ((Selection_v()).getReferences( $InstanceOfReference1 ))

--select $ReferenceOfInstance1
--select ((Selection_v()).getReferences( $ReferenceOfInstance1 ))

--select ((Selection_v()).getReferences( $ReferenceOfInstance1 ))


/* GET REFERENCE OF MULTIPLE OBJECTS */
--select ((Selection_v()).getInstances ( $Reference* ))


/* FILTER UNIQUE */
select ((Selection_v()).filterUnique( objects ))

--select ((Selection_v()).filterUnique( $Instance* ))


/* FILTER REFERENCES */
--select ((Selection_v()).filterReference ( objects ))
--select ((Selection_v()).filterReference ( $*Inst* ))


/* FILTER ISNTANCES */
--select ((Selection_v()).filterInstance ( objects ))
--select ((Selection_v()).filterInstance ( $*Inst* ))




