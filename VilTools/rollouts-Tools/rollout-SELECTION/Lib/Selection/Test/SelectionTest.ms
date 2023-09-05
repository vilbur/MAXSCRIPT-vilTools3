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

	--format "\n"; print "SelectionTest.ms.prepareScene()"
	_Teapot	= Teapot	pos:[ 0, -100, 0 ]	wirecolor:green name:"Original"
	--_Sphere	= Sphere	pos:[ 0,   0, 0 ]	wirecolor:green
	--_Box	= Box	pos:[ 0, 100, 0 ]	wirecolor:blue


	--clones	= cloneNodes	1 #( _Teapot )	#copy	offset:[ 100,0,0]
	--clones.wirecolor = color  128 128 128

	instances	= cloneNodes	2 #( _Teapot )	#instance	offset:[ 0,100,0]
	instances.wirecolor = color  64 164 64
	for i = 1 to instances.count do
		instances[i].name = "Instance" + i as string


	references	= cloneNodes	1 ( objects as Array )	#reference	offset:[ 0,0, 100]
	references.wirecolor = color  64 64 164
	for i = 1 to references.count do
		references[i].name = "Reference" + i as string


	instances_of_refs	= cloneNodes	1 ( references )	#instance	offset:[ 0,0, 100]
	instances_of_refs.wirecolor = color  164 64 164
	for i = 1 to instances_of_refs.count do
		instances_of_refs[i].name = "InstOfReference" + i as string

	refs_instances_of_refs	= cloneNodes	1 ( instances_of_refs )	#reference	offset:[ 0,0, 100]
	refs_instances_of_refs.wirecolor = color  164 64 64
	for i = 1 to refs_instances_of_refs.count do
		refs_instances_of_refs[i].name = "RefOfInstOfReference" + i as string

)


/* GET AL ISNTANCES AND REFERENCES */
--select ((Selection_v()).getInstancesAll( $Original ))
--select ((Selection_v()).getInstancesAll( $InstOfReference1 ))
--select ((Selection_v()).getInstancesAll( $RefOfInstOfReference1 ))

/* GET ISNTANCE */
--select ((Selection_v()).getInstances( $Original ))
--select ((Selection_v()).getInstances( $InstOfReference1 ))
--select ((Selection_v()).getInstances( $RefOfInstOfReference1 ))

--/* GET REFERENCE */
--select ((Selection_v()).getReferences( $Original ))
--select ((Selection_v()).getInstances( $InstOfReference1 ))
--select ((Selection_v()).getInstances( $RefOfInstOfReference1 ))


/* GET REFERENCE OF MULTIPLE OBJECTS */
select $Reference*
select ((Selection_v()).getInstances ( selection ))


/* GET UNIQUE */
--select ((Selection_v()).filterUniqueObjects( objects ))
--select $Reference*
--select ((Selection_v()).filterUniqueObjects ( selection ))
