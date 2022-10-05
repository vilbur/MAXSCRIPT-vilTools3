clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Wirecolor.ms" )




/** Test colors
 */
function createTestObjects hue:0 brightness:255 saturation:255 =
(
	primitives	= #( #box, #teapot, #cylinder )
	new_objects	= #()

	delete objects

	for i = 1 to primitives.count do 
	(
		primitive = primitives[i]
		
		obj = execute(primitive as string + "()")
		
		obj.pos = [ i*50, 0, 0]
		
		append new_objects obj
	)
	
	
	copies = for myobj in new_objects collect (copy myobj )
	
	copies.pos.y += 100

	new_objects = new_objects + copies
	
	instances = for myobj in new_objects collect (instance  myobj )

	instances.pos.z += 100

	new_objects = new_objects + instances

	select new_objects
)


createTestObjects()

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

(Wirecolor_v()).randomize hue:10

--(Wirecolor_v()).randomize brightness:128
--(Wirecolor_v()).randomize brightness:#(64, 255)

--(Wirecolor_v()).randomize saturation:128
--(Wirecolor_v()).randomize saturation:#(64, 255)

--(Wirecolor_v()).randomize brightness:128	saturation:128
--(Wirecolor_v()).randomize brightness:#(64, 255)	saturation:#(64, 255) 


--(Wirecolor_v()).randomize hue:10 brightness:128	saturation:164 
--(Wirecolor_v()).randomize hue:10 brightness:#(64, 255)	saturation:#(64, 255)

--(Wirecolor_v()).randomize hue:128 brightness:#(64, 255)	saturation:#(64, 255) -- random hue


			