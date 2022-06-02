clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Material.ms" )


/** Create test object
 */
function createTestObject =
(
	resetMaxFile #noPrompt --reset the scene again
	
	_box = Box()
	
	select _box
	
	_box --return
)


_box = createTestObject()

_Material = Material_v()

id_multi_material = _Material.getIdMaterial()

_box.material = id_multi_material