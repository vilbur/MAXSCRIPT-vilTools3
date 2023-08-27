clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../InstancedModifierFinder.ms" )	-- "./../InstancedModifierFinder.ms"


delete objects

 boxes = for k=0 to 2 collect Box pos:[ k*100, 0, 0]

_Edit_Poly = Edit_Poly()
_Meshosmooth = meshsmooth()

addModifier boxes[1] _Edit_Poly
addModifier boxes[2] _Edit_Poly

--addModifier boxes[2] _Meshosmooth
--addModifier boxes[3] _Meshosmooth

addModifier boxes[3] (Edit_Poly())


select  boxes[1]

max modify mode


InstancedModifierFinder 	= InstancedModifierFinder_v( objects )


--objects_with_mod_instance = InstancedModifierFinder.getObjectsWithInstance(_modifier)
objects_with_mod_instance = InstancedModifierFinder.getObjectsWithInstance( modPanel.getCurrentObject() )


select objects_with_mod_instance