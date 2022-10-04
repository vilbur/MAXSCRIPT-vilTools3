clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Wirecolor.ms" )




/** Test colors
 */
function testColors hue:0 brightness:255 saturation:255 =
(
	_Color 	= Color_v()
	Wirecolor 	= Wirecolor_v()

	new_objects	= #()

	--format "\n"; print ".testColors()"
	for y = 1 to 50 do 
		for i = 1 to _Color.hues.count do
		(
			color_name = _Color.hues[i][1]	
			--format "color_name	= % \n" color_name
			obj = Sphere radius:4 pos:[ i*10, y*-10, 0] name:(color_name as string )
			
			obj.wirecolor = Wirecolor.randomize col:color_name	hue:hue brightness:brightness saturation:saturation
			
			append new_objects obj
		)
	
	--select new_objects
)
	
--_color = Wirecolor.randomize()
--format "_color	= % \n" (classOf _color)


--testColors()
--testColors hue:10

--testColors brightness:128
--testColors brightness:#(64, 255)

--testColors saturation:128
--testColors saturation:#(64, 255)

--testColors brightness:128	saturation:128
--testColors brightness:#(64, 255)	saturation:#(64, 255) 


--testColors hue:10 brightness:128	saturation:164 
--testColors hue:10 brightness:#(64, 255)	saturation:#(64, 255)

--testColors hue:128 brightness:#(64, 255)	saturation:#(64, 255) -- random hue