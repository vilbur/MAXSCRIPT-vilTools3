clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../GroupCreator.ms" )

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


delete objects
delete shapes

/* Create new layer for objects */ 
LayerManager.newLayerFromName "Groups"
layer_groups = LayerManager.getLayerFromName "Groups"
layer_groups.current = true

parent_obj	= text name:"PARENT" text:"PARENT" size:20  pos:[-50,0,0] 
child_obj	= text name:"CHILD"  text:"CHILD"  size:20  pos:[100,0,0] 

teapots	= createTestObjects(Teapot)

spheres	= (createTestObjects(Sphere)   z_pos:20)

cylinders	= (createTestObjects(Cylinder) z_pos:30)


/* CREATE HIERARCHY */ 
--for _teapot in teapots do _teapot.parent = parent_obj
--child_obj.parent = teapots[1]


/* ACTIVATE DEFAULT LAYER to test if groups are created in layer same layer as obejcts */ 
(LayerManager.getLayer 0).current = true

/*------------------------------------------------------------------------------
	CREATE GROUPS
--------------------------------------------------------------------------------*/
select teapots

GroupCreator_v "GROUP" "Teapot"

selectmore spheres
selectmore cylinders

main_group = (GroupCreator_v "PARENT-GROUP").getGroup()


setGroupOpen main_group true

select spheres

nested_group = (GroupCreator_v "NESTED-GROUP").getGroup()



