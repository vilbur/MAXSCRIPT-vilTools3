clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../GroupAttacher.ms" )

/*------------------------------------------------------------------------------
	HELPER METHODS
--------------------------------------------------------------------------------*/
/** Create test objects
 */
function createTestObjects object_type z_pos:0 =
(
	--format "\n"; print ".createTestObjects()"
	colors = #(red, green, blue)
	new_nodes = #()

	for i = 1 to colors.count do
	(
		_teapot = object_type pos:[ 20 * (i  - 1), 0, z_pos] radius:5 height:10  wirecolor:colors[i]

		append new_nodes _teapot

		Rotate _teapot ( AngleAxis (90*i) [0,0,1])
	)

	new_nodes --return
)


/*------------------------------------------------------------------------------
	TEST METHODS
--------------------------------------------------------------------------------*/

/** Add single object to single group 
 */
function addSingleObjectToGroup =
(
	delete objects

	group_source = group (createTestObjects(Teapot)) name:"GROUP-ROOT"

	attaching_node = Sphere pos:[30,30,0] radius:5

	select group_source
	selectmore attaching_node

	(GroupAttacher_v()).attachSelectionToGroups()
)

/** Add multiple instanced objects to instances of group 
 */
function addInstacedObjectsToGroupInstances =
(
	delete objects

	group_source = group (createTestObjects(Teapot)) name:"GROUP-ROOT"

	maxOps.cloneNodes group_source cloneType:#instance newNodes:&detination_groups offset:[0,0,30]

	attaching_node = Sphere pos:[30,30,0] radius:5
	
	maxOps.cloneNodes attaching_node cloneType:#instance newNodes:&attaching_nodes offset:[30,0,0]

	select group_source
	selectmore attaching_node
	selectmore attaching_nodes
	
	(GroupAttacher_v()).attachSelectionToGroups()
)

/** Add single object to group, but all objects are nested in another group
 */
function addObjectsToNestedGroup =
(
	delete objects

	teapots	= createTestObjects(Teapot)
	cylinders	= createTestObjects(Cylinder)

	move cylinders [0,0,30]

	child_group = group (teapots) name:"GROUP-ROOT"

	parent_group = group (append cylinders child_group) name:"GROUP-PARENT"

	setGroupOpen parent_group true
	
	select child_group
	selectmore cylinders

	(GroupAttacher_v()).attachSelectionToGroups()
)

/*------------------------------------------------------------------------------
	RUN TESTS
--------------------------------------------------------------------------------*/
--addSingleObjectToGroup()
--addInstacedObjectsToGroupInstances()
addObjectsToNestedGroup()