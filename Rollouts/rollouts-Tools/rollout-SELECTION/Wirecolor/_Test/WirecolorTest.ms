clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Wirecolor.ms" )

Wirecolor 	= Wirecolor_v()


--delete objects
new_objects	= #()


for i = 1 to Wirecolor.colors.count do
(
	color_name = Wirecolor.colors[i][1]	
	
	obj = Sphere radius:4 pos:[ i*10, 0, 0] name:(color_name as string )
	
	obj.wirecolor = Wirecolor.randomize col:color_name	range:10

	append new_objects obj
)

select new_objects


--$.wirecolor = Wirecolor.randomize col:#red
--$.wirecolor = Wirecolor.randomize col:#cyan
--$.wirecolor = Wirecolor.randomize col:#orange
