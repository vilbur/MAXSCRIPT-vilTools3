clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../instanceModifiersOnCopy.ms" )	--"./../instanceModifiersOnCopy.ms"



/*------------------------------------------------------------------------------
	CREATE TEST OBJECTS
--------------------------------------------------------------------------------*/
delete objects

_box_1 = box()

addModifier _box_1 (Poly_Select ())
addModifier _box_1 (meshsmooth ())


cloned_nodes = #( #( _box_1 ) )

for i = 1 to 3 do
(
	nnl = #()
	
	maxOps.CloneNodes _box_1 offset:[ i*50, 0, 0 ] newNodes:&nnl
	
	append cloned_nodes nnl
	
)

instanceModifiersOnCopy cloned_nodes #COPY -- #INSTANCE|#REFERENCE

