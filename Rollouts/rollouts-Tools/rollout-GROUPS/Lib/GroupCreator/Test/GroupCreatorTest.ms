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

/* Create new layer for objects */ 
LayerManager.newLayerFromName "Groups"
layer_groups = LayerManager.getLayerFromName "Groups"
layer_groups.current = true


teapots	= createTestObjects(Teapot)
spheres	= (createTestObjects(Sphere)   z_pos:20)
cylinders	= (createTestObjects(Cylinder) z_pos:30)


/* Activate default layer to test if groups are created in it`s layers */ 
(LayerManager.getLayer 0).current = true

selectmore teapots
GroupCreator_v params:#("Teapot", "GROUP", false, false, false )

selectmore spheres

GroupCreator_v params:#("Sphere", "GROUP", false, false, false )

selectmore cylinders

GroupCreator_v params:#("Cylinder", "GROUP", false, false, false )
