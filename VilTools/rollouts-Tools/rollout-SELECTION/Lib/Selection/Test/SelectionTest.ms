clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Selection.ms" )




/** Create instances
  *
  */
function cloneNodes count _objects cloneType offset:[0,0,0] =
(
	--format "\n"; print "ObjectRenamerTest.ms.cloneNodes()"
	new_nodes = #()

	with redraw off
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
	_Teapot	= Teapot	pos:[ 0, -100, 0 ]	wirecolor:green
	--_Sphere	= Sphere	pos:[ 0,   0, 0 ]	wirecolor:green
	--_Box	= Box	pos:[ 0, 100, 0 ]	wirecolor:blue


	clones	= cloneNodes	1 #( _Teapot )	#copy	offset:[ 100,0,0]
	clones.wirecolor = color  128 128 128

	instances	= cloneNodes	1 #( _Teapot )	#instance	offset:[ 0,100,0]
	instances.wirecolor = color  64 164 64

	references	= cloneNodes	1 ( objects )	#reference	offset:[ 0,0, 100]
	references.wirecolor = color  64 64 164

)


 prepareScene()

/* GET ISNTANCE AND REFERENCE */
select ((Selection_v()).getInstances( objects[1] ) type:#ALL)

/* GET ISNTANCE */
select ((Selection_v()).getInstances( objects[1] ) type:#INSTANCE)

/* GET REFERENCE */
select ((Selection_v()).getInstances( objects[1] ) type:#REFERENCE)


/* GET REFERENCE OF MULTIPLE OBJECTS */
select ((Selection_v()).getInstances #( objects[1],  objects[2] ) typSe:#REFERENCE)


--select ((Selection_v()).getInstances( objects[1] )) -- Slect all instaces and references

/* GET UNIQUE */
--select ((Selection_v()).filterUniqueObjects( objects ))